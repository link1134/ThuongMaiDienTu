
package com.mangaz.controller;

import com.mangaz.dao.ListingDAO;
import com.mangaz.dao.OrderDAO;
import com.mangaz.model.Listing;
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
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet("/seller/dashboard")
public class SellerCenterServlet extends HttpServlet {
    private final ListingDAO listingDAO = new ListingDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || !(session.getAttribute("user") instanceof User)) {
            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return;
        }

        User user = (User) session.getAttribute("user");

// Lấy bài đăng của người bán hiện tại
        List<Listing> sellerListings =
                listingDAO.getListingsBySellerId(user.getId());

        request.setAttribute("sellerListings", sellerListings);

        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        String startDateParam = request.getParameter("startDate");
        String endDateParam = request.getParameter("endDate");

        try {
            LocalDate startDate = null;
            LocalDate endDate = null;

            if (startDateParam != null && !startDateParam.isBlank()) {
                startDate = LocalDate.parse(startDateParam);
            }

            if (endDateParam != null && !endDateParam.isBlank()) {
                endDate = LocalDate.parse(endDateParam);
            }

            if (startDate != null && endDate != null
                    && startDate.isAfter(endDate)) {
                request.setAttribute(
                        "orderError",
                        "Ngày bắt đầu không được sau ngày kết thúc."
                );
            } else {
                List<Order> sellerOrders = orderDAO.getOrdersBySellerId(
                        user.getId(),
                        keyword,
                        status,
                        startDate,
                        endDate
                );

                request.setAttribute("sellerOrders", sellerOrders);
            }

        } catch (DateTimeParseException e) {
            request.setAttribute(
                    "orderError",
                    "Ngày lọc không hợp lệ."
            );
        } catch (SQLException e) {
            throw new ServletException(
                    "Không thể tải danh sách đơn bán.", e
            );
        }

        request.getRequestDispatcher("/SellerCenter.jsp")
                .forward(request, response);
    }
}
