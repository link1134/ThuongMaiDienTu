package com.mangaz.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public final class DBConnection {
    private static final Properties CONFIG = ConfigUtil.load("db.properties");
    private DBConnection() {}

    public static Connection getConnection() throws SQLException {
        String url = CONFIG.getProperty("db.url");
        String username = CONFIG.getProperty("db.username");
        String password = CONFIG.getProperty("db.password");

        if (url == null || username == null || password == null) {
            throw new SQLException("Missing db.properties configuration.");
        }

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Không tìm thấy SQL Server JDBC Driver", e);
        }

        return DriverManager.getConnection(url, username, password);
    }
}