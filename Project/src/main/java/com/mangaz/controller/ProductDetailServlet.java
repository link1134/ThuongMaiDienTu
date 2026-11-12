package com.mangaz.controller;

import com.mangaz.dao.CommentDAO;
import com.mangaz.dao.ProductDAO;
import com.mangaz.model.Comment;
import com.mangaz.model.ProductDetail;
import com.mangaz.dao.FavoriteDAO;
import com.mangaz.model.User;

import jakarta.servlet.http.HttpSession;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/product-detail")
public class ProductDetailServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final CommentDAO commentDAO = new CommentDAO();
    private final FavoriteDAO favoriteDAO = new FavoriteDAO();
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
        product.setAttributes(
                productDAO.findAttributesByListingId(listingId)
        );
        List<Comment> comments = commentDAO.getCommentsByListingId(listingId, product.getSellerId());
        int totalCommentCount = 0;
        for (Comment c : comments) {
            totalCommentCount += 1 + c.getReplies().size();
        }
        // Kiểm tra trạng thái yêu thích
        boolean isFavorite = false;

        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            isFavorite = favoriteDAO.isFavorite(user.getId(), listingId);
        }

        // Chuyển dữ liệu sang JSP
        request.setAttribute("comments", comments);
        request.setAttribute("commentCount", totalCommentCount);
        request.setAttribute("product", product);
        request.setAttribute("isFavorite", isFavorite);
        request.getRequestDispatcher("/BookDetail.jsp").forward(request, response);
    }
}
