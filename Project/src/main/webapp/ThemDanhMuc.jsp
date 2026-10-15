<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm Danh Thể Loại mới - MangaVault Admin</title>
    <style>
        .form-container { max-width: 600px; margin: 40px auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px; font-family: sans-serif; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input, .form-group textarea, .form-group select { width: 100%; padding: 8px; box-sizing: border-box; }
        .btn-submit { padding: 10px 20px; background-color: #2563eb; color: white; border: none; border-radius: 4px; cursor: pointer; }
        .btn-cancel { padding: 10px 20px; background-color: #f1f5f9; color: black; border: 1px solid #ccc; text-decoration: none; border-radius: 4px; }
        .error-msg { color: red; margin-bottom: 15px; }
    </style>
</head>
<body>
<div class="form-container">
    <h2>Thêm Danh Mục Mới</h2>

    <!-- Hiển thị thông báo lỗi nếu có -->
    <c:if test="${not empty errorMessage}">
        <div class="error-msg">${errorMessage}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/admin/categories" method="POST">
        <!-- Action ẩn để Servlet biết đây là request Insert -->
        <input type="hidden" name="action" value="insert">

        <div class="form-group">
            <label>Mã Thể Loại (Category Code): *</label>
            <input type="text" name="categoryCode" placeholder="VD: CAT-SHN-01" required>
        </div>

        <div class="form-group">
            <label>Tên Danh Mục: *</label>
            <input type="text" name="categoryName" placeholder="VD: Shonen Manga" required>
        </div>

        <div class="form-group">
            <label>Mô tả ngắn:</label>
            <textarea name="description" rows="4" placeholder="Nhập mô tả về thể loại này..."></textarea>
        </div>

        <!-- KHỐI CHỌN NHÀ XUẤT BẢN -->
        <div class="form-group">
            <label>Nhà Xuất Bản Liên Kết:</label>
            <div class="publisher-checkbox-grid">
                <c:choose>
                    <c:when test="${not empty publishers}">
                        <c:forEach var="pub" items="${publishers}">
                            <label class="publisher-checkbox-item">
                                <input type="checkbox" name="publisherIds" value="${pub.publisherId}">
                                <span>${pub.publisherName} (${pub.publisherCode})</span>
                            </label>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <span style="color: gray; grid-column: span 2;">Chưa có nhà xuất bản nào trong hệ thống.</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="form-group">
            <label>Mô tả ngắn:</label>
            <textarea name="description" rows="3" placeholder="Nhập mô tả về thể loại này..."></textarea>
        </div>

        <div class="form-group">
            <label>Trạng Thái:</label>
            <select name="status">
                <option value="1">Hiển thị (Active)</option>
                <option value="0">Tạm ẩn (Hidden)</option>
            </select>
        </div>

        <div style="margin-top: 20px;">
            <button type="submit" class="btn-submit">Lưu Danh Mục</button>
            <a href="${pageContext.request.contextPath}/admin/categories" class="btn-cancel">Hủy bỏ</a>
        </div>
    </form>
</div>
</body>
</html>