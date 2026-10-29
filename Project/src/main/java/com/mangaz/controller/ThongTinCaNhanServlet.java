package com.mangaz.controller;

import com.mangaz.dao.OrderDAO;
import com.mangaz.dao.UserDAO;
import com.mangaz.model.Order;
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

@WebServlet("/profile")
public class ThongTinCaNhanServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp
    ) throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/Login.jsp");
            return;
        }

        try {
            User sessionUser = (User) session.getAttribute("user");
            User user = userDAO.findById(sessionUser.getId());

            if (user == null) {
                session.invalidate();
                resp.sendRedirect(req.getContextPath() + "/Login.jsp");
                return;
            }

            req.setAttribute("profile", user);

            List<Order> orders = orderDAO.getOrdersByUserId(user.getId());
            req.setAttribute("orders", orders);
            int pendingCount = 0;
            int processingCount = 0;
            int shippingCount = 0;
            int completedCount = 0;
            int cancelledCount = 0;
            for (Order order : orders) {
                String status = order.getStatus();
                if ("Pending".equalsIgnoreCase(status)) pendingCount++;
                else if ("Processing".equalsIgnoreCase(status)) processingCount++;
                else if ("Shipping".equalsIgnoreCase(status)) shippingCount++;
                else if ("Completed".equalsIgnoreCase(status)) completedCount++;
                else if ("Cancelled".equalsIgnoreCase(status)) cancelledCount++;
            }
            req.setAttribute("totalOrdersCount", orders.size());
            req.setAttribute("pendingCount", pendingCount);
            req.setAttribute("processingCount", processingCount);
            req.setAttribute("shippingCount", shippingCount);
            req.setAttribute("completedCount", completedCount);
            req.setAttribute("cancelledCount", cancelledCount);

            req.getRequestDispatcher("/ThongTinCaNhan.jsp")
                    .forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Không thể tải thông tin hồ sơ", e);
        }
    }
}