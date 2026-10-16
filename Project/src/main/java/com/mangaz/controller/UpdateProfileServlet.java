
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
import java.sql.Date;
import java.sql.SQLException;

@WebServlet("/profile/update")
public class UpdateProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp
    ) throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write(
                    "{\"success\":false,\"message\":\"Vui lòng đăng nhập lại.\"}"
            );
            return;
        }

        User sessionUser = (User) session.getAttribute("user");

        String field = req.getParameter("field");
        String value = req.getParameter("value");

        if (field == null || value == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write(
                    "{\"success\":false,\"message\":\"Thiếu dữ liệu cập nhật.\"}"
            );
            return;
        }

        value = value.trim();

        try {
            // Kiểm tra người dùng còn tồn tại
            User user = userDAO.findById(sessionUser.getId());

            if (user == null) {
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                resp.getWriter().write(
                        "{\"success\":false,\"message\":\"Tài khoản không tồn tại.\"}"
                );
                return;
            }

            boolean updated;

            switch (field) {
                case "fullName":
                    if (value.isEmpty()) {
                        resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        resp.getWriter().write(
                                "{\"success\":false,\"message\":\"Họ tên không được để trống.\"}"
                        );
                        return;
                    }

                    updated = userDAO.updateFullName(user.getId(), value);
                    break;

                case "phoneNumber":
                    updated = userDAO.updatePhoneNumber(
                            user.getId(),
                            value
                    );
                    break;

                case "dateOfBirth":
                    Date dateOfBirth = value.isEmpty()
                            ? null
                            : Date.valueOf(value);

                    updated = userDAO.updateDateOfBirth(
                            user.getId(),
                            dateOfBirth
                    );
                    break;

                case "gender":
                    if (value.isEmpty()) {
                        value = null;
                    }

                    updated = userDAO.updateGender(
                            user.getId(),
                            value
                    );
                    break;

                default:
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write(
                            "{\"success\":false,\"message\":\"Trường dữ liệu không hợp lệ.\"}"
                    );
                    return;
            }

            if (updated) {
                resp.getWriter().write(
                        "{\"success\":true,\"message\":\"Cập nhật thành công.\"}"
                );
            } else {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write(
                        "{\"success\":false,\"message\":\"Không thể cập nhật thông tin.\"}"
                );
            }

        } catch (IllegalArgumentException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write(
                    "{\"success\":false,\"message\":\"Ngày sinh không hợp lệ.\"}"
            );
        } catch (SQLException e) {
            throw new ServletException("Lỗi cập nhật thông tin cá nhân", e);
        }
    }
}
