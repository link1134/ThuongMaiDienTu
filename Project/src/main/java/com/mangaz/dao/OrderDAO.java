package com.mangaz.dao;

import com.mangaz.model.Order;
import com.mangaz.model.OrderDetail;
import com.mangaz.util.DBConnection;

import java.sql.*;

public class OrderDAO {
    public boolean createOrder(Order order) {
        String insertOrderSql = """
                    INSERT INTO dbo.Orders 
                    (UserId, RecipientName, PhoneNumber, ShippingAddress, ShippingFee, TotalAmount, PaymentMethod, DeliveryMethod, Status)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        String insertDetailSql = """
                    INSERT INTO dbo.OrderDetails (OrderId, ListingId, Quantity, Price)
                    VALUES (?, ?, ?, ?)
                """;

        String updateStockSql = """
                    UPDATE dbo.Listings 
                    SET Quantity = Quantity - ? 
                    WHERE ListingId = ? AND Quantity >= ?
                """;

        String clearCartSql = """
                    DELETE ci FROM dbo.CartItems ci
                    JOIN dbo.Carts c ON ci.CartId = c.CartId
                    WHERE c.UserId = ?
                """;

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // 1. Tạo đơn hàng
            int generatedOrderId = -1;
            try (PreparedStatement psOrder = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, order.getUserId());
                psOrder.setString(2, order.getRecipientName());
                psOrder.setString(3, order.getPhoneNumber());
                psOrder.setString(4, order.getShippingAddress());
                psOrder.setBigDecimal(5, order.getShippingFee());
                psOrder.setBigDecimal(6, order.getTotalAmount());
                psOrder.setString(7, order.getPaymentMethod());
                psOrder.setString(8, order.getDeliveryMethod());
                psOrder.setString(9, order.getStatus());

                psOrder.executeUpdate();
                ResultSet rs = psOrder.getGeneratedKeys();
                if (rs.next()) {
                    generatedOrderId = rs.getInt(1);
                    order.setOrderId(generatedOrderId);
                }
            }

            if (generatedOrderId == -1) {
                conn.rollback();
                return false;
            }

            // 2. Thêm danh sách chi tiết đơn hàng & trừ tồn kho
            try (PreparedStatement psDetail = conn.prepareStatement(insertDetailSql);
                 PreparedStatement psStock = conn.prepareStatement(updateStockSql)) {

                for (OrderDetail detail : order.getDetails()) {
                    // Thêm order detail
                    psDetail.setInt(1, generatedOrderId);
                    psDetail.setInt(2, detail.getListingId());
                    psDetail.setInt(3, detail.getQuantity());
                    psDetail.setBigDecimal(4, detail.getPrice());
                    psDetail.executeUpdate();

                    // Trừ số lượng kho sản phẩm
                    psStock.setInt(1, detail.getQuantity());
                    psStock.setInt(2, detail.getListingId());
                    psStock.setInt(3, detail.getQuantity());
                    int updatedRows = psStock.executeUpdate();

                    if (updatedRows == 0) {
                        // Không đủ tồn kho -> Hủy transaction
                        conn.rollback();
                        return false;
                    }
                }
            }

            // 3. Xóa các mặt hàng khỏi giỏ hàng
            try (PreparedStatement psCart = conn.prepareStatement(clearCartSql)) {
                psCart.setInt(1, order.getUserId());
                psCart.executeUpdate();
            }

            conn.commit(); // Hoàn tất Transaction thành công
            return true;

        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}

