
package com.mangaz.controller;

import com.mangaz.dao.OrderDAO;
import com.mangaz.util.VNPayConfig;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Map;
import java.util.TreeMap;

@WebServlet("/vnpay-ipn")
public class VNPayIPNServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp
    ) throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");

        try {
            // 1. Lấy toàn bộ tham số VNPay gửi về
            Map<String, String> params = new TreeMap<>();

            for (Map.Entry<String, String[]> entry
                    : req.getParameterMap().entrySet()) {

                String[] values = entry.getValue();

                if (values != null && values.length > 0) {
                    params.put(entry.getKey(), values[0]);
                }
            }

            // 2. Kiểm tra chữ ký
            if (!VNPayConfig.verifySignature(params)) {
                sendResponse(resp, "97", "Invalid Signature");
                return;
            }

            // 3. Kiểm tra mã Merchant
            if (!VNPayConfig.isValidMerchant(
                    params.get("vnp_TmnCode"))) {

                sendResponse(resp, "97", "Invalid Merchant");
                return;
            }

            // 4. Lấy mã đơn hàng
            String txnRef = params.get("vnp_TxnRef");

            if (txnRef == null || !txnRef.matches("\\d+")) {
                sendResponse(resp, "01", "Order Not Found");
                return;
            }

            int orderId = Integer.parseInt(txnRef);

            // 5. Lấy số tiền VNPay gửi về
            String amountParam = params.get("vnp_Amount");

            if (amountParam == null
                    || !amountParam.matches("\\d+")) {

                sendResponse(resp, "04", "Invalid Amount");
                return;
            }

            BigDecimal paidAmount = new BigDecimal(amountParam)
                    .divide(new BigDecimal("100"));

            // 6. Kiểm tra kết quả giao dịch
            String responseCode = params.get("vnp_ResponseCode");
            String transactionStatus =
                    params.get("vnp_TransactionStatus");

            if ("00".equals(responseCode)
                    && "00".equals(transactionStatus)) {

                // 7. Xác nhận thanh toán và cập nhật database
                boolean success = orderDAO.confirmVnpayPayment(
                        orderId,
                        paidAmount
                );

                if (success) {
                    sendResponse(resp, "00", "Confirm Success");
                } else {
                    sendResponse(resp, "99", "Order Update Failed");
                }

            } else {
                // Giao dịch không thành công.
                // Không trừ kho và không xóa giỏ hàng.
                sendResponse(resp, "00", "Payment Failed Recorded");
            }

        } catch (Exception e) {
            e.printStackTrace();
            sendResponse(resp, "99", "Unknown Error");
        }
    }

    // Trả kết quả JSON cho VNPay
    private void sendResponse(
            HttpServletResponse resp,
            String code,
            String message
    ) throws IOException {

        resp.getWriter().write(
                "{\"RspCode\":\"" + code
                        + "\",\"Message\":\"" + message + "\"}"
        );
    }
}
