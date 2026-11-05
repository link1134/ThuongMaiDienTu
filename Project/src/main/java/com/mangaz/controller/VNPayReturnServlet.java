
package com.mangaz.controller;

import com.mangaz.util.VNPayConfig;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Map;
import java.util.TreeMap;

@WebServlet("/vnpay-return")
public class VNPayReturnServlet extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp
    ) throws ServletException, IOException {

        // Lấy tham số VNPay gửi về
        Map<String, String> params = new TreeMap<>();

        for (Map.Entry<String, String[]> entry
                : req.getParameterMap().entrySet()) {

            String[] values = entry.getValue();

            if (values != null && values.length > 0) {
                params.put(entry.getKey(), values[0]);
            }
        }

        try {
            // 1. Xác thực chữ ký và Merchant
            boolean validSignature =
                    VNPayConfig.verifySignature(params);

            boolean validMerchant =
                    VNPayConfig.isValidMerchant(
                            params.get("vnp_TmnCode")
                    );

            if (!validSignature || !validMerchant) {

                req.setAttribute(
                        "paymentResult",
                        "invalid"
                );

                req.setAttribute(
                        "paymentMessage",
                        "Thông tin thanh toán không hợp lệ."
                );

            } else {

                // 2. Đọc kết quả VNPay trả về
                String responseCode =
                        params.get("vnp_ResponseCode");

                String transactionStatus =
                        params.get("vnp_TransactionStatus");

                String txnRef = params.get("vnp_TxnRef");

                req.setAttribute("orderId", txnRef);

                if ("00".equals(responseCode)
                        && "00".equals(transactionStatus)) {

                    req.setAttribute(
                            "paymentResult",
                            "processing"
                    );

                    req.setAttribute(
                            "paymentMessage",
                            "VNPay thông báo giao dịch thành công. "
                                    + "Hệ thống đang xác nhận thanh toán."
                    );

                } else {

                    req.setAttribute(
                            "paymentResult",
                            "failed"
                    );

                    req.setAttribute(
                            "paymentMessage",
                            "Thanh toán không thành công hoặc đã bị hủy. "
                                    + "Mã lỗi VNPay: " + responseCode
                    );
                }
            }

        } catch (Exception e) {
            e.printStackTrace();

            req.setAttribute("paymentResult", "error");

            req.setAttribute(
                    "paymentMessage",
                    "Không thể xác thực kết quả thanh toán."
            );
        }

        // Hiển thị kết quả thanh toán
        resp.setContentType("text/html;charset=UTF-8");

        String result = (String) req.getAttribute("paymentResult");
        String message = (String) req.getAttribute("paymentMessage");

        resp.getWriter().println("""
    <!DOCTYPE html>
    <html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Kết quả thanh toán - MangaZ</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                text-align: center;
                padding: 80px 20px;
            }
            .result {
                max-width: 500px;
                margin: auto;
                padding: 30px;
                border: 1px solid #ddd;
                border-radius: 10px;
            }
            a {
                display: inline-block;
                margin-top: 20px;
                color: #333;
            }
        </style>
    </head>
    <body>
        <div class="result">
            <h2>Kết quả thanh toán MangaZ</h2>
            <p id="payment-message"></p>
            <a href="%s/">Quay về trang chủ</a>
        </div>
        <script>
            document.getElementById("payment-message").textContent = %s;
        </script>
    </body>
    </html>
    """.formatted(
                req.getContextPath(),
                toJavaScriptString(message)
        ));
    }

    private String toJavaScriptString(String value) {
        if (value == null) {
            return "\"Không có thông tin thanh toán.\"";
        }

        return "\"" + value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "")
                .replace("\n", "\\n") + "\"";
    }
}
