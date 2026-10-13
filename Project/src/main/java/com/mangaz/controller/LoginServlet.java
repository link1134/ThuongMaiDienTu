package com.mangaz.controller;

import com.mangaz.model.User;
import com.mangaz.service.AuthService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp
    ) throws ServletException, IOException {

        resp.sendRedirect(req.getContextPath() + "/Login.jsp");
    }

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp
    ) throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        try {
            String identifier = req.getParameter("identifier");
            String password = req.getParameter("password");

            // Kiểm tra lỗi (sai thông tin, chưa xác nhận email, bị khóa...)
            String error = authService.getLoginError(identifier, password);

            if (error != null) {
                req.setAttribute("error", error);
                req.getRequestDispatcher("/Login.jsp").forward(req, resp);
                return;
            }

            User user = authService.login(identifier, password);

            if (user == null) {
                req.setAttribute("error", "Không thể đăng nhập. Vui lòng thử lại.");
                req.getRequestDispatcher("/Login.jsp").forward(req, resp);
                return;
            }

            HttpSession session = req.getSession();
            req.changeSessionId();
            session.setAttribute("user", user);

            resp.sendRedirect(req.getContextPath() + "/main");

        } catch (Exception e) {
            throw new ServletException("Login failed", e);
        }
    }
}