package com.mangaz.controller;

import com.mangaz.dao.ListingDAO;
import com.mangaz.dao.TagDAO;
import com.mangaz.model.Listing;
import com.mangaz.model.Tag;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import com.mangaz.dao.FavoriteDAO;
import com.mangaz.model.User;
import jakarta.servlet.http.HttpSession;
import java.util.Set;
import java.util.HashSet;

@WebServlet("/main")
public class MainServlet extends HttpServlet {

    private final ListingDAO listingDAO = new ListingDAO();
    private final TagDAO tagDAO = new TagDAO();
    private final FavoriteDAO favoriteDAO = new FavoriteDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        try {
            List<Listing> products = listingDAO.getLatestListings();
            List<Integer> listingIds = new ArrayList<>();
            for (Listing product : products) {
                listingIds.add(product.getListingId());
            }
            Map<Integer, List<Tag>> tagsByListing =
                    tagDAO.getTagsByListingIds(listingIds);
            for (Listing product : products) {
                List<Tag> tags = tagsByListing.get(product.getListingId());
                if (tags != null) {
                    product.setTags(tags);
                }
            }
            // Lấy danh sách sản phẩm yêu thích của người dùng
            Set<Integer> favoriteIds = new HashSet<>();
            int favoriteCount = 0;

            HttpSession session = req.getSession(false);

            if (session != null && session.getAttribute("user") != null) {

                User user = (User) session.getAttribute("user");

                favoriteIds = favoriteDAO.getFavoriteListingIds(user.getId());
                favoriteCount = favoriteIds.size();
            }
            req.setAttribute("products", products);
            req.setAttribute("favoriteIds", favoriteIds);
            req.setAttribute("favoriteCount", favoriteCount);

            req.getRequestDispatcher("/Main.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException(
                    "Không thể tải danh sách sản phẩm và tag.", e);
        }
    }
}