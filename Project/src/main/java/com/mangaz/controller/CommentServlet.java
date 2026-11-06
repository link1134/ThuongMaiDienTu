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
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");

        try {
            // 1. Kiểm tra đăng nhập
            HttpSession session = req.getSession(false);

            if (session == null || session.getAttribute("user") == null) {
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                resp.getWriter().write(
                        "{\"success\":false,\"message\":\"Vui lòng đăng nhập!\"}"
                );
                return;
            }

            User user = (User) session.getAttribute("user");

            // 2. Lấy thông tin request
            String listingIdParam = req.getParameter("listingId");
            String path = req.getServletPath();

            if (listingIdParam == null || listingIdParam.trim().isEmpty()) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write(
                        "{\"success\":false,\"message\":\"Thiếu thông tin bài đăng!\"}"
                );
                return;
            }

            int listingId = Integer.parseInt(listingIdParam);

            // 3. Thêm bình luận hoặc câu trả lời
            if ("/comment/add".equals(path)) {

                String content = req.getParameter("content");
                String parentIdParam = req.getParameter("parentCommentId");

                if (content == null || content.trim().isEmpty()) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write(
                            "{\"success\":false,\"message\":\"Nội dung không được để trống!\"}"
                    );
                    return;
                }

                Comment comment = new Comment();
                comment.setListingId(listingId);
                comment.setUserId(user.getId());
                comment.setContent(content.trim());

                if (parentIdParam != null && !parentIdParam.trim().isEmpty()) {
                    comment.setParentCommentId(Integer.parseInt(parentIdParam));
                }

                commentDAO.addComment(comment);

            }

            // 4. Sửa bình luận
            else if ("/comment/update".equals(path)) {

                String commentIdParam = req.getParameter("commentId");
                String content = req.getParameter("content");

                if (commentIdParam == null || content == null
                        || content.trim().isEmpty()) {

                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write(
                            "{\"success\":false,\"message\":\"Dữ liệu không hợp lệ!\"}"
                    );
                    return;
                }

                int commentId = Integer.parseInt(commentIdParam);

                commentDAO.updateComment(
                        commentId,
                        user.getId(),
                        content.trim()
                );
            }

            // 5. Xóa bình luận
            else if ("/comment/delete".equals(path)) {

                String commentIdParam = req.getParameter("commentId");

                if (commentIdParam == null || commentIdParam.trim().isEmpty()) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write(
                            "{\"success\":false,\"message\":\"Thiếu mã bình luận!\"}"
                    );
                    return;
                }

                int commentId = Integer.parseInt(commentIdParam);

                commentDAO.deleteComment(commentId, user.getId());
            }

            // 6. Trả kết quả JSON
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write(
                    "{\"success\":true,\"message\":\"Thao tác thành công!\"}"
            );

        } catch (NumberFormatException e) {

            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write(
                    "{\"success\":false,\"message\":\"Dữ liệu không hợp lệ!\"}"
            );

        } catch (Exception e) {

            e.printStackTrace();

            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write(
                    "{\"success\":false,\"message\":\"Đã xảy ra lỗi khi xử lý bình luận!\"}"
            );
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
}