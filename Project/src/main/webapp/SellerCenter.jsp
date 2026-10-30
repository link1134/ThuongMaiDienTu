<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MangaZ Seller Center</title> <!-- Google Fonts & Material Symbols Icons -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
          rel="stylesheet">
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SellerCenter.css">
</head>

<body> <!-- Layout Wrapper -->
<div class="seller-layout"> <!-- SIDEBAR -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="brand-icon-box"><span class="material-symbols-outlined">menu_book</span></div>
            <div class="brand-text">
                <h1 class="brand-title">MangaZ</h1>
                <p class="brand-subtitle">Cổng thông tin người bán</p>
            </div>
        </div>
        <nav class="sidebar-nav"> <!-- Nhóm Tổng quan -->
            <div class="nav-group"><span class="nav-group-title">TỔNG QUAN</span>
                <a href="#" class="nav-item active" data-panel="seller-dashboard-panel">
                    <span class="material-symbols-outlined nav-icon">dashboard</span>
                    <span class="nav-label">Dashboard</span>
                </a>
            </div> <!-- Nhóm Quản lý bán hàng -->
            <div class="nav-group">
                <span class="nav-group-title">QUẢN LÝ BÁN HÀNG</span>
                <a href="#" class="nav-item" data-panel="post-management-panel">
                    <span class="material-symbols-outlined nav-icon">menu_book</span>
                    <span class="nav-label">Quản lý bài đăng</span>
                    <span class="badge">48</span>
                </a>
                <a href="#" class="nav-item" data-panel="order-management-panel">
                    <span class="material-symbols-outlined nav-icon">receipt_long</span>
                    <span class="nav-label">Quản lý đơn bán</span>
                    <span class="badge">15</span>
                </a>
                <a href="#" class="nav-item" data-panel="auction-management-panel">
                    <span class="material-symbols-outlined nav-icon">gavel</span>
                    <span class="nav-label">Quản lý đấu giá</span>
                    <span class="badge">8</span>
                </a>
            </div>
            <!-- Nhóm Cài đặt -->
            <div class="nav-group"><span class="nav-group-title">CÀI ĐẶT</span>
                <a href="#" class="nav-item" data-panel="seller-profile-panel">
                    <span class="material-symbols-outlined nav-icon">account_circle</span>
                    <span class="nav-label">Hồ sơ người bán</span>
                </a>
                <a href="#" class="nav-item"> <span class="material-symbols-outlined nav-icon">help</span> <span
                        class="nav-label">Trợ
                            giúp</span> </a>
            </div>
        </nav> <!-- Sidebar Footer: Hồ sơ người bán tóm tắt -->
        <div class="sidebar-footer">
            <div class="seller-profile-card">
               <img src="${sessionScope.user.avatarUrl}"
                                                alt="Ảnh đại diện"
                                                class="seller-avatar">
                <div class="seller-info"><span class="seller-name">${sessionScope.user.fullName}</span >
<%--                    <span--%>
<%--                        class="seller-rating">★ Uy tín 4.9 • Đã xác thực</span>--%>
                </div>
            </div>
            <button class="btn-logout" title="Đăng xuất"> <span
                    class="material-symbols-outlined">logout</span> <span>Đăng xuất</span></button>
        </div>
    </aside> <!-- MAIN CONTENT -->
    <main class="main-content"> <!-- Top Bar / Filter Bar -->
        <div id="seller-dashboard-panel">
            <header class="content-header">
                <div class="header-titles">
                    <h2 class="page-title">Bảng điều khiển Người Bán</h2>
                    <p class="page-desc">Tổng hợp kết quả kinh doanh và luồng đấu giá manga thời gian thực</p>
                </div> <!-- Bộ chọn khoảng thời gian -->
                <div class="date-filter-wrapper">
                    <button type="button" class="date-range-selector" id="dateRangeButton">
        <span class="material-symbols-outlined date-icon">
            calendar_today
        </span>
                        <span class="date-text" id="dateRangeText">
            ALL (Từ đầu tới giờ)
        </span>
                        <span class="material-symbols-outlined dropdown-icon">
            expand_more
        </span>
                    </button>

                    <div id="dateRangePopup" class="date-range-popup" hidden>
                        <label for="datePreset">Khoảng thời gian</label>
                        <select id="datePreset">
                            <option value="all">ALL (Từ đầu tới giờ)</option>
                            <option value="today">Hôm nay</option>
                            <option value="7days">7 ngày gần nhất</option>
                            <option value="30days">30 ngày gần nhất</option>
                            <option value="custom">Tùy chọn ngày</option>
                        </select>

                        <div id="customDateFields" hidden>
                            <label for="startDate">Từ ngày</label>
                            <input type="date" id="startDate">

                            <label for="endDate">Đến ngày</label>
                            <input type="date" id="endDate">
                        </div>

                        <button type="button" id="applyDateFilter">
                            Áp dụng
                        </button>
                    </div>
                </div>
            </header> <!-- KPI Summary Cards -->
            <div>
                <section class="kpi-grid"> <!-- Card 1 -->
                    <div class="kpi-card">
                        <div class="kpi-card-header"><span class="kpi-label">TỔNG DOANH THU</span> <span
                                class="kpi-icon-badge blue"> <span class="material-symbols-outlined">payments</span>
                                </span>
                        </div>
                        <div class="kpi-value">
                            <span id="totalRevenue">0</span>
                            <span class="currency">₫</span>
                        </div>
<%--                        <div class="kpi-subtext positive"> <span--%>
<%--                                class="material-symbols-outlined trend-icon">trending_up</span> <span>+14.2% so với--%>
<%--                                    tháng--%>
<%--                                    trước</span></div>--%>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-card-header"><span class="kpi-label">ĐƠN HÀNG HOÀN TẤT</span> <span
                                class="kpi-icon-badge sky"> <span class="material-symbols-outlined">task_alt</span>
                                </span>
                        </div>
                        <div class="kpi-value">
                            <span id="completedOrders">0</span>
                            <span class="unit">đơn</span>
                        </div>
                        <!-- <div class="kpi-subtext positive">
                    <span
                        class="material-symbols-outlined trend-icon">trending_up</span> <span>+8.5% • Tỉ lệ giao
                        thành công 98%</span>
                    </div> -->
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-card-header"><span class="kpi-label">ĐƠN HÀNG ĐANG ĐƯỢC CHUẨN BỊ</span> <span
                                class="kpi-icon-badge purple"> <span class="material-symbols-outlined ">
                                        box
                                    </span> </span>
                        </div>
<%--                        <div class="kpi-card-header"><span class="kpi-label">ĐƠN HÀNG ĐANG XỬ LÝ</span> <span--%>
<%--                                class="kpi-icon-badge amber"> <span class="material-symbols-outlined ">--%>
<%--                                        priority_high--%>
<%--                                    </span> </span>--%>
<%--                        </div>--%>
                        <div class="kpi-value">
                            <span id="processingOrders">0</span>
                            <span class="unit">đơn</span>
                        </div>
                        <!-- <div class="kpi-subtext positive">
                    <span
                        class="material-symbols-outlined trend-icon">trending_up</span> <span>+8.5% • Tỉ lệ giao
                        thành công 98%</span>
                    </div> -->
                    </div>
                    <!-- Card 3 -->
                    <div class="kpi-card">
                        <div class="kpi-card-header"><span class="kpi-label">ĐẤU GIÁ ĐANG DIỄN RA</span> <span
                                class="kpi-icon-badge red"> <span class="material-symbols-outlined">gavel</span>
                                </span>
                        </div>
                        <div class="kpi-value-inline"> <span class="kpi-value">8 <span
                                class="unit">phiên</span></span>
                        </div>
                        <div class="kpi-subtext neutral"> <span
                                class="material-symbols-outlined trend-icon">schedule</span>
                            <span>2 phiên sắp kết thúc trong 1h</span>
                        </div>
                    </div> <!-- Card 4 -->

                    <!-- <div class="kpi-card">
                <div class="kpi-card-header"> <span class="kpi-label">ĐÁNH GIÁ TÍCH CỰC</span> <span
                        class="kpi-icon-badge amber"> <span class="material-symbols-outlined">thumb_up</span>
                    </span>
                </div>
                <div class="kpi-value">99.4%</div>
                <div class="kpi-subtext amber-text"> <span class="material-symbols-outlined star-icon">star</span>
                    <span>Từ 318 lượt nhận xét</span> </div>
                </div> -->
                </section> <!-- Charts Section (Side-by-side) -->
                <section class="charts-grid"> <!-- BIỂU ĐỒ CỘT: Doanh thu theo thời gian -->
                    <div class="dashboard-panel bar-chart-panel">
                        <div class="panel-header">
                            <div>
                                <h3 class="panel-title">Doanh thu theo thời gian</h3>
                                <p class="panel-subtitle">Phân tích dòng tiền giữa Bán thẳng Manga &amp; Đấu giá</p>
                            </div> <!-- Legend trên biểu đồ cột -->
                            <div class="bar-chart-legend"> <span class="legend-item"> <span
                                    class="dot bar-primary"></span>
                                        <span>Bán thẳng manga</span> </span> <span class="legend-item"> <span
                                    class="dot bar-secondary"></span> <span>Đấu giá manga</span> </span></div>
                        </div> <!-- Chart Area -->
                        <div class="chart-canvas">
                            <div class="y-axis"><span>30M ₫</span> <span>20M ₫</span> <span>10M ₫</span> <span>0M
                                        ₫</span>
                            </div>
                            <div class="bars-container">
                                <div class="grid-line" style="bottom: 0%;"></div>
                                <div class="grid-line" style="bottom: 33.3%;"></div>
                                <div class="grid-line" style="bottom: 66.6%;"></div>
                                <div class="grid-line" style="bottom: 100%;"></div> <!-- Cột Tuần 1 -->
                                <div class="bar-group">
                                    <div class="bar bar-primary" style="height: 43%;" title="Bán thẳng: 13M"></div>
                                    <div class="bar bar-secondary" style="height: 27%;" title="Đấu giá: 8M"></div>
                                    <span class="x-label">Tuần 1</span>
                                </div> <!-- Cột Tuần 2 -->
                                <div class="bar-group">
                                    <div class="bar bar-primary" style="height: 56%;" title="Bán thẳng: 17M"></div>
                                    <div class="bar bar-secondary" style="height: 40%;" title="Đấu giá: 12M"></div>
                                    <span class="x-label">Tuần 2</span>
                                </div> <!-- Cột Tuần 3 (Peak) -->
                                <div class="bar-group highlight">
                                    <div class="bar bar-primary" style="height: 75%;" title="Bán thẳng: 22.5M">
                                    </div>
                                    <div class="bar bar-secondary" style="height: 65%;" title="Đấu giá: 19.5M">
                                    </div>
                                    <span class="x-label">Tuần 3 ★</span>
                                </div> <!-- Cột Tuần 4 -->
                                <div class="bar-group">
                                    <div class="bar bar-primary" style="height: 50%;" title="Bán thẳng: 15M"></div>
                                    <div class="bar bar-secondary" style="height: 44%;" title="Đấu giá: 13M"></div>
                                    <span class="x-label">Tuần 4</span>
                                </div> <!-- Cột Dự phòng -->
                                <div class="bar-group forecast">
                                    <div class="bar bar-primary striped" style="height: 35%;" title="Dự kiến: 10M">
                                    </div>
                                    <div class="bar bar-secondary striped" style="height: 25%;" title="Dự kiến: 7M">
                                    </div>
                                    <span class="x-label">Dự phòng</span>
                                </div>
                            </div>
                        </div>
                        <div class="panel-footer-summary"><span>Tổng cơ cấu doanh thu tháng này:</span> <strong>Bán
                            lẻ:
                            55.400.000₫ (65.5%)</strong> <span class="separator">|</span> <strong>Đấu giá:
                            29.100.000₫
                            (34.5%)</strong></div>
                    </div> <!-- BIỂU ĐỒ TRÒN: Cơ cấu trạng thái đơn hàng -->
                    <div class="dashboard-panel donut-chart-panel">
                        <div class="panel-header">
                            <div>
                                <h3 class="panel-title">Thống kê đơn hàng</h3>
                                <p class="panel-subtitle">Tổng số: 218 đơn</p>
                            </div> <!-- Nút chuyển đổi % và Số lượng theo yêu cầu -->
                            <div class="toggle-mode-group">
                                <button class="btn-toggle active" id="btnPercent">% Tỉ
                                    lệ
                                </button>
                                <button class="btn-toggle" id="btnCount">Số lượng</button>
                            </div>
                        </div> <!-- Donut Graphic Container -->
                        <div class="donut-display-wrapper">
                            <div class="donut-chart-svg-container"> <!-- SVG Donut Chart 5 Phân khúc màu -->
                                <svg
                                        class="donut-svg" viewBox="0 0 160 160"> <!-- Vòng nền xám nhẹ -->
                                    <circle cx="80" cy="80" r="58" class="donut-bg-track"/>
                                    <!-- Hoàn tất: 54% (Xanh ngọc / Emerald) -->
                                    <circle cx="80" cy="80" r="58" class="donut-segment segment-complete"
                                            stroke-dasharray="196.7 364.4" stroke-dashoffset="0"/>
                                    <!-- Đang giao: 18% (Tím chàm / Indigo) -->
                                    <circle cx="80" cy="80" r="58" class="donut-segment segment-shipping"
                                            stroke-dasharray="65.6 364.4" stroke-dashoffset="-196.7"/>
                                    <!-- Chờ gửi hàng: 14% (Xanh dương / Cyan-Blue) -->
                                    <circle cx="80" cy="80" r="58" class="donut-segment segment-pending-ship"
                                            stroke-dasharray="51.0 364.4" stroke-dashoffset="-262.3"/>
                                    <!-- Chờ xác nhận: 8% (Cam vàng / Amber) -->
                                    <circle cx="80" cy="80" r="58" class="donut-segment segment-pending-confirm"
                                            stroke-dasharray="29.1 364.4" stroke-dashoffset="-313.3"/>
                                    <!-- Đã hủy: 6% (Đỏ san hô / Coral-Red) -->
                                    <circle cx="80" cy="80" r="58" class="donut-segment segment-cancelled"
                                            stroke-dasharray="21.9 364.4" stroke-dashoffset="-342.4"/>
                                </svg> <!-- Tâm vòng tròn -->
                                <div class="donut-center-info"> <span class="donut-center-val"
                                                                      id="centerStatValue">54%</span> <span
                                        class="donut-center-lbl">Hoàn
                                            tất</span>
                                </div>
                            </div>
                        </div>
                        <ul class="donut-legend-list">
                            <li class="legend-row"> <span class="legend-mark-group"> <span
                                    class="dot-status bg-complete"></span> <span class="status-name">Hoàn
                                            tất</span>
                                    </span> <span class="status-data val-percent">54%</span> <span
                                    class="status-data val-count hidden">118 đơn</span></li>
                            <li class="legend-row"> <span class="legend-mark-group"> <span
                                    class="dot-status bg-shipping"></span> <span class="status-name">Đang
                                            giao</span>
                                    </span> <span class="status-data val-percent">18%</span> <span
                                    class="status-data val-count hidden">39 đơn</span></li>
                            <li class="legend-row"> <span class="legend-mark-group"> <span
                                    class="dot-status bg-pending-ship"></span> <span class="status-name">Chờ gửi
                                            hàng</span> </span> <span class="status-data val-percent">14%</span> <span
                                    class="status-data val-count hidden">31 đơn</span></li>
                            <li class="legend-row"> <span class="legend-mark-group"> <span
                                    class="dot-status bg-pending-confirm"></span> <span class="status-name">Chờ
                                            xác
                                            nhận</span> </span> <span class="status-data val-percent">8%</span> <span
                                    class="status-data val-count hidden">17 đơn</span></li>
                            <li class="legend-row"> <span class="legend-mark-group"> <span
                                    class="dot-status bg-cancelled"></span> <span class="status-name">Đã
                                            hủy</span>
                                    </span> <span class="status-data val-percent">6%</span> <span
                                    class="status-data val-count hidden">13 đơn</span></li>
                        </ul>
                    </div>
                </section>
                <!-- <section class="dashboard-panel orders-panel">
                    <div class="panel-header table-panel-header">
                        <div class="table-title-area">
                            <h3 class="panel-title">Đơn hàng gần đây</h3> <span class="badge-accent">5 đơn mới
                                nhất</span>
                        </div>
                        <div class="table-actions">
                            <div class="table-filter-tabs"> <button class="filter-tab active">Tất cả</button>
                                <button class="filter-tab">Mua ngay</button> <button class="filter-tab">Đấu giá
                                    thắng</button>
                            </div> <button class="btn-secondary"> <span
                                    class="material-symbols-outlined">download</span>
                                <span>Xuất Excel</span> </button> <a href="#" class="link-view-all">Xem tất cả
                                &rsaquo;</a>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>MÃ ĐƠN</th>
                                    <th>TRUYỆN TRANH / SẢN PHẨM</th>
                                    <th>NGƯỜI MUA</th>
                                    <th>NGÀY ĐẶT</th>
                                    <th>GIÁ TRỊ ĐƠN</th>
                                    <th>TRẠNG THÁI</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="order-code">#ORD-99824</td>
                                    <td class="product-cell"> <span class="product-type-tag auction">Đấu giá</span>
                                        <div class="product-desc"> <span class="product-title">One Piece Tập 1 (Bản
                                                in đầu
                                                1997 - Japan)</span> <span class="product-sub">Tình trạng: Near Mint
                                                9.4 •
                                                Kèm bìa lót gốc</span> </div>
                                    </td>
                                    <td class="buyer-name">Phạm Hoàng Minh</td>
                                    <td class="order-date">10 phút trước</td>
                                    <td class="order-amount highlight-price">3.250.000 ₫</td>
                                    <td><span class="tag-status status-pending">Chờ xác nhận</span></td>
                                </tr>
                                <tr>
                                    <td class="order-code">#ORD-99818</td>
                                    <td class="product-cell"> <span class="product-type-tag direct">Mua ngay</span>
                                        <div class="product-desc"> <span class="product-title">Trọn bộ Slam Dunk
                                                Deluxe
                                                Boxset 24 tập</span> <span class="product-sub">Nguyên màng co Seal •
                                                NXB Kim
                                                Đồng</span> </div>
                                    </td>
                                    <td class="buyer-name">Lê Quang Hải</td>
                                    <td class="order-date">2 giờ trước</td>
                                    <td class="order-amount">1.850.000 ₫</td>
                                    <td><span class="tag-status status-shipping">Đang giao</span></td>
                                </tr>
                                <tr>
                                    <td class="order-code">#ORD-99805</td>
                                    <td class="product-cell"> <span class="product-type-tag auction">Đấu giá</span>
                                        <div class="product-desc"> <span class="product-title">Dragon Ball Tập 42 -
                                                Chữ ký
                                                tác giả Akira Toriyama</span> <span class="product-sub">Chứng thư
                                                giám định
                                                CGC Authentic</span> </div>
                                    </td>
                                    <td class="buyer-name">Trần Đình Bảo</td>
                                    <td class="order-date">Hôm qua, 18:30</td>
                                    <td class="order-amount highlight-price">12.500.000 ₫</td>
                                    <td><span class="tag-status status-complete">Hoàn tất</span></td>
                                </tr>
                                <tr>
                                    <td class="order-code">#ORD-99792</td>
                                    <td class="product-cell"> <span class="product-type-tag direct">Mua ngay</span>
                                        <div class="product-desc"> <span class="product-title">Jujutsu Kaisen Vol 0
                                                - Bản
                                                bìa áo đặc biệt Anime Expo</span> <span class="product-sub">Mới 100%
                                                • Quà
                                                tặng kèm bookmark kim loại</span> </div>
                                    </td>
                                    <td class="buyer-name">Nguyễn Thảo My</td>
                                    <td class="order-date">Hôm qua, 14:15</td>
                                    <td class="order-amount">450.000 ₫</td>
                                    <td><span class="tag-status status-complete">Hoàn tất</span></td>
                                </tr>
                                <tr>
                                    <td class="order-code">#ORD-99781</td>
                                    <td class="product-cell"> <span class="product-type-tag direct">Mua ngay</span>
                                        <div class="product-desc"> <span class="product-title">Berserk Deluxe
                                                Edition Vol
                                                1-3 (Tiếng Anh, Bìa da)</span> <span class="product-sub">Dark Horse
                                                Comics •
                                                Khổ lớn</span> </div>
                                    </td>
                                    <td class="buyer-name">Đặng Tuấn Kiệt</td>
                                    <td class="order-date">28/10/2023</td>
                                    <td class="order-amount">2.100.000 ₫</td>
                                    <td><span class="tag-status status-cancelled">Đã hủy</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                </section> -->
            </div>
        </div>
        <div id="post-management-panel">
            <header class="content-header">
                <div class="header-titles">
                    <h2 class="page-title">Quản lý bài đăng</h2>
                    <p class="page-desc">Tổng hợp các bài đăng bán/đấu giá của bạn</p>
                </div>
            </header>
            <div class="orders-page">
                <!-- Thanh công cụ nằm ngoài bảng -->
                <div class="post-toolbar">
                    <div class="post-tabs">
                        <button class="post-tab active" type="button">
                            Đăng bài
                        </button>

                        <button class="post-tab" type="button">
                            Đấu giá
                        </button>
                    </div>
                    <div class="new-post-group-btn">
                        <button class="btn-create-post" type="button" id="postDropdownBtn">
                            <span class="material-symbols-outlined">add</span>
                            Đăng bài mới
                        </button>
                        <div class="post-menu" id="postMenu">
                            <button type="button" id="openListingPopup">
                                Đăng bài bán
                            </button>

                            <button type="button">
                                Đăng bài đấu giá
                            </button>
                        </div>
                    </div>
                </div>
                <div class="orders-toolbar">
                    <div class="orders-search">
                            <span class="material-symbols-outlined search-icon">
                                search
                            </span>
                        <input type="text" placeholder="Tìm kiếm đơn hàng...">
                    </div>

                    <!-- <div class="orders-filters">
                        <button class="filter-btn" type="button">
                            <span>Ngày đặt hàng</span>
                            <span class="filter-icon">▦</span>
                        </button>

                        <select class="filter-select">
                            <option value="">Tất cả trạng thái</option>
                            <option value="pending">Chờ xác nhận</option>
                            <option value="confirmed">Đã xác nhận</option>
                            <option value="shipping">Đang giao</option>
                            <option value="completed">Hoàn thành</option>
                            <option value="cancelled">Đã hủy</option>
                        </select>
                    </div> -->
                </div>

                <!-- Container bảng -->

                <div class="orders-table-container">
                    <table class="orders-table">
                        <thead>
                        <tr>
                            <th class="checkbox-col">
                                <input type="checkbox">
                            </th>
                            <th>
                                Mã bài đăng
                                <span class="material-symbols-outlined sort-icon">sort</span>
                            </th>
                            <th>
                                Tên bài đăng
                                <span class="material-symbols-outlined sort-icon">sort</span>
                            </th>
                            <th>
                                Giá bán
                                <span class="material-symbols-outlined sort-icon">sort</span>
                            </th>
                            <th>
                                Số lượng
                                <span class="material-symbols-outlined sort-icon">sort</span>
                            </th>
                            <th>
                                Trạng thái
                                <span class="material-symbols-outlined sort-icon">sort</span>
                            </th>
                            <th>
                                Cập nhật lần cuối
                                <span class="material-symbols-outlined sort-icon">sort</span>
                            </th>
                            <th>
                                Loại sản phẩm
                                <span class="material-symbols-outlined sort-icon">sort</span>
                            </th>
                            <th class="detail-col"></th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:forEach var="listing" items="${sellerListings}">
                            <tr>
                                <td class="checkbox-col">
                                    <input type="checkbox">
                                </td>

                                <td class="order-id">
                                    #${listing.listingCode}
                                </td>

                                <td class="product-name">
                                    <c:out value="${listing.title}" />
                                </td>

                                <td class="amount">
                                    <fmt:formatNumber value="${listing.price}"
                                                      type="number"
                                                      groupingUsed="true" /> ₫
                                </td>

                                <td>${listing.quantity}</td>

                                <td>
                                    <c:choose>
                                        <c:when test="${listing.status == 'Active'}">
                        <span class="listing-status status-active">
                            Đang hiển thị
                        </span>
                                        </c:when>
                                        <c:when test="${listing.status == 'Pending'}">
                        <span class="listing-status status-pending">
                            Chờ duyệt
                        </span>
                                        </c:when>
                                        <c:when test="${listing.status == 'Hidden'}">
                        <span class="listing-status status-hidden">
                            Đã ẩn
                        </span>
                                        </c:when>
                                        <c:otherwise>
                        <span class="listing-status">
                            <c:out value="${listing.status}" />
                        </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td class="listing-updated">
                                    <c:if test="${not empty listing.updatedAt}">
                                        <fmt:parseDate value="${listing.updatedAt}"
                                                       pattern="yyyy-MM-dd'T'HH:mm"
                                                       var="updatedDate"
                                                       type="both" />
                                        <fmt:formatDate value="${updatedDate}"
                                                        pattern="dd/MM/yyyy HH:mm" />
                                    </c:if>
                                </td>

                                <td>
                <span class="product-type type-manga">
                    Manga
                </span>
                                </td>

                                <td class="detail-col">
                                    <button class="detail-btn"
                                            type="button"
                                            onclick="viewListing('<c:out value="${listing.listingCode}" />')">
                                        Chi tiết
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

            </div>
        </div>
        <div id="auction-management-panel">

        </div>
        <div id="seller-profile-panel">

        </div>
        <div id="order-management-panel">
            <header class="content-header">
                <div class="header-titles">
                    <h2 class="page-title">Quản lý đơn hàng</h2>
                    <p class="page-desc">Tổng hợp các mua nhận được từ khách hàng</p>
                </div>
            </header>
            <div class="orders-page">
                <!-- Thanh công cụ nằm ngoài bảng -->
                <div class="orders-toolbar">
                    <div class="orders-search">
                            <span class="material-symbols-outlined search-icon">
                                search
                            </span>
                        <input type="text" placeholder="Tìm kiếm đơn hàng...">
                    </div>

                    <div class="orders-filters">
                        <button class="filter-btn" type="button">
                            <span>Ngày đặt hàng</span>
                            <span class="filter-icon">▦</span>
                        </button>

                        <select class="filter-select">
                            <option value="">Tất cả trạng thái</option>
                            <option value="pending">Chờ xác nhận</option>
                            <option value="confirmed">Đã xác nhận</option>
                            <option value="shipping">Đang giao</option>
                            <option value="completed">Hoàn thành</option>
                            <option value="cancelled">Đã hủy</option>
                        </select>
                    </div>
                </div>

                <!-- Container bảng -->
                <div class="orders-table-container">
                    <table class="orders-table">
                        <thead>
                        <tr>
                            <th class="checkbox-col">
                                <input type="checkbox">
                            </th>
                            <th>Mã đơn hàng <span class="material-symbols-outlined sort-icon">
                                            sort
                                        </span></th>
                            <th>Khách hàng <span class="material-symbols-outlined sort-icon">
                                            sort
                                        </span></th>
                            <th>Ngày đặt <span class="material-symbols-outlined sort-icon">
                                            sort
                                        </span></th>
                            <th>Tổng tiền <span class="material-symbols-outlined sort-icon">
                                            sort
                                        </span></th>
                            <th>Số lượng <span class="material-symbols-outlined sort-icon">
                                            sort
                                        </span></th>
                            <th>Thanh toán <span class="material-symbols-outlined sort-icon">
                                            sort
                                        </span></th>
                            <th>Trạng thái <span class="material-symbols-outlined sort-icon">
                                            sort
                                        </span></th>
                            <th class="detail-col"></th>
                        </tr>
                        </thead>


                        <tbody>
                        <c:choose>
                            <c:when test="${not empty sellerOrders}">
                                <c:forEach var="order" items="${sellerOrders}">
                                    <%-- Tính tổng số lượng sản phẩm của người bán trong đơn --%>
                                    <c:set var="totalQuantity" value="0" />

                                    <c:forEach var="detail" items="${order.details}">
                                        <c:set var="totalQuantity"
                                               value="${totalQuantity + detail.quantity}" />
                                    </c:forEach>

                                    <tr>
                                        <td class="checkbox-col">
                                            <input type="checkbox"
                                                   value="${order.orderId}">
                                        </td>

                                        <td class="order-id">
                                            #ORD-<c:out value="${order.orderId}" />
                                        </td>

                                        <td>
                                            <c:out value="${order.recipientName}" />
                                        </td>

                                        <td>
                                            <fmt:formatDate
                                                    value="${order.createdAt}"
                                                    pattern="dd/MM/yyyy HH:mm" />
                                        </td>

                                        <td class="amount">
                                            <fmt:formatNumber
                                                    value="${order.totalAmount}"
                                                    type="number"
                                                    groupingUsed="true" /> ₫
                                        </td>

                                        <td>
                                            <c:out value="${totalQuantity}" />
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${order.paymentMethod == 'COD'}">
                                <span class="payment-unpaid">
                                    Thanh toán khi nhận hàng
                                </span>
                                                </c:when>

                                                <c:when test="${order.paymentMethod == 'MoMo'}">
                                <span class="payment-paid">
                                    MoMo
                                </span>
                                                </c:when>

                                                <c:when test="${order.paymentMethod == 'ZaloPay'}">
                                <span class="payment-paid">
                                    ZaloPay
                                </span>
                                                </c:when>

                                                <c:otherwise>
                                                    <c:out value="${order.paymentMethod}" />
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${order.status == 'Pending'}">
                                <span class="status-badge status-pending">
                                    Chờ xác nhận
                                </span>
                                                </c:when>

                                                <c:when test="${order.status == 'Processing'}">
                                <span class="status-badge status-shipping">
                                    Đang chuẩn bị
                                </span>
                                                </c:when>

                                                <c:when test="${order.status == 'Shipping'}">
                                <span class="status-badge status-shipping">
                                    Đang giao
                                </span>
                                                </c:when>

                                                <c:when test="${order.status == 'Completed'}">
                                <span class="status-badge status-completed">
                                    Hoàn thành
                                </span>
                                                </c:when>

                                                <c:when test="${order.status == 'Cancelled'}">
                                <span class="status-badge status-cancelled">
                                    Đã hủy
                                </span>
                                                </c:when>

                                                <c:otherwise>
                                <span class="status-badge">
                                    <c:out value="${order.status}" />
                                </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="detail-col">
                                            <button class="detail-btn"
                                                    type="button"
                                                    onclick="viewOrder('ORD-${order.orderId}')">
                                                Chi tiết
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                                <tr>
                                    <td colspan="9" style="text-align: center; padding: 30px;">
                                        Bạn chưa có đơn hàng nào.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>

                    </table>

                </div>
            </div>
        </div>
    </main>
</div>
<div class="listing-modal" id="listingModal">

    <div class="listing-popup" role="dialog" aria-modal="true" aria-labelledby="popupTitle">

        <!-- Header -->
        <header class="popup-header">
            <div class="popup-heading">
                <h2 id="popupTitle">Tạo bài đăng mới</h2>
                <p>Điền thông tin sản phẩm bạn muốn bán trên MangaZ.</p>
            </div>

            <button type="button" class="close-popup-button" id="closeListingPopup" aria-label="Đóng popup">
                ×
            </button>
        </header>

        <!-- Nội dung có thanh cuộn -->
        <form id="createListingForm" action="#" method="post" enctype="multipart/form-data">

            <div class="popup-body">

                <!-- 01. Thông tin cơ bản -->
                <section class="form-section">

                    <div class="section-heading">
                        <div class="section-number">01</div>
                        <div>
                            <h3>Thông tin cơ bản</h3>
                            <p>Thông tin nhận diện sản phẩm.</p>
                        </div>
                    </div>

                    <div class="form-grid">

                        <div class="form-group full-width">
                            <label for="productType">
                                Loại sản phẩm <span class="required">*</span>
                            </label>

                            <select id="productType" name="productTypeId" required>
                                <option value="">Chọn loại sản phẩm</option>
                                <option value="1">Manga</option>
                                <option value="2">ArtBook</option>
                            </select>
                        </div>

                        <div class="form-group full-width">
                            <label for="title">
                                Tên sản phẩm <span class="required">*</span>
                            </label>

                            <input type="text" id="title" name="title" maxlength="200"
                                   placeholder="Ví dụ: Chuyển Sinh Thành Slime - Tập 1" required>
                        </div>

                        <div class="form-group full-width">
                            <div class="label-with-action">
                                <label>Tác giả</label>
                                <button type="button" class="add-person-button" data-add-target="authors">
                                    + Thêm tác giả
                                </button>
                            </div>

                            <div class="person-list" id="authors">
                                <div class="person-row">
                                    <input type="text" name="authors[]" placeholder="Tên tác giả">

                                    <button type="button" class="remove-person-button" disabled>−</button>
                                </div>
                            </div>
                        </div>

                        <div class="form-group full-width">
                            <div class="label-with-action">
                                <label>Họa sĩ / Minh họa</label>
                                <button type="button" class="add-person-button" data-add-target="artists">
                                    + Thêm họa sĩ
                                </button>
                            </div>

                            <div class="person-list" id="artists">
                                <div class="person-row">
                                    <input type="text" name="artists[]" placeholder="Tên họa sĩ">

                                    <button type="button" class="remove-person-button" disabled>−</button>
                                </div>
                            </div>
                        </div>

                    </div>
                </section>

                <!-- 02. Ảnh bìa -->
                <section class="form-section">

                    <div class="section-heading">
                        <div class="section-number">02</div>
                        <div>
                            <h3>Ảnh bìa sản phẩm</h3>
                            <p>Chọn ảnh đại diện cho bài đăng.</p>
                        </div>
                    </div>

                    <div class="cover-upload">

                        <div class="cover-preview">
                            <div class="cover-placeholder" id="coverPlaceholder">
                                Chưa có ảnh bìa
                            </div>

                            <img id="coverImage" alt="Ảnh bìa xem trước" hidden>
                        </div>

                        <div class="cover-upload-info">
                            <p>
                                Chọn ảnh rõ nét, thể hiện đúng sản phẩm.
                                Hỗ trợ JPG, PNG, WEBP, tối đa 5 MB.
                            </p>

                            <label for="coverFile" class="upload-button">
                                ↑ Chọn ảnh bìa
                            </label>

                            <input type="file" id="coverFile" name="coverImage"
                                   accept="image/jpeg,image/png,image/webp" hidden>

                            <p id="coverFileName"></p>

                            <button type="button" class="remove-cover-button" id="removeCover" hidden>
                                Xóa ảnh đã chọn
                            </button>
                        </div>

                    </div>
                </section>

                <!-- 03. Tình trạng -->
                <section class="form-section">

                    <div class="section-heading">
                        <div class="section-number">03</div>
                        <div>
                            <h3>Tình trạng sản phẩm</h3>
                            <p>Mô tả thực tế tình trạng của sản phẩm.</p>
                        </div>
                    </div>

                    <div class="attribute-note">
                        <p>
                            Các thuộc tính phụ thuộc vào loại sản phẩm.
                            Trường có dấu <span class="required">*</span>
                            là bắt buộc.
                        </p>
                    </div>

                    <!-- DEMO thuộc tính Manga.
                     JSP thực tế sẽ sinh các trường từ database. -->
                    <div class="attribute-grid" id="conditionAttributes">

                        <div class="form-group">
                            <label for="attr2">
                                Tình trạng tổng thể <span class="required">*</span>
                            </label>
                            <textarea id="attr2" name="attributes[2]"
                                      placeholder="Mức độ mới và chất lượng tổng thể..." required></textarea>
                        </div>

                        <div class="form-group">
                            <label for="attr3">
                                Tình trạng bìa <span class="required">*</span>
                            </label>
                            <textarea id="attr3" name="attributes[3]" placeholder="Độ nguyên vẹn, trầy xước..."
                                      required></textarea>
                        </div>

                        <div class="form-group">
                            <label for="attr4">Tình trạng gáy</label>
                            <textarea id="attr4" name="attributes[4]"
                                      placeholder="Độ liên kết, cong hoặc rách..."></textarea>
                        </div>

                        <div class="form-group">
                            <label for="attr5">Tình trạng giấy</label>
                            <textarea id="attr5" name="attributes[5]"
                                      placeholder="Màu sắc và chất lượng giấy..."></textarea>
                        </div>

                        <div class="form-group">
                            <label for="attr6">Độ đầy đủ trang</label>
                            <textarea id="attr6" name="attributes[6]"
                                      placeholder="Đầy đủ trang, có thiếu trang không..."></textarea>
                        </div>

                        <div class="form-group">
                            <label for="attr7">Tình trạng góc sách</label>
                            <textarea id="attr7" name="attributes[7]"
                                      placeholder="Góc sách cong, cấn hoặc rách..."></textarea>
                        </div>

                        <div class="form-group">
                            <label for="attr8">Tình trạng chữ viết</label>
                            <textarea id="attr8" name="attributes[8]"
                                      placeholder="Ghi chú hoặc đánh dấu trên sách..."></textarea>
                        </div>

                        <div class="form-group">
                            <label for="attr9">Tình trạng ẩm mốc</label>
                            <textarea id="attr9" name="attributes[9]"
                                      placeholder="Dấu hiệu ẩm mốc nếu có..."></textarea>
                        </div>

                        <div class="form-group">
                            <label for="attr10">Tình trạng mùi</label>
                            <textarea id="attr10" name="attributes[10]"
                                      placeholder="Mùi của sách nếu có..."></textarea>
                        </div>

                        <div class="form-group">
                            <label for="attr11">Phụ kiện đi kèm</label>
                            <textarea id="attr11" name="attributes[11]"
                                      placeholder="Phụ kiện, quà tặng đi kèm..."></textarea>
                        </div>

                    </div>
                </section>

                <!-- 04. Mô tả -->
                <section class="form-section">

                    <div class="section-heading">
                        <div class="section-number">04</div>
                        <div>
                            <h3>Mô tả sản phẩm</h3>
                            <p>Giới thiệu ngắn gọn và cung cấp thông tin chi tiết.</p>
                        </div>
                    </div>

                    <div class="form-grid">

                        <div class="form-group full-width">
                            <label for="shortDescription">
                                Mô tả ngắn <span class="required">*</span>
                            </label>

                            <textarea id="shortDescription" name="shortDescription" rows="2" maxlength="300"
                                      placeholder="Giới thiệu ngắn về sản phẩm..." required></textarea>

                            <div class="field-footer">
                                <span>Hiển thị trên thẻ sản phẩm.</span>
                                <span id="shortDescriptionCount">0/300</span>
                            </div>
                        </div>

                        <div class="form-group full-width">
                            <label for="description">Mô tả chi tiết</label>

                            <textarea id="description" name="description" rows="4"
                                      placeholder="Thông tin bổ sung dành cho người mua..."></textarea>
                        </div>

                    </div>
                </section>

                <!-- 05. Giá bán -->
                <section class="form-section">

                    <div class="section-heading">
                        <div class="section-number">05</div>
                        <div>
                            <h3>Thông tin bán hàng</h3>
                            <p>Thiết lập giá bán và số lượng.</p>
                        </div>
                    </div>

                    <div class="form-grid">

                        <div class="form-group">
                            <label for="price">
                                Giá bán (VNĐ) <span class="required">*</span>
                            </label>

                            <div class="price-input">
                                <input type="number" id="price" name="price" min="1" step="1" placeholder="65000"
                                       required>
                                <span>₫</span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="originalPrice">Giá gốc (VNĐ)</label>

                            <div class="price-input">
                                <input type="number" id="originalPrice" name="originalPrice" min="0" step="1"
                                       placeholder="85000">
                                <span>₫</span>
                            </div>
                        </div>

                        <div class="form-group full-width">
                            <label for="quantity">
                                Số lượng <span class="required">*</span>
                            </label>

                            <input type="number" id="quantity" name="quantity" min="1" step="1" value="1" required>
                        </div>

                    </div>
                </section>

            </div>

            <!-- Footer luôn nằm dưới popup -->
            <footer class="popup-footer">
                <p>
                    <span class="required">*</span> Trường bắt buộc
                </p>

                <div class="footer-actions">
                    <button type="button" class="button-secondary" id="cancelListing">
                        Hủy
                    </button>

                    <button type="submit" class="button-primary">
                        Gửi duyệt →
                    </button>
                </div>
            </footer>

        </form>
    </div>
</div> <!-- Script nhỏ điều khiển toggle % và Số lượng trên biểu đồ tròn -->
<script>
    const btnPercent = document.getElementById('btnPercent');
    const btnCount = document.getElementById('btnCount');

    const percentVals = document.querySelectorAll('.val-percent');
    const countVals = document.querySelectorAll('.val-count');
    const centerStat = document.getElementById('centerStatValue');
    const centerLabel = document.querySelector('.donut-center-lbl');
    const chartSubtitle = document.querySelector('.donut-chart-panel .panel-subtitle');

    const circumference = 2 * Math.PI * 58;

    const chartSegments = [
        {
            key: 'Completed',
            selector: '.segment-complete',
            name: 'Hoàn tất'
        },
        {
            key: 'Shipping',
            selector: '.segment-shipping',
            name: 'Đang giao'
        },
        {
            key: 'Processing',
            selector: '.segment-pending-ship',
            name: 'Chờ gửi hàng'
        },
        {
            key: 'Pending',
            selector: '.segment-pending-confirm',
            name: 'Chờ xác nhận'
        },
        {
            key: 'Cancelled',
            selector: '.segment-cancelled',
            name: 'Đã hủy'
        }
    ];

    let currentStatuses = {
        Completed: 0,
        Shipping: 0,
        Processing: 0,
        Pending: 0,
        Cancelled: 0
    };

    let showingPercent = true;
    let selectedStatus = 'Completed';

    function updateDonutChart(statuses) {
        currentStatuses = statuses;

        const total = chartSegments.reduce(function (sum, segment) {
            return sum + Number(statuses[segment.key] || 0);
        }, 0);

        if (chartSubtitle) {
            chartSubtitle.textContent = 'Tổng số: ' + total + ' đơn';
        }

        let offset = 0;

        chartSegments.forEach(function (segment) {
            const count = Number(statuses[segment.key] || 0);
            const percent = total > 0 ? count / total * 100 : 0;
            const length = circumference * percent / 100;

            const circle = document.querySelector(segment.selector);

            if (circle) {
                circle.setAttribute(
                    'stroke-dasharray',
                    length + ' ' + (circumference - length)
                );

                circle.setAttribute('stroke-dashoffset', -offset);
            }

            offset += length;

            const index = chartSegments.indexOf(segment);
            const row = document.querySelectorAll('.donut-legend-list .legend-row')[index];

            if (row) {
                row.querySelector('.val-percent').textContent =
                    percent.toFixed(1).replace('.0', '') + '%';

                row.querySelector('.val-count').textContent = count + ' đơn';
            }
        });

        updateCenterStat();
    }

    function updateCenterStat() {
        const total = chartSegments.reduce(function (sum, segment) {
            return sum + Number(currentStatuses[segment.key] || 0);
        }, 0);

        const count = Number(currentStatuses[selectedStatus] || 0);
        const percent = total > 0 ? count / total * 100 : 0;

        const selected = chartSegments.find(function (segment) {
            return segment.key === selectedStatus;
        });

        if (centerStat) {
            centerStat.textContent = showingPercent
                ? percent.toFixed(1).replace('.0', '') + '%'
                : String(count);
        }

        if (centerLabel && selected) {
            centerLabel.textContent = selected.name;
        }
    }

    btnPercent.addEventListener('click', function () {
        showingPercent = true;

        btnPercent.classList.add('active');
        btnCount.classList.remove('active');

        percentVals.forEach(function (el) {
            el.classList.remove('hidden');
        });

        countVals.forEach(function (el) {
            el.classList.add('hidden');
        });

        updateCenterStat();
    });

    btnCount.addEventListener('click', function () {
        showingPercent = false;

        btnCount.classList.add('active');
        btnPercent.classList.remove('active');

        percentVals.forEach(function (el) {
            el.classList.add('hidden');
        });

        countVals.forEach(function (el) {
            el.classList.remove('hidden');
        });

        updateCenterStat();
    });
</script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        var postButton = document.getElementById("postDropdownBtn");
        var postMenu = document.getElementById("postMenu");

        postButton.addEventListener("click", function (event) {
            event.stopPropagation();

            if (postMenu.style.display === "block") {
                postMenu.style.display = "none";
            } else {
                postMenu.style.display = "block";
            }
        });

        document.addEventListener("click", function () {
            postMenu.style.display = "none";
        });
    });
</script>
<script>
    document.addEventListener("DOMContentLoaded", function () {

        var modal = document.getElementById("listingModal");
        var openButton = document.getElementById("openListingPopup");
        var closeButton = document.getElementById("closeListingPopup");
        var cancelButton = document.getElementById("cancelListing");
        var form = document.getElementById("createListingForm");

        // Mở và đóng popup
        function openPopup() {
            modal.classList.add("show");
            document.body.style.overflow = "hidden";
        }

        function closePopup() {
            modal.classList.remove("show");
            document.body.style.overflow = "";
        }

        openButton.addEventListener("click", openPopup);
        closeButton.addEventListener("click", closePopup);
        cancelButton.addEventListener("click", closePopup);

        // Nhấn vào nền bên ngoài khung popup để đóng
        modal.addEventListener("click", function (event) {
            if (event.target === modal) {
                closePopup();
            }
        });

        // Đóng bằng phím Escape
        document.addEventListener("keydown", function (event) {
            if (event.key === "Escape" && modal.classList.contains("show")) {
                closePopup();
            }
        });

        // Thêm tác giả / họa sĩ
        document.querySelectorAll("[data-add-target]").forEach(function (button) {

            button.addEventListener("click", function () {
                var targetId = button.getAttribute("data-add-target");
                var list = document.getElementById(targetId);

                var row = document.createElement("div");
                row.className = "person-row";

                var input = document.createElement("input");
                input.type = "text";

                if (targetId === "authors") {
                    input.name = "authors[]";
                    input.placeholder = "Tên tác giả";
                } else {
                    input.name = "artists[]";
                    input.placeholder = "Tên họa sĩ";
                }

                var removeButton = document.createElement("button");
                removeButton.type = "button";
                removeButton.className = "remove-person-button";
                removeButton.textContent = "−";
                removeButton.setAttribute("aria-label", "Xóa dòng");

                removeButton.addEventListener("click", function () {
                    row.remove();
                    updateRemoveButtons(list);
                });

                row.appendChild(input);
                row.appendChild(removeButton);
                list.appendChild(row);

                updateRemoveButtons(list);
                input.focus();
            });
        });

        // Xóa các dòng có sẵn
        document.querySelectorAll(".person-list").forEach(function (list) {

            list.querySelectorAll(".remove-person-button").forEach(function (button) {

                button.addEventListener("click", function () {
                    var rows = list.querySelectorAll(".person-row");

                    if (rows.length > 1) {
                        button.closest(".person-row").remove();
                        updateRemoveButtons(list);
                    }
                });
            });

            updateRemoveButtons(list);
        });

        function updateRemoveButtons(list) {
            var rows = list.querySelectorAll(".person-row");

            rows.forEach(function (row) {
                row.querySelector(".remove-person-button").disabled =
                    rows.length === 1;
            });
        }

        // Xem trước ảnh bìa
        var coverFile = document.getElementById("coverFile");
        var coverImage = document.getElementById("coverImage");
        var coverPlaceholder = document.getElementById("coverPlaceholder");
        var coverFileName = document.getElementById("coverFileName");
        var removeCover = document.getElementById("removeCover");

        var currentImageUrl = null;

        coverFile.addEventListener("change", function () {
            var file = coverFile.files[0];

            if (!file) {
                return;
            }

            var allowedTypes = [
                "image/jpeg",
                "image/png",
                "image/webp"
            ];

            if (!allowedTypes.includes(file.type)) {
                alert("Vui lòng chọn ảnh JPG, PNG hoặc WEBP.");
                coverFile.value = "";
                return;
            }

            if (file.size > 5 * 1024 * 1024) {
                alert("Ảnh bìa không được vượt quá 5 MB.");
                coverFile.value = "";
                return;
            }

            if (currentImageUrl) {
                URL.revokeObjectURL(currentImageUrl);
            }

            currentImageUrl = URL.createObjectURL(file);

            coverImage.src = currentImageUrl;
            coverImage.hidden = false;
            coverPlaceholder.hidden = true;
            coverFileName.textContent = file.name;
            removeCover.hidden = false;
        });

        removeCover.addEventListener("click", function () {
            coverFile.value = "";
            coverImage.removeAttribute("src");
            coverImage.hidden = true;
            coverPlaceholder.hidden = false;
            coverFileName.textContent = "";
            removeCover.hidden = true;

            if (currentImageUrl) {
                URL.revokeObjectURL(currentImageUrl);
                currentImageUrl = null;
            }
        });

        // Đếm ký tự mô tả ngắn
        var shortDescription = document.getElementById("shortDescription");
        var counter = document.getElementById("shortDescriptionCount");

        shortDescription.addEventListener("input", function () {
            counter.textContent = shortDescription.value.length + "/300";
        });

        // DEMO: Chưa kết nối Servlet
        form.addEventListener("submit", function (event) {
            event.preventDefault();

            if (!form.reportValidity()) {
                return;
            }

            alert("Form hợp lệ. Cần kết nối Servlet để lưu bài đăng.");
        });

    });
</script>
<script>
    const contextPath = '${pageContext.request.contextPath}';
    async function loadDashboard(startDate = '', endDate = '') {
        const params = new URLSearchParams();
        // Không có ngày nghĩa là ALL.
        if (startDate && endDate) {
            params.set('startDate', startDate);
            params.set('endDate', endDate);
        }
        const query = params.toString();
        const url = contextPath + '/seller/dashboard-data'
            + (query ? '?' + query : '');
        try {
            const response = await fetch(url, {
                method: 'GET',
                headers: {
                    'Accept': 'application/json'
                }
            });
            const data = await response.json();
            if (!response.ok) {
                throw new Error(data.error || 'Không thể tải dữ liệu.');
            }

            // Cập nhật các thẻ KPI.
            const revenueElement = document.getElementById('totalRevenue');
            const completedElement = document.getElementById('completedOrders');
            const processingElement = document.getElementById('processingOrders');

            if (revenueElement) {
                revenueElement.textContent =
                    Number(data.totalRevenue).toLocaleString('vi-VN');
            }

            if (completedElement) {
                completedElement.textContent = data.completedOrders;
            }

            if (processingElement) {
                processingElement.textContent = data.processingOrders;
            }

            // Dữ liệu biểu đồ tròn.
            if (typeof updateDonutChart === 'function') {
                updateDonutChart(data.statuses);
            }

        } catch (error) {
            console.error('Dashboard:', error);
            alert(error.message || 'Có lỗi khi tải dữ liệu dashboard.');
        }
    }
    document.addEventListener('DOMContentLoaded', function () {
        const dateButton = document.getElementById('dateRangeButton');
        const datePopup = document.getElementById('dateRangePopup');
        const datePreset = document.getElementById('datePreset');
        const customFields = document.getElementById('customDateFields');
        const startInput = document.getElementById('startDate');
        const endInput = document.getElementById('endDate');
        const applyButton = document.getElementById('applyDateFilter');
        const dateText = document.getElementById('dateRangeText');

        function formatDate(date) {
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');

            return year + '-' + month + '-' + day;
        }

        function updateDateText(start, end, preset) {
            if (preset === 'all') {
                dateText.textContent = 'ALL (Từ đầu tới giờ)';
            } else if (preset === 'today') {
                dateText.textContent = 'Hôm nay';
            } else if (preset === '7days') {
                dateText.textContent = '7 ngày gần nhất';
            } else if (preset === '30days') {
                dateText.textContent = '30 ngày gần nhất';
            } else {
                dateText.textContent = start + ' → ' + end;
            }
        }

        dateButton.addEventListener('click', function (event) {
            event.stopPropagation();
            datePopup.hidden = !datePopup.hidden;
        });

        datePopup.addEventListener('click', function (event) {
            event.stopPropagation();
        });

        document.addEventListener('click', function () {
            datePopup.hidden = true;
        });

        datePreset.addEventListener('change', function () {
            customFields.hidden = datePreset.value !== 'custom';
        });

        applyButton.addEventListener('click', function () {
            const preset = datePreset.value;
            const today = new Date();

            let start;
            let end = formatDate(today);

            if (preset === 'all') {
                updateDateText('', '', 'all');
                datePopup.hidden = true;
                loadDashboard();
                return;
            }

            if (preset === 'today') {
                start = end;
            } else if (preset === '7days' || preset === '30days') {
                const days = preset === '7days' ? 6 : 29;
                const startDate = new Date(today);

                startDate.setDate(startDate.getDate() - days);
                start = formatDate(startDate);
            } else {
                start = startInput.value;
                end = endInput.value;

                if (!start || !end) {
                    alert('Vui lòng chọn đủ ngày bắt đầu và kết thúc.');
                    return;
                }

                if (start > end) {
                    alert('Ngày bắt đầu không được sau ngày kết thúc.');
                    return;
                }
            }

            updateDateText(start, end, preset);
            datePopup.hidden = true;
            loadDashboard(start, end);
        });

        // Tải số liệu thực tế ngay khi mở giao diện.
        loadDashboard();
    });

</script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const navItems = document.querySelectorAll(".sidebar-nav .nav-item");

        const panels = document.querySelectorAll(
            "#seller-dashboard-panel, " +
            "#post-management-panel, " +
            "#order-management-panel, " +
            "#auction-management-panel, " +
            "#seller-profile-panel"
        );

        navItems.forEach(function (item) {
            item.addEventListener("click", function (event) {
                const panelId = item.getAttribute("data-panel");

                // Những mục chưa có panel thì không xử lý.
                if (!panelId) {
                    return;
                }

                event.preventDefault();

                // Ẩn tất cả panel.
                panels.forEach(function (panel) {
                    panel.style.display = "none";
                });

                // Hiện panel được chọn.
                const selectedPanel = document.getElementById(panelId);

                if (selectedPanel) {
                    selectedPanel.style.display = "block";
                }

                // Cập nhật mục đang được chọn trên sidebar.
                navItems.forEach(function (navItem) {
                    navItem.classList.remove("active");
                });

                item.classList.add("active");
            });
        });
    });
</script>
</body>

</html>