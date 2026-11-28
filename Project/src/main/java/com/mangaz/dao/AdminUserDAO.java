package com.mangaz.dao;

import com.mangaz.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO dành riêng cho trang quản lý người dùng của Admin
 * (tìm kiếm, lọc, phân trang, khóa/mở khóa, sửa, xóa).
 */
public class AdminUserDAO {

    /** Một dòng trong bảng "Danh sách tài khoản". */
    public static class UserRow {
        private int id;
        private String username;
        private String email;
        private String fullName;
        private String phoneNumber;
        private String role;          // "Admin" hoặc "User"
        private boolean seller;       // đã được duyệt làm người bán
        private boolean emailVerified;
        private boolean enabled;
        private Timestamp createdAt;

        public int getId() { return id; }
        public String getUsername() { return username; }
        public String getEmail() { return email; }
        public String getFullName() { return fullName; }
        public String getPhoneNumber() { return phoneNumber; }
        public String getRole() { return role; }
        public boolean isSeller() { return seller; }
        public boolean isEmailVerified() { return emailVerified; }
        public boolean isEnabled() { return enabled; }
        public Timestamp getCreatedAt() { return createdAt; }
    }

    // ---------------------------------------------------------
    // Điều kiện WHERE dùng chung cho đếm + liệt kê
    // ---------------------------------------------------------
    private String buildWhere(String keyword, String status, List<Object> params) {
        StringBuilder where = new StringBuilder(" WHERE 1 = 1");

        if (keyword != null && !keyword.isBlank()) {
            String like = "%" + escapeLike(keyword.trim()) + "%";
            where.append(" AND (u.FullName LIKE ? ESCAPE '\\'")
                    .append(" OR u.Email LIKE ? ESCAPE '\\'")
                    .append(" OR u.Username LIKE ? ESCAPE '\\')");
            params.add(like);
            params.add(like);
            params.add(like);
        }

        if ("active".equals(status)) {
            where.append(" AND u.Enabled = 1");
        } else if ("locked".equals(status)) {
            where.append(" AND u.Enabled = 0");
        }
        return where.toString();
    }

    private String escapeLike(String s) {
        return s.replace("\\", "\\\\")
                .replace("%", "\\%")
                .replace("_", "\\_")
                .replace("[", "\\[");
    }

    private void bind(PreparedStatement ps, List<Object> params) throws SQLException {
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
    }

    // ---------------------------------------------------------
    // Đếm tổng số tài khoản khớp bộ lọc
    // ---------------------------------------------------------
    public int countUsers(String keyword, String status) throws SQLException {
        List<Object> params = new ArrayList<>();
        String sql = "SELECT COUNT(*) FROM dbo.Users u" + buildWhere(keyword, status, params);

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            bind(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    // ---------------------------------------------------------
    // Lấy một trang danh sách (mới nhất trước)
    // ---------------------------------------------------------
    public List<UserRow> searchUsers(String keyword, String status, int offset, int limit)
            throws SQLException {
        List<Object> params = new ArrayList<>();
        String sql = """
                SELECT u.Id, u.Username, u.Email, u.FullName, u.PhoneNumber, u.Role,
                       u.EmailVerified, u.Enabled, u.CreatedAt,
                       CASE WHEN EXISTS (
                            SELECT 1 FROM dbo.SellerProfiles sp
                            WHERE sp.SellerId = u.Id AND sp.Status = N'Approved'
                       ) THEN 1 ELSE 0 END AS IsSeller
                FROM dbo.Users u
                """ + buildWhere(keyword, status, params) + """
                 ORDER BY u.Id DESC
                 OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """;
        params.add(offset);
        params.add(limit);

        List<UserRow> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            bind(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }
        return list;
    }

    private UserRow map(ResultSet rs) throws SQLException {
        UserRow u = new UserRow();
        u.id = rs.getInt("Id");
        u.username = rs.getString("Username");
        u.email = rs.getString("Email");
        u.fullName = rs.getString("FullName");
        u.phoneNumber = rs.getString("PhoneNumber");
        u.role = rs.getString("Role");
        u.emailVerified = rs.getBoolean("EmailVerified");
        u.enabled = rs.getBoolean("Enabled");
        u.createdAt = rs.getTimestamp("CreatedAt");
        u.seller = rs.getInt("IsSeller") == 1;
        return u;
    }

    // ---------------------------------------------------------
    // Lấy vai trò + trạng thái của một user (để kiểm tra quyền)
    // ---------------------------------------------------------
    public UserRow findById(int id) throws SQLException {
        String sql = """
                SELECT u.Id, u.Username, u.Email, u.FullName, u.PhoneNumber, u.Role,
                       u.EmailVerified, u.Enabled, u.CreatedAt, 0 AS IsSeller
                FROM dbo.Users u WHERE u.Id = ?
                """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    // ---------------------------------------------------------
    // Khóa / mở khóa
    // ---------------------------------------------------------
    public boolean setEnabled(int id, boolean enabled) throws SQLException {
        String sql = "UPDATE dbo.Users SET Enabled = ?, UpdatedAt = SYSDATETIME() WHERE Id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setBoolean(1, enabled);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ---------------------------------------------------------
    // Xóa tài khoản.
    // Xóa trong 1 transaction; nếu còn dữ liệu liên quan (đơn hàng,
    // bài đăng, bình luận...) SQL Server báo lỗi khóa ngoại (547) và
    // toàn bộ thao tác được rollback.
    // ---------------------------------------------------------
    public boolean deleteUser(int id) throws SQLException {
        try (Connection c = DBConnection.getConnection()) {
            c.setAutoCommit(false);
            try {
                // SellerProfiles trỏ tới DeliveryAddresses nên phải xóa trước
                execDelete(c, "DELETE FROM dbo.SellerProfiles WHERE SellerId = ?", id);
                execDelete(c, "DELETE FROM dbo.DeliveryAddresses WHERE UserId = ?", id);
                int affected = execDelete(c, "DELETE FROM dbo.Users WHERE Id = ?", id);
                c.commit();
                return affected > 0;
            } catch (SQLException e) {
                c.rollback();
                throw e;
            }
        }
    }

    private int execDelete(Connection c, String sql, int id) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate();
        }
    }
}
