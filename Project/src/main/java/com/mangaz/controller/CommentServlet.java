package com.mangaz.controller;

import com.mangaz.dao.CommentDAO;
import com.mangaz.model.Comment;
import com.mangaz.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet({"/comment/add", "/comment/update", "/comment/delete"})
public class CommentServlet extends HttpServlet {
    private final CommentDAO commentDAO = new CommentDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");
        String listingIdParam = req.getParameter("listingId");
        String path = req.getServletPath();
        if (listingIdParam == null || listingIdParam.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }
        try {
            int listingId = Integer.parseInt(listingIdParam);
            if ("/comment/add".equals(path)) {
                // --- THÊM BÌNH LUẬN / THÊM CÂU TRẢ LỜI ---
                String content = req.getParameter("content");
                String parentIdParam = req.getParameter("parentCommentId");
                if (content != null && !content.trim().isEmpty()) {
                    Comment comment = new Comment();
                    comment.setListingId(listingId);
                    comment.setUserId(user.getId());
                    comment.setContent(content.trim());
                    if (parentIdParam != null && !parentIdParam.trim().isEmpty()) {
                        comment.setParentCommentId(Integer.parseInt(parentIdParam));
                    }
                    commentDAO.addComment(comment);
                }
            } else if ("/comment/update".equals(path)) {
                // --- SỬA BÌNH LUẬN ---
                String commentIdParam = req.getParameter("commentId");
                String content = req.getParameter("content");
                if (commentIdParam != null && content != null && !content.trim().isEmpty()) {
                    int commentId = Integer.parseInt(commentIdParam);
                    commentDAO.updateComment(commentId, user.getId(), content.trim());
                }
            } else if ("/comment/delete".equals(path)) {
                // --- XÓA BÌNH LUẬN ---
                String commentIdParam = req.getParameter("commentId");
                if (commentIdParam != null && !commentIdParam.trim().isEmpty()) {
                    int commentId = Integer.parseInt(commentIdParam);
                    commentDAO.deleteComment(commentId, user.getId());
                }
            }
            resp.sendRedirect(req.getContextPath() + "/product-detail?id=" + listingId + "#comment-panel");
            return;
        } catch (Exception e) {
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect(req.getContextPath() + "/");
    }
}
