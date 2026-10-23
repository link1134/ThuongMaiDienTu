
package com.mangaz.dao;

import com.mangaz.model.Listing;
import com.mangaz.util.DBConnection;
import java.util.LinkedHashMap;
import java.util.Map;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ListingDAO {

    public List<Listing> searchByTitle(String keyword) throws SQLException {
        return searchByTitle(keyword, "All");
    }

    public List<Listing> searchByTitle(
            String keyword, String type) throws SQLException {

        List<Listing> listings = new ArrayList<>();

        String trimmedKeyword = keyword == null ? "" : keyword.trim();

        StringBuilder sql = new StringBuilder("""
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
            FROM dbo.Listings l
            JOIN dbo.ProductType pt
                ON l.ProductTypeId = pt.ProductTypeId
            WHERE l.Status = 'Active'
                AND l.Title LIKE ?
            """);

        if ("Auction".equals(type)) {
            sql.append(" AND l.ListingType = 'Auction' ");
        } else if ("Sale".equals(type)) {
            sql.append(" AND l.ListingType = 'Sale' ");
        }

        sql.append("""
            ORDER BY
                CASE
                    WHEN l.Title = ? THEN 0
                    WHEN l.Title LIKE ? THEN 1
                    ELSE 2
                END,
                l.CreatedAt DESC
            """);

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql.toString())) {

            statement.setString(1, "%" + trimmedKeyword + "%");
            statement.setString(2, trimmedKeyword);
            statement.setString(3, trimmedKeyword + "%");

            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    listings.add(mapListing(rs));
                }
            }
        }

        return listings;
    }

    private Listing mapListing(ResultSet rs) throws SQLException {
        Listing listing = new Listing();

        listing.setListingId(rs.getInt("ListingId"));
        listing.setListingCode(rs.getString("ListingCode"));
        listing.setSellerId(rs.getInt("SellerId"));
        listing.setProductTypeId(rs.getInt("ProductTypeId"));

        listing.setTitle(rs.getString("Title"));
        listing.setDescription(rs.getString("Description"));
        listing.setShortDescription(rs.getString("ShortDescription"));

        listing.setPrice(rs.getBigDecimal("Price"));
        listing.setOriginalPrice(rs.getBigDecimal("OriginalPrice"));
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

        listing.setProductTypeName(rs.getString("ProductTypeName"));
        listing.setImageUrl(rs.getString("ImageUrl"));

        return listing;
    }

    public Map<String, Integer> getSearchCounts(String keyword)
            throws SQLException {

        Map<String, Integer> counts = new LinkedHashMap<>();

        String sql = """
                
                    SELECT
                                        COUNT(*) AS AllCount,
                                        COALESCE(SUM(
                                            CASE WHEN ListingType = 'Auction'
                                                 THEN 1 ELSE 0 END
                                        ), 0) AS AuctionCount,
                                        COALESCE(SUM(
                                            CASE WHEN ListingType = 'Sale'
                                                 THEN 1 ELSE 0 END
                                        ), 0) AS SaleCount
                                    FROM dbo.Listings
                                    WHERE Status = 'Active'
                                        AND Title LIKE ?
                """;

        String trimmedKeyword = keyword == null ? "" : keyword.trim();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, "%" + trimmedKeyword + "%");

            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    counts.put("All", rs.getInt("AllCount"));
                    counts.put("Auction", rs.getInt("AuctionCount"));
                    counts.put("Sale", rs.getInt("SaleCount"));
                }
            }
        }

        return counts;
    }

    public List<Listing> getLatestListings() throws SQLException {
        List<Listing> listings = new ArrayList<>();

        String sql = """
                SELECT TOP 8
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
                FROM dbo.Listings l
                JOIN dbo.ProductType pt
                    ON l.ProductTypeId = pt.ProductTypeId
                WHERE l.Status = 'Active'
                ORDER BY l.CreatedAt DESC, l.ListingId DESC
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {

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

        return listings;
    }

}
