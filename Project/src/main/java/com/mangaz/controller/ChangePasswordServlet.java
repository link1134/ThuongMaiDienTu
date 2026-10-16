
package com.mangaz.controller;

import com.mangaz.dao.UserDAO;
import com.mangaz.model.User;
import com.mangaz.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            sendResponse(response, 401, false,
                    "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (currentPassword == null || newPassword == null
                || confirmPassword == null) {

            getServletContext().log(
                    "Thiếu tham số đổi mật khẩu: currentPassword="
                            + (currentPassword != null)
                            + ", newPassword=" + (newPassword != null)
                            + ", confirmPassword=" + (confirmPassword != null)
            );

            sendResponse(response, 400, false,
                    "Dữ liệu gửi lên bị thiếu. Vui lòng tải lại trang và thử lại.");
            return;
        }

        if (currentPassword.isBlank() || newPassword.isBlank()
                || confirmPassword.isBlank()) {

            sendResponse(response, 400, false,
                    "Có ô mật khẩu đang để trống.");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            sendResponse(response, 400, false,
                    "Mật khẩu mới nhập lại không khớp.");
            return;
        }

        if (newPassword.length() < 8) {
            sendResponse(response, 400, false,
                    "Mật khẩu mới phải có ít nhất 8 ký tự.");
            return;
        }

        if (currentPassword.equals(newPassword)) {
            sendResponse(response, 400, false,
                    "Mật khẩu mới phải khác mật khẩu hiện tại.");
            return;
        }

        try {
            // Lấy hash mới nhất từ database để xác thực.
            User dbUser = userDAO.findById(sessionUser.getId());

            if (dbUser == null) {
                sendResponse(response, 404, false,
                        "Không tìm thấy tài khoản.");
                return;
            }

            if (!PasswordUtil.checkPassword(
                    currentPassword, dbUser.getPassword())) {

                sendResponse(response, 400, false,
                        "Mật khẩu hiện tại không chính xác.");
                return;
            }

            // Mã hóa mật khẩu mới bằng BCrypt.
            String newHash = PasswordUtil.hashPassword(newPassword);

            boolean updated = userDAO.updatePassword(
                    dbUser.getId(), newHash);

            if (!updated) {
                sendResponse(response, 500, false,
                        "Không thể cập nhật mật khẩu. Vui lòng thử lại.");
                return;
            }

            // Đồng bộ hash trong session hiện tại.
            sessionUser.setPassword(newHash);

            sendResponse(response, 200, true,
                    "Đổi mật khẩu thành công!");

        } catch (SQLException e) {
            getServletContext().log("Lỗi cập nhật mật khẩu", e);

            sendResponse(response, 500, false,
                    "Lỗi cơ sở dữ liệu. Vui lòng thử lại sau.");
        }
    }

    private void sendResponse(HttpServletResponse response,
                              int status,
                              boolean success,
                              String message) throws IOException {

        response.setStatus(status);

        String json = "{\"success\":" + success
                + ",\"message\":\"" + message + "\"}";

        response.getWriter().write(json);
    }
}
