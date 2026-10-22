package com.mangaz.dao;

import com.mangaz.model.Category;
import com.mangaz.model.Publisher;
import com.mangaz.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    /**
     * Lấy toàn bộ danh sách thể loại kèm theo danh sách Nhà xuất bản liên kết
     */
    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();

        String sql = "SELECT c.CategoryID, c.CategoryCode, c.CategoryName, c.Description, " +
                "c.ParentCategoryID, c.Status, c.CreatedAt, c.UpdatedAt, " +
                "STRING_AGG(CAST(p.PublisherID AS VARCHAR), ',') AS PubIds, " +
                "STRING_AGG(CAST(p.PublisherCode AS VARCHAR), ',') AS PubCodes, " +
                "STRING_AGG(CAST(p.PublisherName AS VARCHAR), ',') AS PubNames " +
                "FROM Categories c " +
                "LEFT JOIN CategoryPublisher cp ON c.CategoryID = cp.CategoryID " +
                "LEFT JOIN Publishers p ON cp.PublisherID = p.PublisherID " +
                "WHERE c.IsDeleted = 0 " +
                "GROUP BY c.CategoryID, c.CategoryCode, c.CategoryName, c.Description, " +
                "c.ParentCategoryID, c.Status, c.CreatedAt, c.UpdatedAt " +
                "ORDER BY c.CategoryID DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category cat = new Category();
                cat.setCategoryId(rs.getInt("CategoryID"));
                cat.setCategoryCode(rs.getString("CategoryCode"));
                cat.setCategoryName(rs.getString("CategoryName"));
                cat.setDescription(rs.getString("Description"));

                Integer parentId = (Integer) rs.getObject("ParentCategoryID");
                cat.setParentCategoryId(parentId);

                cat.setStatus(rs.getBoolean("Status"));
                cat.setCreatedAt(rs.getTimestamp("CreatedAt"));
                cat.setUpdatedAt(rs.getTimestamp("UpdatedAt"));


                List<Publisher> pubList = new ArrayList<>();
                String pubIds = rs.getString("PubIds");
                String pubCodes = rs.getString("PubCodes");
                String pubNames = rs.getString("PubNames");

                // Chỉ cắt chuỗi nếu PubIds và PubNames không bị NULL
                if (pubIds != null && !pubIds.trim().isEmpty() && pubNames != null && !pubNames.trim().isEmpty()) {
                    String[] ids = pubIds.split(",");
                    String[] names = pubNames.split(",");
                    // Ép độ dài của codes bằng với ids để tránh lỗi IndexOutOfBounds
                    String[] codes = (pubCodes != null && !pubCodes.trim().isEmpty()) ? pubCodes.split(",") : new String[ids.length];

                    // Đảm bảo không bị lỗi mảng lệch độ dài
                    int minLength = Math.min(ids.length, names.length);
                    for (int i = 0; i < minLength; i++) {
                        Publisher pub = new Publisher();
                        try {
                            pub.setPublisherId(Integer.parseInt(ids[i].trim()));
                            pub.setPublisherName(names[i].trim());
                            pub.setPublisherCode(i < codes.length && codes[i] != null ? codes[i].trim() : "");
                            pubList.add(pub);
                        } catch (NumberFormatException ex) {
                            // Bỏ qua nếu ID không phải là số hợp lệ
                            System.out.println("Lỗi parse Publisher ID: " + ids[i]);
                        }
                    }
                }

                cat.setPublishers(pubList);

                list.add(cat);
            }
        } catch (Exception e) {
            System.out.println("Lỗi ở getAllCategories: ");
            e.printStackTrace();
        }
        return list;
    }
    /**
     * Thêm một danh mục mới vào cơ sở dữ liệu
     * @param category Đối tượng Category chứa dữ liệu từ form
     * @return true nếu thêm thành công, false nếu thất bại
     */
    /**
     * Thêm thể loại mới đồng thời lưu danh sách NXB liên kết (sử dụng Transaction)
     */
    public boolean insertCategory(Category category, String[] publisherIds) {
        String sqlCategory = "INSERT INTO Categories (CategoryCode, CategoryName, Description, ParentCategoryID, Status) VALUES (?, ?, ?, ?, ?)";
        String sqlMapping = "INSERT INTO CategoryPublisher (CategoryID, PublisherID) VALUES (?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // 1. Thêm thể loại mới và lấy ID vừa tạo
            PreparedStatement psCat = conn.prepareStatement(sqlCategory, Statement.RETURN_GENERATED_KEYS);
            psCat.setString(1, category.getCategoryCode());
            psCat.setString(2, category.getCategoryName());
            psCat.setString(3, category.getDescription());

            if (category.getParentCategoryId() != null && category.getParentCategoryId() > 0) {
                psCat.setInt(4, category.getParentCategoryId());
            } else {
                psCat.setNull(4, java.sql.Types.INTEGER);
            }
            psCat.setBoolean(5, category.isStatus());

            int affectedRows = psCat.executeUpdate();
            if (affectedRows == 0) {
                conn.rollback();
                return false;
            }

            // Lấy CategoryID vừa sinh ra
            int generatedCategoryId = -1;
            try (ResultSet rsKeys = psCat.getGeneratedKeys()) {
                if (rsKeys.next()) {
                    generatedCategoryId = rsKeys.getInt(1);
                }
            }

            if (generatedCategoryId == -1) {
                conn.rollback();
                return false;
            }

            // 2. Thêm danh sách NXB liên kết vào bảng CategoryPublisher
            if (publisherIds != null && publisherIds.length > 0) {
                try (PreparedStatement psMap = conn.prepareStatement(sqlMapping)) {
                    for (String pubIdStr : publisherIds) {
                        int pubId = Integer.parseInt(pubIdStr);
                        psMap.setInt(1, generatedCategoryId);
                        psMap.setInt(2, pubId);
                        psMap.addBatch(); // Gom nhóm câu lệnh
                    }
                    psMap.executeBatch(); // Thực thi hàng loạt
                }
            }

            conn.commit(); // Xác nhận lưu toàn bộ thay đổi thành công
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Hủy bỏ thao tác nếu có lỗi
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
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
        return false;
    }
    /**
     * Đếm tổng số Thể loại hiện có trong CSDL
     */
    public int countCategories() {
        String sql = "SELECT COUNT(*) FROM Categories WHERE IsDeleted = 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    /**
     * Lấy thông tin chi tiết của 1 thể loại theo ID
     */
    public Category getCategoryById(int categoryId) {
        Category cat = null;
        String sql = "SELECT c.CategoryID, c.CategoryCode, c.CategoryName, c.Description, " +
                "       c.ParentCategoryID, c.Status, c.CreatedAt, c.UpdatedAt, " +
                "       STRING_AGG(CAST(p.PublisherID AS VARCHAR), ',') AS PubIds, " +
                "       STRING_AGG(CAST(p.PublisherCode AS VARCHAR), ',') AS PubCodes, " +
                "       STRING_AGG(CAST(p.PublisherName AS VARCHAR), ',') AS PubNames " +
                "FROM Categories c " +
                "LEFT JOIN CategoryPublisher cp ON c.CategoryID = cp.CategoryID " +
                "LEFT JOIN Publishers p ON cp.PublisherID = p.PublisherID " +
                "WHERE c.IsDeleted = 0 " +
                "GROUP BY c.CategoryID, c.CategoryCode, c.CategoryName, c.Description, " +
                "         c.ParentCategoryID, c.Status, c.CreatedAt, c.UpdatedAt";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    cat = new Category();
                    cat.setCategoryId(rs.getInt("CategoryID"));
                    cat.setCategoryCode(rs.getString("CategoryCode"));
                    cat.setCategoryName(rs.getString("CategoryName"));
                    cat.setDescription(rs.getString("Description"));
                    cat.setParentCategoryId((Integer) rs.getObject("ParentCategoryID"));
                    cat.setStatus(rs.getBoolean("Status"));
                    cat.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    cat.setUpdatedAt(rs.getTimestamp("UpdatedAt"));

                    // Lấy danh sách ID các NXB đã liên kết
                    List<Publisher> pubList = new ArrayList<>();
                    String pubIds = rs.getString("PubIds");
                    if (pubIds != null && !pubIds.trim().isEmpty()) {
                        for (String idStr : pubIds.split(",")) {
                            Publisher p = new Publisher();
                            p.setPublisherId(Integer.parseInt(idStr.trim()));
                            pubList.add(p);
                        }
                    }
                    cat.setPublishers(pubList);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cat;
    }

    /**
     * Cập nhật thông tin Thể loại & danh sách NXB liên kết
     */
    public boolean updateCategory(Category category, String[] publisherIds) {
        String sqlCategory = "UPDATE Categories SET CategoryCode = ?, CategoryName = ?, Description = ?, Status = ?, UpdatedAt = SYSDATETIME() WHERE CategoryID = ?";
        String sqlDeleteMap = "DELETE FROM CategoryPublisher WHERE CategoryID = ?";
        String sqlInsertMap = "INSERT INTO CategoryPublisher (CategoryID, PublisherID) VALUES (?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // 1. Cập nhật bảng Categories
            try (PreparedStatement psCat = conn.prepareStatement(sqlCategory)) {
                psCat.setString(1, category.getCategoryCode());
                psCat.setString(2, category.getCategoryName());
                psCat.setString(3, category.getDescription());
                psCat.setBoolean(4, category.isStatus());
                psCat.setInt(5, category.getCategoryId());
                psCat.executeUpdate();
            }

            // 2. Xóa các liên kết NXB cũ
            try (PreparedStatement psDel = conn.prepareStatement(sqlDeleteMap)) {
                psDel.setInt(1, category.getCategoryId());
                psDel.executeUpdate();
            }

            // 3. Chèn các liên kết NXB mới
            if (publisherIds != null && publisherIds.length > 0) {
                try (PreparedStatement psIns = conn.prepareStatement(sqlInsertMap)) {
                    for (String pubIdStr : publisherIds) {
                        psIns.setInt(1, category.getCategoryId());
                        psIns.setInt(2, Integer.parseInt(pubIdStr));
                        psIns.addBatch();
                    }
                    psIns.executeBatch();
                }
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        return false;
    }

    /**
     * Xóa logic Thể loại
     */
    public boolean deleteCategoryLogic(int categoryId) {
        String sql = "UPDATE Categories SET IsDeleted = 1, UpdatedAt = SYSDATETIME() WHERE CategoryID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    /**
     * Lấy danh sách thể loại có phân trang
     * @param page Trang hiện tại (bắt đầu từ 1)
     * @param pageSize Số lượng dòng trên 1 trang   
     */
    public List<Category> getCategoriesByPage(int page, int pageSize) {
        List<Category> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        String sql = "SELECT c.CategoryID, c.CategoryCode, c.CategoryName, c.Description, " +
                "c.ParentCategoryID, c.Status, c.CreatedAt, c.UpdatedAt, " +
                "STRING_AGG(CAST(p.PublisherID AS VARCHAR), ',') AS PubIds, " +
                "STRING_AGG(CAST(p.PublisherCode AS VARCHAR), ',') AS PubCodes, " +
                "STRING_AGG(CAST(p.PublisherName AS VARCHAR), ',') AS PubNames " +
                "FROM Categories c " +
                "LEFT JOIN CategoryPublisher cp ON c.CategoryID = cp.CategoryID " +
                "LEFT JOIN Publishers p ON cp.PublisherID = p.PublisherID " +
                "WHERE c.IsDeleted = 0 " +
                "GROUP BY c.CategoryID, c.CategoryCode, c.CategoryName, c.Description, " +
                "c.ParentCategoryID, c.Status, c.CreatedAt, c.UpdatedAt " +
                "ORDER BY c.CategoryID DESC " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, offset);
            ps.setInt(2, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Category cat = new Category();
                    cat.setCategoryId(rs.getInt("CategoryID"));
                    cat.setCategoryCode(rs.getString("CategoryCode"));
                    cat.setCategoryName(rs.getString("CategoryName"));
                    cat.setDescription(rs.getString("Description"));
                    cat.setParentCategoryId((Integer) rs.getObject("ParentCategoryID"));
                    cat.setStatus(rs.getBoolean("Status"));
                    cat.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    cat.setUpdatedAt(rs.getTimestamp("UpdatedAt"));

                    List<Publisher> pubList = new ArrayList<>();
                    String pubIds = rs.getString("PubIds");
                    String pubCodes = rs.getString("PubCodes");
                    String pubNames = rs.getString("PubNames");

                    if (pubIds != null && !pubIds.trim().isEmpty() && pubNames != null && !pubNames.trim().isEmpty()) {
                        String[] ids = pubIds.split(",");
                        String[] names = pubNames.split(",");
                        String[] codes = (pubCodes != null && !pubCodes.trim().isEmpty()) ? pubCodes.split(",") : new String[ids.length];

                        int minLength = Math.min(ids.length, names.length);
                        for (int i = 0; i < minLength; i++) {
                            Publisher pub = new Publisher();
                            try {
                                pub.setPublisherId(Integer.parseInt(ids[i].trim()));
                                pub.setPublisherName(names[i].trim());
                                pub.setPublisherCode(i < codes.length && codes[i] != null ? codes[i].trim() : "");
                                pubList.add(pub);
                            } catch (NumberFormatException ex) {
                                System.out.println("Lỗi parse Publisher ID: " + ids[i]);
                            }
                        }
                    }
                    cat.setPublishers(pubList);
                    list.add(cat);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}