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
        String sql = "SELECT PublisherID, PublisherCode, PublisherName FROM Publishers WHERE Status = 1 AND IsDeleted = 0";

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
     * Đếm tổng số Nhà xuất bản hiện có trong CSDL với IsDeleted =0;
     */
    public int countPublishers() {
        String sql = "SELECT COUNT(*) FROM Publishers WHERE IsDeleted = 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy danh sách NXB có phân trang
     */
    public List<Publisher> getPublishersByPage(int page, int pageSize) {
        List<Publisher> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        String sql = "SELECT PublisherID, PublisherCode, PublisherName, Country, Description, " +
                "Website, LogoURL, FoundedYear, Status, CreatedAt, UpdatedAt " +
                "FROM Publishers " +
                "WHERE IsDeleted = 0 " +
                "ORDER BY PublisherID DESC " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, offset);
            ps.setInt(2, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Publisher pub = new Publisher();
                    pub.setPublisherId(rs.getInt("PublisherID"));
                    pub.setPublisherCode(rs.getString("PublisherCode"));
                    pub.setPublisherName(rs.getString("PublisherName"));
                    pub.setCountry(rs.getString("Country"));
                    pub.setDescription(rs.getString("Description"));
                    pub.setWebsite(rs.getString("Website"));
                    pub.setLogoUrl(rs.getString("LogoURL"));
                    int year = rs.getInt("FoundedYear");
                    pub.setFoundedYear(rs.wasNull() ? null : year);
                    pub.setStatus(rs.getBoolean("Status"));
                    pub.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    pub.setUpdatedAt(rs.getTimestamp("UpdatedAt"));

                    list.add(pub);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy NXB theo ID
     */
    public Publisher getPublisherById(int id) {
        Publisher pub = null;
        String sql = "SELECT PublisherID, PublisherCode, PublisherName, Country, Description, " +
                "Website, LogoURL, FoundedYear, Status, CreatedAt, UpdatedAt " +
                "FROM Publishers WHERE PublisherID = ? AND IsDeleted = 0";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    pub = new Publisher();
                    pub.setPublisherId(rs.getInt("PublisherID"));
                    pub.setPublisherCode(rs.getString("PublisherCode"));
                    pub.setPublisherName(rs.getString("PublisherName"));
                    pub.setCountry(rs.getString("Country"));
                    pub.setDescription(rs.getString("Description"));
                    pub.setWebsite(rs.getString("Website"));
                    pub.setLogoUrl(rs.getString("LogoURL"));
                    int year = rs.getInt("FoundedYear");
                    pub.setFoundedYear(rs.wasNull() ? null : year);
                    pub.setStatus(rs.getBoolean("Status"));
                    pub.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    pub.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pub;
    }

    /**
     * Thêm mới NXB
     */
    public boolean insertPublisher(Publisher pub) {
        String sql = "INSERT INTO Publishers (PublisherCode, PublisherName, Country, Description, Website, LogoURL, FoundedYear, Status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, pub.getPublisherCode());
            ps.setString(2, pub.getPublisherName());
            ps.setString(3, pub.getCountry());
            ps.setString(4, pub.getDescription());
            ps.setString(5, pub.getWebsite());
            ps.setString(6, pub.getLogoUrl());
            if (pub.getFoundedYear() != null && pub.getFoundedYear() > 0) {
                ps.setInt(7, pub.getFoundedYear());
            } else {
                ps.setNull(7, Types.SMALLINT);
            }
            ps.setBoolean(8, pub.isStatus());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cập nhật NXB
     */
    public boolean updatePublisher(Publisher pub) {
        String sql = "UPDATE Publishers SET PublisherCode = ?, PublisherName = ?, Country = ?, " +
                "Description = ?, Website = ?, LogoURL = ?, FoundedYear = ?, Status = ?, UpdatedAt = SYSDATETIME() " +
                "WHERE PublisherID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, pub.getPublisherCode());
            ps.setString(2, pub.getPublisherName());
            ps.setString(3, pub.getCountry());
            ps.setString(4, pub.getDescription());
            ps.setString(5, pub.getWebsite());
            ps.setString(6, pub.getLogoUrl());
            if (pub.getFoundedYear() != null && pub.getFoundedYear() > 0) {
                ps.setInt(7, pub.getFoundedYear());
            } else {
                ps.setNull(7, Types.SMALLINT);
            }
            ps.setBoolean(8, pub.isStatus());
            ps.setInt(9, pub.getPublisherId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Xóa logic NXB (IsDeleted = 1)
     */
    public boolean deletePublisherLogic(int id) {
        String sql = "UPDATE Publishers SET IsDeleted = 1, UpdatedAt = SYSDATETIME() WHERE PublisherID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}