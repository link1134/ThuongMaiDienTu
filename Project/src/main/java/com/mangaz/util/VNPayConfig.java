package com.mangaz.util;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;
import java.util.TreeMap;
import java.security.MessageDigest;
import java.util.TreeMap;

public class VNPayConfig {
    private static final String VNP_PAY_URL = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    private static final String VNP_TMN_CODE = "6LE1GSUF";
    private static final String VNP_HASH_SECRET = "EWONADGFCAUFJEOTOXCLGIVHHWOEZGBI";
    private static final String VNP_RETURN_URL = "https://stargazer-correct-buggy.ngrok-free.dev/ThuongMaiDienTu/vnpay-return";
    private static final String VNP_VERSION = "2.1.0";
    private static final String VNP_COMMAND = "pay";
    private static final String VNP_CURRENCY = "VND";
    private static final ZoneId TIME_ZONE = ZoneId.of("Asia/Ho_Chi_Minh");
    private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");

    private static void checkConfig() {
        if (VNP_TMN_CODE == null || VNP_TMN_CODE.isBlank() || VNP_HASH_SECRET == null
            || VNP_HASH_SECRET.isBlank() || VNP_RETURN_URL == null || VNP_RETURN_URL.isBlank()) {

            throw new IllegalStateException(
                    "Chưa cấu hình đầy đủ thông tin VNPay trong Environment Variables."
            );
        }
    }

    public static String createPaymentUrl(long orderId, BigDecimal amount, String ipAddress) throws Exception {
        checkConfig();
        ZonedDateTime now = ZonedDateTime.now(TIME_ZONE);
        String createDate = now.format(DATE_FORMAT);
        String expireDate = now.plusMinutes(15).format(DATE_FORMAT);

        long vnpAmount = amount.multiply(new BigDecimal("100")).setScale(0, RoundingMode.HALF_UP).longValueExact();

        Map<String, String> params = new TreeMap<>();

        params.put("vnp_Version", VNP_VERSION);
        params.put("vnp_Command", VNP_COMMAND);
        params.put("vnp_TmnCode", VNP_TMN_CODE);
        params.put("vnp_Amount", String.valueOf(vnpAmount));
        params.put("vnp_CurrCode", VNP_CURRENCY);
        params.put("vnp_TxnRef", String.valueOf(orderId));
        params.put("vnp_OrderInfo", "Thanh toan don hang MangaZ " + orderId);
        params.put("vnp_OrderType", "other");
        params.put("vnp_Locale", "vn");
        params.put("vnp_ReturnUrl", VNP_RETURN_URL);
        params.put("vnp_IpAddr", ipAddress);
        params.put("vnp_CreateDate", createDate);
        params.put("vnp_ExpireDate", expireDate);

        // Tạo chuỗi dữ liệu để ký
        StringBuilder hashData = new StringBuilder();

        for (Map.Entry<String, String> entry : params.entrySet()) {
            if (hashData.length() > 0) {
                hashData.append("&");
            }
            hashData.append(
                    URLEncoder.encode(entry.getKey(), StandardCharsets.UTF_8)
            ).append("=");

            hashData.append(
                    URLEncoder.encode(entry.getValue(), StandardCharsets.UTF_8)
            );
        }

        String secureHash = hmacSHA512(
                VNP_HASH_SECRET, hashData.toString()
        );

        StringBuilder query = new StringBuilder();

        for (Map.Entry<String, String> entry : params.entrySet()) {
            if(query.length() > 0) {
                query.append("&");
            }

            query.append(URLEncoder.encode(
                    entry.getKey(),
                    StandardCharsets.UTF_8
            ));
            query.append("=");
            query.append(URLEncoder.encode(
                    entry.getValue(),
                    StandardCharsets.UTF_8
            ));
        }
        query.append("&vnp_SecureHash=").append(secureHash);
        return VNP_PAY_URL + "?" + query;
    }

    public static String hmacSHA512(String key, String data) throws Exception {
        Mac hmac = Mac.getInstance("HmacSHA512");
        SecretKeySpec secretKey = new SecretKeySpec(
                key.getBytes(StandardCharsets.UTF_8), "HmacSHA512"
        );
        hmac.init(secretKey);

        byte[] hashBytes = hmac.doFinal(data.getBytes(StandardCharsets.UTF_8));

        StringBuilder hash = new StringBuilder();
        for (byte b : hashBytes) {
            hash.append(String.format("%02x", b & 0xff));
        }
        return hash.toString();
    }

    public static boolean verifySignature(Map<String, String> params) throws Exception {
        checkConfig();

        String receivedHash = params.get("vnp_SecureHash");

        if (receivedHash == null || receivedHash.isBlank()) {
            return false;
        }

        Map<String, String> sortedParams = new TreeMap<>(params);

        sortedParams.remove("vnp_SecureHash");
        sortedParams.remove("vnp_SecureHashType");

        StringBuilder hashData = new StringBuilder();

        for (Map.Entry<String, String> entry : sortedParams.entrySet()) {

            if (hashData.length() > 0) {
                hashData.append("&");
            }

            hashData.append(
                    URLEncoder.encode(entry.getKey(), StandardCharsets.UTF_8)
            );

            hashData.append("=");

            hashData.append(
                    URLEncoder.encode(entry.getValue(), StandardCharsets.UTF_8)
            );
        }

        String calculatedHash = hmacSHA512(
                VNP_HASH_SECRET,
                hashData.toString()
        );

        return MessageDigest.isEqual(
                calculatedHash.toLowerCase().getBytes(StandardCharsets.UTF_8),
                receivedHash.toLowerCase().getBytes(StandardCharsets.UTF_8)
        );
    }

    // Kiểm tra mã Merchant
    public static boolean isValidMerchant(String tmnCode) {
        return VNP_TMN_CODE != null
                && VNP_TMN_CODE.equals(tmnCode);
    }

}
