
package com.mangaz.dao;
import com.mangaz.model.ProductAttribute;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
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
    public List<ProductAttribute> findAttributesByListingId(int listingId) {
        List<ProductAttribute> attributes = new ArrayList<>();

        String sql =
                "SELECT ad.AttributeName, lav.ValueText " +
                        "FROM dbo.ListingAttributeValues lav " +
                        "JOIN dbo.AttributeDefinitions ad " +
                        "    ON lav.AttributeId = ad.AttributeId " +
                        "JOIN dbo.Listings l " +
                        "    ON lav.ListingId = l.ListingId " +
                        "JOIN dbo.ProductTypeAttributes pta " +
                        "    ON pta.ProductTypeId = l.ProductTypeId " +
                        "    AND pta.AttributeId = lav.AttributeId " +
                        "WHERE lav.ListingId = ? " +
                        "ORDER BY pta.DisplayOrder, ad.AttributeName";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, listingId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductAttribute attribute = new ProductAttribute();

                    attribute.setAttributeName(rs.getString("AttributeName"));
                    attribute.setValueText(rs.getString("ValueText"));

                    attributes.add(attribute);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(
                    "Lỗi khi lấy thuộc tính bài đăng: " + listingId, e
            );
        }

        return attributes;
    }
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
