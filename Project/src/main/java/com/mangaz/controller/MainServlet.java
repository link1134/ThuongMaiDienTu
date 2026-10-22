
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

@WebServlet("/main")
public class MainServlet extends HttpServlet {

    private final ListingDAO listingDAO = new ListingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        try {
            List<Listing> products = listingDAO.getLatestListings();
            req.setAttribute("products", products);

            req.getRequestDispatcher("/Main.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Không thể tải danh sách sản phẩm mới nhất.", e);
        }
    }
}
