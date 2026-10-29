
package com.mangaz.dao;

import com.mangaz.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class SellerProfileDAO {

    public static boolean existsBySellerId(int sellerId) {
        String sql = "SELECT 1 FROM dbo.SellerProfiles WHERE SellerId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, sellerId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
