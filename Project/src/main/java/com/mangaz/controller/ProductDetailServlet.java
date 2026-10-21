
package com.mangaz.controller;

import com.mangaz.dao.ProductDAO;
import com.mangaz.model.ProductDetail;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
@WebServlet("/product-detail")
public class ProductDetailServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        // Kiểm tra tham số ID
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Thiếu ID bài đăng."
            );
            return;
        }
        int listingId;
        try {
            listingId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "ID bài đăng không hợp lệ."
            );
            return;
        }
        // ID phải là số nguyên dương
        if (listingId <= 0) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "ID bài đăng không hợp lệ."
            );
            return;
        }
        // Lấy chi tiết bài đăng từ database
        ProductDetail product = productDAO.findById(listingId);
        if (product == null) {
            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Không tìm thấy bài đăng."
            );
            return;
        }
        // Chuyển dữ liệu sang JSP
        request.setAttribute("product", product);
        request.getRequestDispatcher(
                "/BookDetail.jsp"
        ).forward(request, response);
    }
}
