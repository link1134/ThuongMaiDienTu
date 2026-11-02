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

@WebServlet("/comment/add")
public class CommentServlet extends HttpServlet {
    private final CommentDAO commentDAO = new CommentDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");
        String listingIdParam = req.getParameter("listingId");
        String content = req.getParameter("content");
        String parentIdParam = req.getParameter("parentCommentId");
        if (listingIdParam != null && content != null && !content.trim().isEmpty()) {
            try {
                int listingId = Integer.parseInt(listingIdParam);
                Comment comment = new Comment();
                comment.setListingId(listingId);
                comment.setUserId(user.getId());
                comment.setContent(content.trim());

                if (parentIdParam != null && !parentIdParam.trim().isEmpty()) {
                    comment.setParentCommentId(Integer.parseInt(parentIdParam));
                }

                commentDAO.addComment(comment);
                resp.sendRedirect(req.getContextPath() + "/product-detail?id=" + listingId + "#comment-panel");
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    }
}
