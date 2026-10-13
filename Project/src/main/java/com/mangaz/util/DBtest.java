package com.mangaz.util;

import java.sql.Connection;

public class DBtest {

    public static void main(String[] args) {
        try {
            Connection connection = DBConnection.getConnection();

            System.out.println("=================================");
            System.out.println("KET NOI SQL SERVER THANH CONG!");
            System.out.println("Database: " + connection.getCatalog());
            System.out.println("=================================");

            connection.close();

        } catch (Exception e) {
            System.out.println("=================================");
            System.out.println("KET NOI SQL SERVER THAT BAI!");
            System.out.println("=================================");
            e.printStackTrace();
        }
    }
}