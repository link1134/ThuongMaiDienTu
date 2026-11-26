package com.mangaz.dao;

import com.mangaz.model.Order;
import com.mangaz.model.OrderDetail;
import com.mangaz.util.DBConnection;
import com.mangaz.util.VNPayConfig;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;
import java.util.UUID;

public class OrderDAO {
    public boolean createOrder(Order order) {
        return createOrder(order, false);
    }

    public boolean createOrder(Order order, boolean isBuyNow) {
        String insertOrderSql = """
                    INSERT INTO dbo.Orders
                    (UserId, RecipientName, PhoneNumber, ShippingAddress,
                    ShippingFee, TotalAmount, PaymentMethod, DeliveryMethod,
                    Status, IsBuyNow)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
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
                psOrder.setBoolean(10, isBuyNow);

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
            if (!isBuyNow) {
                try (PreparedStatement psCart = conn.prepareStatement(clearCartSql)) {
                    psCart.setInt(1, order.getUserId());
                    psCart.executeUpdate();
                }
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

    // Tạo đơn hàng VNPay ở trạng thái chờ thanh toán
    public boolean createPendingOrder(Order order) {
        return createPendingOrder(order, false);
    }

    public boolean createPendingOrder(Order order, boolean isBuyNow) {

        String insertOrderSql = """
                INSERT INTO dbo.Orders
                (UserId, RecipientName, PhoneNumber, ShippingAddress,
                ShippingFee, TotalAmount, PaymentMethod, DeliveryMethod,
                Status, PaymentStatus, IsBuyNow)
                VALUES (?, ?, ?, ?, ?, ?, N'VNPay', ?, N'Pending', N'Unpaid', ?)
        """;

        String insertDetailSql = """
        INSERT INTO dbo.OrderDetails
        (OrderId, ListingId, Quantity, Price)
        VALUES (?, ?, ?, ?)
        """;

        try (Connection conn = DBConnection.getConnection()) {

            conn.setAutoCommit(false);

            try {
                int orderId = -1;

                // 1. Tạo đơn hàng
                try (PreparedStatement ps = conn.prepareStatement(
                        insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {

                    ps.setInt(1, order.getUserId());
                    ps.setString(2, order.getRecipientName());
                    ps.setString(3, order.getPhoneNumber());
                    ps.setString(4, order.getShippingAddress());
                    ps.setBigDecimal(5, order.getShippingFee());
                    ps.setBigDecimal(6, order.getTotalAmount());
                    ps.setString(7, order.getDeliveryMethod());
                    ps.setBoolean(8, isBuyNow);

                    ps.executeUpdate();

                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            orderId = rs.getInt(1);
                            order.setOrderId(orderId);
                        }
                    }
                }

                if (orderId == -1) {
                    conn.rollback();
                    return false;
                }

                // 2. Lưu chi tiết đơn hàng
                try (PreparedStatement ps = conn.prepareStatement(insertDetailSql)) {

                    for (OrderDetail detail : order.getDetails()) {

                        ps.setInt(1, orderId);
                        ps.setInt(2, detail.getListingId());
                        ps.setInt(3, detail.getQuantity());
                        ps.setBigDecimal(4, detail.getPrice());

                        ps.executeUpdate();
                    }
                }

                // Chưa trừ kho và chưa xóa giỏ hàng
                conn.commit();
                return true;

            } catch (Exception e) {
                conn.rollback();
                throw e;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xác nhận thanh toán VNPay thành công
    public boolean confirmVnpayPayment(
            int orderId,
            java.math.BigDecimal paidAmount,
            String transactionNo,
            String payDate) {

        String checkOrderSql = """
        SELECT TotalAmount, PaymentStatus, PaymentMethod,
               IsBuyNow, Status
        FROM dbo.Orders WITH (UPDLOCK, ROWLOCK)
        WHERE OrderId = ?
        """;

        String getDetailsSql = """
        SELECT ListingId, Quantity
        FROM dbo.OrderDetails
        WHERE OrderId = ?
        """;

        String updateStockSql = """
        UPDATE dbo.Listings
        SET Quantity = Quantity - ?
        WHERE ListingId = ? AND Quantity >= ?
        """;

        String updatePaymentSql = """
        UPDATE dbo.Orders
        SET PaymentStatus = N'Paid',
            UpdatedAt = SYSDATETIME()
        WHERE OrderId = ? AND PaymentStatus = N'Unpaid'
        """;

        String insertTransactionSql = """
        INSERT INTO dbo.VNPayTransactions
        (OrderId, VnpTransactionNo, VnpPayDate, Amount, RefundStatus)
        SELECT ?, ?, ?, ?, ?
        WHERE NOT EXISTS (
            SELECT 1
            FROM dbo.VNPayTransactions WITH (UPDLOCK, HOLDLOCK)
            WHERE OrderId = ?
        )
        """;

        String clearCartSql = """
        DELETE ci
        FROM dbo.CartItems ci
        JOIN dbo.Carts c ON ci.CartId = c.CartId
        WHERE c.UserId = (
            SELECT UserId FROM dbo.Orders WHERE OrderId = ?
        )
        """;

        try (Connection conn = DBConnection.getConnection()) {

            conn.setAutoCommit(false);

            try {
                java.math.BigDecimal totalAmount;
                String paymentStatus;
                String paymentMethod;
                String orderStatus;
                boolean isBuyNow;

                // 1. Lấy thông tin đơn hàng và khóa bản ghi
                try (PreparedStatement ps = conn.prepareStatement(checkOrderSql)) {

                    ps.setInt(1, orderId);

                    try (ResultSet rs = ps.executeQuery()) {

                        if (!rs.next()) {
                            conn.rollback();
                            return false;
                        }

                        totalAmount = rs.getBigDecimal("TotalAmount");
                        paymentStatus = rs.getString("PaymentStatus");
                        paymentMethod = rs.getString("PaymentMethod");
                        isBuyNow = rs.getBoolean("IsBuyNow");
                        orderStatus = rs.getString("Status");
                    }
                }

                // 2. Kiểm tra phương thức thanh toán
                if (!"VNPay".equalsIgnoreCase(paymentMethod)) {
                    conn.rollback();
                    return false;
                }

                // 3. Kiểm tra số tiền
                if (totalAmount == null || paidAmount == null
                        || totalAmount.compareTo(paidAmount) != 0) {
                    conn.rollback();
                    return false;
                }

                // 4. Kiểm tra thông tin giao dịch
                if (transactionNo == null || transactionNo.isBlank()
                        || payDate == null || !payDate.matches("\\d{14}")) {
                    conn.rollback();
                    return false;
                }

                // Xác định trạng thái hoàn tiền
                // Đơn đã hủy: chờ hoàn tiền.
                // Đơn chưa hủy: chưa cần hoàn tiền.
                String refundStatus = "Cancelled".equalsIgnoreCase(orderStatus)
                        ? "Pending"
                        : "NotRequested";

                // 5. Nếu đơn đã thanh toán trước đó
                // Không trừ kho thêm lần nữa.
                if ("Paid".equalsIgnoreCase(paymentStatus)) {

                    // Nếu chưa có giao dịch được lưu thì bổ sung.
                    try (PreparedStatement ps =
                                 conn.prepareStatement(insertTransactionSql)) {

                        ps.setInt(1, orderId);
                        ps.setString(2, transactionNo);
                        ps.setString(3, payDate);
                        ps.setBigDecimal(4, paidAmount);
                        ps.setString(5, refundStatus);
                        ps.setInt(6, orderId);

                        ps.executeUpdate();
                    }

                    // Nếu đơn đã bị hủy nhưng giao dịch trước đó
                    // chưa được đưa vào hàng chờ hoàn tiền.
                    if ("Cancelled".equalsIgnoreCase(orderStatus)) {

                        String updateRefundSql = """
                        UPDATE dbo.VNPayTransactions
                        SET RefundStatus = N'Pending',
                            UpdatedAt = SYSDATETIME()
                        WHERE OrderId = ?
                          AND RefundStatus = N'NotRequested'
                        """;

                        try (PreparedStatement ps =
                                     conn.prepareStatement(updateRefundSql)) {

                            ps.setInt(1, orderId);
                            ps.executeUpdate();
                        }
                    }

                    conn.commit();
                    return true;
                }

                // 6. Chỉ xử lý đơn chưa thanh toán
                if (!"Unpaid".equalsIgnoreCase(paymentStatus)) {
                    conn.rollback();
                    return false;
                }

                // 7. Nếu đơn chưa bị hủy, tiến hành trừ tồn kho.
                // Nếu đơn đã hủy, tuyệt đối không trừ tồn kho.
                if (!"Cancelled".equalsIgnoreCase(orderStatus)) {

                    if (!"Pending".equalsIgnoreCase(orderStatus)
                            && !"Processing".equalsIgnoreCase(orderStatus)) {

                        conn.rollback();
                        return false;
                    }

                    try (PreparedStatement psDetail =
                                 conn.prepareStatement(getDetailsSql);
                         PreparedStatement psStock =
                                 conn.prepareStatement(updateStockSql)) {

                        psDetail.setInt(1, orderId);

                        try (ResultSet rs = psDetail.executeQuery()) {

                            while (rs.next()) {

                                int listingId = rs.getInt("ListingId");
                                int quantity = rs.getInt("Quantity");

                                psStock.setInt(1, quantity);
                                psStock.setInt(2, listingId);
                                psStock.setInt(3, quantity);

                                if (psStock.executeUpdate() == 0) {
                                    conn.rollback();
                                    return false;
                                }
                            }
                        }
                    }
                }

                // 8. Cập nhật trạng thái thanh toán
                try (PreparedStatement ps =
                             conn.prepareStatement(updatePaymentSql)) {

                    ps.setInt(1, orderId);

                    if (ps.executeUpdate() == 0) {
                        conn.rollback();
                        return false;
                    }
                }

                // 9. Lưu thông tin giao dịch VNPay
                try (PreparedStatement ps =
                             conn.prepareStatement(insertTransactionSql)) {

                    ps.setInt(1, orderId);
                    ps.setString(2, transactionNo);
                    ps.setString(3, payDate);
                    ps.setBigDecimal(4, paidAmount);
                    ps.setString(5, refundStatus);
                    ps.setInt(6, orderId);

                    ps.executeUpdate();
                }

                // 10. Chỉ xóa giỏ hàng nếu đơn chưa bị hủy
                if (!isBuyNow
                        && !"Cancelled".equalsIgnoreCase(orderStatus)) {

                    try (PreparedStatement ps =
                                 conn.prepareStatement(clearCartSql)) {

                        ps.setInt(1, orderId);
                        ps.executeUpdate();
                    }
                }

                conn.commit();
                return true;

            } catch (Exception e) {
                conn.rollback();
                throw e;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
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

    // Người mua gửi yêu cầu hủy đơn
    public boolean createCancellationRequest(
            int orderId, int userId, String reason) {

        String checkOrderSql = """
        SELECT Status
        FROM dbo.Orders WITH (UPDLOCK, ROWLOCK)
        WHERE OrderId = ? AND UserId = ?
        """;

        String checkPendingSql = """
        SELECT RequestId
        FROM dbo.OrderCancellationRequests
        WHERE OrderId = ? AND RequestStatus = N'Pending'
        """;

        String insertSql = """
        INSERT INTO dbo.OrderCancellationRequests
        (OrderId, UserId, Reason)
        VALUES (?, ?, ?)
        """;

        try (Connection conn = DBConnection.getConnection()) {

            conn.setAutoCommit(false);

            try {
                // 1. Kiểm tra đơn hàng thuộc về người dùng
                String orderStatus;

                try (PreparedStatement ps = conn.prepareStatement(checkOrderSql)) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, userId);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            return false;
                        }

                        orderStatus = rs.getString("Status");
                    }
                }

                // 2. Chỉ cho phép hủy Pending hoặc Processing
                if (!"Pending".equalsIgnoreCase(orderStatus)
                        && !"Processing".equalsIgnoreCase(orderStatus)) {
                    conn.rollback();
                    return false;
                }

                // 3. Kiểm tra yêu cầu đang chờ xử lý
                try (PreparedStatement ps = conn.prepareStatement(checkPendingSql)) {
                    ps.setInt(1, orderId);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            conn.rollback();
                            return false;
                        }
                    }
                }

                // 4. Tạo yêu cầu hủy
                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, userId);
                    ps.setString(3, reason.trim());

                    ps.executeUpdate();
                }

                conn.commit();
                return true;

            } catch (Exception e) {
                conn.rollback();
                throw e;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy OrderId từ mã yêu cầu hủy dành cho Admin
    public int getOrderIdByCancellationRequest(
            int requestId, int adminId) {

        String sql = """
        SELECT r.OrderId
        FROM dbo.OrderCancellationRequests r
        WHERE r.RequestId = ?
          AND EXISTS (
              SELECT 1
              FROM dbo.Users
              WHERE Id = ? AND Role = N'Admin'
          )
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, requestId);
            ps.setInt(2, adminId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("OrderId");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    // Admin xác nhận hủy đơn
    public boolean approveCancellationRequest(
            int requestId, int adminId) {

        String checkRequestSql = """
        SELECT
            r.OrderId,
            r.RequestStatus,
            o.Status,
            o.PaymentMethod,
            o.PaymentStatus
        FROM dbo.OrderCancellationRequests r
        WITH (UPDLOCK, ROWLOCK)
        JOIN dbo.Orders o
        WITH (UPDLOCK, ROWLOCK)
            ON r.OrderId = o.OrderId
        WHERE r.RequestId = ?
        """;

        String checkAdminSql = """
        SELECT Id
        FROM dbo.Users
        WHERE Id = ? AND Role = N'Admin'
        """;

        String updateOrderSql = """
        UPDATE dbo.Orders
        SET Status = N'Cancelled',
            UpdatedAt = SYSDATETIME()
        WHERE OrderId = ?
          AND Status IN (N'Pending', N'Processing')
        """;

        String updateRequestSql = """
        UPDATE dbo.OrderCancellationRequests
        SET RequestStatus = N'Approved',
            AdminId = ?,
            ProcessedAt = SYSDATETIME()
        WHERE RequestId = ?
          AND RequestStatus = N'Pending'
        """;

        String restoreStockSql = """
        UPDATE l
        SET l.Quantity = l.Quantity + d.TotalQuantity
        FROM dbo.Listings l
        JOIN (
            SELECT ListingId, SUM(Quantity) AS TotalQuantity
            FROM dbo.OrderDetails
            WHERE OrderId = ?
            GROUP BY ListingId
        ) d ON l.ListingId = d.ListingId
        """;

        String queueRefundSql = """
            UPDATE dbo.VNPayTransactions
            SET RefundStatus = N'Pending',
                UpdatedAt = SYSDATETIME()
            WHERE OrderId = ?
              AND RefundStatus = N'NotRequested'
            """;

        String checkRefundSql = """
            SELECT RefundStatus
            FROM dbo.VNPayTransactions
            WHERE OrderId = ?
            """;

        try (Connection conn = DBConnection.getConnection()) {

            conn.setAutoCommit(false);

            try {
                // 1. Kiểm tra quyền Admin
                try (PreparedStatement ps = conn.prepareStatement(checkAdminSql)) {
                    ps.setInt(1, adminId);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            return false;
                        }
                    }
                }

                // 2. Lấy thông tin yêu cầu và khóa đơn hàng
                int orderId;
                String requestStatus;
                String orderStatus;
                String paymentMethod;
                String paymentStatus;

                try (PreparedStatement ps = conn.prepareStatement(checkRequestSql)) {
                    ps.setInt(1, requestId);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            return false;
                        }

                        orderId = rs.getInt("OrderId");
                        requestStatus = rs.getString("RequestStatus");
                        orderStatus = rs.getString("Status");
                        paymentMethod = rs.getString("PaymentMethod");
                        paymentStatus = rs.getString("PaymentStatus");
                    }
                }

                // 3. Chỉ duyệt yêu cầu đang chờ
                if (!"Pending".equalsIgnoreCase(requestStatus)) {
                    conn.rollback();
                    return false;
                }

                // 4. Kiểm tra trạng thái đơn hàng
                if (!"Pending".equalsIgnoreCase(orderStatus)
                        && !"Processing".equalsIgnoreCase(orderStatus)) {
                    conn.rollback();
                    return false;
                }

                // 5. Xác nhận hủy đơn
                try (PreparedStatement ps = conn.prepareStatement(updateOrderSql)) {
                    ps.setInt(1, orderId);

                    if (ps.executeUpdate() == 0) {
                        conn.rollback();
                        return false;
                    }
                }

                // 6. Cập nhật yêu cầu hủy
                try (PreparedStatement ps = conn.prepareStatement(updateRequestSql)) {
                    ps.setInt(1, adminId);
                    ps.setInt(2, requestId);

                    if (ps.executeUpdate() == 0) {
                        conn.rollback();
                        return false;
                    }
                }

                // 7. Chỉ hoàn kho nếu đơn đã từng trừ tồn kho
                boolean stockWasDeducted =
                        "COD".equalsIgnoreCase(paymentMethod)
                                || "Paid".equalsIgnoreCase(paymentStatus);

                if (stockWasDeducted) {
                    try (PreparedStatement ps = conn.prepareStatement(restoreStockSql)) {
                        ps.setInt(1, orderId);
                        ps.executeUpdate();
                    }
                }

                // 8. Nếu đơn đã thanh toán bằng VNPay, đưa vào hàng chờ hoàn tiền
                if ("VNPay".equalsIgnoreCase(paymentMethod)
                        && "Paid".equalsIgnoreCase(paymentStatus)) {

                    boolean refundQueued = false;

                    try (PreparedStatement ps = conn.prepareStatement(queueRefundSql)) {
                        ps.setInt(1, orderId);
                        refundQueued = ps.executeUpdate() > 0;
                    }

                    // Nếu chưa cập nhật được, kiểm tra trạng thái hiện tại
                    if (!refundQueued) {
                        try (PreparedStatement ps = conn.prepareStatement(checkRefundSql)) {
                            ps.setInt(1, orderId);

                            try (ResultSet rs = ps.executeQuery()) {
                                if (!rs.next()) {
                                    throw new SQLException(
                                            "Không tìm thấy giao dịch VNPay của đơn hàng: " + orderId
                                    );
                                }

                                String refundStatus = rs.getString("RefundStatus");

                                if (!"Pending".equalsIgnoreCase(refundStatus)
                                        && !"Processing".equalsIgnoreCase(refundStatus)
                                        && !"Succeeded".equalsIgnoreCase(refundStatus)) {

                                    throw new SQLException(
                                            "Trạng thái hoàn tiền không hợp lệ: " + refundStatus
                                    );
                                }
                            }
                        }
                    }
                }

                conn.commit();
                return true;

            } catch (Exception e) {
                conn.rollback();
                throw e;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Admin từ chối yêu cầu hủy đơn
    public boolean rejectCancellationRequest(
            int requestId, int adminId, String adminNote) {

        String sql = """
        UPDATE dbo.OrderCancellationRequests
        SET RequestStatus = N'Rejected',
            AdminId = ?,
            AdminNote = ?,
            ProcessedAt = SYSDATETIME()
        WHERE RequestId = ?
          AND RequestStatus = N'Pending'
          AND EXISTS (
              SELECT 1
              FROM dbo.Users
              WHERE Id = ? AND Role = N'Admin'
          )
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, adminId);
            ps.setString(2, adminNote);
            ps.setInt(3, requestId);
            ps.setInt(4, adminId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateVnpCreateDate(int orderId, String createDate) {

        if (createDate == null || !createDate.matches("\\d{14}")) {
            return false;
        }

        String sql = """
        UPDATE dbo.Orders
        SET VnpCreateDate = ?
        WHERE OrderId = ?
          AND PaymentMethod = N'VNPay'
          AND VnpCreateDate IS NULL
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, createDate);
            ps.setInt(2, orderId);

            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Thông tin cần thiết để gửi yêu cầu hoàn tiền VNPay
    public static class RefundData {
        private final int orderId;
        private final String requestId;
        private final BigDecimal amount;
        private final String transactionNo;
        private final String transactionDate;
        private final String createdBy;

        public RefundData(
                int orderId,
                String requestId,
                BigDecimal amount,
                String transactionNo,
                String transactionDate,
                String createdBy) {

            this.orderId = orderId;
            this.requestId = requestId;
            this.amount = amount;
            this.transactionNo = transactionNo;
            this.transactionDate = transactionDate;
            this.createdBy = createdBy;
        }

        public int getOrderId() {
            return orderId;
        }

        public String getRequestId() {
            return requestId;
        }

        public BigDecimal getAmount() {
            return amount;
        }

        public String getTransactionNo() {
            return transactionNo;
        }

        public String getTransactionDate() {
            return transactionDate;
        }

        public String getCreatedBy() {
            return createdBy;
        }
    }

    // Chuẩn bị thông tin trước khi gửi yêu cầu hoàn tiền VNPay
    public RefundData prepareRefund(int orderId, int adminId) {

        String checkAdminSql = """
        SELECT Id
        FROM dbo.Users
        WHERE Id = ? AND Role = N'Admin'
        """;

        String getRefundDataSql = """
        SELECT
            o.Status,
            o.PaymentMethod,
            o.PaymentStatus,
            o.VnpCreateDate,
            vt.Amount,
            vt.VnpTransactionNo,
            vt.RefundStatus,
            vt.RefundRequestId
        FROM dbo.Orders o WITH (UPDLOCK, ROWLOCK)
        JOIN dbo.VNPayTransactions vt WITH (UPDLOCK, ROWLOCK)
            ON o.OrderId = vt.OrderId
        WHERE o.OrderId = ?
        """;

        String updateRefundSql = """
        UPDATE dbo.VNPayTransactions
        SET RefundStatus = N'Processing',
            RefundRequestId = ?,
            UpdatedAt = SYSDATETIME()
        WHERE OrderId = ?
          AND RefundStatus = N'Pending'
          AND RefundRequestId IS NULL
        """;

        try (Connection conn = DBConnection.getConnection()) {

            conn.setAutoCommit(false);

            try {
                // 1. Kiểm tra quyền Admin
                try (PreparedStatement ps = conn.prepareStatement(checkAdminSql)) {
                    ps.setInt(1, adminId);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            return null;
                        }
                    }
                }

                // 2. Lấy thông tin đơn hàng và giao dịch VNPay
                BigDecimal amount;
                String orderStatus;
                String paymentMethod;
                String paymentStatus;
                String transactionNo;
                String transactionDate;
                String refundStatus;
                String oldRequestId;

                try (PreparedStatement ps = conn.prepareStatement(getRefundDataSql)) {
                    ps.setInt(1, orderId);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            return null;
                        }

                        orderStatus = rs.getString("Status");
                        paymentMethod = rs.getString("PaymentMethod");
                        paymentStatus = rs.getString("PaymentStatus");
                        transactionDate = rs.getString("VnpCreateDate");
                        amount = rs.getBigDecimal("Amount");
                        transactionNo = rs.getString("VnpTransactionNo");
                        refundStatus = rs.getString("RefundStatus");
                        oldRequestId = rs.getString("RefundRequestId");
                    }
                }

                // 3. Chỉ hoàn tiền cho đơn đã hủy và đã thanh toán VNPay
                if (!"Cancelled".equalsIgnoreCase(orderStatus)
                        || !"VNPay".equalsIgnoreCase(paymentMethod)
                        || !"Paid".equalsIgnoreCase(paymentStatus)
                        || !"Pending".equalsIgnoreCase(refundStatus)
                        || oldRequestId != null) {

                    conn.rollback();
                    return null;
                }

                // 4. Kiểm tra thông tin giao dịch
                if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0
                        || transactionNo == null || transactionNo.isBlank()
                        || transactionDate == null
                        || !transactionDate.matches("\\d{14}")) {

                    conn.rollback();
                    return null;
                }

                // 5. Tạo mã yêu cầu hoàn tiền
                String requestId = UUID.randomUUID()
                        .toString()
                        .replace("-", "");

                // 6. Chuyển trạng thái sang Processing và lưu RequestId
                try (PreparedStatement ps = conn.prepareStatement(updateRefundSql)) {
                    ps.setString(1, requestId);
                    ps.setInt(2, orderId);

                    if (ps.executeUpdate() != 1) {
                        conn.rollback();
                        return null;
                    }
                }

                conn.commit();

                // 7. Trả về dữ liệu để gửi đến VNPay
                return new RefundData(
                        orderId,
                        requestId,
                        amount,
                        transactionNo,
                        transactionDate,
                        String.valueOf(adminId)
                );

            } catch (Exception e) {
                conn.rollback();
                throw e;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean updateRefundResult(
            int orderId,
            String requestId,
            VNPayConfig.RefundResponse response) {

        if (response == null
                || !response.isValidSignature()
                || requestId == null
                || requestId.isBlank()) {
            return false;
        }

        String getDataSql = """
        SELECT
            o.Status,
            o.PaymentMethod,
            o.PaymentStatus,
            vt.Amount,
            vt.RefundStatus,
            vt.RefundRequestId
        FROM dbo.Orders o
        JOIN dbo.VNPayTransactions vt
            ON o.OrderId = vt.OrderId
        WHERE o.OrderId = ?
        """;

        String updateSql = """
        UPDATE dbo.VNPayTransactions
        SET RefundStatus = ?,
            RefundResponseCode = ?,
            RefundMessage = ?,
            RefundTransactionNo = ?,
            RefundedAt = CASE
                WHEN ? = N'Succeeded' THEN SYSDATETIME()
                ELSE RefundedAt
            END,
            UpdatedAt = SYSDATETIME()
        WHERE OrderId = ?
          AND RefundRequestId = ?
          AND RefundStatus = N'Processing'
        """;

        try (Connection conn = DBConnection.getConnection()) {

            conn.setAutoCommit(false);

            try {
                BigDecimal amount;
                String orderStatus;
                String paymentMethod;
                String paymentStatus;
                String refundStatus;
                String savedRequestId;

                // 1. Lấy thông tin đơn hàng và giao dịch
                try (PreparedStatement ps =
                             conn.prepareStatement(getDataSql)) {

                    ps.setInt(1, orderId);

                    try (ResultSet rs = ps.executeQuery()) {

                        if (!rs.next()) {
                            conn.rollback();
                            return false;
                        }

                        orderStatus = rs.getString("Status");
                        paymentMethod = rs.getString("PaymentMethod");
                        paymentStatus = rs.getString("PaymentStatus");
                        amount = rs.getBigDecimal("Amount");
                        refundStatus = rs.getString("RefundStatus");
                        savedRequestId = rs.getString("RefundRequestId");
                    }
                }

                // 2. Kiểm tra thông tin giao dịch
                if (!"Cancelled".equalsIgnoreCase(orderStatus)
                        || !"VNPay".equalsIgnoreCase(paymentMethod)
                        || !"Paid".equalsIgnoreCase(paymentStatus)
                        || !"Processing".equalsIgnoreCase(refundStatus)
                        || !requestId.equals(savedRequestId)
                        || amount == null) {

                    conn.rollback();
                    return false;
                }

                // 3. Kiểm tra mã đơn hàng VNPay trả về
                String txnRef = response.getTxnRef();

                if (!String.valueOf(orderId).equals(txnRef)) {
                    conn.rollback();
                    return false;
                }

                // 4. Kiểm tra số tiền hoàn trả
                BigDecimal expectedAmount = amount
                        .multiply(BigDecimal.valueOf(100));

                BigDecimal responseAmount;

                try {
                    responseAmount = new BigDecimal(response.getAmount());
                } catch (Exception e) {
                    conn.rollback();
                    return false;
                }

                if (expectedAmount.compareTo(responseAmount) != 0) {
                    conn.rollback();
                    return false;
                }

                // 5. Xác định trạng thái hoàn tiền
                String responseCode = response.getResponseCode();
                String transactionStatus = response.getTransactionStatus();

                String newRefundStatus = "Processing";

                if ("00".equals(responseCode)
                        && "00".equals(transactionStatus)) {

                    newRefundStatus = "Succeeded";

                } else if ("09".equals(transactionStatus)
                        || "95".equals(responseCode)) {

                    newRefundStatus = "Failed";
                }

                // 05, 06 và các trạng thái chưa xác định:
                // Giữ Processing để tiếp tục đối soát.

                // 6. Cập nhật kết quả vào database
                try (PreparedStatement ps =
                             conn.prepareStatement(updateSql)) {

                    ps.setString(1, newRefundStatus);
                    ps.setString(2, responseCode);
                    ps.setString(3, response.getMessage());
                    ps.setString(4, response.getTransactionNo());
                    ps.setString(5, newRefundStatus);
                    ps.setInt(6, orderId);
                    ps.setString(7, requestId);

                    if (ps.executeUpdate() != 1) {
                        conn.rollback();
                        return false;
                    }
                }

                conn.commit();
                return true;

            } catch (Exception e) {
                conn.rollback();
                throw e;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    // Dữ liệu một đơn hàng dành cho trang quản trị
    public static class AdminOrderData {
        private Order order;
        private String buyerName;
        private String paymentStatus;

        public AdminOrderData(Order order, String buyerName, String paymentStatus) {
            this.order = order;
            this.buyerName = buyerName;
            this.paymentStatus = paymentStatus;
        }

        public Order getOrder() {
            return order;
        }

        public String getBuyerName() {
            return buyerName;
        }

        public String getPaymentStatus() {
            return paymentStatus;
        }
    }

    // Dữ liệu yêu cầu hủy đơn dành cho Admin
    public static class AdminCancellationData {
        private int requestId;
        private int orderId;
        private String buyerName;
        private String reason;
        private String requestStatus;
        private String orderStatus;

        public AdminCancellationData(
                int requestId,
                int orderId,
                String buyerName,
                String reason,
                String requestStatus,
                String orderStatus) {

            this.requestId = requestId;
            this.orderId = orderId;
            this.buyerName = buyerName;
            this.reason = reason;
            this.requestStatus = requestStatus;
            this.orderStatus = orderStatus;
        }

        public int getRequestId() {
            return requestId;
        }

        public int getOrderId() {
            return orderId;
        }

        public String getBuyerName() {
            return buyerName;
        }

        public String getReason() {
            return reason;
        }

        public String getRequestStatus() {
            return requestStatus;
        }

        public String getOrderStatus() {
            return orderStatus;
        }
    }

    // Admin lấy toàn bộ đơn hàng trong hệ thống
    public List<AdminOrderData> getAllOrdersForAdmin() throws SQLException {

        List<AdminOrderData> orders = new ArrayList<>();

        String sql = """
        SELECT
            o.OrderId,
            o.UserId,
            o.RecipientName,
            o.PhoneNumber,
            o.ShippingAddress,
            o.ShippingFee,
            o.TotalAmount,
            o.PaymentMethod,
            o.DeliveryMethod,
            o.Status,
            o.PaymentStatus,
            o.CreatedAt,
            COALESCE(u.FullName, u.Username) AS BuyerName
        FROM dbo.Orders o
        JOIN dbo.Users u ON o.UserId = u.Id
        ORDER BY o.CreatedAt DESC, o.OrderId DESC
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order order = new Order();

                order.setOrderId(rs.getInt("OrderId"));
                order.setUserId(rs.getInt("UserId"));
                order.setRecipientName(rs.getString("RecipientName"));
                order.setPhoneNumber(rs.getString("PhoneNumber"));
                order.setShippingAddress(rs.getString("ShippingAddress"));
                order.setShippingFee(rs.getBigDecimal("ShippingFee"));
                order.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                order.setPaymentMethod(rs.getString("PaymentMethod"));
                order.setDeliveryMethod(rs.getString("DeliveryMethod"));
                order.setStatus(rs.getString("Status"));
                order.setCreatedAt(rs.getTimestamp("CreatedAt"));

                String buyerName = rs.getString("BuyerName");
                String paymentStatus = rs.getString("PaymentStatus");

                orders.add(new AdminOrderData(
                        order,
                        buyerName,
                        paymentStatus
                ));
            }
        }

        return orders;
    }

    // Admin lấy danh sách yêu cầu hủy đơn hàng
    public List<AdminCancellationData> getCancellationRequestsForAdmin()
            throws SQLException {

        List<AdminCancellationData> requests = new ArrayList<>();

        String sql = """
        SELECT
            r.RequestId,
            r.OrderId,
            COALESCE(u.FullName, u.Username) AS BuyerName,
            r.Reason,
            r.RequestStatus,
            o.Status AS OrderStatus
        FROM dbo.OrderCancellationRequests r
        JOIN dbo.Users u ON r.UserId = u.Id
        JOIN dbo.Orders o ON r.OrderId = o.OrderId
        ORDER BY
            CASE WHEN r.RequestStatus = N'Pending' THEN 0 ELSE 1 END,
            r.RequestId DESC
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                requests.add(new AdminCancellationData(
                        rs.getInt("RequestId"),
                        rs.getInt("OrderId"),
                        rs.getString("BuyerName"),
                        rs.getString("Reason"),
                        rs.getString("RequestStatus"),
                        rs.getString("OrderStatus")
                ));
            }
        }

        return requests;
    }
}

