package com.mangaz.controller;

import com.mangaz.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp
    ) throws ServletException, IOException {

        resp.sendRedirect(req.getContextPath() + "/Register.jsp");
    }

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp
    ) throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        try {
            AuthService.RegisterResult result = authService.register(
                    req.getParameter("username"),
                    req.getParameter("email"),
                    req.getParameter("password"),
                    req.getParameter("confirmPassword"),
                    req.getParameter("fullName")
            );

            if (!result.isSuccess()) {
                req.setAttribute("error", result.getMessage());
                req.getRequestDispatcher("/Register.jsp").forward(req, resp);
                return;
            }

            req.setAttribute("success", result.getMessage());
            req.getRequestDispatcher("/Login.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Register failed", e);
        }
    }
}