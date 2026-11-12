package com.mangaz.controller;

import com.mangaz.dao.FavoriteDAO;
import com.mangaz.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/favorite/toggle")
public class FavoriteServlet extends HttpServlet {

    private final FavoriteDAO favoriteDAO = new FavoriteDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");

        try {
            // 1. Kiểm tra đăng nhập
            HttpSession session = req.getSession(false);

            if (session == null || session.getAttribute("user") == null) {
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                resp.getWriter().write(
                        "{\"success\":false,\"message\":\"Vui lòng đăng nhập!\"}"
                );
                return;
            }

            User user = (User) session.getAttribute("user");

            // 2. Lấy ListingId
            String listingIdParam = req.getParameter("listingId");

            if (listingIdParam == null || listingIdParam.trim().isEmpty()) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write(
                        "{\"success\":false,\"message\":\"Thiếu mã sản phẩm!\"}"
                );
                return;
            }

            int listingId = Integer.parseInt(listingIdParam);

            if (listingId <= 0) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write(
                        "{\"success\":false,\"message\":\"Mã sản phẩm không hợp lệ!\"}"
                );
                return;
            }

            // 3. Kiểm tra trạng thái yêu thích hiện tại
            boolean isFavorite = favoriteDAO.isFavorite(
                    user.getId(), listingId
            );

            boolean success;

            // 4. Nếu đã yêu thích thì xóa, ngược lại thì thêm
            if (isFavorite) {
                success = favoriteDAO.removeFavorite(
                        user.getId(), listingId
                );
            } else {
                success = favoriteDAO.addFavorite(
                        user.getId(), listingId
                );
            }

            if (!success) {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write(
                        "{\"success\":false,\"message\":\"Không thể cập nhật danh sách yêu thích!\"}"
                );
                return;
            }

            // 5. Lấy trạng thái và số lượng mới nhất
            boolean newFavoriteStatus = favoriteDAO.isFavorite(
                    user.getId(), listingId
            );

            int favoriteCount = favoriteDAO.countFavorites(user.getId());

            // 6. Trả kết quả JSON
            resp.setStatus(HttpServletResponse.SC_OK);

            resp.getWriter().write(
                    "{\"success\":true,"
                            + "\"isFavorite\":" + newFavoriteStatus + ","
                            + "\"favoriteCount\":" + favoriteCount + ","
                            + "\"message\":\""
                            + (newFavoriteStatus
                            ? "Đã thêm vào yêu thích!"
                            : "Đã bỏ yêu thích!")
                            + "\"}"
            );

        } catch (NumberFormatException e) {

            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write(
                    "{\"success\":false,\"message\":\"Mã sản phẩm không hợp lệ!\"}"
            );

        } catch (Exception e) {

            e.printStackTrace();

            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write(
                    "{\"success\":false,\"message\":\"Đã xảy ra lỗi khi xử lý yêu thích!\"}"
            );
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
}
