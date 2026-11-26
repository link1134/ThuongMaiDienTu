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
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/orderManager")
public class AdminOrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // 1. Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);

        if (session == null
                || !(session.getAttribute("user") instanceof User)) {

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return;
        }

        // 2. Kiểm tra quyền Admin
        User user = (User) session.getAttribute("user");

        if (!"Admin".equalsIgnoreCase(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            // 3. Lấy toàn bộ đơn hàng
            List<OrderDAO.AdminOrderData> orders =
                    orderDAO.getAllOrdersForAdmin();

            // 4. Lấy danh sách yêu cầu hủy
            List<OrderDAO.AdminCancellationData> cancellationRequests =
                    orderDAO.getCancellationRequestsForAdmin();

            // 5. Đếm số đơn hàng theo trạng thái
            int pendingOrders = 0;
            int shippingOrders = 0;

            for (OrderDAO.AdminOrderData item : orders) {

                String status = item.getOrder().getStatus();

                if ("Pending".equalsIgnoreCase(status)
                        || "Processing".equalsIgnoreCase(status)) {
                    pendingOrders++;
                }

                if ("Shipping".equalsIgnoreCase(status)) {
                    shippingOrders++;
                }
            }

            // 6. Đưa dữ liệu sang JSP
            request.setAttribute("adminOrders", orders);

            request.setAttribute(
                    "cancellationRequests",
                    cancellationRequests
            );

            request.setAttribute("pendingOrders", pendingOrders);
            request.setAttribute("shippingOrders", shippingOrders);

            request.setAttribute(
                    "pendingCancellationCount",
                    cancellationRequests.stream()
                            .filter(item -> "Pending".equalsIgnoreCase(
                                    item.getRequestStatus()
                            ))
                            .count()
            );

            // Giữ lại tài khoản Admin để hiển thị thông tin
            request.setAttribute("adminUser", user);

            // 7. Chuyển đến giao diện quản lý đơn hàng
            request.getRequestDispatcher("/AdminOrders.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                    "Không thể tải dữ liệu quản lý đơn hàng Admin.", e
            );
        }
    }
}
