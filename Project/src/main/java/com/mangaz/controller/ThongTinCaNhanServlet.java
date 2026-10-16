package com.mangaz.controller;

import com.mangaz.dao.UserDAO;
import com.mangaz.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/profile")
public class ThongTinCaNhanServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

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

            req.getRequestDispatcher("/ThongTinCaNhan.jsp")
                    .forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Không thể tải thông tin hồ sơ", e);
        }
    }
}