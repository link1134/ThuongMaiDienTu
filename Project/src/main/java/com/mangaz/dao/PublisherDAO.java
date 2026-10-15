package com.mangaz.dao;

import com.mangaz.model.Publisher;
import com.mangaz.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PublisherDAO {
    /**
     * Lấy toàn bộ danh sách NXB đang hoạt động
     */
    public List<Publisher> getAllPublishers() {
        List<Publisher> list = new ArrayList<>();
        String sql = "SELECT PublisherID, PublisherCode, PublisherName FROM Publishers WHERE Status = 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Publisher pub = new Publisher();
                pub.setPublisherId(rs.getInt("PublisherID"));
                pub.setPublisherCode(rs.getString("PublisherCode"));
                pub.setPublisherName(rs.getString("PublisherName"));
                list.add(pub);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    /**
     * Đếm tổng số Nhà xuất bản hiện có trong CSDL
     */
    public int countPublishers() {
        String sql = "SELECT COUNT(*) FROM Publishers";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}