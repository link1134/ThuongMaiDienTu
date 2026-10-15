<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chỉnh Sửa Thể Loại - MangaVault Admin</title>
    <style>
        .form-container { max-width: 600px; margin: 40px auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px; font-family: sans-serif; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input[type="text"], .form-group textarea, .form-group select { width: 100%; padding: 8px; box-sizing: border-box; border-radius: 4px; border: 1px solid #ccc; }
        .select-scroll-box { height: 120px; }
        .select-scroll-box option { padding: 6px; }
        .form-hint { font-size: 12px; color: #666; margin-top: 4px; display: block; }
        .btn-submit { padding: 10px 20px; background-color: #2563eb; color: white; border: none; border-radius: 4px; cursor: pointer; }
        .btn-cancel { padding: 10px 20px; background-color: #f1f5f9; color: black; border: 1px solid #ccc; text-decoration: none; border-radius: 4px; }
        .error-msg { color: red; margin-bottom: 15px; }
    </style>
</head>
<body>
<div class="form-container">
    <h2>Chỉnh Sửa Thể Loại</h2>

    <c:if test="${not empty errorMessage}">
        <div class="error-msg">${errorMessage}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/admin/categories" method="POST">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="categoryId" value="${category.categoryId}">

        <div class="form-group">
            <label>Mã Thể Loại: *</label>
            <input type="text" name="categoryCode" value="${category.categoryCode}" required>
        </div>

        <div class="form-group">
            <label>Tên Thể Loại: *</label>
            <input type="text" name="categoryName" value="${category.categoryName}" required>
        </div>

        <!-- DANH SÁCH NXB ĐÃ CHỌN TRƯỚC ĐÓ -->
        <div class="form-group">
            <label>Nhà Xuất Bản Liên Kết:</label>
            <select name="publisherIds" multiple size="5" class="select-scroll-box">
                <c:forEach var="pub" items="${publishers}">
                    <!-- Kiểm tra NXB nào đã được liên kết thì thêm attribute selected -->
                    <c:set var="isSelected" value="false" />
                    <c:forEach var="catPub" items="${category.publishers}">
                        <c:if test="${catPub.publisherId == pub.publisherId}">
                            <c:set var="isSelected" value="true" />
                        </c:if>
                    </c:forEach>
                    <option value="${pub.publisherId}" ${isSelected ? 'selected' : ''}>
                            ${pub.publisherName} (${pub.publisherCode})
                    </option>
                </c:forEach>
            </select>
            <span class="form-hint">💡 Giữ phím <b>Ctrl</b> (hoặc <b>Cmd</b>) để chọn/bỏ chọn nhiều NXB.</span>
        </div>

        <div class="form-group">
            <label>Mô tả ngắn:</label>
            <textarea name="description" rows="3">${category.description}</textarea>
        </div>

        <div class="form-group">
            <label>Trạng Thái:</label>
            <select name="status">
                <option value="1" ${category.status ? 'selected' : ''}>Hiển thị (Active)</option>
                <option value="0" ${!category.status ? 'selected' : ''}>Tạm ẩn (Hidden)</option>
            </select>
        </div>

        <div style="margin-top: 20px;">
            <button type="submit" class="btn-submit">Cập Nhật</button>
            <a href="${pageContext.request.contextPath}/admin/categories" class="btn-cancel">Hủy bỏ</a>
        </div>
    </form>
</div>
</body>
</html>