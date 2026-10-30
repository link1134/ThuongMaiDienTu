package com.mangaz.dao;

import com.mangaz.model.Order;
import com.mangaz.model.OrderDetail;
import com.mangaz.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

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
    // Lấy danh sách đơn hàng theo UserId kèm danh sách chi tiết sản phẩm
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sqlOrders = """
            SELECT OrderId, UserId, RecipientName, PhoneNumber, ShippingAddress, 
                   ShippingFee, TotalAmount, PaymentMethod, DeliveryMethod, Status, CreatedAt 
            FROM dbo.Orders 
            WHERE UserId = ? 
            ORDER BY CreatedAt DESC
        """;

        String sqlDetails = """
            SELECT od.OrderDetailId, od.OrderId, od.ListingId, od.Quantity, od.Price, 
                   l.Title, li.ImageUrl
            FROM dbo.OrderDetails od
            JOIN dbo.Listings l ON od.ListingId = l.ListingId
            JOIN dbo.Users u ON l.SellerId = u.Id
            LEFT JOIN dbo.ListingImages li ON l.ListingId = li.ListingId AND li.IsPrimary = 1
            WHERE od.OrderId = ?
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement psOrder = conn.prepareStatement(sqlOrders)) {

            psOrder.setInt(1, userId);
            try (ResultSet rsOrder = psOrder.executeQuery()) {
                while (rsOrder.next()) {
                    Order order = new Order();
                    order.setOrderId(rsOrder.getInt("OrderId"));
                    order.setUserId(rsOrder.getInt("UserId"));
                    order.setRecipientName(rsOrder.getString("RecipientName"));
                    order.setPhoneNumber(rsOrder.getString("PhoneNumber"));
                    order.setShippingAddress(rsOrder.getString("ShippingAddress"));
                    order.setShippingFee(rsOrder.getBigDecimal("ShippingFee"));
                    order.setTotalAmount(rsOrder.getBigDecimal("TotalAmount"));
                    order.setPaymentMethod(rsOrder.getString("PaymentMethod"));
                    order.setDeliveryMethod(rsOrder.getString("DeliveryMethod"));
                    order.setStatus(rsOrder.getString("Status"));
                    order.setCreatedAt(rsOrder.getTimestamp("CreatedAt"));

                    // Load danh sách OrderDetails cho đơn hàng này
                    List<OrderDetail> details = new ArrayList<>();
                    try (PreparedStatement psDetail = conn.prepareStatement(sqlDetails)) {
                        psDetail.setInt(1, order.getOrderId());
                        try (ResultSet rsDetail = psDetail.executeQuery()) {
                            while (rsDetail.next()) {
                                OrderDetail detail = new OrderDetail();
                                detail.setOrderDetailId(rsDetail.getInt("OrderDetailId"));
                                detail.setOrderId(rsDetail.getInt("OrderId"));
                                detail.setListingId(rsDetail.getInt("ListingId"));
                                detail.setQuantity(rsDetail.getInt("Quantity"));
                                detail.setPrice(rsDetail.getBigDecimal("Price"));
                                detail.setProductTitle(rsDetail.getString("Title"));

                                detail.setProductImageUrl(rsDetail.getString("ImageUrl"));
                                details.add(detail);
                            }
                        }
                    }
                    order.setDetails(details);
                    orders.add(order);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<Order> getOrdersBySellerId(
            int sellerId,
            String keyword,
            String status,
            LocalDate startDate,
            LocalDate endDate) throws SQLException {

        List<Order> orders = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
        SELECT
            o.OrderId,
            o.UserId,
            o.RecipientName,
            o.PhoneNumber,
            o.ShippingAddress,
            o.ShippingFee,
            o.PaymentMethod,
            o.DeliveryMethod,
            o.Status,
            o.CreatedAt,
            COALESCE(buyer.FullName, buyer.Username) AS BuyerName,

            (
                SELECT SUM(od.Price * od.Quantity)
                FROM dbo.OrderDetails od
                JOIN dbo.Listings l ON l.ListingId = od.ListingId
                WHERE od.OrderId = o.OrderId
                  AND l.SellerId = ?
            ) AS SellerTotal

        FROM dbo.Orders o
        LEFT JOIN dbo.Users buyer ON buyer.Id = o.UserId

        WHERE EXISTS (
            SELECT 1
            FROM dbo.OrderDetails od
            JOIN dbo.Listings l ON l.ListingId = od.ListingId
            WHERE od.OrderId = o.OrderId
              AND l.SellerId = ?
        )
        """);

        List<Object> params = new ArrayList<>();

        // Tham số đầu tiên: tính tổng tiền sản phẩm của người bán
        params.add(sellerId);

        // Tham số thứ hai: chỉ lấy đơn có sản phẩm của người bán này
        params.add(sellerId);

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("""
            AND (
                o.RecipientName LIKE ?
                OR buyer.FullName LIKE ?
                OR buyer.Username LIKE ?
                OR EXISTS (
                    SELECT 1
                    FROM dbo.OrderDetails od
                    JOIN dbo.Listings l ON l.ListingId = od.ListingId
                    WHERE od.OrderId = o.OrderId
                      AND l.SellerId = ?
                      AND l.Title LIKE ?
                )
            )
            """);

            String search = "%" + keyword.trim() + "%";

            params.add(search);
            params.add(search);
            params.add(search);
            params.add(sellerId);
            params.add(search);
        }

        if (status != null && !status.trim().isEmpty()
                && !"All".equalsIgnoreCase(status)) {
            sql.append(" AND o.Status = ? ");
            params.add(status.trim());
        }

        if (startDate != null) {
            sql.append(" AND o.CreatedAt >= ? ");
            params.add(Date.valueOf(startDate));
        }

        if (endDate != null) {
            sql.append(" AND o.CreatedAt < DATEADD(day, 1, ?) ");
            params.add(Date.valueOf(endDate));
        }

        sql.append(" ORDER BY o.CreatedAt DESC, o.OrderId DESC ");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object value = params.get(i);

                if (value instanceof Integer) {
                    ps.setInt(i + 1, (Integer) value);
                } else if (value instanceof String) {
                    ps.setString(i + 1, (String) value);
                } else if (value instanceof Date) {
                    ps.setDate(i + 1, (Date) value);
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();

                    order.setOrderId(rs.getInt("OrderId"));
                    order.setUserId(rs.getInt("UserId"));
                    order.setRecipientName(rs.getString("RecipientName"));
                    order.setPhoneNumber(rs.getString("PhoneNumber"));
                    order.setShippingAddress(rs.getString("ShippingAddress"));

                    order.setShippingFee(rs.getBigDecimal("ShippingFee"));

                    // Đây là tổng tiền sản phẩm của người bán hiện tại,
                    // không phải tổng tiền của toàn bộ đơn hàng nhiều người bán.
                    order.setTotalAmount(rs.getBigDecimal("SellerTotal"));

                    order.setPaymentMethod(rs.getString("PaymentMethod"));
                    order.setDeliveryMethod(rs.getString("DeliveryMethod"));
                    order.setStatus(rs.getString("Status"));
                    order.setCreatedAt(rs.getTimestamp("CreatedAt"));

                    // Nạp chi tiết chỉ gồm sản phẩm do người bán hiện tại đăng.
                    order.setDetails(
                            getOrderDetailsBySeller(conn, order.getOrderId(), sellerId)
                    );

                    orders.add(order);
                }
            }
        }

        return orders;
    }


    private List<OrderDetail> getOrderDetailsBySeller(
            Connection conn, int orderId, int sellerId) throws SQLException {

        List<OrderDetail> details = new ArrayList<>();

        String sql = """
        SELECT
            od.OrderDetailId,
            od.OrderId,
            od.ListingId,
            od.Quantity,
            od.Price,
            l.Title,
       
            productImage.ImageUrl
        FROM dbo.OrderDetails od
        JOIN dbo.Listings l ON l.ListingId = od.ListingId
        JOIN dbo.Users seller ON seller.Id = l.SellerId
        OUTER APPLY (
            SELECT TOP 1 li.ImageUrl
            FROM dbo.ListingImages li
            WHERE li.ListingId = l.ListingId
            ORDER BY li.IsPrimary DESC, li.DisplayOrder ASC
        ) productImage
        WHERE od.OrderId = ?
          AND l.SellerId = ?
        ORDER BY od.OrderDetailId
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, sellerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail detail = new OrderDetail();

                    detail.setOrderDetailId(rs.getInt("OrderDetailId"));
                    detail.setOrderId(rs.getInt("OrderId"));
                    detail.setListingId(rs.getInt("ListingId"));
                    detail.setQuantity(rs.getInt("Quantity"));
                    detail.setPrice(rs.getBigDecimal("Price"));
                    detail.setProductTitle(rs.getString("Title"));

                    detail.setProductImageUrl(rs.getString("ImageUrl"));

                    details.add(detail);
                }
            }
        }

        return details;
    }

}

