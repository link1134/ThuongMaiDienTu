
package com.mangaz.dao;

import com.mangaz.model.DeliveryAddress;
import com.mangaz.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DeliveryAddressDAO {

    public List<DeliveryAddress> findByUserId(int userId)
            throws SQLException {

        List<DeliveryAddress> addresses = new ArrayList<>();

        String sql = """
                SELECT Id, UserId, RecipientName, PhoneNumber,
                       ProvinceCode, CityProvince,
                       WardCode, Ward, AddressDetail, IsDefault
                FROM DeliveryAddresses
                WHERE UserId = ?
                ORDER BY IsDefault DESC, Id DESC
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DeliveryAddress address = new DeliveryAddress();

                    address.setId(rs.getInt("Id"));
                    address.setUserId(rs.getInt("UserId"));
                    address.setRecipientName(rs.getString("RecipientName"));
                    address.setPhoneNumber(rs.getString("PhoneNumber"));

                    address.setProvinceCode(rs.getInt("ProvinceCode"));
                    address.setCityProvince(rs.getString("CityProvince"));

                    address.setWardCode(rs.getInt("WardCode"));
                    address.setWard(rs.getString("Ward"));

                    address.setAddressDetail(rs.getString("AddressDetail"));
                    address.setDefaultAddress(rs.getBoolean("IsDefault"));

                    addresses.add(address);
                }
            }
        }

        return addresses;
    }

    public void insert(DeliveryAddress address) throws SQLException {

        String countSql = """
                SELECT COUNT(*)
                FROM DeliveryAddresses WITH (UPDLOCK, HOLDLOCK)
                WHERE UserId = ?
                """;

        String resetDefaultSql = """
                UPDATE DeliveryAddresses
                SET IsDefault = 0
                WHERE UserId = ?
                """;

        String insertSql = """
                INSERT INTO DeliveryAddresses
                (
                    UserId, RecipientName, PhoneNumber,
                    ProvinceCode, CityProvince,
                    WardCode, Ward, AddressDetail, IsDefault
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        try (Connection conn = DBConnection.getConnection()) {

            conn.setAutoCommit(false);

            try {
                int addressCount;

                try (PreparedStatement ps = conn.prepareStatement(countSql)) {
                    ps.setInt(1, address.getUserId());

                    try (ResultSet rs = ps.executeQuery()) {
                        rs.next();
                        addressCount = rs.getInt(1);
                    }
                }

                // Địa chỉ đầu tiên luôn là địa chỉ mặc định.
                boolean makeDefault =
                        address.isDefaultAddress() || addressCount == 0;

                // Nếu đặt địa chỉ mới làm mặc định,
                // bỏ mặc định của các địa chỉ cũ cùng người dùng.
                if (makeDefault) {
                    try (PreparedStatement ps =
                                 conn.prepareStatement(resetDefaultSql)) {
                        ps.setInt(1, address.getUserId());
                        ps.executeUpdate();
                    }
                }

                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    ps.setInt(1, address.getUserId());
                    ps.setString(2, address.getRecipientName());
                    ps.setString(3, address.getPhoneNumber());

                    ps.setInt(4, address.getProvinceCode());
                    ps.setString(5, address.getCityProvince());

                    ps.setInt(6, address.getWardCode());
                    ps.setString(7, address.getWard());
                    ps.setString(8, address.getAddressDetail());
                    ps.setBoolean(9, makeDefault);

                    ps.executeUpdate();
                }

                conn.commit();

            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }
}
