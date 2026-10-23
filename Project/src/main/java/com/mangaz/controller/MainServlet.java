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

@WebServlet("/main")
public class MainServlet extends HttpServlet {

    private final ListingDAO listingDAO = new ListingDAO();
    private final TagDAO tagDAO = new TagDAO();

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
            req.setAttribute("products", products);
            req.getRequestDispatcher("/Main.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException(
                    "Không thể tải danh sách sản phẩm và tag.", e);
        }
    }
}