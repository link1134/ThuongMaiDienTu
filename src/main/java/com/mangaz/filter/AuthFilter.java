package com.mangaz.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(
            ServletRequest request,
            ServletResponse response,
            FilterChain chain
    ) throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String contextPath = req.getContextPath();
        String uri = req.getRequestURI();

        String path = uri.substring(contextPath.length());

        // =========================
        // CÁC TRANG ĐƯỢC TRUY CẬP TỰ DO
        // =========================

        if (path.equals("/")
                || path.equals("")
                || path.equals("/main")
                || path.equals("/Main.jsp")
                || path.equals("/Login.jsp")
                || path.equals("/Register.jsp")
                || path.equals("/ForgotPassword.jsp")
                || path.equals("/ResetPassword.jsp")
                || path.equals("/login")
                || path.equals("/register")
                || path.equals("/forgot-password")
                || path.equals("/reset-password")
                || path.equals("/verify-email")
                || path.equals("/google-login")
                || path.equals("/google-callback")
                || path.equals("/logout")
                || path.startsWith("/css/")
                || path.startsWith("/js/")
                || path.startsWith("/images/")
                || path.startsWith("/assets/")
        ) {
            chain.doFilter(request, response);
            return;
        }

        // =========================
        // KIỂM TRA ĐĂNG NHẬP
        // =========================

        HttpSession session = req.getSession(false);

        boolean loggedIn =
                session != null &&
                        session.getAttribute("user") != null;

        if (loggedIn) {
            chain.doFilter(request, response);
            return;
        }

        // Chưa đăng nhập → Login
        resp.sendRedirect(contextPath + "/Login.jsp");
    }
}