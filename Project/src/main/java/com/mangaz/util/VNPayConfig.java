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
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

public class VNPayConfig {
    private static final String VNP_PAY_URL = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    private static final String VNP_REFUND_URL = "https://sandbox.vnpayment.vn/merchant_webapi/api/transaction";
    private static final String VNP_TMN_CODE = "6LE1GSUF";
    private static final String VNP_HASH_SECRET = "EWONADGFCAUFJEOTOXCLGIVHHWOEZGBI";
    private static final String VNP_RETURN_URL = "https://stargazer-correct-buggy.ngrok-free.dev/ThuongMaiDienTu/vnpay-return";
    private static final String VNP_VERSION = "2.1.0";
    private static final String VNP_COMMAND = "pay";
    private static final String VNP_CURRENCY = "VND";
    private static final ZoneId TIME_ZONE = ZoneId.of("Asia/Ho_Chi_Minh");
    private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

    public static class PaymentData {
        private final String paymentUrl;
        private final String createDate;

        public PaymentData(String paymentUrl, String createDate) {
            this.paymentUrl = paymentUrl;
            this.createDate = createDate;
        }

        public String getPaymentUrl() {
            return paymentUrl;
        }

        public String getCreateDate() {
            return createDate;
        }
    }

    private static void checkConfig() {
        if (VNP_TMN_CODE == null || VNP_TMN_CODE.isBlank() || VNP_HASH_SECRET == null
            || VNP_HASH_SECRET.isBlank() || VNP_RETURN_URL == null || VNP_RETURN_URL.isBlank()) {

            throw new IllegalStateException(
                    "Chưa cấu hình đầy đủ thông tin VNPay trong Environment Variables."
            );
        }
    }

    public static PaymentData createPaymentData(long orderId, BigDecimal amount, String ipAddress) throws Exception {
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
        return new PaymentData(
                VNP_PAY_URL + "?" + query,
                createDate
        );
    }

    public static String createPaymentUrl(
            long orderId, BigDecimal amount, String ipAddress
    ) throws Exception {

        PaymentData paymentData = createPaymentData(
                orderId, amount, ipAddress
        );

        return paymentData.getPaymentUrl();
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

    public static String getCurrentCreateDate() {
        return ZonedDateTime.now(TIME_ZONE).format(DATE_FORMAT);
    }

    public static String refundTransaction(
            long orderId,
            String requestId,
            BigDecimal amount,
            String transactionNo,
            String transactionDate,
            String createdBy,
            String ipAddress
    ) throws Exception {

        checkConfig();

        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Số tiền hoàn không hợp lệ.");
        }

        if (transactionNo == null || transactionNo.isBlank()
                || transactionDate == null
                || !transactionDate.matches("\\d{14}")) {
            throw new IllegalArgumentException("Thông tin giao dịch không hợp lệ.");
        }

        if (createdBy == null || createdBy.isBlank()
                || ipAddress == null || ipAddress.isBlank()) {
            throw new IllegalArgumentException("Thiếu thông tin người yêu cầu hoặc IP.");
        }

        // 1. Tạo thông tin yêu cầu hoàn tiền
        if (requestId == null || !requestId.matches("[a-zA-Z0-9]{1,32}")) {
            throw new IllegalArgumentException(
                    "Mã yêu cầu hoàn tiền không hợp lệ."
            );
        }

        String version = VNP_VERSION;
        String command = "refund";
        String transactionType = "02";

        String txnRef = String.valueOf(orderId);

        long vnpAmount = amount.multiply(new BigDecimal("100"))
                .setScale(0, RoundingMode.HALF_UP)
                .longValueExact();

        String createDate = ZonedDateTime.now(TIME_ZONE)
                .format(DATE_FORMAT);

        String orderInfo = "Hoan tien don hang MangaZ " + orderId;

        // 2. Tạo chuỗi dữ liệu theo đúng thứ tự VNPay quy định
        String hashData = String.join("|",
                requestId,
                version,
                command,
                VNP_TMN_CODE,
                transactionType,
                txnRef,
                String.valueOf(vnpAmount),
                transactionNo,
                transactionDate,
                createdBy,
                createDate,
                ipAddress,
                orderInfo
        );

        // 3. Tạo chữ ký
        String secureHash = hmacSHA512(
                VNP_HASH_SECRET,
                hashData
        );

        // 4. Tạo JSON gửi VNPay
        String jsonBody = """
        {
            "vnp_RequestId": "%s",
            "vnp_Version": "%s",
            "vnp_Command": "%s",
            "vnp_TmnCode": "%s",
            "vnp_TransactionType": "%s",
            "vnp_TxnRef": "%s",
            "vnp_Amount": "%s",
            "vnp_TransactionNo": "%s",
            "vnp_TransactionDate": "%s",
            "vnp_CreateBy": "%s",
            "vnp_CreateDate": "%s",
            "vnp_IpAddr": "%s",
            "vnp_OrderInfo": "%s",
            "vnp_SecureHash": "%s"
        }
        """.formatted(
                requestId,
                version,
                command,
                VNP_TMN_CODE,
                transactionType,
                txnRef,
                vnpAmount,
                transactionNo,
                transactionDate,
                escapeJson(createdBy),
                createDate,
                ipAddress,
                escapeJson(orderInfo),
                secureHash
        );

        // 5. Gửi request đến VNPay
        HttpClient client = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(15))
                .build();

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(VNP_REFUND_URL))
                .timeout(Duration.ofSeconds(30))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(
                        jsonBody,
                        StandardCharsets.UTF_8
                ))
                .build();

        HttpResponse<String> response = client.send(
                request,
                HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8)
        );

        if (response.statusCode() != 200) {
            throw new IllegalStateException(
                    "VNPay Refund API trả về HTTP "
                            + response.statusCode()
            );
        }

        // Trả về JSON để bước tiếp theo xử lý kết quả
        return response.body();
    }
    private static String escapeJson(String value) {
        return value.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }

    public static class RefundResponse {
        private final String responseCode;
        private final String message;
        private final String transactionStatus;
        private final String transactionNo;
        private final String txnRef;
        private final boolean validSignature;

        public RefundResponse(
                String responseCode,
                String message,
                String transactionStatus,
                String transactionNo,
                String txnRef,
                boolean validSignature
        ) {
            this.responseCode = responseCode;
            this.message = message;
            this.transactionStatus = transactionStatus;
            this.transactionNo = transactionNo;
            this.txnRef = txnRef;
            this.validSignature = validSignature;
        }

        public String getResponseCode() {
            return responseCode;
        }

        public String getMessage() {
            return message;
        }

        public String getTransactionStatus() {
            return transactionStatus;
        }

        public String getTransactionNo() {
            return transactionNo;
        }

        public String getTxnRef() {
            return txnRef;
        }

        public boolean isValidSignature() {
            return validSignature;
        }
    }

    public static RefundResponse parseRefundResponse(String json)
            throws Exception {

        JsonNode root = OBJECT_MAPPER.readTree(json);

        String responseId = root.path("vnp_ResponseId").asText("");
        String command = root.path("vnp_Command").asText("");
        String responseCode = root.path("vnp_ResponseCode").asText("");
        String message = root.path("vnp_Message").asText("");
        String tmnCode = root.path("vnp_TmnCode").asText("");
        String txnRef = root.path("vnp_TxnRef").asText("");
        String amount = root.path("vnp_Amount").asText("");
        String bankCode = root.path("vnp_BankCode").asText("");
        String payDate = root.path("vnp_PayDate").asText("");
        String transactionNo = root.path("vnp_TransactionNo").asText("");
        String transactionType = root.path("vnp_TransactionType").asText("");
        String transactionStatus = root.path("vnp_TransactionStatus").asText("");
        String orderInfo = root.path("vnp_OrderInfo").asText("");
        String secureHash = root.path("vnp_SecureHash").asText("");

        if (responseId.isBlank()
                || responseCode.isBlank()
                || tmnCode.isBlank()
                || txnRef.isBlank()
                || amount.isBlank()
                || transactionNo.isBlank()
                || transactionType.isBlank()
                || transactionStatus.isBlank()
                || secureHash.isBlank()) {
            throw new IllegalArgumentException(
                    "Phản hồi hoàn tiền từ VNPay thiếu dữ liệu bắt buộc."
            );
        }

        if (!"refund".equals(command) || !isValidMerchant(tmnCode)) {
            throw new SecurityException(
                    "Phản hồi không đúng Merchant hoặc không phải Refund API."
            );
        }

        String hashData = String.join("|",
                responseId,
                command,
                responseCode,
                message,
                tmnCode,
                txnRef,
                amount,
                bankCode,
                payDate,
                transactionNo,
                transactionType,
                transactionStatus,
                orderInfo
        );

        String calculatedHash = hmacSHA512(VNP_HASH_SECRET, hashData);

        boolean validSignature = MessageDigest.isEqual(
                calculatedHash.toLowerCase().getBytes(StandardCharsets.UTF_8),
                secureHash.toLowerCase().getBytes(StandardCharsets.UTF_8)
        );

        if (!validSignature) {
            throw new SecurityException(
                    "Chữ ký phản hồi Refund từ VNPay không hợp lệ."
            );
        }

        return new RefundResponse(
                responseCode,
                message,
                transactionStatus,
                transactionNo,
                txnRef,
                true
        );
    }



}
