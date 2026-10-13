package com.mangaz.controller;

import com.mangaz.service.AuthService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/verify-email")
public class VerifyEmailServlet extends HttpServlet {

    private final AuthService authService =
            new AuthService();


    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp
    ) throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");


        String token =
                req.getParameter("token");


        // Không có token
        if (token == null
                || token.trim().isEmpty()) {

            req.setAttribute(
                    "error",
                    "Liên kết xác nhận email không hợp lệ."
            );

            req.getRequestDispatcher(
                    "/Login.jsp"
            ).forward(req, resp);

            return;
        }


        try {


            boolean verified =
                    authService.verifyEmail(token);


            if (verified) {

                req.setAttribute(
                        "success",
                        "Xác nhận email thành công! "
                                + "Bạn có thể đăng nhập vào tài khoản."
                );

            } else {

                req.setAttribute(
                        "error",
                        "Liên kết xác nhận không hợp lệ "
                                + "hoặc đã hết hạn."
                );
            }


            req.getRequestDispatcher(
                    "/Login.jsp"
            ).forward(req, resp);


        } catch (Exception e) {

            throw new ServletException(
                    "Email verification failed",
                    e
            );
        }
    }
}