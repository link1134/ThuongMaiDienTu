
package com.mangaz.dao;

import com.mangaz.model.Listing;
import com.mangaz.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ListingDAO {

    public List<Listing> searchByTitle(String keyword) throws SQLException {
        List<Listing> listings = new ArrayList<>();

        if (keyword == null || keyword.trim().isEmpty()) {
            return listings;
        }

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
                FROM dbo.Listings l
                JOIN dbo.ProductType pt
                    ON l.ProductTypeId = pt.ProductTypeId
                WHERE l.Status = 'Active'
                    AND l.Title LIKE ?
                ORDER BY
                    CASE
                        WHEN l.Title = ? THEN 0
                        WHEN l.Title LIKE ? THEN 1
                        ELSE 2
                    END,
                    l.CreatedAt DESC
                """;

        String trimmedKeyword = keyword.trim();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, "%" + trimmedKeyword + "%");
            statement.setString(2, trimmedKeyword);
            statement.setString(3, trimmedKeyword + "%");

            try (ResultSet rs = statement.executeQuery()) {
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
        }

        return listings;
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
