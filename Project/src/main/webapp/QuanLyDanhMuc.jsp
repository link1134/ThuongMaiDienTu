<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Danh Mục (Admin) - MangaVault</title> <!-- Google Fonts: Plus Jakarta Sans & Playfair Display -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link
            href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,600;0,700;0,800;1,600&family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&display=swap"
            rel="stylesheet"> <!-- Google Material Symbols Outlined -->
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"/>
    <!-- File CSS riêng biệt -->
    <link rel="stylesheet" href="../css/QuanlyDanhMuc.css">
</head>

<body class="site-body">
<jsp:include page="/common/header.jsp"/>
<!-- VÙNG NỘI DUNG CHÍNH TRANG QUẢN TRỊ ADMIN -->
<main class="admin-page-container">
    <div class="admin-layout-grid"> <!-- CỘT TRÁI: SIDEBAR QUẢN TRỊ ADMIN -->
        <aside class="admin-sidebar"> <!-- Brand Badge MangaVault Admin -->
            <div class="admin-brand-badge-card">
                <div class="admin-shield-icon-box"><span class="material-symbols-outlined">shield_person</span>
                </div>
                <div class="admin-badge-meta"><span class="admin-badge-title">MangaVault Admin</span> <span
                        class="admin-badge-subtitle">Collector Exchange Portal</span></div>
            </div> <!-- Menu Quản trị chính -->
            <div class="admin-nav-card">
                <ul class="admin-nav-list">
                    <li><a href="#" class="admin-nav-item"> <span
                            class="material-symbols-outlined">dashboard</span> <span>Dashboard Thống kê</span>
                    </a></li>
                    <li><a href="#" class="admin-nav-item active"> <span
                            class="material-symbols-outlined">category</span> <span>Quản lý Danh mục</span> </a>
                    </li>
                    <li><a href="#" class="admin-nav-item"> <span
                            class="material-symbols-outlined">menu_book</span> <span>Master Catalog</span> </a>
                    </li>
                    <li><a href="#" class="admin-nav-item"> <span class="material-symbols-outlined">group</span>
                        <span>Quản lý Người dùng &amp; Collector</span> </a></li>
                </ul>
            </div> <!-- Menu Phụ: Kiểm toán & Hệ thống -->
            <div class="admin-secondary-nav-card">
                <ul class="admin-nav-list">
                    <li><a href="#" class="admin-nav-item"> <span class="material-symbols-outlined">verified</span>
                        <span>Báo cáo kiểm toán</span> </a></li>
                    <li><a href="#" class="admin-nav-item"> <span class="material-symbols-outlined">settings</span>
                        <span>Cài đặt hệ thống</span> </a></li>
                    <li><a href="#" class="admin-nav-item"> <span class="material-symbols-outlined">security</span>
                        <span>Nhật ký Escrow</span> </a></li>
                </ul>
            </div>
        </aside> <!-- CỘT PHẢI: KHU VỰC QUẢN LÝ NỘI DUNG CHÍNH -->
        <section class="admin-main-content"> <!-- Header Trang & Nút Thao Tác -->
            <div class="admin-page-header">
                <div class="admin-header-titles">
                    <h1 class="admin-page-title">Quản Lý Danh Mục Manga &amp; Thể Loại Sưu Tầm</h1>
                    <p class="admin-page-subtitle">Quản lý hệ thống phân cấp thể loại, tiêu chuẩn giám định CGC và
                        danh mục ấn phẩm bản quyền.</p>
                </div>
                <div class="admin-header-actions">
                    <a href="${pageContext.request.contextPath}/admin/categories?action=add" class="btn-add-category"
                       style="text-decoration: none; display: inline-flex; align-items: center;">
                        <span class="material-symbols-outlined">add</span> <span> Thêm Danh Thể Loại mới</span>
                    </a>
                </div>
            </div> <!-- 4 Thẻ Chỉ Số KPI Tổng Quan -->
            <div class="admin-metrics-grid"> <!-- KPI 1 -->
                <div class="metric-kpi-card">
                    <div class="metric-info-col"><span class="metric-kpi-label">Tổng Thể Loại</span>
                        <span class="metric-kpi-value">${totalCategories} Thể loại</span>
                    </div>
                    <div class="metric-icon-box"><span class="material-symbols-outlined">auto_stories</span></div>
                </div> <!-- KPI 2 -->
                <div class="metric-kpi-card">
                    <div class="metric-info-col"><span class="metric-kpi-label">Số Lượng NXB liên kết</span>
                        <span class="metric-kpi-value">${totalPublishers} NXB</span>
                    </div>
                    <div class="metric-icon-box green-box"><span class="material-symbols-outlined">menu_book</span>
                    </div>
                </div> <!-- KPI 3 -->
                <div class="metric-kpi-card">
                    <div class="metric-info-col"><span class="metric-kpi-label">Tiêu Chuẩn Slab Phân Loại</span>
                        <span class="metric-kpi-value">6 Chuẩn</span> <span class="metric-kpi-subtext blue-text">
                                <span class="material-symbols-outlined" style="font-size:14px;">verified</span> CGC/CBCS
                                Verified </span></div>
                    <div class="metric-icon-box blue-box"><span class="material-symbols-outlined">layers</span>
                    </div>
                </div> <!-- KPI 4 -->
                <div class="metric-kpi-card">
                    <div class="metric-info-col"><span class="metric-kpi-label">Tỷ Lệ Bảo Chứng</span> <span
                            class="metric-kpi-value">99.8%</span> <span class="metric-kpi-subtext purple-text">
                                <span class="material-symbols-outlined" style="font-size:14px;">lock</span> Ký quỹ
                                Escrow </span></div>
                    <div class="metric-icon-box purple-box"> <span
                            class="material-symbols-outlined">workspace_premium</span></div>
                </div>
            </div> <!-- Tabs Phân Loại & Bộ Lọc Tìm Kiếm -->
            <div class="admin-toolbar-row">
                <div class="category-tabs-group">
                    <a href="${pageContext.request.contextPath}/admin/categories" class="tab-category-btn active" style="text-decoration: none; display: inline-flex; align-items: center;">
                        <span class="material-symbols-outlined" style="font-size:16px;">format_list_bulleted</span>
                        <span>Thể loại truyện</span>
                        <span class="tab-count-badge">${totalCategories}</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/publishers" class="tab-category-btn" style="text-decoration: none; display: inline-flex; align-items: center;">
                        <span class="material-symbols-outlined" style="font-size:16px;">apartment</span>
                        <span>Nhà Xuất Bản</span>
                        <span class="tab-count-badge">${totalPublishers}</span>
                    </a>
                    <a href="#" class="tab-category-btn" style="text-decoration: none; display: inline-flex; align-items: center;">
                        <span class="material-symbols-outlined" style="font-size:16px;">approval</span>
                        <span>Định dạng &amp; Tiêu chuẩn Slab</span>
                        <span class="tab-count-badge">6</span>
                    </a>
                </div>
                <div class="search-filter-cluster">
                    <div class="admin-search-box"><span class="material-symbols-outlined">search</span> <input
                            type="text" class="admin-search-input" placeholder="Tìm kiếm mã, tên thể loại...">
                    </div>
                    <button type="button" class="btn-filter-tool"> <span
                            class="material-symbols-outlined">tune</span> <span>Bộ lọc</span></button>
                </div>
            </div> <!-- Bảng Dữ Liệu Danh Mục (Data Table) -->
            <div class="admin-table-card">
                <div class="table-responsive-wrapper">
                    <table class="admin-data-table">
                        <thead>
                        <tr>
                            <th>MÃ THỂ LOẠI</th>
                            <th>TÊN THỂ LOẠI</th>
                            <th>MÔ TẢ</th>
                            <th>NXB LIÊN KẾT</th>
                            <th class="col-status-fixed">TRẠNG THÁI</th>
                            <th>THAO TÁC</th>
                        </tr>
                        </thead>
                        <tbody>
                        <!-- Kiểm tra xem có dữ liệu không -->
                        <c:choose>
                            <c:when test="${not empty categories}">
                                <!-- Lặp qua danh sách danh mục -->
                                <c:forEach var="cat" items="${categories}">
                                    <tr>
                                        <td>
                                            <span class="category-code-tag">${cat.categoryCode}</span>
                                        </td>
                                        <td>
                                            <div class="category-name-cell">
                                                <span class="category-primary-title">${cat.categoryName}</span>
                                            </div>
                                        </td>
                                        <td>
                                            <!-- Hiển thị một phần mô tả (nếu có) -->
                                            <span class="master-count-val">
                                <c:choose>
                                    <c:when test="${not empty cat.description}">
                                        ${cat.description.length() > 30 ? cat.description.substring(0, 30) += '...' : cat.description}
                                    </c:when>
                                    <c:otherwise>
                                        <i style="color: gray;">Chưa có mô tả</i>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                                        </td>
                                        <td>
                                            <!-- Xử lý danh sách NXB liên kết -->
                                            <div class="publisher-stack-col">
                                                <c:choose>
                                                    <c:when test="${not empty cat.publishers}">
                                                        <div class="publisher-row-with-more">
                                                            <!-- Hiển thị tối đa 2 NXB -->
                                                            <c:forEach var="pub" items="${cat.publishers}"
                                                                       varStatus="loop">
                                                                <c:if test="${loop.index < 2}">
                                                                    <span class="pub-pill-small">${pub.publisherName}</span>
                                                                </c:if>
                                                            </c:forEach>

                                                            <!-- Hiển thị số lượng NXB còn lại (nếu > 2) -->
                                                            <c:if test="${cat.publishers.size() > 2}">
                                                                <span class="pub-more-badge">+ ${cat.publishers.size() - 2}</span>
                                                            </c:if>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="pub-pill-small"
                                                              style="background: #f1f5f9; color: #64748b;">Chưa liên kết NXB</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                        <td class="col-status-fixed">
                                            <!-- Xử lý Trạng thái (1: Hiển thị, 0: Tạm ẩn) -->
                                            <c:choose>
                                                <c:when test="${cat.status}">
                                    <span class="status-indicator-badge visible">
                                        <span class="status-dot-bullet"></span> <span>Hiển thị</span>
                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                    <span class="status-indicator-badge hidden">
                                        <span class="status-dot-bullet"></span> <span>Tạm ẩn </span>
                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="action-buttons-cell">
                                                <a href="${pageContext.request.contextPath}/admin/categories?action=edit&id=${cat.categoryId}"
                                                   class="btn-row-action" title="Chỉnh sửa"
                                                   style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center;">
                                                    <span class="material-symbols-outlined">edit</span>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/categories?action=delete&id=${cat.categoryId}"
                                                   class="btn-row-action" title="Xóa"
                                                   onclick="return confirm('Bạn có chắc chắn muốn xóa thể loại này ?');"
                                                   style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center;">
                                                    <span class="material-symbols-outlined">delete</span>
                                                </a>
                                                <button type="button" class="btn-row-action" title="Chi tiết">
                                                    <span class="material-symbols-outlined">open_in_new</span>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" style="text-align: center; padding: 20px;">
                                        Chưa có danh mục nào trong hệ thống.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
                <!-- Dải Phân Trang Động -->
                <div class="admin-pagination-row">
                    <div class="pagination-info-text">
                        Hiển thị <strong>${startItem} – ${endItem}</strong> của <strong>${totalCategories}</strong> thể loại đã phê duyệt
                    </div>

                    <c:if test="${totalPages > 1}">
                        <div class="pagination-controls-group">
                            <!-- Nút Trang trước (Chevron Left) -->
                            <c:if test="${currentPage > 1}">
                                <a href="${pageContext.request.contextPath}/admin/categories?page=${currentPage - 1}" class="btn-page-nav" title="Trang trước" style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center;">
                                    <span class="material-symbols-outlined">chevron_left</span>
                                </a>
                            </c:if>

                            <!-- Danh sách các nút số trang -->
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <a href="${pageContext.request.contextPath}/admin/categories?page=${i}" class="btn-page-nav ${i == currentPage ? 'active' : ''}" style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center;">
                                        ${i}
                                </a>
                            </c:forEach>

                            <!-- Nút Trang sau (Chevron Right) -->
                            <c:if test="${currentPage < totalPages}">
                                <a href="${pageContext.request.contextPath}/admin/categories?page=${currentPage + 1}" class="btn-page-nav" title="Trang sau" style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center;">
                                    <span class="material-symbols-outlined">chevron_right</span>
                                </a>
                            </c:if>
                        </div>
                    </c:if>
                </div>

    </div>
</main>
<footer class="site-main-footer">
    <div class="footer-inner-shell">
        <div class="footer-top-columns"> <!-- Brand Description -->
            <div class="footer-brand-column">
                <div class="footer-brand-title">MangaVault</div>
                <p class="footer-brand-mission"> Sàn giao dịch truyện tranh, ấn bản hiếm &amp; vật phẩm sưu tầm
                    xác thực bản quyền số 1 tại Đông Nam Á. </p>
                <div class="escrow-cert-tag"><span class="material-symbols-outlined">verified_user</span>
                    <span>100% Bảo Chứng Escrow</span>
                </div>
            </div> <!-- Col 1 -->
            <div class="footer-nav-column">
                <h4 class="footer-col-header">DANH MỤC LƯU TRỮ</h4>
                <ul class="footer-nav-list">
                    <li><a class="footer-link-item" href="#">Shonen Originals</a></li>
                    <li><a class="footer-link-item" href="#">Seinen Masterpieces</a></li>
                    <li><a class="footer-link-item" href="#">Shojo Vintage Classics</a></li>
                    <li><a class="footer-link-item" href="#">Tankōbon First Editions</a></li>
                </ul>
            </div> <!-- Col 2 -->
            <div class="footer-nav-column">
                <h4 class="footer-col-header">DỊCH VỤ COLLECTOR</h4>
                <ul class="footer-nav-list">
                    <li><a class="footer-link-item" href="#">Đấu Giá Trực Tiếp</a></li>
                    <li><a class="footer-link-item" href="#">Thẩm Định &amp; Đóng Slab</a></li>
                    <li><a class="footer-link-item" href="#">Lịch Private Drops</a></li>
                    <li><a class="footer-link-item" href="#">Ký Quỹ Ví Vault</a></li>
                </ul>
            </div> <!-- Col 3 -->
            <div class="footer-nav-column">
                <h4 class="footer-col-header">KÝ QUỸ &amp; PHÁP LÝ</h4>
                <ul class="footer-nav-list">
                    <li><a class="footer-link-item" href="#">Bảo Hiểm Ký Quỹ Escrow</a></li>
                    <li><a class="footer-link-item" href="#">Quy Trình Giám Định CGC/CBCS</a></li>
                    <li><a class="footer-link-item" href="#">Chính Sách Hoàn Tiền 100%</a></li>
                    <li><a class="footer-link-item" href="#">Điều Khoản Sử Dụng Sàn</a></li>
                </ul>
            </div> <!-- Col 4 -->
            <div class="footer-nav-column">
                <h4 class="footer-col-header">TRUNG TÂM HỖ TRỢ</h4>
                <ul class="footer-nav-list">
                    <li><a class="footer-link-item" href="#">Yêu Cầu Hỗ Trợ 24/7</a></li>
                    <li><a class="footer-link-item" href="#">Quy Chuẩn Đóng Gói Manga</a></li>
                    <li><a class="footer-link-item" href="#">Tra Cứu Mã Chứng Thư (API)</a></li>
                    <li><a class="footer-link-item" href="#">Quan Hệ Đối Tác &amp; NXB</a></li>
                </ul>
            </div>
        </div> <!-- Footer Bottom Bar -->
        <div class="footer-legal-bar">
            <p>© 2025 MangaVault Exchange Inc. Mọi quyền được bảo lưu.</p>
            <p class="footer-security-tags"><span>Bảo mật dữ liệu ISO 27001</span> <span>•</span> <span>Chứng
                        thực chữ ký số SHA-256</span></p>
        </div>
    </div>
</footer> <!-- END: SiteFooter -->
</body>

</html>