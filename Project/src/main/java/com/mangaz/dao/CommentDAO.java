package com.mangaz.dao;

import com.mangaz.model.Comment;
import com.mangaz.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CommentDAO {
    // Lấy danh sách bình luận (gồm cả cây trả lời) theo ListingId
    public List<Comment> getCommentsByListingId(int listingId, int sellerId) {
        List<Comment> rootComments = new ArrayList<>();
        Map<Integer, Comment> commentMap = new HashMap<>();

        String sql = """
            SELECT c.CommentId, c.ListingId, c.UserId, c.ParentCommentId, c.Content, c.CreatedAt,
                   u.FullName, u.Username, u.AvatarUrl
            FROM dbo.ListingComments c
            JOIN dbo.Users u ON c.UserId = u.Id
            WHERE c.ListingId = ?
            ORDER BY c.CreatedAt ASC
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, listingId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Comment comment = new Comment();
                    comment.setCommentId(rs.getInt("CommentId"));
                    comment.setListingId(rs.getInt("ListingId"));
                    comment.setUserId(rs.getInt("UserId"));

                    int parentId = rs.getInt("ParentCommentId");
                    if (!rs.wasNull()) {
                        comment.setParentCommentId(parentId);
                    }

                    comment.setContent(rs.getString("Content"));
                    comment.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    comment.setUserFullName(rs.getString("FullName"));
                    comment.setUsername(rs.getString("Username"));
                    comment.setUserAvatarUrl(rs.getString("AvatarUrl"));
                    comment.setSeller(comment.getUserId() == sellerId);

                    commentMap.put(comment.getCommentId(), comment);

                    if (comment.getParentCommentId() == null) {
                        rootComments.add(comment);
                    } else {
                        Comment parent = commentMap.get(comment.getParentCommentId());
                        if (parent != null) {
                            parent.getReplies().add(comment);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rootComments;
    }
    // Thêm bình luận hoặc câu trả lời mới
    public boolean addComment(Comment comment) {
        String sql = """
            INSERT INTO dbo.ListingComments (ListingId, UserId, ParentCommentId, Content)
            VALUES (?, ?, ?, ?)
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, comment.getListingId());
            ps.setInt(2, comment.getUserId());

            if (comment.getParentCommentId() != null) {
                ps.setInt(3, comment.getParentCommentId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }

            ps.setString(4, comment.getContent());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
