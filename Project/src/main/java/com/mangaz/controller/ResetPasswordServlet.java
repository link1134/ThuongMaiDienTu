package com.mangaz.controller;

import com.mangaz.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    private final AuthService authService = new AuthService();
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        try {
            if (!authService.isResetTokenValid(token)) {
                req.setAttribute("error", "Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.");
                req.getRequestDispatcher("/ForgotPassword.jsp").forward(req, resp);
                return;
            }
        } catch (Exception e) { throw new ServletException("Reset password failed", e); }
        req.setAttribute("token", token);
        req.getRequestDispatcher("/ResetPassword.jsp").forward(req, resp);
    }
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String token = req.getParameter("token");
            boolean ok = authService.resetPassword(token, req.getParameter("password"), req.getParameter("confirmPassword"));
            if (!ok) { req.setAttribute("error", "Token không hợp lệ/hết hạn hoặc mật khẩu không hợp lệ."); req.setAttribute("token", token); req.getRequestDispatcher("/ResetPassword.jsp").forward(req, resp); return; }
            req.setAttribute("success", "Đặt lại mật khẩu thành công. Bạn có thể đăng nhập bằng mật khẩu mới.");
            req.getRequestDispatcher("/Login.jsp").forward(req, resp);
        } catch (Exception e) { throw new ServletException("Reset password failed", e); }
    }
}