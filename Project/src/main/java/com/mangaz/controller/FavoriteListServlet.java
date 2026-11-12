package com.mangaz.controller;

import com.mangaz.dao.FavoriteDAO;
import com.mangaz.model.Listing;
import com.mangaz.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/favorites")
public class FavoriteListServlet extends HttpServlet {

    private final FavoriteDAO favoriteDAO = new FavoriteDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Kiểm tra đăng nhập
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/Login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            // Lấy danh sách sản phẩm yêu thích
            List<Listing> favorites =
                    favoriteDAO.getFavoritesByUserId(user.getId());

            // Lấy số lượng sản phẩm yêu thích
            int favoriteCount = favorites.size();

            req.setAttribute("favorites", favorites);
            req.setAttribute("favoriteCount", favoriteCount);

            req.getRequestDispatcher("/Favorites.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();

            throw new ServletException(
                    "Không thể tải danh sách sản phẩm yêu thích.", e
            );
        }
    }
}
