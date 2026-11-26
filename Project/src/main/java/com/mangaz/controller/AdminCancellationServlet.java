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

            success = orderDAO.approveCancellationRequest(
                    requestId,
                    user.getId()
            );

            message = success
                    ? "Đã duyệt yêu cầu hủy đơn hàng."
                    : "Không thể duyệt yêu cầu. Vui lòng kiểm tra lại trạng thái đơn hàng.";

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
