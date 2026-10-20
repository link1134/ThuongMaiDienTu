<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chỉnh Sửa Nhà Xuất Bản - MangaVault Admin</title>
    <style>
        .form-container { max-width: 600px; margin: 40px auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px; font-family: sans-serif; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input, .form-group textarea, .form-group select { width: 100%; padding: 8px; box-sizing: border-box; border-radius: 4px; border: 1px solid #ccc; }
        .btn-submit { padding: 10px 20px; background-color: #2563eb; color: white; border: none; border-radius: 4px; cursor: pointer; }
        .btn-cancel { padding: 10px 20px; background-color: #f1f5f9; color: black; border: 1px solid #ccc; text-decoration: none; border-radius: 4px; }
        .error-msg { color: red; margin-bottom: 15px; }
    </style>
</head>
<body>
<div class="form-container">
    <h2>Chỉnh Sửa Nhà Xuất Bản</h2>

    <c:if test="${not empty errorMessage}">
        <div class="error-msg">${errorMessage}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/admin/publishers" method="POST">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="publisherId" value="${publisher.publisherId}">

        <div class="form-group">
            <label>Mã NXB: *</label>
            <input type="text" name="publisherCode" value="${publisher.publisherCode}" required>
        </div>

        <div class="form-group">
            <label>Tên Nhà Xuất Bản: *</label>
            <input type="text" name="publisherName" value="${publisher.publisherName}" required>
        </div>

        <div class="form-group">
            <label>Quốc Gia:</label>
            <input type="text" name="country" value="${publisher.country}">
        </div>

        <div class="form-group">
            <label>Năm Thành Lập:</label>
            <input type="number" name="foundedYear" value="${publisher.foundedYear}">
        </div>

        <div class="form-group">
            <label>Website chính thức:</label>
            <input type="text" name="website" value="${publisher.website}">
        </div>

        <div class="form-group">
            <label>Mô tả ngắn:</label>
            <textarea name="description" rows="3">${publisher.description}</textarea>
        </div>

        <div class="form-group">
            <label>Trạng Thái:</label>
            <select name="status">
                <option value="1" ${publisher.status ? 'selected' : ''}>Hiển thị (Active)</option>
                <option value="0" ${!publisher.status ? 'selected' : ''}>Tạm ẩn (Hidden)</option>
            </select>
        </div>

        <div style="margin-top: 20px;">
            <button type="submit" class="btn-submit">Cập Nhật</button>
            <a href="${pageContext.request.contextPath}/admin/publishers" class="btn-cancel">Hủy bỏ</a>
        </div>
    </form>
</div>
</body>
</html>