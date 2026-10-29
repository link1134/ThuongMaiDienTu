
package com.mangaz.controller;

import com.mangaz.dao.SellerDashboardDAO;
import com.mangaz.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Map;

@WebServlet("/seller/dashboard-data")
public class SellerDashboardDataServlet extends HttpServlet {

    private final SellerDashboardDAO dashboardDAO =
            new SellerDashboardDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || !(session.getAttribute("user") instanceof User)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(
                    "{\"error\":\"Vui lòng đăng nhập lại.\"}"
            );
            return;
        }

        User user = (User) session.getAttribute("user");

        String startText = request.getParameter("startDate");
        String endText = request.getParameter("endDate");

        LocalDate startDate = null;
        LocalDate endDate = null;

        try {
            // Không truyền ngày nào = ALL, lấy dữ liệu từ trước đến nay.
            if ((startText == null || startText.isBlank())
                    && (endText == null || endText.isBlank())) {

                startDate = null;
                endDate = null;

            } else {
                // Nếu đã chọn ngày thì phải có đủ cả ngày bắt đầu và kết thúc.
                if (startText == null || startText.isBlank()
                        || endText == null || endText.isBlank()) {

                    response.setStatus(
                            HttpServletResponse.SC_BAD_REQUEST
                    );
                    response.getWriter().write(
                            "{\"error\":\"Vui lòng chọn đủ ngày bắt đầu và kết thúc.\"}"
                    );
                    return;
                }

                startDate = LocalDate.parse(startText);
                endDate = LocalDate.parse(endText);

                if (startDate.isAfter(endDate)) {
                    response.setStatus(
                            HttpServletResponse.SC_BAD_REQUEST
                    );
                    response.getWriter().write(
                            "{\"error\":\"Ngày bắt đầu không được sau ngày kết thúc.\"}"
                    );
                    return;
                }
            }

            Map<String, Object> data = dashboardDAO.getDashboardData(
                    user.getId(), startDate, endDate
            );

            BigDecimal revenue = (BigDecimal) data.get("totalRevenue");

            @SuppressWarnings("unchecked")
            Map<String, Integer> statuses =
                    (Map<String, Integer>) data.get("statuses");

            String json =
                    "{"
                            + "\"totalRevenue\":" + revenue.toPlainString() + ","
                            + "\"completedOrders\":" + data.get("completedOrders") + ","
                            + "\"processingOrders\":" + data.get("processingOrders") + ","
                            + "\"statuses\":{"
                            + "\"Completed\":" + statuses.get("Completed") + ","
                            + "\"Shipping\":" + statuses.get("Shipping") + ","
                            + "\"Processing\":" + statuses.get("Processing") + ","
                            + "\"Pending\":" + statuses.get("Pending") + ","
                            + "\"Cancelled\":" + statuses.get("Cancelled")
                            + "}"
                            + "}";

            response.getWriter().write(json);
            System.out.println(
                    "Dashboard userId = " + user.getId()
            );
        } catch (DateTimeParseException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(
                    "{\"error\":\"Ngày không hợp lệ.\"}"
            );

        } catch (SQLException e) {
            log("Lỗi truy vấn dữ liệu dashboard người bán", e);

            response.setStatus(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            );
            response.getWriter().write(
                    "{\"error\":\"Không thể tải dữ liệu dashboard.\"}"
            );
        }
    }
}
