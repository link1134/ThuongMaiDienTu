<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người dùng - MangaVault Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,600;0,700;0,800;1,600&family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&display=swap"
          rel="stylesheet">
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/QuanLyNguoiDung.css">
</head>

<body class="site-body">
<jsp:include page="/common/header.jsp"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<main class="admin-page-container">
    <div class="admin-layout-grid">

        <aside class="admin-sidebar">
            <div class="admin-brand-badge-card">
                <div class="admin-shield-icon-box">
                    <span class="material-symbols-outlined">shield_person</span>
                </div>
                <div class="admin-badge-meta">
                    <span class="admin-badge-title">MangaVault Admin</span>
                    <span class="admin-badge-subtitle">Collector Exchange Portal</span>
                </div>
            </div>

            <div class="admin-nav-card">
                <ul class="admin-nav-list">
                    <li><a href="#" class="admin-nav-item">
                        <span class="material-symbols-outlined">dashboard</span>
                        <span>Dashboard Thống kê</span>
                    </a></li>
                    <li><a href="${ctx}/admin/categories" class="admin-nav-item">
                        <span class="material-symbols-outlined">category</span>
                        <span>Quản lý Danh mục</span>
                    </a></li>
                    <li><a href="#" class="admin-nav-item">
                        <span class="material-symbols-outlined">menu_book</span>
                        <span>Master Catalog</span>
                    </a></li>
                    <li><a href="${ctx}/admin/orderManager" class="admin-nav-item">
                        <span class="material-symbols-outlined">local_shipping</span>
                        <span>Quản lý Đơn hàng</span>
                    </a></li>
                    <li><a href="${ctx}/admin/userManager" class="admin-nav-item active">
                        <span class="material-symbols-outlined">group</span>
                        <span>Quản lý Người dùng</span>
                    </a></li>
                </ul>
            </div>

            <div class="admin-secondary-nav-card">
                <ul class="admin-nav-list">
                    <li><a href="#" class="admin-nav-item">
                        <span class="material-symbols-outlined">verified</span>
                        <span>Báo cáo kiểm toán</span>
                    </a></li>
                    <li><a href="#" class="admin-nav-item">
                        <span class="material-symbols-outlined">settings</span>
                        <span>Cài đặt hệ thống</span>
                    </a></li>
                </ul>
            </div>
        </aside>

        <section class="admin-main-content">

            <!-- Thông báo kết quả thao tác -->
            <c:if test="${not empty flashMessage}">
                <div class="admin-flash ${flashType eq 'success' ? 'is-success' : 'is-error'}" role="alert">
                    <span class="material-symbols-outlined">${flashType eq 'success' ? 'check_circle' : 'error'}</span>
                    <span><c:out value="${flashMessage}"/></span>
                </div>
            </c:if>

            <!-- Thanh Công Cụ Tìm Kiếm & Bộ Lọc -->
            <form method="get" action="${pageContext.request.contextPath}/admin/userManager"
                  class="admin-toolbar-row">
                <div class="admin-search-box">
                    <span class="material-symbols-outlined">search</span>
                    <input type="text" name="q" class="admin-search-input"
                           value="<c:out value='${keyword}'/>"
                           placeholder="Tìm tên, email hoặc username...">
                </div>

                <div class="filter-select-cluster">
                    <select name="status" class="filter-select filter-select-wide">
                        <option value="" ${empty status ? 'selected' : ''}>Tất cả trạng thái</option>
                        <option value="active" ${status eq 'active' ? 'selected' : ''}>Hoạt động</option>
                        <option value="locked" ${status eq 'locked' ? 'selected' : ''}>Đã khóa</option>
                    </select>

                    <button type="submit" class="btn-filter-submit">
                        <span class="material-symbols-outlined">filter_alt</span>
                        <span>Lọc</span>
                    </button>

                    <a href="${pageContext.request.contextPath}/admin/userManager"
                       class="btn-icon-refresh" title="Làm mới bộ lọc">
                        <span class="material-symbols-outlined">refresh</span>
                    </a>
                </div>
            </form>

            <!-- Bảng Danh Sách Tài Khoản -->
            <div class="admin-table-card">
                <div class="table-card-head">
                    <div>
                        <h2 class="table-card-title">Danh sách tài khoản</h2>
                        <p class="table-card-sub">Dữ liệu được cung cấp bởi QuanLyNguoiDungServlet.</p>
                    </div>
                    <span class="table-card-tag">
                            <span class="material-symbols-outlined">dns</span>
                            <span>Người dùng</span>
                        </span>
                </div>

                <div class="table-responsive-wrapper">
                    <table class="admin-data-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>THÔNG TIN NGƯỜI DÙNG</th>
                            <th>VAI TRÒ</th>
                            <th class="col-status-fixed">TRẠNG THÁI</th>
                            <th>NGÀY ĐĂNG KÝ</th>
                            <th class="col-actions-head">THAO TÁC</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="u" items="${users}">
                            <c:set var="isAdminRow" value="${u.role eq 'Admin'}"/>
                            <c:set var="isSelf" value="${u.id == currentUserId}"/>
                            <c:set var="displayName" value="${empty u.fullName ? u.username : u.fullName}"/>
                            <tr>
                                <td><span class="collector-id-code">#${u.id}</span></td>
                                <td>
                                    <div class="user-identity-cell">
                                        <div class="user-avatar-frame">
                                            <div class="avatar-person-circle">
                                                <span class="material-symbols-outlined">person</span>
                                            </div>
                                        </div>
                                        <div class="user-name-meta">
                                            <div class="user-fullname-row">
                                                <span class="user-fullname"><c:out value="${displayName}"/></span>
                                            </div>
                                            <span class="user-email-text"><c:out value="${u.email}"/></span>
                                            <span class="user-handle-text">@<c:out value="${u.username}"/></span>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${isAdminRow}">
                                                    <span class="role-badge admin">
                                                        <span class="material-symbols-outlined">shield</span>
                                                        <span>Quản trị</span>
                                                    </span>
                                        </c:when>
                                        <c:when test="${u.seller}">
                                                    <span class="role-badge seller">
                                                        <span class="material-symbols-outlined">storefront</span>
                                                        <span>Người bán</span>
                                                    </span>
                                        </c:when>
                                        <c:otherwise>
                                                    <span class="role-badge buyer">
                                                        <span class="material-symbols-outlined">person</span>
                                                        <span>Người mua</span>
                                                    </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="col-status-fixed">
                                    <c:choose>
                                        <c:when test="${u.enabled}">
                                                    <span class="status-indicator-badge active">
                                                        <span class="status-dot-bullet"></span>
                                                        <span>Hoạt động</span>
                                                    </span>
                                        </c:when>
                                        <c:otherwise>
                                                    <span class="status-indicator-badge locked">
                                                        <span class="status-dot-bullet"></span>
                                                        <span>Đã khóa</span>
                                                    </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                            <span class="user-date-text"><fmt:formatDate value="${u.createdAt}"
                                                                                         pattern="yyyy-MM-dd'T'HH:mm:ss"/></span>
                                </td>
                                <td>
                                    <div class="action-buttons-cell">
                                        <c:if test="${not isAdminRow}">
                                            <button type="button"
                                                    class="btn-icon-action ${u.enabled ? 'lock' : 'unlock'} js-row-action"
                                                    title="${u.enabled ? 'Khóa tài khoản' : 'Mở khóa tài khoản'}"
                                                    data-action="toggleLock"
                                                    data-id="${u.id}"
                                                    data-confirm="${u.enabled ? 'Khóa' : 'Mở khóa'} tài khoản @<c:out value='${u.username}'/>?">
                                                <span class="material-symbols-outlined">${u.enabled ? 'lock' : 'lock_open'}</span>
                                            </button>

                                            <button type="button" class="btn-icon-action delete js-row-action"
                                                    title="Xóa tài khoản"
                                                    data-action="delete"
                                                    data-id="${u.id}"
                                                    data-confirm="Xóa vĩnh viễn tài khoản @<c:out value='${u.username}'/>? Hành động này không thể hoàn tác.">
                                                <span class="material-symbols-outlined">delete</span>
                                            </button>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty users}">
                            <tr>
                                <td colspan="6" class="table-empty-cell">
                                    Không tìm thấy tài khoản nào phù hợp.
                                </td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- Dải Phân Trang -->
                <c:url var="pageBase" value="/admin/userManager">
                    <c:param name="q" value="${keyword}"/>
                    <c:param name="status" value="${status}"/>
                </c:url>
                <div class="admin-pagination-row">
                    <div class="pagination-info-text">
                        Hiển thị <strong>${fromIndex} – ${toIndex}</strong> trên tổng số
                        <strong>${totalUsers}</strong> tài khoản
                    </div>
                    <c:if test="${totalPages > 1}">
                        <div class="pagination-controls-group">
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a class="btn-page-nav" title="Trang trước"
                                       href="${pageBase}&amp;page=${currentPage - 1}">
                                        <span class="material-symbols-outlined">chevron_left</span>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                        <span class="btn-page-nav is-disabled">
                                            <span class="material-symbols-outlined">chevron_left</span>
                                        </span>
                                </c:otherwise>
                            </c:choose>

                            <c:forEach var="p" begin="${startPage}" end="${endPage}">
                                <a class="btn-page-nav ${p == currentPage ? 'active' : ''}"
                                   href="${pageBase}&amp;page=${p}">${p}</a>
                            </c:forEach>

                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a class="btn-page-nav" title="Trang sau"
                                       href="${pageBase}&amp;page=${currentPage + 1}">
                                        <span class="material-symbols-outlined">chevron_right</span>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                        <span class="btn-page-nav is-disabled">
                                            <span class="material-symbols-outlined">chevron_right</span>
                                        </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Form ẩn dùng chung cho khóa / mở khóa / xóa -->
            <form id="rowActionForm" method="post"
                  action="${pageContext.request.contextPath}/admin/userManager" hidden>
                <input type="hidden" name="action" id="rowActionName">
                <input type="hidden" name="id" id="rowActionId">
                <input type="hidden" name="q" value="<c:out value='${keyword}'/>">
                <input type="hidden" name="status" value="<c:out value='${status}'/>">
                <input type="hidden" name="page" value="${currentPage}">
            </form>

            <script>
                (function () {
                    // Khóa / mở khóa / xóa: xác nhận rồi gửi form ẩn
                    var actionForm = document.getElementById('rowActionForm');
                    document.querySelectorAll('.js-row-action').forEach(function (btn) {
                        btn.addEventListener('click', function () {
                            if (!window.confirm(btn.dataset.confirm)) return;
                            document.getElementById('rowActionName').value = btn.dataset.action;
                            document.getElementById('rowActionId').value = btn.dataset.id;
                            actionForm.submit();
                        });
                    });
                })();
            </script>

        </section>
    </div>
</main>
</body>

</html>
