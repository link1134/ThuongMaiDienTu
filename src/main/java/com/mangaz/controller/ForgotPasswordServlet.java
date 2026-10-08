package com.mangaz.controller;

import com.mangaz.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private final AuthService authService = new AuthService();
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        try {
            String identifier = req.getParameter("identifier");
            if (identifier == null || identifier.trim().isEmpty()) {
                req.setAttribute("error", "Vui lòng nhập email hoặc tên tài khoản.");
            } else {
                authService.requestPasswordReset(identifier);
                req.setAttribute("success", "Nếu tài khoản tồn tại, liên kết đặt lại mật khẩu đã được gửi đến email đã đăng ký.");
            }
            req.getRequestDispatcher("/ForgotPassword.jsp").forward(req, resp);
        } catch (Exception e) { throw new ServletException("Forgot password failed", e); }
    }
}
