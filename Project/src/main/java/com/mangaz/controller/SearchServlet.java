package com.mangaz.controller;

import com.mangaz.dao.ListingDAO;
import com.mangaz.model.Listing;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    private final ListingDAO listingDAO = new ListingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String keyword = request.getParameter("keyword");
        keyword = keyword == null ? "" : keyword.trim();

        String type = request.getParameter("type");
        type = type == null ? "All" : type;

        if (!type.equals("All") && !type.equals("Sale") && !type.equals("Auction")) {
            type = "All";
        }

        boolean partial = "true".equals(request.getParameter("partial"));

        try {
            List<Listing> products = listingDAO.searchByTitle(keyword, type);

            Map<String, Integer> counts = listingDAO.getSearchCounts(keyword);

            request.setAttribute("keyword", keyword);
            request.setAttribute("products", products);
            request.setAttribute("totalResults", products.size());

            request.setAttribute("allCount", counts.get("All"));
            request.setAttribute("saleCount", counts.get("Sale"));
            request.setAttribute("auctionCount", counts.get("Auction"));

            request.setAttribute("selectedType", type);

            if (partial) {
                response.setContentType("text/html;charset=UTF-8");

                request.getRequestDispatcher("/SearchResult.jsp").forward(request, response);

            } else {
                request.getRequestDispatcher("/Search.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            throw new ServletException("Lỗi khi tìm kiếm bài đăng", e);
        }
    }
}