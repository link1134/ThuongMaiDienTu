package com.mangaz.controller;

import com.mangaz.dao.OrderDAO;
import com.mangaz.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/order/cancellation-request")
public class OrderCancellationRequestServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=UTF-8");

        // 1. Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);

        if (session == null ||
                !(session.getAttribute("user") instanceof User)) {

            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("Vui lòng đăng nhập.");
            return;
        }

        User user = (User) session.getAttribute("user");

        // 2. Lấy dữ liệu
        String orderIdParam = request.getParameter("orderId");
        String reason = request.getParameter("reason");

        // 3. Kiểm tra mã đơn
        int orderId;

        try {
            orderId = Integer.parseInt(orderIdParam);

            if (orderId <= 0) {
                throw new NumberFormatException();
            }

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Mã đơn hàng không hợp lệ.");
            return;
        }

        // 4. Kiểm tra lý do
        if (reason == null || reason.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Vui lòng nhập lý do hủy đơn.");
            return;
        }

        reason = reason.trim();

        if (reason.length() > 500) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Lý do không được vượt quá 500 ký tự.");
            return;
        }

        // 5. Tạo yêu cầu hủy
        boolean success = orderDAO.createCancellationRequest(
                orderId,
                user.getId(),
                reason
        );

        if (!success) {
            response.setStatus(HttpServletResponse.SC_CONFLICT);
            response.getWriter().write(
                    "Không thể gửi yêu cầu. Đơn hàng không đủ điều kiện " +
                            "hủy hoặc đã có yêu cầu đang chờ xử lý."
            );
            return;
        }

        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write(
                "Gửi yêu cầu hủy đơn hàng thành công. Vui lòng chờ Admin xử lý."
        );
    }
}
