package com.mangaz.dao;

import com.mangaz.model.User;
import com.mangaz.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;

public class UserDAO {


    private User map(ResultSet rs) throws SQLException {

        return new User(
                rs.getInt("Id"),
                rs.getString("Username"),
                rs.getString("Email"),
                rs.getString("Password"),
                rs.getString("FullName"),
                rs.getBoolean("EmailVerified"),
                rs.getBoolean("Enabled"),
                rs.getTimestamp("CreatedAt")
        );
    }


    // =========================================================
    // TÌM USER THEO USERNAME HOẶC EMAIL
    // =========================================================

    public User findByUsernameOrEmail(
            String input
    ) throws SQLException {

        String sql =
                "SELECT * FROM Users " +
                        "WHERE Username = ? OR Email = ?";


        try (
                Connection c =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        c.prepareStatement(sql)
        ) {

            ps.setString(1, input);
            ps.setString(2, input);


            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return map(rs);
                }

                return null;
            }
        }
    }


    // =========================================================
    // TÌM USER THEO EMAIL
    // =========================================================

    public User findByEmail(
            String email
    ) throws SQLException {

        String sql =
                "SELECT * FROM Users WHERE Email = ?";


        try (
                Connection c =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        c.prepareStatement(sql)
        ) {

            ps.setString(1, email);


            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return map(rs);
                }

                return null;
            }
        }
    }


    // =========================================================
    // TÌM USER THEO USERNAME
    // =========================================================

    public User findByUsername(
            String username
    ) throws SQLException {

        String sql =
                "SELECT * FROM Users WHERE Username = ?";


        try (
                Connection c =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        c.prepareStatement(sql)
        ) {

            ps.setString(1, username);


            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return map(rs);
                }

                return null;
            }
        }
    }


    // =========================================================
    // TÌM USER THEO ID
    // =========================================================

    public User findById(
            int id
    ) throws SQLException {

        String sql =
                "SELECT * FROM Users WHERE Id = ?";


        try (
                Connection c =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        c.prepareStatement(sql)
        ) {

            ps.setInt(1, id);


            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return map(rs);
                }

                return null;
            }
        }
    }


    // =========================================================
    // TẠO USER
    // =========================================================

    public int createUser(
            User user
    ) throws SQLException {

        String sql =
                "INSERT INTO Users " +
                        "(Username, Email, Password, FullName, EmailVerified, Enabled) " +
                        "VALUES (?, ?, ?, ?, 0, 1)";


        try (
                Connection c =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        c.prepareStatement(
                                sql,
                                Statement.RETURN_GENERATED_KEYS
                        )
        ) {

            ps.setString(
                    1,
                    user.getUsername()
            );

            ps.setString(
                    2,
                    user.getEmail()
            );

            ps.setString(
                    3,
                    user.getPassword()
            );

            ps.setString(
                    4,
                    user.getFullName()
            );


            ps.executeUpdate();


            try (ResultSet keys =
                         ps.getGeneratedKeys()) {

                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }


        return 0;
    }


    // =========================================================
    // XÁC NHẬN EMAIL
    // =========================================================

    public void setEmailVerified(
            int userId
    ) throws SQLException {

        String sql =
                "UPDATE Users " +
                        "SET EmailVerified = 1 " +
                        "WHERE Id = ?";


        try (
                Connection c =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        c.prepareStatement(sql)
        ) {

            ps.setInt(1, userId);

            ps.executeUpdate();
        }
    }


    // =========================================================
    // UPDATE PASSWORD
    // =========================================================

    public void updatePassword(
            int userId,
            String hash
    ) throws SQLException {

        String sql =
                "UPDATE Users " +
                        "SET Password = ? " +
                        "WHERE Id = ?";


        try (
                Connection c =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        c.prepareStatement(sql)
        ) {

            ps.setString(1, hash);
            ps.setInt(2, userId);

            ps.executeUpdate();
        }
    }


    // =========================================================
    // LƯU TOKEN XÁC NHẬN EMAIL
    // =========================================================

    public void saveVerificationToken(
            int userId,
            String token,
            Timestamp expiresAt
    ) throws SQLException {

        String deleteSql =
                "DELETE FROM EmailVerificationTokens " +
                        "WHERE UserId = ?";


        String insertSql =
                "INSERT INTO EmailVerificationTokens " +
                        "(UserId, Token, ExpiresAt) " +
                        "VALUES (?, ?, ?)";


        try (
                Connection c =
                        DBConnection.getConnection()
        ) {

            // Xóa token cũ
            try (
                    PreparedStatement ps =
                            c.prepareStatement(deleteSql)
            ) {

                ps.setInt(1, userId);

                ps.executeUpdate();
            }


            // Tạo token mới
            try (
                    PreparedStatement ps =
                            c.prepareStatement(insertSql)
            ) {

                ps.setInt(1, userId);
                ps.setString(2, token);
                ps.setTimestamp(3, expiresAt);

                ps.executeUpdate();
            }
        }
    }


    // =========================================================
    // TÌM USER TỪ TOKEN XÁC NHẬN
    // =========================================================

    public int findUserIdByVerificationToken(
            String token
    ) throws SQLException {

        String sql =
                "SELECT UserId " +
                        "FROM EmailVerificationTokens " +
                        "WHERE Token = ? " +
                        "AND ExpiresAt > SYSDATETIME()";


        try (
                Connection c =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        c.prepareStatement(sql)
        ) {

            ps.setString(1, token);


            try (ResultSet rs =
                         ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt(1);
                }

                return 0;
            }
        }
    }


    // =========================================================
    // XÓA TOKEN XÁC NHẬN
    // =========================================================

    public void deleteVerificationToken(
            String token
    ) throws SQLException {

        String sql =
                "DELETE FROM EmailVerificationTokens " +
                        "WHERE Token = ?";


        try (
                Connection c =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        c.prepareStatement(sql)
        ) {

            ps.setString(1, token);

            ps.executeUpdate();
        }
    }


    // =========================================================
    // LƯU TOKEN RESET PASSWORD
    // =========================================================

    public void saveResetToken(
            int userId,
            String token,
            Timestamp expiresAt
    ) throws SQLException {

        String deleteSql =
                "DELETE FROM PasswordResetTokens " +
                        "WHERE UserId = ?";


        String insertSql =
                "INSERT INTO PasswordResetTokens " +
                        "(UserId, Token, ExpiresAt) " +
                        "VALUES (?, ?, ?)";


        try (
                Connection c =
                        DBConnection.getConnection()
        ) {

            // Xóa token cũ
            try (
                    PreparedStatement ps =
                            c.prepareStatement(deleteSql)
            ) {

                ps.setInt(1, userId);

                ps.executeUpdate();
            }


            // Tạo token mới
            try (
                    PreparedStatement ps =
                            c.prepareStatement(insertSql)
            ) {

                ps.setInt(1, userId);
                ps.setString(2, token);
                ps.setTimestamp(3, expiresAt);

                ps.executeUpdate();
            }
        }
    }


    // =========================================================
    // TÌM USER TỪ RESET TOKEN
    // =========================================================

    public int findUserIdByResetToken(
            String token
    ) throws SQLException {

        String sql =
                "SELECT UserId " +
                        "FROM PasswordResetTokens " +
                        "WHERE Token = ? " +
                        "AND ExpiresAt > SYSDATETIME()";


        try (
                Connection c =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        c.prepareStatement(sql)
        ) {

            ps.setString(1, token);


            try (ResultSet rs =
                         ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt(1);
                }

                return 0;
            }
        }
    }


    // =========================================================
    // XÓA RESET TOKEN
    // =========================================================

    public void deleteResetToken(
            String token
    ) throws SQLException {

        String sql =
                "DELETE FROM PasswordResetTokens " +
                        "WHERE Token = ?";


        try (
                Connection c =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        c.prepareStatement(sql)
        ) {

            ps.setString(1, token);

            ps.executeUpdate();
        }
    }
}