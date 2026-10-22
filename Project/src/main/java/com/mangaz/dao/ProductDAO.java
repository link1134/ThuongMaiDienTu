
package com.mangaz.dao;

import com.mangaz.model.ProductDetail;
import com.mangaz.util.DBConnection;
import com.mangaz.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    public ProductDetail findById(int listingId) {
        String sql = """
                SELECT ListingId, Title, Description,
                       Price, OriginalPrice, Quantity, ShortDescription
                FROM Listings
                WHERE ListingId = ?
                  AND ListingType = 'Sale'
                  AND Status = 'Active'
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, listingId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    ProductDetail product = new ProductDetail();
                    product.setProductId(resultSet.getInt("ListingId"));
                    product.setTitle(resultSet.getString("Title"));
                    product.setDescription(resultSet.getString("Description"));
                    product.setPrice(resultSet.getBigDecimal("Price"));
                    product.setOriginalPrice(
                            resultSet.getBigDecimal("OriginalPrice")
                    );
                    product.setStockQuantity(
                            resultSet.getInt("Quantity")
                    );
                    product.setShortDescription(resultSet.getString("ShortDescription"));
                    product.setImageUrls(findImagesByListingId(
                            connection, listingId
                    ));

                    if (!product.getImageUrls().isEmpty()) {
                        product.setCoverImageUrl(
                                product.getImageUrls().get(0)
                        );
                    }
                    return product;
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Lỗi khi lấy chi tiết bài đăng: " + listingId, e
            );
        }

        return null;
    }

    private List<String> findImagesByListingId(
            Connection connection, int listingId) throws SQLException {

        List<String> imageUrls = new ArrayList<>();

        String sql = """
                SELECT ImageUrl
                FROM ListingImages
                WHERE ListingId = ?
                ORDER BY IsPrimary DESC, DisplayOrder ASC, ImageId ASC
                """;

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, listingId);

            try (ResultSet resultSet = statement.executeQuery()) {

                while (resultSet.next()) {
                    imageUrls.add(resultSet.getString("ImageUrl"));
                }

            }
        }

        return imageUrls;
    }
}
