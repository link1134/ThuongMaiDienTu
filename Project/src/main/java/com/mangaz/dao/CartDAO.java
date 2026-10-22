package com.mangaz.dao;

import com.mangaz.model.Cart;
import com.mangaz.model.CartItem;
import com.mangaz.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    public Cart getCartByUserId(int userId) {
        Cart cart = new Cart();
        cart.setUserId(userId);

        String getCartSql = "SELECT CartId FROM Carts WHERE UserId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(getCartSql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                cart.setCartId(rs.getInt("CartId"));
            } else {
                cart.setCartId(createCart(userId, conn));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        String getItemsSql =
                "SELECT ci.CartItemId, ci.CartId, ci.ListingId, ci.Quantity, " +
                        "l.Title, l.Price, l.Quantity as StockQuantity, li.ImageUrl " +
                        "FROM CartItems ci " +
                        "JOIN Listings l ON ci.ListingId = l.ListingId " +
                        "LEFT JOIN ListingImages li ON l.ListingId = li.ListingId AND li.IsPrimary = 1 " +
                        "WHERE ci.CartId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(getItemsSql)) {
            ps.setInt(1, cart.getCartId());
            ResultSet rs = ps.executeQuery();
            List<CartItem> items = new ArrayList<>();

            while (rs.next()) {
                CartItem item = new CartItem();
                item.setCartItemId(rs.getInt("CartItemId"));
                item.setCartId(rs.getInt("CartId"));
                item.setListingId(rs.getInt("ListingId"));
                item.setQuantity(rs.getInt("Quantity"));
                item.setProductTitle(rs.getString("Title"));
                item.setProductPrice(rs.getBigDecimal("Price"));
                item.setStockQuantity(rs.getInt("StockQuantity"));
                item.setProductImageUrl(rs.getString("ImageUrl"));
                items.add(item);
            }
            cart.setItems(items);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cart;
    }
    /*
    * Tạo giỏ hàng mới theo ID của người dùng
    * */
    private int createCart(int userId, Connection conn) throws SQLException {
        String sql = "INSERT INTO Carts (UserId) VALUES (?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
        }
        return -1;
    }
    /*
    * Thêm sản phẩm vào giỏ hàng
    * */
    public boolean addToCart(int userId, int listingId, int quantity) {
        Cart cart = getCartByUserId(userId);
        String checkSql = "SELECT CartItemId, Quantity FROM CartItems WHERE CartId = ? AND ListingId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
            psCheck.setInt(1, cart.getCartId());
            psCheck.setInt(2, listingId);
            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                int currentQty = rs.getInt("Quantity");
                return updateQuantity(rs.getInt("CartItemId"), currentQty + quantity);
            } else {
                String insertSql = "INSERT INTO CartItems (CartId, ListingId, Quantity) VALUES (?, ?, ?)";
                try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                    psInsert.setInt(1, cart.getCartId());
                    psInsert.setInt(2, listingId);
                    psInsert.setInt(3, quantity);
                    return psInsert.executeUpdate() > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    /*
    * Cập nhật lại số lượng sản phẩm trong giỏ hàng
    * */
    public boolean updateQuantity(int cartItemId, int newQuantity) {
        if (newQuantity <= 0) return removeCartItem(cartItemId);

        String sql = "UPDATE CartItems SET Quantity = ? WHERE CartItemId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newQuantity);
            ps.setInt(2, cartItemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    /*
    * Xóa sản phẩm khỏi giỏ hàng
    * */
    public boolean removeCartItem(int cartItemId) {
        String sql = "DELETE FROM CartItems WHERE CartItemId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartItemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
