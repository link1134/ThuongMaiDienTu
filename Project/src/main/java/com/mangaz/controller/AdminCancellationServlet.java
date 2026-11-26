package com.mangaz.controller;

import com.mangaz.dao.OrderDAO;
import com.mangaz.model.User;
import com.mangaz.util.VNPayConfig;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/cancellation")
public class AdminCancellationServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        // 1. Kiểm tra đăng nhập
        if (session == null || !(session.getAttribute("user") instanceof User)) {
            response.sendRedirect(
                    request.getContextPath() + "/Login.jsp"
            );
            return;
        }

        User user = (User) session.getAttribute("user");

        // 2. Kiểm tra quyền Admin
        if (!"Admin".equalsIgnoreCase(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // 3. Lấy dữ liệu từ form
        String action = request.getParameter("action");
        String requestIdParam = request.getParameter("requestId");

        if (requestIdParam == null || requestIdParam.isBlank()) {
            setMessage(session, "Mã yêu cầu hủy không hợp lệ.");
            redirectToAdmin(request, response);
            return;
        }

        int requestId;

        try {
            requestId = Integer.parseInt(requestIdParam);
            if (requestId <= 0) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException e) {
            setMessage(session, "Mã yêu cầu hủy không hợp lệ.");
            redirectToAdmin(request, response);
            return;
        }

        // 4. Xử lý duyệt hoặc từ chối
        boolean success = false;
        String message;

        if ("approve".equalsIgnoreCase(action)) {

            // Lấy OrderId trước khi duyệt yêu cầu
            int orderId = orderDAO.getOrderIdByCancellationRequest(
                    requestId,
                    user.getId()
            );

            if (orderId <= 0) {
                message = "Không tìm thấy đơn hàng của yêu cầu hủy.";
            } else {

                // Bước 1: Duyệt yêu cầu hủy đơn hàng
                success = orderDAO.approveCancellationRequest(
                        requestId,
                        user.getId()
                );

                if (!success) {
                    message = "Không thể duyệt yêu cầu hủy đơn hàng.";
                } else {

                    // Bước 2: Chuẩn bị thông tin hoàn tiền
                    OrderDAO.RefundData refundData =
                            orderDAO.prepareRefund(orderId, user.getId());

                    if (refundData == null) {

                        message = "Đã duyệt hủy đơn hàng. "
                                + "Không tạo được yêu cầu hoàn tiền "
                                + "(đơn COD, chưa thanh toán hoặc thiếu thông tin giao dịch).";

                    } else {

                        try {
                            // Bước 3: Gửi yêu cầu hoàn tiền đến VNPay
                            String rawResponse = VNPayConfig.refundTransaction(
                                    orderId,
                                    refundData.getRequestId(),
                                    refundData.getAmount(),
                                    refundData.getTransactionNo(),
                                    refundData.getTransactionDate(),
                                    refundData.getCreatedBy(),
                                    request.getRemoteAddr()
                            );

                            // Bước 4: Đọc phản hồi từ VNPay
                            VNPayConfig.RefundResponse refundResponse =
                                    VNPayConfig.parseRefundResponse(rawResponse);

                            // Bước 5: Cập nhật kết quả vào database
                            boolean updated = orderDAO.updateRefundResult(
                                    orderId,
                                    refundData.getRequestId(),
                                    refundResponse
                            );

                            if (!updated) {
                                message = "Đã duyệt hủy đơn hàng nhưng không thể "
                                        + "cập nhật kết quả hoàn tiền.";
                            } else {

                                String refundStatus = "Processing";

                                if ("00".equals(refundResponse.getResponseCode())
                                        && "00".equals(refundResponse.getTransactionStatus())) {

                                    refundStatus = "Succeeded";

                                } else if ("09".equals(refundResponse.getTransactionStatus())
                                        || "95".equals(refundResponse.getResponseCode())) {

                                    refundStatus = "Failed";
                                }

                                if ("Succeeded".equals(refundStatus)) {
                                    message = "Đã duyệt hủy đơn hàng và hoàn tiền thành công.";
                                } else if ("Failed".equals(refundStatus)) {
                                    message = "Đã duyệt hủy đơn hàng nhưng VNPay từ chối hoàn tiền.";
                                } else {
                                    message = "Đã duyệt hủy đơn hàng. "
                                            + "Yêu cầu hoàn tiền đang được xử lý.";
                                }
                            }

                        } catch (Exception e) {
                            e.printStackTrace();

                            message = "Đã duyệt hủy đơn hàng nhưng chưa nhận được "
                                    + "kết quả hoàn tiền từ VNPay. "
                                    + "Vui lòng kiểm tra trạng thái giao dịch.";
                        }
                    }
                }
            }
        } else if ("reject".equalsIgnoreCase(action)) {

            String adminNote = request.getParameter("adminNote");

            if (adminNote == null) {
                adminNote = "";
            }

            success = orderDAO.rejectCancellationRequest(
                    requestId,
                    user.getId(),
                    adminNote.trim()
            );

            message = success
                    ? "Đã từ chối yêu cầu hủy đơn hàng."
                    : "Không thể từ chối yêu cầu. Vui lòng kiểm tra lại trạng thái yêu cầu.";

        } else {

            message = "Thao tác không hợp lệ.";
        }

        // 5. Lưu thông báo vào session
        setMessage(session, message);

        // 6. Quay lại trang quản trị
        redirectToAdmin(request, response);
    }

    private void setMessage(HttpSession session, String message) {
        session.setAttribute("cancellationMessage", message);
    }

    private void redirectToAdmin(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        response.sendRedirect(
                request.getContextPath() + "/admin/orderManager"
        );
    }
}
