<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Nhà Xuất Bản (Admin) - MangaVault</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,600;0,700;0,800;1,600&family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/QuanlyDanhMuc.css">
</head>

<body class="site-body">
<header class="site-header">
    <div class="header-inner">
        <a class="brand-identity" href="#">
            <div class="brand-icon-box"> <span class="material-symbols-outlined">menu_book</span> </div>
            <div class="brand-text-group"> <span class="brand-title">MANGAZ</span> <span class="brand-subtitle">COLLECTOR EXCHANGE</span> </div>
        </a>
        <div class="search-container">
            <div class="search-field">
                <span class="search-prefix-icon"> <span class="material-symbols-outlined">search</span> </span>
                <input class="search-input-control" placeholder="Tìm kiếm nhà xuất bản..." type="text" />
            </div>
        </div>
        <nav class="main-navigation">
            <a class="nav-item active-nav" href="#">Trang chủ</a>
            <div class="nav-dropdown-trigger"> <span>Khám phá</span> <span class="material-symbols-outlined icon-expand">expand_more</span> </div>
            <a class="nav-item live-auction-link" href="#"> <span class="pulse-status-dot"></span> <span>Đấu giá</span> </a>
            <a class="nav-item" href="#">Cộng đồng</a>
        </nav>
        <div class="header-utilities">
            <button class="btn-trade-post" type="button"> <span class="material-symbols-outlined">add_circle</span> <span>Đăng bài / Trade</span> </button>
            <div class="user-avatar-trigger">
                <img alt="User profile avatar image" class="user-avatar-img" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCbxKavvR8kUjvRe_85K1vxKIgd4X86LdgGPiu_SkKlzkmzcXB4fOx5vrolj97DVgsrVm_dhA8v6P6lAQuJ8Bv5vzRoWp-_TxJf8PfMNH8oSc5G9qJgn3zgFD0JadKnt0pMIrdWesa3Jm1sN2yr0ah2CIcSApzWEURl1teMgwpWL98wV54jA0VIgIcvQmp2JOFx0ERJdQPpxjIMDNWNBMhoP0z7vOmmxUGgsYkywIM" />
                <span class="material-symbols-outlined icon-chevron">expand_more</span>
            </div>
        </div>
    </div>
</header>

<main class="admin-page-container">
    <div class="admin-layout-grid">
        <aside class="admin-sidebar">
            <div class="admin-brand-badge-card">
                <div class="admin-shield-icon-box"> <span class="material-symbols-outlined">shield_person</span> </div>
                <div class="admin-badge-meta"> <span class="admin-badge-title">MangaVault Admin</span> <span class="admin-badge-subtitle">Collector Exchange Portal</span> </div>
            </div>
            <div class="admin-nav-card">
                <ul class="admin-nav-list">
                    <li> <a href="#" class="admin-nav-item"> <span class="material-symbols-outlined">dashboard</span> <span>Dashboard Thống kê</span> </a> </li>
                    <li> <a href="${pageContext.request.contextPath}/admin/categories" class="admin-nav-item active"> <span class="material-symbols-outlined">category</span> <span>Quản lý Thể loại &amp; NXB</span> </a> </li>
                    <li> <a href="#" class="admin-nav-item"> <span class="material-symbols-outlined">menu_book</span> <span>Master Catalog</span> </a> </li>
                    <li> <a href="#" class="admin-nav-item"> <span class="material-symbols-outlined">group</span> <span>Quản lý Người dùng &amp; Collector</span> </a> </li>
                </ul>
            </div>
        </aside>

        <section class="admin-main-content">
            <div class="admin-page-header">
                <div class="admin-header-titles">
                    <h1 class="admin-page-title">Quản Lý Nhà Xuất Bản &amp; Đối Tác Bản Quyền</h1>
                    <p class="admin-page-subtitle">Quản lý hệ thống nhà xuất bản chính thống chấp thuận trong luồng định giá và giám định.</p>
                </div>
                <div class="admin-header-actions">
                    <button type="button" class="btn-export-outline"> <span class="material-symbols-outlined">download</span> <span>Xuất dữ liệu</span> </button>
                    <a href="${pageContext.request.contextPath}/admin/publishers?action=add" class="btn-add-category" style="text-decoration: none; display: inline-flex; align-items: center;">
                        <span class="material-symbols-outlined">add</span> <span>+ Thêm NXB Mới</span>
                    </a>
                </div>
            </div>

            <!-- KPI Summary Grid -->
            <div class="admin-metrics-grid">
                <div class="metric-kpi-card">
                    <div class="metric-info-col">
                        <span class="metric-kpi-label">Tổng Thể Loại</span>
                        <span class="metric-kpi-value">${totalCategories} Thể loại</span>
                    </div>
                    <div class="metric-icon-box"> <span class="material-symbols-outlined">auto_stories</span> </div>
                </div>
                <div class="metric-kpi-card">
                    <div class="metric-info-col">
                        <span class="metric-kpi-label">Danh Mục Bản Quyền NXB</span>
                        <span class="metric-kpi-value">${totalPublishers} NXB</span>
                    </div>
                    <div class="metric-icon-box green-box"> <span class="material-symbols-outlined">menu_book</span> </div>
                </div>
            </div>

            <!-- Tabs Navigation -->
            <div class="admin-toolbar-row">
                <div class="category-tabs-group">
                    <a href="${pageContext.request.contextPath}/admin/categories" class="tab-category-btn" style="text-decoration: none; display: inline-flex; align-items: center;">
                        <span class="material-symbols-outlined" style="font-size:16px;">format_list_bulleted</span>
                        <span>Thể loại truyện</span> <span class="tab-count-badge">${totalCategories}</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/publishers" class="tab-category-btn active" style="text-decoration: none; display: inline-flex; align-items: center;">
                        <span class="material-symbols-outlined" style="font-size:16px;">apartment</span>
                        <span>Nhà Xuất Bản</span> <span class="tab-count-badge">${totalPublishers}</span>
                    </a>
                    <a href="#" class="tab-category-btn" style="text-decoration: none; display: inline-flex; align-items: center;">
                        <span class="material-symbols-outlined" style="font-size:16px;">approval</span>
                        <span>Định dạng &amp; Tiêu chuẩn Slab</span> <span class="tab-count-badge">6</span>
                    </a>
                </div>
            </div>

            <!-- Bảng Dữ Liệu Nhà Xuất Bản -->
            <div class="admin-table-card">
                <div class="table-responsive-wrapper">
                    <table class="admin-data-table">
                        <thead>
                        <tr>
                            <th>MÃ NXB</th>
                            <th>TÊN NHÀ XUẤT BẢN</th>
                            <th>QUỐC GIA</th>
                            <th>NĂM THÀNH LẬP</th>
                            <th>WEBSITE</th>
                            <th class="col-status-fixed">TRẠNG THÁI</th>
                            <th>THAO TÁC</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty publishers}">
                                <c:forEach var="pub" items="${publishers}">
                                    <tr>
                                        <td> <span class="category-code-tag">${pub.publisherCode}</span> </td>
                                        <td> <span class="category-primary-title">${pub.publisherName}</span> </td>
                                        <td> <span>${not empty pub.country ? pub.country : 'N/A'}</span> </td>
                                        <td> <span>${not empty pub.foundedYear ? pub.foundedYear : 'N/A'}</span> </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty pub.website}">
                                                    <a href="${pub.website}" target="_blank" style="color: #2563eb; text-decoration: none;">${pub.website}</a>
                                                </c:when>
                                                <c:otherwise><i style="color: gray;">Chưa có</i></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="col-status-fixed">
                                            <c:choose>
                                                <c:when test="${pub.status}">
                                                    <span class="status-indicator-badge visible"> <span class="status-dot-bullet"></span> <span>Hiển thị</span> </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-indicator-badge hidden"> <span class="status-dot-bullet"></span> <span>Tạm ẩn</span> </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="action-buttons-cell">
                                                <a href="${pageContext.request.contextPath}/admin/publishers?action=edit&id=${pub.publisherId}" class="btn-row-action" title="Chỉnh sửa" style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center;">
                                                    <span class="material-symbols-outlined">edit</span>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/publishers?action=delete&id=${pub.publisherId}" class="btn-row-action" title="Xóa" onclick="return confirm('Bạn có chắc chắn muốn ẩn Nhà xuất bản này?');" style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center;">
                                                    <span class="material-symbols-outlined">delete</span>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 20px;">Chưa có Nhà xuất bản nào.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Phân trang -->
                <div class="admin-pagination-row">
                    <div class="pagination-info-text">
                        Hiển thị <strong>${startItem} – ${endItem}</strong> của <strong>${totalPublishers}</strong> Nhà xuất bản
                    </div>
                    <c:if test="${totalPages > 1}">
                        <div class="pagination-controls-group">
                            <c:if test="${currentPage > 1}">
                                <a href="${pageContext.request.contextPath}/admin/publishers?page=${currentPage - 1}" class="btn-page-nav" style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center;">
                                    <span class="material-symbols-outlined">chevron_left</span>
                                </a>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <a href="${pageContext.request.contextPath}/admin/publishers?page=${i}" class="btn-page-nav ${i == currentPage ? 'active' : ''}" style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center;">
                                        ${i}
                                </a>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <a href="${pageContext.request.contextPath}/admin/publishers?page=${currentPage + 1}" class="btn-page-nav" style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center;">
                                    <span class="material-symbols-outlined">chevron_right</span>
                                </a>
                            </c:if>
                        </div>
                    </c:if>
                </div>
            </div>
        </section>
    </div>
</main>
</body>
</html>