<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.mangaz.model.User" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ &amp; Thông tin người mua - MangaVault</title>
    <!-- Google Fonts: Plus Jakarta Sans & Playfair Display -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link
            href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,600;0,700;0,800;1,600&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
            rel="stylesheet"> <!-- Google Material Symbols Outlined -->
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"/>
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ThongTinCaNhan.css"/>
</head>

<body data-context-path="${pageContext.request.contextPath}" class="site-body">
<!-- ==================== HEADER ==================== -->
<jsp:include page="/common/header.jsp"/>
<main class="main-page-container"> <!-- Breadcrumb -->
    <nav class="breadcrumb-nav"><a href="#">Trang chủ</a> <span class="bc-sep">/</span> <a href="#">Tài khoản</a>
        <span class="bc-sep">/</span> <span class="bc-current">Thông tin cá nhân</span>
    </nav>
    <!-- Page Title & Status -->
    <div class="page-header-row">
        <div>
            <div class="section-tag"><span class="square-accent"></span> COLLECTOR DOSSIER</div>
            <h1 class="page-title">Thông tin cá nhân</h1>
            <p class="page-subtitle">Quản lý thông tin tài khoản, đơn hàng sưu tập và tùy chọn ấn bản nghệ thuật của
                bạn.</p>
        </div>
        <!-- <div class="sync-status-badge"> <span class="sync-dot"></span> <span>Lưu trữ đồng bộ: 12 phút trước</span> -->
    </div>
    <div class="profile-layout-grid">
        <aside class="sidebar-column"> <!-- Profile Card -->
            <div class="card-panel profile-identity-card">
                <div class="avatar-header-row">
                    <div class="avatar-wrapper">
                        <c:choose>
                            <c:when test="${not empty profile.avatarUrl}">
                                <img src="<c:out value='${profile.avatarUrl}'/>"
                                     alt="Ảnh đại diện"
                                     class="collector-avatar">
                            </c:when>
                            <c:otherwise>
                                <img src="https://lh3.googleusercontent.com/aida-public/AB6AXuCbxKavvR8kUjvRe_85K1vxKIgd4X86LdgGPiu_SkKlzkmzcXB4fOx5vrolj97DVgsrVm_dhA8v6P6lAQuJ8Bv5vzRoWp-_TxJf8PfMNH8oSc5G9qJgn3zgFD0JadKnt0pMIrdWesa3Jm1sN2yr0ah2CIcSApzWEURl1teMgwpWL98wV54jA0VIgIcvQmp2JOFx0ERJdQPpxjIMDNWNBMhoP0z7vOmmxUGgsYkywIM"
                                     alt="Ảnh đại diện mặc định"
                                     class="collector-avatar">
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="collector-info-brief">
                        <h2 class="collector-name">
                            <c:out value="${profile.fullName}" default="Chưa cập nhật họ tên"/>
                        </h2>

                        <span class="collector-email-abbr">
                            <c:out value="${profile.email}"/>
                        </span>
                    </div>
                </div>
                <div class="profile-actions-dual">
                    <button class="btn-outline-action" type="button">Đổi ảnh đại diện</button>
                </div>
            </div> <!-- Navigation Menu -->
            <div class="card-panel sidebar-nav-card">
                <div class="sidebar-section-heading">MỤC LỤC QUẢN LÝ</div>
                <nav class="sidebar-nav-list">
                    <a href="#ordersSection" class="sidebar-nav-item"
                       data-section="orders">
                        <div class="nav-left-meta">
                            <span class="material-symbols-outlined">inventory_2</span>
                            <span>Đơn hàng</span>
                        </div>
                        <span class="count-pill"><fmt:formatNumber value="${totalOrdersCount}" pattern="00"/> mục</span>
                    </a>

                    <a href="#addressSection" class="sidebar-nav-item"
                       data-section="address">
                        <div class="nav-left-meta"><span class="material-symbols-outlined">local_shipping</span>
                            <span>Địa chỉ giao nhận</span>
                        </div>
                        <span class="count-pill"><fmt:formatNumber value="${addressNumbers}" pattern="00"/> địa chỉ</span>
                    </a>
                    <a href="#followListSection" class="sidebar-nav-item"
                       data-section="followList">
                        <div class="nav-left-meta"><span class="material-symbols-outlined">bookmark</span> <span>Dach sách theo dõi</span>
                        </div>
                        <span class="count-pill">${favoriteCount} quyển</span>
                    </a>
                    <%--                    <a href="#" class="sidebar-nav-item">--%>
                    <%--                        <div class="nav-left-meta"><span class="material-symbols-outlined">security</span>--%>
                    <%--                            <span>Cài đặt &amp; Bảo mật</span>--%>
                    <%--                        </div>--%>
                    <%--                        <span class="material-symbols-outlined chevron-icon">chevron_right</span>--%>
                    <%--                    </a>--%>
                    <a href="#profileSection" class="sidebar-nav-item"
                       data-section="settings">
                        <div class="nav-left-meta">
                            <span class="material-symbols-outlined">settings</span>
                            <span>Cài đặt tài khoản</span>
                        </div>

                    </a>
                </nav>
            </div> <!-- Certified Badge Card -->
            <!-- <div class="card-panel certified-badge-card">
                <div class="cert-icon-container"> <span
                        class="material-symbols-outlined cert-icon">verified_user</span> </div>
                <div>
                    <div class="cert-title">CHỨNG NHẬN HẠNG S</div>
                    <div class="cert-subtitle">Verified Collector Dossier</div>
                    <p class="cert-desc">Tài khoản đã ký quỹ đảm bảo và hoàn tất thẩm định chữ ký số cá nhân cho các
                        giao dịch ấn bản gốc.</p>
                </div>
            </div> -->
        </aside> <!-- RIGHT COLUMN -->
        <section class="main-content-column"> <!-- 1. Order Logistics Status -->
            <div class="orders-section" id="ordersSection">
                <div class="card-panel management-section">
                    <div class="card-head-row">
                        <div>
                            <h2 class="card-main-title">Đơn hàng của tôi</h2>
                        </div>
                    </div>
                    <div class="order-metrics-grid">
                        <div class="metric-card active"data-status="ALL" style="cursor: pointer;">
                            <div class="metric-top"><span class="material-symbols-outlined metric-icon ">
                            shopping_cart
                        </span>
                                <span class="metric-number"><fmt:formatNumber value="${totalOrdersCount}" pattern="00"/></span>
                            </div>
                            <div class="metric-label">TẤT CẢ ĐƠN HÀNG</div>
                        </div>
                        <div class="metric-card"data-status="Pending" style="cursor: pointer;">
                            <div class="metric-top"><span class="material-symbols-outlined metric-icon">wallet</span>
                                <span class="metric-number"><fmt:formatNumber value="${pendingCount}" pattern="00"/></span>
                            </div>
                            <div class="metric-label">CHỜ XỬ LÝ</div>

                        </div>
                        <div class="metric-card"data-status="Processing" style="cursor: pointer;">
                            <div class="metric-top"> <span
                                    class="material-symbols-outlined metric-icon">inventory</span> <span
                                    class="metric-number"><fmt:formatNumber value="${processingCount}" pattern="00"/></span></div>
                            <div class="metric-label">ĐANG XỬ LÝ</div>

                        </div>
                        <div class="metric-card"data-status="Shipping" style="cursor: pointer;">
                            <div class="metric-top"> <span
                                    class="material-symbols-outlined metric-icon">local_shipping</span> <span
                                    class="metric-number"><fmt:formatNumber value="${shippingCount}" pattern="00"/></span></div>
                            <div class="metric-label">ĐANG GIAO</div>

                        </div>
                        <div class="metric-card"data-status="Completed" style="cursor: pointer;">
                            <div class="metric-top"> <span
                                    class="material-symbols-outlined metric-icon check-icon">check_circle</span> <span
                                    class="metric-number"><fmt:formatNumber value="${completedCount}" pattern="00"/></span></div>
                            <div class="metric-label">ĐÃ GIAO</div>

                        </div>
                        <div class="metric-card"data-status="Cancelled" style="cursor: pointer;">
                            <div class="metric-top"><span class="material-symbols-outlined metric-icon">cancel</span>
                                <span class="metric-number"><fmt:formatNumber value="${cancelledCount}" pattern="00"/></span>
                            </div>
                            <div class="metric-label">ĐÃ HỦY</div>

                        </div>
                    </div>
                </div>
                <div class="order-list">
                    <!-- Trạng thái đơn hàng -->
                    <!-- DANH SÁCH ĐƠN HÀNG ĐỘNG -->
                    <c:choose>
                        <c:when test="${empty orders}">
                            <div class="card-panel" style="text-align: center; padding: 40px; color: #666; margin-top: 15px;">
                                <span class="material-symbols-outlined" style="font-size: 48px; color: #ccc;">receipt_long</span>
                                <p style="margin-top: 10px;">Bạn chưa có đơn hàng nào.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="order" items="${orders}">
                                <div class="order-card"data-status="${order.status}">
                                    <!-- Trạng thái đơn hàng -->
                                    <div class="order-status">
                                        <c:choose>
                                            <c:when test="${order.status eq 'Completed'}">
                                                <span class="material-symbols-outlined" style="color: #10b981;">check_circle</span>
                                                <span>Giao hàng thành công</span>
                                            </c:when>
                                            <c:when test="${order.status eq 'Shipping'}">
                                                <span class="material-symbols-outlined" style="color: #3b82f6;">local_shipping</span>
                                                <span>Đang giao hàng</span>
                                            </c:when>
                                            <c:when test="${order.status eq 'Processing'}">
                                                <span class="material-symbols-outlined metric-icon" style="color: #b45309">inventory</span>
                                                <span>Đang xử lý</span>
                                            </c:when>
                                            <c:when test="${order.status eq 'Cancelled'}">
                                                <span class="material-symbols-outlined" style="color: #ef4444;">cancel</span>
                                                <span>Đã hủy</span>
                                            </c:when>
                                            <c:when test="${order.status eq 'Pending'}">
                                                <span class="material-symbols-outlined metric-icon" style="color: #7c3aed">
                                                    inventory
                                                </span>
                                                <span>Chờ xử lý</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="material-symbols-outlined metric-icon" style="color: #7c3aed">wallet</span>
                                                <span>Chờ thanh toán</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="payment-status">
                                        <c:choose>
                                            <c:when test="${order.paymentStatus eq 'Paid'}">
                                                <span>Đã thanh toán</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span>Chưa thanh toán</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Danh sách sản phẩm trong đơn -->
                                    <c:forEach var="detail" items="${order.details}">
                                        <div class="order-product">
                                            <div class="order-product-image">
                                                <img src="${pageContext.request.contextPath}${detail.productImageUrl}"
                                                     alt="<c:out value='${detail.productTitle}'/>"
                                                     onerror="this.src='https://picsum.photos/200/300'">
                                                <span class="order-product-quantity">x${detail.quantity}</span>
                                            </div>

                                            <div class="order-product-info">
                                                <div class="order-product-name">
                                                    <c:out value="${detail.productTitle}"/>
                                                </div>
                                                <div class="order-seller-name">
                                                    <c:out value="${detail.sellerName}" default="MangaVault Seller"/>
                                                </div>
                                            </div>

                                            <div class="order-product-price">
                                                <fmt:formatNumber value="${detail.price}" pattern="#,##0"/> ₫
                                            </div>
                                        </div>
                                    </c:forEach>
                                    <!-- Tổng tiền và nút thao tác -->
                                    <div class="order-footer">
                                        <div class="order-total">
                                            <span>Mã đơn #${order.orderId} - Tổng tiền:</span>
                                            <strong><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0"/> ₫</strong>
                                        </div>

                                        <div class="order-actions">
                                            <!-- Trạng thái yêu cầu hủy đơn -->
                                            <c:if test="${order.cancellationRequestStatus eq 'Pending'}">
                                                <span style="color: #d97706; font-weight: 600;">
                                                    Đang chờ duyệt yêu cầu hủy
                                                </span>
                                            </c:if>
                                            <c:if test="${order.cancellationRequestStatus eq 'Rejected'}">
                                                <span style="color: #dc2626; font-weight: 600;">
                                                    Yêu cầu hủy đã bị từ chối
                                                </span>
                                            </c:if>
                                            <c:if test="${not empty order.details}">
                                                <a href="${pageContext.request.contextPath}/product-detail?id=${order.details[0].listingId}" class="btn-order btn-buy-again" style="text-decoration:none; text-align:center;">
                                                    Mua lại
                                                </a>
                                            </c:if>
                                            <button type="button" class="btn-order btn-order-detail">
                                                Xem chi tiết
                                            </button>
                                            <c:if test="${(order.status eq 'Pending' || order.status eq 'Processing')
                                                            && order.cancellationRequestStatus ne 'Pending'}">
                                                <button type="button"
                                                        class="btn-order btn-cancel-order"
                                                        data-order-id="${order.orderId}">
                                                    Yêu cầu hủy đơn
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    <!-- Thông báo khi lọc không có đơn nào -->
                    <div id="empty-filter-notice" class="card-panel" style="display: none; text-align: center; padding: 40px; color: #666; margin-top: 15px;">
                        <span class="material-symbols-outlined" style="font-size: 48px; color: #ccc;">search_off</span>
                        <p style="margin-top: 10px;">Không tìm thấy đơn hàng nào ở trạng thái này.</p>
                    </div>
                </div>

            </div>
            <!-- 2. Personal Information Dossier -->
            <div class="card-panel management-section" id="profileSection">
                <div class="card-head-row">
                    <div>

                        <h2 class="card-main-title">Thông tin cá nhân</h2>
                    </div>

                </div>

                <div class="profile-info-fields-grid">
                    <!-- Họ và tên -->
                    <div class="info-field-box editable-field " data-field="fullName">
                        <div class="field-label-row">
                            <span class="field-label">HỌ VÀ TÊN</span>
                            <button class="material-symbols-outlined field-action-icon edit-trigger">edit</button>
                            <div class="group-action-icon" style="display: none">
                                <button class="material-symbols-outlined field-action-icon save-trigger"
                                        style="color: green">check
                                </button>
                                <button class="material-symbols-outlined field-action-icon cancel-trigger"
                                        style="color: red">close
                                </button>
                            </div>

                        </div>
                        <div class="field-value">
                            <c:out value="${profile.fullName}" default="Chưa cập nhật"/>
                        </div>
                    </div>

                    <!-- Gmail -->
                    <div class="info-field-box">
                        <div class="field-label-row">
                            <span class="field-label">GMAIL</span>
                            <button class="material-symbols-outlined field-action-icon ">edit</button>
                            <div class="group-action-icon" style="display: none">
                                <button class="material-symbols-outlined field-action-icon" style="color: green">check
                                </button>
                                <button class="material-symbols-outlined field-action-icon" style="color: red">close
                                </button>
                            </div>
                        </div>
                        <div class="field-value-row">
                <span class="field-value">
                    <c:out value="${profile.email}"/>
                </span>
                            <c:if test="${profile.emailVerified}">
                    <span class="verified-pill">
                        <span class="material-symbols-outlined">check</span>
                        <span>ĐÃ XÁC MINH</span>
                    </span>
                            </c:if>
                        </div>
                    </div>

                    <!-- Số điện thoại -->
                    <div class="info-field-box">
                        <div class="field-label-row">
                            <span class="field-label">SỐ ĐIỆN THOẠI LIÊN HỆ</span>
                            <button class="material-symbols-outlined field-action-icon">edit</button>
                            <div class="group-action-icon" style="display: none">
                                <button class="material-symbols-outlined field-action-icon" style="color: green">check
                                </button>
                                <button class="material-symbols-outlined field-action-icon" style="color: red">close
                                </button>
                            </div>
                        </div>
                        <div class="field-value">
                            <c:out value="${profile.phoneNumber}" default="Chưa cập nhật"/>
                        </div>
                    </div>

                    <!-- Ngày sinh -->
                    <div class="info-field-box editable-field date-field" data-field="dateOfBirth">
                        <div class="field-label-row">
                            <span class="field-label">NGÀY SINH</span>
                            <button class="material-symbols-outlined field-action-icon edit-trigger">edit</button>
                            <div class="group-action-icon" style="display: none">
                                <button class="material-symbols-outlined field-action-icon save-trigger"
                                        style="color: green">check
                                </button>
                                <button class="material-symbols-outlined field-action-icon cancel-trigger"
                                        style="color: red">close
                                </button>
                            </div>
                        </div>
                        <div class="field-value">
                            <c:choose>
                                <c:when test="${not empty profile.dateOfBirth}">
                                    <fmt:formatDate value="${profile.dateOfBirth}"
                                                    pattern="dd / MM / yyyy"/>
                                </c:when>
                                <c:otherwise>Chưa cập nhật</c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Giới tính -->
                    <div class="info-field-box editable-field gender-field" data-field="gender">
                        <div class="field-label-row">
                            <span class="field-label">GIỚI TÍNH</span>

                            <button type="button"
                                    class="material-symbols-outlined field-action-icon edit-trigger">
                                edit
                            </button>

                            <div class="group-action-icon" style="display: none">
                                <button type="button"
                                        class="material-symbols-outlined field-action-icon save-trigger"
                                        style="color: green">
                                    check
                                </button>

                                <button type="button"
                                        class="material-symbols-outlined field-action-icon cancel-trigger"
                                        style="color: red">
                                    close
                                </button>
                            </div>
                        </div>

                        <div class="gender-options" style="display: none">
                            <button type="button" class="gender-btn" data-gender="Nam">
                                Nam
                            </button>

                            <button type="button" class="gender-btn" data-gender="Nữ">
                                Nữ
                            </button>

                            <input type="text"
                                   class="gender-other"
                                   placeholder="Hoặc nhập giới tính khác">
                        </div>

                        <div class="field-value"
                             data-value="${profile.dateOfBirth}">
                            <c:out value="${profile.gender}" default="Chưa cập nhật"/>
                        </div>
                    </div>


                    <!-- Ngày gia nhập -->
                    <div class="info-field-box">
                        <div class="field-label-row">
                            <span class="field-label">NGÀY GIA NHẬP</span>
                        </div>
                        <div class="field-value">
                            <fmt:formatDate value="${profile.createdAt}"
                                            pattern="dd 'Tháng' MM, yyyy"/>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-panel management-section" id="addressSection">
                <div class="card-head-row">
                    <div>
                        <h2 class="card-main-title">Địa chỉ giao hàng</h2>
                    </div>

                </div>

                <div class="address-list">

                    <!-- Khu vực được tải lại bằng fetch -->
                    <div class="addressItems" id="addressItems">
                        <!-- Các địa chỉ sẽ được Servlet trả về tại đây -->
                    </div>

                    <!-- Giữ nút thêm địa chỉ ở bên ngoài -->
                    <div class="add-address-row">
                        <button class="btn-outline-rounded"
                                type="button"
                                id="addAddressBtn">
                            <span class="material-symbols-outlined">add</span>
                            <span>Thêm địa chỉ mới</span>
                        </button>
                    </div>

                </div>

            </div>
            <!-- 4. Favorite Products -->
            <div class="card-panel management-section" id="followListSection">
                <div class="card-head-row">
                    <div>
                        <h2 class="card-main-title">Sản phẩm yêu thích</h2>
                        <p class="book-author">
                            Các sản phẩm bạn đã lưu vào danh sách yêu thích.
                        </p>
                    </div>

                    <span class="card-link-action">
                    <span id="favoriteCount">${favoriteCount} sản phẩm</span>
                    </span>
                </div>

                <div class="bookshelf-grid" id="favoriteProductsGrid">

                    <c:choose>
                        <%-- Có sản phẩm yêu thích --%>
                        <c:when test="${not empty favorites}">

                            <c:forEach var="item" items="${favorites}">
                                <div class="manga-shelf-item" data-listing-id="${item.listingId}">

                                    <div class="book-cover-frame">

                                        <c:choose>
                                            <c:when test="${not empty item.imageUrl}">
                                                <img src="${item.imageUrl}"
                                                     alt="${fn:escapeXml(item.title)}"
                                                     class="book-cover-img">
                                            </c:when>

                                            <c:otherwise>
                                                <div class="favorite-no-image">
                                                    <span class="material-symbols-outlined">image</span>
                                                    <span>Chưa có hình ảnh</span>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>

                                        <button class="book-bookmark-btn remove-favorite-btn"
                                                type="button"
                                                data-listing-id="${item.listingId}"
                                                title="Bỏ yêu thích">
                                        <span class="material-symbols-outlined">favorite</span>
                                        </button>
                                    </div>

                                    <h3 class="book-title"
                                        title="${fn:escapeXml(item.title)}">
                                        <c:out value="${item.title}"/>
                                    </h3>

                                    <p class="book-author"><c:out value="${item.productTypeName}"/></p>

                                    <div class="book-price-meta">
                                        <span class="book-price">
                                            <fmt:formatNumber value="${item.price}"
                                                              type="number"
                                                              groupingUsed="true"/> đ
                                        </span>
                                        <span class="book-format-tag">
                                            <c:out value="${item.listingType}"/>
                                        </span>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>

                        <%-- Chưa có sản phẩm yêu thích --%>
                        <c:otherwise>
                            <div class="favorite-empty">
                                <span class="material-symbols-outlined">
                                    favorite_border
                                </span>

                                <h3>Chưa có sản phẩm yêu thích</h3>

                                <p>
                                    Hãy khám phá MangaZ và lưu những sản phẩm
                                    bạn quan tâm nhé!
                                </p>
                            </div>
                        </c:otherwise>
                    </c:choose>

                </div>
            </div>
            <!-- 5. Account Settings -->
            <div class="card-panel management-section" id="settingsSection">
                <div class="card-head-row">
                    <div><span class="eyebrow-text">TÙY CHỌN HỆ THỐNG</span>
                        <h2 class="card-main-title">Cài đặt tài khoản</h2>
                    </div>
                </div>
                <div class="settings-list-group">
                    <!-- <div class="setting-item-row">
                        <div class="setting-left">
                            <div class="setting-icon-box"> <span
                                    class="material-symbols-outlined">notifications</span> </div>
                            <div>
                                <div class="setting-name">Thông báo &amp; Bản tin xuất bản</div>
                                <div class="setting-desc">Cập nhật phát hành sách mới, tin tức giám định đơn hàng
                                </div>
                            </div>
                        </div>
                        <div class="setting-right"> <span class="setting-val-text">Bật qua Email &amp; SMS</span>
                            <span class="material-symbols-outlined setting-arrow">chevron_right</span>
                        </div>
                    </div> -->
                    <div class="setting-item-row">
                        <div class="setting-left">
                            <div class="setting-icon-box"> <span
                                    class="material-symbols-outlined">credit_card</span></div>
                            <div>
                                <div class="setting-name">Phương thức thanh toán</div>
                                <div class="setting-desc">Quản lý thẻ tín dụng, tài khoản bảo lãnh thanh toán</div>
                            </div>
                        </div>
                        <div class="setting-right"> <span class="setting-val-text">Visa **** 8829 &bull; Apple
                                    Pay</span> <span
                                class="material-symbols-outlined setting-arrow">chevron_right</span></div>
                    </div>
                    <!-- <div class="setting-item-row">
                        <div class="setting-left">
                            <div class="setting-icon-box"> <span class="material-symbols-outlined">security</span>
                            </div>
                            <div>
                                <div class="setting-name">Bảo mật tài khoản</div>
                                <div class="setting-desc">Bảo vệ phiên lưu trữ và giao dịch chữ ký số</div>
                            </div>
                        </div>
                        <div class="setting-right"> <span class="status-badge-green">2FA: Đang bật</span> <span
                                class="material-symbols-outlined setting-arrow">chevron_right</span> </div>
                    </div> -->

                    <div class="setting-item-row password-toggle-row"
                         id="passwordToggle"
                         role="button"
                         tabindex="0"
                         aria-expanded="false"
                         aria-controls="passwordChangeForm">

                        <div class="setting-left">
                            <div class="setting-icon-box">
                                <span class="material-symbols-outlined">key</span>
                            </div>

                            <div>
                                <div class="setting-name">Đổi mật khẩu</div>
                                <div class="setting-desc">
                                    Khuyến nghị đổi mật khẩu mỗi 180 ngày
                                </div>
                            </div>
                        </div>

                        <div class="setting-right">
        <span class="material-symbols-outlined setting-arrow"
              id="passwordToggleIcon">keyboard_arrow_down</span>
                        </div>
                    </div>

                    <!-- Form đổi mật khẩu xổ xuống -->
                    <div class="password-change-form" id="passwordChangeForm" hidden>
                        <form id="changePasswordForm" data-url="${pageContext.request.contextPath}/change-password">

                            <div class="password-field">
                                <label for="currentPassword">Mật khẩu hiện tại</label>
                                <input type="password"
                                       id="currentPassword"
                                       name="currentPassword"
                                       placeholder="Nhập mật khẩu hiện tại"
                                       autocomplete="current-password"
                                       required>
                            </div>

                            <div class="password-field">
                                <label for="newPassword">Mật khẩu mới</label>
                                <input type="password"
                                       id="newPassword"
                                       name="newPassword"
                                       placeholder="Nhập mật khẩu mới"
                                       autocomplete="new-password"
                                       required>
                            </div>

                            <div class="password-field">
                                <label for="confirmPassword">Nhập lại mật khẩu mới</label>
                                <input type="password"
                                       id="confirmPassword"
                                       name="confirmPassword"
                                       placeholder="Nhập lại mật khẩu mới"
                                       autocomplete="new-password"
                                       required>
                            </div>

                            <button type="submit" class="password-save-btn">
                                <span class="material-symbols-outlined">save</span>
                                <span>Lưu mật khẩu</span>
                            </button>

                        </form>
                    </div>

                    <!-- <div class="setting-item-row">
                        <div class="setting-left">
                            <div class="setting-icon-box"> <span class="material-symbols-outlined">language</span>
                            </div>
                            <div>
                                <div class="setting-name">Ngôn ngữ &amp; Tiền tệ hiển thị</div>
                                <div class="setting-desc">Khu vực phân phối và biểu giá niêm yết</div>
                            </div>
                        </div>
                        <div class="setting-right"> <span class="setting-val-text">Tiếng Việt &mdash; VND (đ)</span>
                            <span class="material-symbols-outlined setting-arrow">chevron_right</span>
                        </div>
                    </div> -->
                </div>
            </div> <!-- Footer Sign-out Bar -->
            <div class="session-footer-row">
                <div class="session-id-tag">ID Phiên: <strong>SS-ARC-99481-VN</strong></div>
                <button
                        class="btn-logout" type="button"
                        onclick="window.location.href='${pageContext.request.contextPath}/logout'"><span
                        class="material-symbols-outlined">logout</span>
                    <span>Đăng xuất tài khoản</span></button>
            </div>
        </section>
    </div>
    </div>
</main> <!-- ==================== FOOTER ==================== -->

<!-- Popup yêu cầu hủy đơn hàng -->
<dialog id="cancelOrderDialog"
        style="width: min(500px, calc(100% - 32px));
               border: none;
               border-radius: 14px;
               padding: 24px;
               box-shadow: 0 10px 40px rgba(0,0,0,0.2);">

    <h2 style="margin-top: 0;">Yêu cầu hủy đơn hàng</h2>

    <p style="color: #666; font-size: 14px;">
        Vui lòng cho chúng tôi biết lý do bạn muốn hủy đơn hàng.
        Yêu cầu sẽ được gửi đến Admin để xem xét.
    </p>

    <form id="cancelOrderForm">

        <input type="hidden"
               id="cancelOrderId"
               name="orderId">

        <label for="cancelReason"
               style="display: block;
                      margin-bottom: 8px;
                      font-weight: 600;">
            Lý do hủy đơn hàng
        </label>

        <textarea id="cancelReason"
                  name="reason"
                  rows="5"
                  maxlength="500"
                  required
                  placeholder="Nhập lý do bạn muốn hủy đơn hàng..."
                  style="width: 100%;
                         box-sizing: border-box;
                         padding: 12px;
                         border: 1px solid #ddd;
                         border-radius: 8px;
                         resize: vertical;
                         font-family: inherit;"></textarea>

        <div style="display: flex;
                    justify-content: flex-end;
                    gap: 10px;
                    margin-top: 20px;">

            <button type="button"
                    id="closeCancelOrder"
                    class="btn-order">
                Đóng
            </button>

            <button type="submit"
                    id="submitCancelOrder"
                    class="btn-order btn-cancel-order">
                Gửi yêu cầu
            </button>

        </div>

    </form>
</dialog>

<style>
    #cancelOrderDialog::backdrop {
        background: rgba(0, 0, 0, 0.5);
    }

    #cancelOrderDialog textarea:focus {
        outline: none;
        border-color: #7c3aed;
    }
</style>

<!-- Popup thêm địa chỉ giao hàng -->
<div class="address-modal-overlay" id="addressModal" hidden>
    <div class="address-modal">

        <div class="address-modal-header">
            <div>
                <h2 id="addressModalTitle">Thêm địa chỉ mới</h2>
                <p>Điền thông tin để tạo địa chỉ giao hàng của bạn.</p>
            </div>

            <button type="button"
                    class="address-modal-close"
                    id="closeAddressModal"
                    aria-label="Đóng popup">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>

        <form id="addAddressForm">
            <!-- Họ tên và số điện thoại -->
            <input type="hidden" id="addressId" name="addressId" value="">
            <div class="address-form-grid">
                <div class="address-form-field">
                    <label for="recipientName">
                        Họ tên <span class="required-mark">*</span>
                    </label>
                    <input type="text"
                           id="recipientName"
                           name="recipientName"
                           placeholder="Nhập họ và tên người nhận"
                           maxlength="100"
                           required>
                </div>
                <div class="address-form-field">
                    <label for="recipientPhone">
                        Điện thoại di động <span class="required-mark">*</span>
                    </label>
                    <input type="tel"
                           id="recipientPhone"
                           name="recipientPhone"
                           placeholder="Nhập số điện thoại"
                           maxlength="15"
                           required>
                </div>
                <!-- Tỉnh / thành phố -->
                <div class="address-form-field">
                    <label for="province">
                        Tỉnh / thành phố <span class="required-mark">*</span>
                    </label>
                    <select id="province" name="province" required>
                        <option value="" selected disabled>
                            Chọn tỉnh / thành phố
                        </option>
                    </select>
                </div>
                <!-- Quận / huyện -->
                <div class="address-form-field">
                    <label for="ward">
                        Phường / xã <span class="required-mark">*</span>
                    </label>
                    <select id="ward" name="ward" required>
                        <option value="" selected disabled>
                            Chọn phường / xã
                        </option>
                    </select>
                </div>

                <!-- Địa chỉ chi tiết -->
                <div class="address-form-field address-form-full">
                    <label for="detailAddress">
                        Địa chỉ cụ thể <span class="required-mark">*</span>
                    </label>
                    <textarea id="detailAddress"
                              name="detailAddress"
                              placeholder="Số nhà, tên đường, tòa nhà, căn hộ..."
                              rows="4"
                              maxlength="500"
                              required></textarea>
                </div>

            </div>

            <!-- Đặt làm địa chỉ mặc định -->
            <label class="address-default-option">
                <input type="checkbox" name="isDefault" id="isDefaultAddress">
                <span class="address-custom-checkbox"></span>
                <span>Đặt làm địa chỉ mặc định</span>
            </label>

            <!-- Nút thao tác -->
            <div class="address-modal-actions">
                <button type="button"
                        class="address-cancel-btn"
                        id="cancelAddressBtn">
                    Hủy bỏ
                </button>

                <button type="submit" class="address-confirm-btn">
                    <span class="material-symbols-outlined">check</span>
                    <span>Xác nhận</span>
                </button>
            </div>

        </form>
    </div>
</div>
<!-- Kết thúc popup thêm địa chỉ -->

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

</footer>

<script src="${pageContext.request.contextPath}/js/ThongTinCaNhan.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const metricCards = document.querySelectorAll(".metric-card[data-status]");
        const orderCards = document.querySelectorAll(".order-card[data-status]");
        const emptyNotice = document.getElementById("empty-filter-notice");

        metricCards.forEach(card => {
            card.addEventListener("click", function () {
                const selectedStatus = this.getAttribute("data-status");

                // 1. Đổi active viền/màu cho thẻ vừa chọn
                metricCards.forEach(c => c.classList.remove("active"));
                this.classList.add("active");

                // 2. Lọc danh sách đơn hàng
                let visibleCount = 0;
                orderCards.forEach(order => {
                    const orderStatus = order.getAttribute("data-status");

                    if (selectedStatus === "ALL" || orderStatus.toLowerCase() === selectedStatus.toLowerCase()) {
                        order.style.display = "block";
                        visibleCount++;
                    } else {
                        order.style.display = "none";
                    }
                });

                // 3. Hiển thị thông báo rỗng nếu trạng thái đó chưa có đơn hàng nào
                if (emptyNotice) {
                    if (visibleCount === 0 && orderCards.length > 0) {
                        emptyNotice.style.display = "block";
                    } else {
                        emptyNotice.style.display = "none";
                    }
                }
            });
        });
    });
</script>
<script>
    const contextPath = '${pageContext.request.contextPath}';
</script>
<script>
    // Xử lý nút bỏ yêu thích
    document.addEventListener("DOMContentLoaded", function () {

        const favoriteGrid = document.getElementById("favoriteProductsGrid");

        if (!favoriteGrid) {
            return;
        }

        favoriteGrid.addEventListener("click", function (event) {

            const button = event.target.closest(".remove-favorite-btn");

            if (!button) {
                return;
            }

            const listingId = button.dataset.listingId;

            if (!listingId) {
                return;
            }

            // Tránh người dùng nhấn nhiều lần
            button.disabled = true;

            fetch(contextPath + "/favorite/toggle", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: "listingId=" + encodeURIComponent(listingId)
            })
                .then(response => {
                    if (response.status === 401) {
                        throw new Error("Vui lòng đăng nhập để thực hiện thao tác này.");
                    }

                    if (!response.ok) {
                        throw new Error("Không thể cập nhật danh sách yêu thích.");
                    }

                    return response.json();
                })
                .then(result => {

                    if (!result.success) {
                        throw new Error(result.message || "Có lỗi xảy ra.");
                    }

                    // Chỉ xóa khỏi giao diện khi sản phẩm đã được bỏ yêu thích
                    if (!result.isFavorite) {

                        const productItem = button.closest(".manga-shelf-item");

                        if (productItem) {
                            productItem.remove();
                        }

                        // Cập nhật số lượng yêu thích
                        updateFavoriteCount(result.favoriteCount);

                        // Nếu không còn sản phẩm nào, hiển thị thông báo trống
                        if (!favoriteGrid.querySelector(".manga-shelf-item")) {
                            favoriteGrid.innerHTML = `
                            <div class="favorite-empty">
                                <span class="material-symbols-outlined">
                                    favorite_border
                                </span>

                                <h3>Chưa có sản phẩm yêu thích</h3>

                                <p>
                                    Hãy khám phá MangaZ và lưu những sản phẩm
                                    bạn quan tâm nhé!
                                </p>
                            </div>
                        `;
                        }
                    }
                })
                .catch(error => {
                    alert(error.message);
                })
                .finally(() => {
                    button.disabled = false;
                });
        });
    });


    // Cập nhật số lượng sản phẩm yêu thích
    function updateFavoriteCount(count) {

        const favoriteCountElement = document.getElementById("favoriteCount");

        if (favoriteCountElement) {
            favoriteCountElement.textContent = count;
        }
    }
</script>
</body>
</html>

