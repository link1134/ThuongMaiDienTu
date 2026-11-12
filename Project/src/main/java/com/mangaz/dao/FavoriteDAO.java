package com.mangaz.dao;

import com.mangaz.model.Listing;
import com.mangaz.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.HashSet;
import java.util.Set;

public class FavoriteDAO {

    // 1. Thêm sản phẩm vào danh sách yêu thích
    public boolean addFavorite(int userId, int listingId) {

        String sql = """
                IF NOT EXISTS (
                    SELECT 1
                    FROM dbo.Favorites
                    WHERE UserId = ? AND ListingId = ?
                )
                BEGIN
                    INSERT INTO dbo.Favorites (UserId, ListingId)
                    VALUES (?, ?)
                END
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, listingId);
            ps.setInt(3, userId);
            ps.setInt(4, listingId);

            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. Xóa sản phẩm khỏi danh sách yêu thích
    public boolean removeFavorite(int userId, int listingId) {

        String sql = """
                DELETE FROM dbo.Favorites
                WHERE UserId = ? AND ListingId = ?
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, listingId);

            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 3. Kiểm tra sản phẩm đã được yêu thích hay chưa
    public boolean isFavorite(int userId, int listingId) {

        String sql = """
                SELECT COUNT(*)
                FROM dbo.Favorites
                WHERE UserId = ? AND ListingId = ?
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, listingId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // 4. Lấy danh sách sản phẩm yêu thích của người dùng
    public List<Listing> getFavoritesByUserId(int userId) {

        List<Listing> listings = new ArrayList<>();

        String sql = """
                SELECT
                    l.ListingId,
                    l.ListingCode,
                    l.SellerId,
                    l.ProductTypeId,
                    l.Title,
                    l.Description,
                    l.ShortDescription,
                    l.Price,
                    l.OriginalPrice,
                    l.Quantity,
                    l.ListingType,
                    l.Status,
                    l.CreatedAt,
                    l.UpdatedAt,
                    pt.ProductTypeName,
                    (
                        SELECT TOP 1 li.ImageUrl
                        FROM dbo.ListingImages li
                        WHERE li.ListingId = l.ListingId
                        ORDER BY li.IsPrimary DESC, li.DisplayOrder ASC
                    ) AS ImageUrl
                FROM dbo.Favorites f
                JOIN dbo.Listings l
                    ON f.ListingId = l.ListingId
                LEFT JOIN dbo.ProductType pt
                    ON l.ProductTypeId = pt.ProductTypeId
                WHERE f.UserId = ?
                ORDER BY f.CreatedAt DESC
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Listing listing = new Listing();

                    listing.setListingId(rs.getInt("ListingId"));
                    listing.setListingCode(rs.getString("ListingCode"));
                    listing.setSellerId(rs.getInt("SellerId"));
                    listing.setProductTypeId(rs.getInt("ProductTypeId"));

                    listing.setTitle(rs.getString("Title"));
                    listing.setDescription(rs.getString("Description"));
                    listing.setShortDescription(
                            rs.getString("ShortDescription")
                    );

                    listing.setPrice(rs.getBigDecimal("Price"));
                    listing.setOriginalPrice(
                            rs.getBigDecimal("OriginalPrice")
                    );

                    listing.setQuantity(rs.getInt("Quantity"));
                    listing.setListingType(rs.getString("ListingType"));
                    listing.setStatus(rs.getString("Status"));

                    if (rs.getTimestamp("CreatedAt") != null) {
                        listing.setCreatedAt(
                                rs.getTimestamp("CreatedAt").toLocalDateTime()
                        );
                    }

                    if (rs.getTimestamp("UpdatedAt") != null) {
                        listing.setUpdatedAt(
                                rs.getTimestamp("UpdatedAt").toLocalDateTime()
                        );
                    }

                    listing.setProductTypeName(
                            rs.getString("ProductTypeName")
                    );

                    listing.setImageUrl(rs.getString("ImageUrl"));

                    listings.add(listing);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return listings;
    }

    // 5. Đếm số lượng sản phẩm yêu thích
    public int countFavorites(int userId) {

        String sql = """
                SELECT COUNT(*)
                FROM dbo.Favorites
                WHERE UserId = ?
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    // Lấy ID các sản phẩm mà người dùng đã yêu thích
    public Set<Integer> getFavoriteListingIds(int userId) {

        Set<Integer> favoriteIds = new HashSet<>();

        String sql = """
            SELECT ListingId
            FROM dbo.Favorites
            WHERE UserId = ?
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    favoriteIds.add(rs.getInt("ListingId"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return favoriteIds;
    }
}
