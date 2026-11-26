<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đơn hàng - MangaVault Admin</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/QuanlyDanhMuc.css">
    <style>

        .orders-page {
            display: flex;
            flex-direction: column;
            gap: 24px;
            min-width: 0;
        }

        .orders-stats {
            display: grid;
            grid-template-columns: repeat(2, minmax(180px, 1fr));
            gap: 16px;
        }

        .orders-tab-panel {
            background: #fff;
            border: 1px solid var(--color-border-default);
            border-radius: 16px;
            box-shadow: var(--shadow-sm);
            padding: 18px 20px;
        }

        .orders-tab-content {
            display: none;
            padding-top: 18px;
        }

        .orders-tab-content.active {
            display: block;
        }

        .orders-toolbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 16px;
        }

        .orders-search-filter {
            display: flex;
            align-items: center;
            gap: 10px;
            flex: 1;
            min-width: min(100%, 280px);
        }

        .orders-search-box {
            position: relative;
            flex: 1;
            min-width: 220px;
        }

        .orders-search-box .material-symbols-outlined {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--color-text-slate-500);
            font-size: 19px;
        }

        .orders-search-input {
            width: 100%;
            min-height: 42px;
            padding: 10px 12px 10px 40px;
            border: 1px solid var(--color-border-default);
            border-radius: 10px;
            outline: none;
            font: inherit;
            background: #fff;
        }

        .orders-search-input:focus {
            border-color: #93c5fd;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, .08);
        }

        .orders-filter-select {
            min-height: 42px;
            border: 1px solid var(--color-border-default);
            border-radius: 10px;
            padding: 0 12px;
            background: #fff;
            color: var(--color-text-slate-700);
            font: inherit;
        }

        .order-card, .cancel-card {
            background: #fff;
            border: 1px solid var(--color-border-default);
            border-radius: 14px;
            margin-bottom: 14px;
            overflow: hidden;
            box-shadow: var(--shadow-sm);
        }

        .order-card {
            border-left: 4px solid #f59e0b;
        }

        .order-card.shipping { border-left-color: #6366f1; }
        .order-card.completed { border-left-color: #10b981; }
        .order-card.cancelled { border-left-color: #ef4444; }

        .order-top {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
            padding: 14px 18px;
            border-bottom: 1px solid var(--color-border-subtle);
        }

        .order-id {
            font-weight: 800;
            color: var(--color-text-dark);
        }

        .status {
            display: inline-flex;
            align-items: center;
            border-radius: 999px;
            padding: 5px 10px;
            font-size: 10px;
            font-weight: 800;
            background: #fff7ed;
            color: #c2410c;
        }

        .status.shipping { background: #eef2ff; color: #4338ca; }
        .status.completed { background: #ecfdf5; color: #047857; }
        .status.cancelled { background: #fef2f2; color: #b91c1c; }

        .order-body {
            display: grid;
            grid-template-columns: 1.2fr 1fr .8fr;
            gap: 18px;
            padding: 18px;
        }

        .order-info { min-width: 0; }
        .order-info strong {
            display: block;
            font-size: 13px;
            margin-bottom: 7px;
            color: var(--color-text-dark);
        }

        .order-info p {
            margin: 5px 0;
            color: var(--color-text-slate-500);
            font-size: 12px;
            line-height: 1.6;
            overflow-wrap: anywhere;
        }

        .info-label {
            color: var(--color-text-slate-500);
            font-size: 10px;
            font-weight: 800;
            margin-bottom: 8px;
            letter-spacing: .04em;
        }

        .buyer-info, .price-info {
            border-left: 1px solid var(--color-border-subtle);
            padding-left: 18px;
        }

        .price-info { text-align: right; }
        .price {
            font-size: 20px;
            font-weight: 800;
            color: #2563eb;
        }

        .cancel-card { padding: 18px; }
        .cancel-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            margin-bottom: 12px;
        }

        .cancel-reason {
            background: #f8fafc;
            border: 1px solid var(--color-border-subtle);
            border-radius: 10px;
            padding: 13px;
            margin: 12px 0;
            color: var(--color-text-slate-700);
            line-height: 1.6;
        }

        .orders-action-row {
            display: flex;
            justify-content: flex-end;
            flex-wrap: wrap;
            gap: 8px;
        }

        .orders-btn {
            border: 1px solid var(--color-border-default);
            background: #fff;
            border-radius: 9px;
            padding: 9px 14px;
            font: inherit;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
        }

        .orders-btn-approve {
            color: #fff;
            background: #2563eb;
            border-color: #2563eb;
        }

        .orders-btn-reject {
            color: #b91c1c;
            border-color: #fecaca;
        }

        .orders-empty {
            text-align: center;
            padding: 48px 16px;
            color: var(--color-text-slate-500);
        }

        .orders-empty .material-symbols-outlined {
            display: block;
            font-size: 38px;
            margin-bottom: 10px;
        }

        .orders-message {
            padding: 13px 16px;
            background: #ecfdf5;
            border: 1px solid #bbf7d0;
            color: #047857;
            border-radius: 10px;
        }

        @media (max-width: 900px) {
            .order-body { grid-template-columns: 1fr 1fr; }
            .price-info {
                grid-column: 1 / -1;
                border-left: 0;
                border-top: 1px solid var(--color-border-subtle);
                padding: 14px 0 0;
                text-align: left;
            }
        }

        @media (max-width: 650px) {
            .orders-stats { grid-template-columns: 1fr 1fr; }
            .orders-search-filter { flex-direction: column; align-items: stretch; }
            .orders-search-box { min-width: 100%; }
            .orders-filter-select { width: 100%; }
            .order-body { grid-template-columns: 1fr; }
            .buyer-info {
                border-left: 0;
                border-top: 1px solid var(--color-border-subtle);
                padding: 14px 0 0;
            }
            .orders-tab-panel { padding: 14px; }
        }
    </style>
</head>

<body class="site-body">

<jsp:include page="/common/header.jsp"/>

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
                    <li><a href="${pageContext.request.contextPath}/admin/categories"
                           class="admin-nav-item">
                        <span class="material-symbols-outlined">category</span>
                        <span>Quản lý Danh mục</span>
                    </a></li>
                    <li><a href="#" class="admin-nav-item">
                        <span class="material-symbols-outlined">menu_book</span>
                        <span>Master Catalog</span>
                    </a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/orderManager"
                           class="admin-nav-item active">
                        <span class="material-symbols-outlined">local_shipping</span>
                        <span>Quản lý Đơn hàng</span>
                    </a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/userManager"
                           class="admin-nav-item">
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
            <div class="admin-page-header">
                <div class="admin-header-titles">
                    <h1 class="admin-page-title">Quản lý Đơn hàng &amp; Vận chuyển</h1>
                    <p class="admin-page-subtitle">
                        Theo dõi đơn hàng, kiểm soát trạng thái và xử lý yêu cầu hủy đơn.
                    </p>
                </div>
            </div>

            <div class="admin-metrics-grid orders-stats">
                <div class="metric-kpi-card">
                    <div class="metric-info-col">
                        <span class="metric-kpi-label">Đơn hàng cần xử lý</span>
                        <span class="metric-kpi-value">${pendingOrders}</span>
                        <span class="metric-kpi-subtext">Pending / Processing</span>
                    </div>
                    <div class="metric-icon-box">
                        <span class="material-symbols-outlined">pending_actions</span>
                    </div>
                </div>
                <div class="metric-kpi-card">
                    <div class="metric-info-col">
                        <span class="metric-kpi-label">Đơn hàng đang giao</span>
                        <span class="metric-kpi-value">${shippingOrders}</span>
                        <span class="metric-kpi-subtext blue-text">Shipping</span>
                    </div>
                    <div class="metric-icon-box blue-box">
                        <span class="material-symbols-outlined">local_shipping</span>
                    </div>
                </div>
            </div>

            <c:if test="${not empty sessionScope.cancellationMessage}">
                <div class="orders-message">
                    <c:out value="${sessionScope.cancellationMessage}"/>
                </div>
                <c:remove var="cancellationMessage" scope="session"/>
            </c:if>

            <section class="orders-tab-panel">
                <div class="admin-toolbar-row">
                    <div class="category-tabs-group">
                        <button type="button" class="tab-category-btn active"
                                onclick="showTab('ordersTab', this)">
                            <span class="material-symbols-outlined">receipt_long</span>
                            <span>Tất cả đơn hàng</span>
                            <span class="tab-count-badge">${fn:length(adminOrders)}</span>
                        </button>
                        <button type="button" class="tab-category-btn"
                                onclick="showTab('cancellationsTab', this)">
                            <span class="material-symbols-outlined">assignment_return</span>
                            <span>Yêu cầu hủy</span>
                            <span class="tab-count-badge">${pendingCancellationCount}</span>
                        </button>
                    </div>
                </div>

                <div id="ordersTab" class="orders-tab-content active">

                    <div class="orders-toolbar">
                        <div class="orders-search-filter">
                            <div class="orders-search-box">
                                <span class="material-symbols-outlined">search</span>
                                <input class="orders-search-input" type="text" id="orderSearch"
                                       placeholder="Tìm theo mã đơn, tên người nhận, số điện thoại...">
                            </div>

                            <select class="orders-filter-select" id="statusFilter">
                                <option value="">Tất cả trạng thái</option>
                                <option value="pending">Pending</option>
                                <option value="processing">Processing</option>
                                <option value="shipping">Shipping</option>
                                <option value="completed">Completed</option>
                                <option value="cancelled">Cancelled</option>
                            </select>
                        </div>
                    </div>

                    <div id="orderList">

                        <c:forEach var="item" items="${adminOrders}">
                            <c:set var="order" value="${item.order}"/>

                            <div class="order-card
                            ${order.status eq 'Shipping' ? 'shipping' :
                              order.status eq 'Completed' ? 'completed' :
                              order.status eq 'Cancelled' ? 'cancelled' : ''}"
                                 data-search="${order.orderId} ${item.buyerName} ${order.recipientName} ${order.phoneNumber}"
                                 data-status="${fn:toLowerCase(order.status)}">

                                <div class="order-top">
                                <span class="order-id">
                                    #${order.orderId}
                                </span>

                                    <span class="status
                                    ${order.status eq 'Shipping' ? 'shipping' :
                                      order.status eq 'Completed' ? 'completed' :
                                      order.status eq 'Cancelled' ? 'cancelled' : ''}">
                                    <c:out value="${order.status}"/>
                                </span>

                                    <span style="color:#9299a8;font-size:10px;">
                                    <c:if test="${not empty order.createdAt}">
                                        Đặt lúc:
                                        <fmt:formatDate value="${order.createdAt}"
                                                        pattern="HH:mm - dd/MM/yyyy"/>
                                    </c:if>
                                </span>
                                </div>

                                <div class="order-body">

                                    <div class="order-info">
                                        <div class="info-label">THÔNG TIN NGƯỜI NHẬN</div>

                                        <strong>
                                            <c:out value="${order.recipientName}"/>
                                        </strong>

                                        <p>
                                            Số điện thoại:
                                            <c:out value="${order.phoneNumber}"/>
                                        </p>

                                        <p>
                                            Địa chỉ:
                                            <c:out value="${order.shippingAddress}"/>
                                        </p>

                                        <p>
                                            Phương thức giao:
                                            <c:out value="${order.deliveryMethod}"/>
                                        </p>
                                    </div>

                                    <div class="order-info buyer-info">
                                        <div class="info-label">NGƯỜI MUA</div>

                                        <strong>
                                            <c:out value="${item.buyerName}"/>
                                        </strong>

                                        <p>Mã người dùng: ${order.userId}</p>

                                        <p>
                                            Thanh toán:
                                            <c:out value="${order.paymentMethod}"/>
                                        </p>

                                        <p>
                                            Trạng thái thanh toán:
                                            <c:out value="${item.paymentStatus}"/>
                                        </p>
                                    </div>

                                    <div class="order-info price-info">
                                        <div class="info-label">TỔNG TIỀN ĐƠN HÀNG</div>

                                        <div class="price">
                                            <fmt:formatNumber value="${order.totalAmount}"
                                                              pattern="#,##0"/> đ
                                        </div>

                                        <p>
                                            Phí vận chuyển:
                                            <fmt:formatNumber value="${order.shippingFee}"
                                                              pattern="#,##0"/> đ
                                        </p>
                                    </div>

                                </div>

                            </div>
                        </c:forEach>

                        <c:if test="${empty adminOrders}">
                            <div class="orders-empty">
                                <span class="material-symbols-outlined">inventory_2</span>
                                Chưa có đơn hàng nào.
                            </div>
                        </c:if>

                    </div>
                </div>

                <!-- TAB 2: CANCELLATION REQUESTS -->

                <div id="cancellationsTab" class="orders-tab-content">

                    <div class="orders-toolbar">
                        <div class="orders-search-filter">
                            <div class="orders-search-box">
                                <span class="material-symbols-outlined">search</span>
                                <input class="orders-search-input" type="text" id="cancelSearch"
                                       placeholder="Tìm theo mã yêu cầu, mã đơn hoặc người mua...">
                            </div>

                            <select class="orders-filter-select" id="cancelStatusFilter">
                                <option value="">Tất cả yêu cầu</option>
                                <option value="pending">Đang chờ duyệt</option>
                                <option value="approved">Đã duyệt</option>
                                <option value="rejected">Đã từ chối</option>
                            </select>
                        </div>
                    </div>

                    <div id="cancelList">

                        <c:forEach var="item" items="${cancellationRequests}">
                            <div class="cancel-card"
                                 data-search="${item.requestId} ${item.orderId} ${item.buyerName}"
                                 data-status="${fn:toLowerCase(item.requestStatus)}">

                                <div class="cancel-header">
                                    <div>
                                        <strong>Yêu cầu #${item.requestId}</strong>
                                        <span style="color:#8991a1;margin-left:8px;">
                                        Đơn hàng #${item.orderId}
                                    </span>
                                    </div>

                                    <span class="status
                                    ${item.requestStatus eq 'Approved' ? 'completed' :
                                      item.requestStatus eq 'Rejected' ? 'cancelled' : ''}">
                                    <c:out value="${item.requestStatus}"/>
                                </span>
                                </div>

                                <p>
                                    Người yêu cầu:
                                    <strong><c:out value="${item.buyerName}"/></strong>
                                </p>

                                <p>
                                    Trạng thái đơn:
                                    <c:out value="${item.orderStatus}"/>
                                </p>

                                <div class="cancel-reason">
                                    <strong>Lý do hủy:</strong><br>
                                    <c:out value="${item.reason}"/>
                                </div>

                                <c:if test="${item.requestStatus eq 'Pending'}">
                                    <div class="orders-action-row">

                                        <form action="${pageContext.request.contextPath}/admin/cancellation"
                                              method="POST"
                                              onsubmit="return confirm('Bạn chắc chắn muốn duyệt yêu cầu hủy này?');">

                                            <input type="hidden" name="requestId"
                                                   value="${item.requestId}">
                                            <input type="hidden" name="action"
                                                   value="approve">

                                            <button type="submit" class="orders-btn orders-btn-approve">
                                                Duyệt yêu cầu
                                            </button>
                                        </form>

                                        <form action="${pageContext.request.contextPath}/admin/cancellation"
                                              method="POST"
                                              onsubmit="return confirm('Bạn chắc chắn muốn từ chối yêu cầu này?');">

                                            <input type="hidden" name="requestId"
                                                   value="${item.requestId}">
                                            <input type="hidden" name="action"
                                                   value="reject">

                                            <input type="hidden" name="adminNote"
                                                   value="Yêu cầu không được Admin chấp thuận.">

                                            <button type="submit" class="orders-btn orders-btn-reject">
                                                Từ chối
                                            </button>
                                        </form>

                                    </div>
                                </c:if>

                            </div>
                        </c:forEach>

                        <c:if test="${empty cancellationRequests}">
                            <div class="orders-empty">
                                <span class="material-symbols-outlined">task_alt</span>
                                Chưa có yêu cầu hủy đơn hàng.
                            </div>
                        </c:if>

                    </div>
                </div>

            </section>
        </section>
    </div>
</main>

<script>
    // Chuyển đổi giữa hai tab
    function showTab(tabId, button) {
        document.querySelectorAll('.orders-tab-content').forEach(tab => {
            tab.classList.remove('active');
        });

        document.querySelectorAll('.tab-category-btn').forEach(btn => {
            btn.classList.remove('active');
        });

        document.getElementById(tabId).classList.add('active');
        button.classList.add('active');
    }

    // Tìm kiếm và lọc đơn hàng
    function filterCards(searchId, statusId, listId) {
        const search = document.getElementById(searchId).value.toLowerCase();
        const status = document.getElementById(statusId).value.toLowerCase();

        document.querySelectorAll('#' + listId + ' [data-search]').forEach(card => {
            const searchText = card.dataset.search.toLowerCase();
            const cardStatus = card.dataset.status.toLowerCase();

            const matchSearch = searchText.includes(search);
            const matchStatus = status === '' || cardStatus === status;

            card.style.display = matchSearch && matchStatus ? '' : 'none';
        });
    }

    document.getElementById('orderSearch').addEventListener('input', () => {
        filterCards('orderSearch', 'statusFilter', 'orderList');
    });

    document.getElementById('statusFilter').addEventListener('change', () => {
        filterCards('orderSearch', 'statusFilter', 'orderList');
    });

    document.getElementById('cancelSearch').addEventListener('input', () => {
        filterCards('cancelSearch', 'cancelStatusFilter', 'cancelList');
    });

    document.getElementById('cancelStatusFilter').addEventListener('change', () => {
        filterCards('cancelSearch', 'cancelStatusFilter', 'cancelList');
    });
</script>

</body>
</html>
