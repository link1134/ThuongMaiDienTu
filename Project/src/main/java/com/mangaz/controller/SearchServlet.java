
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

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    private final ListingDAO listingDAO = new ListingDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String keyword = request.getParameter("keyword");

        if (keyword == null) {
            keyword = "";
        }

        keyword = keyword.trim();

        try {
            List<Listing> products = listingDAO.searchByTitle(keyword);

            request.setAttribute("keyword", keyword);
            request.setAttribute("products", products);
            request.setAttribute("totalResults", products.size());

            request.getRequestDispatcher("/Search.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                    "Lỗi khi tìm kiếm bài đăng", e
            );
        }
    }
}
