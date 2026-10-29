
package com.mangaz.dao;

import com.mangaz.util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.Map;

public class SellerDashboardDAO {

    public Map<String, Object> getDashboardData(
            int sellerId, LocalDate startDate, LocalDate endDate)
            throws SQLException {

        Map<String, Object> result = new LinkedHashMap<>();
        Map<String, Integer> statuses = new LinkedHashMap<>();

        StringBuilder sql = new StringBuilder(
                "SELECT " +
                        "COALESCE(SUM(CASE WHEN o.Status = N'Completed' " +
                        "THEN od.Quantity * od.Price ELSE 0 END), 0) AS TotalRevenue, " +

                        "COUNT(DISTINCT CASE WHEN o.Status = N'Completed' " +
                        "THEN o.OrderId END) AS CompletedOrders, " +

                        "COUNT(DISTINCT CASE WHEN o.Status = N'Processing' " +
                        "THEN o.OrderId END) AS ProcessingOrders, " +

                        "COUNT(DISTINCT CASE WHEN o.Status = N'Shipping' " +
                        "THEN o.OrderId END) AS ShippingOrders, " +

                        "COUNT(DISTINCT CASE WHEN o.Status = N'Pending' " +
                        "THEN o.OrderId END) AS PendingOrders, " +

                        "COUNT(DISTINCT CASE WHEN o.Status = N'Cancelled' " +
                        "THEN o.OrderId END) AS CancelledOrders " +

                        "FROM Orders o " +
                        "INNER JOIN OrderDetails od ON od.OrderId = o.OrderId " +
                        "INNER JOIN Listings l ON l.ListingId = od.ListingId " +
                        "WHERE l.SellerId = ? "
        );

        // Không thêm điều kiện ngày nếu chọn ALL.
        if (startDate != null && endDate != null) {
            sql.append(
                    "AND o.CreatedAt >= ? " +
                            "AND o.CreatedAt < DATEADD(DAY, 1, ?) "
            );
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            ps.setInt(1, sellerId);

            if (startDate != null && endDate != null) {
                ps.setDate(2, Date.valueOf(startDate));
                ps.setDate(3, Date.valueOf(endDate));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BigDecimal revenue = rs.getBigDecimal("TotalRevenue");

                    result.put(
                            "totalRevenue",
                            revenue == null ? BigDecimal.ZERO : revenue
                    );

                    result.put(
                            "completedOrders",
                            rs.getInt("CompletedOrders")
                    );

                    result.put(
                            "processingOrders",
                            rs.getInt("ProcessingOrders")
                    );

                    statuses.put("Completed",
                            rs.getInt("CompletedOrders"));

                    statuses.put("Shipping",
                            rs.getInt("ShippingOrders"));

                    statuses.put("Processing",
                            rs.getInt("ProcessingOrders"));

                    statuses.put("Pending",
                            rs.getInt("PendingOrders"));

                    statuses.put("Cancelled",
                            rs.getInt("CancelledOrders"));
                }
            }
        }

        result.put("statuses", statuses);

        return result;
    }
}
