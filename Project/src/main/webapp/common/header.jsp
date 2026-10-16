<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<style>
    .user-menu {
        position: relative;
        display: flex;
        align-items: center;
    }

    .user-menu-dropdown {
        display: none;
        position: absolute;
        top: 100%;
        right: 0;
        min-width: 240px;
        padding-top: 10px;
        z-index: 1000;
    }

    .user-menu-panel {
        background: #ffffff;
        border: 1px solid #e2e8f0;
        border-radius: 12px;
        box-shadow: 0 12px 32px rgba(15, 23, 42, 0.14);
        overflow: hidden;
    }

    .user-menu.open .user-menu-dropdown, .user-menu:hover .user-menu-dropdown {
        display: block;
    }

    .user-menu-info {
        padding: 14px 16px;
        border-bottom: 1px solid #e2e8f0;
    }

    .user-menu-name {
        margin: 0;
        font-size: 14px;
        font-weight: 700;
        color: #0f172a;
        word-break: break-word;
    }

    .user-menu-username {
        margin: 2px 0 0;
        font-size: 12px;
        font-weight: 600;
        color: #475569;
        word-break: break-word;
    }

    .user-menu-email {
        margin: 2px 0 0;
        font-size: 12px;
        color: #64748b;
        word-break: break-all;
    }

    .user-menu-item {
        display: block;
        padding: 12px 16px;
        font-size: 13px;
        font-weight: 700;
        color: #2654dc;
        text-decoration: none;
    }

    .user-menu-logout {
        display: block;
        padding: 12px 16px;
        font-size: 13px;
        font-weight: 700;
        color: #dc2626;
        text-decoration: none;
    }

    .user-menu-logout:hover {
        background: #fef2f2;
    }

    .user-menu-item:hover {
        background: #fef2f2;
    }
    /* Nút Đăng nhập / Đăng ký khi chưa đăng nhập */
    .btn-login_register {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 8px 14px;
        border: none;
        border-radius: 8px;
        background-color: var(--color-blue-accent);
        color: #ffffff;
        font-family: var(--font-sans);
        font-size: 12px;
        font-weight: 700;
        text-decoration: none;
        white-space: nowrap;
        cursor: pointer;
        box-shadow: var(--shadow-sm);
        transition: background-color 0.15s ease;
    }
    .btn-login_register:hover {
        background-color: var(--color-primary-dark);
        color: #ffffff;
    }
</style>
<header class="site-header">
    <div class="header-inner"> <!-- Brand Logo --> <a class="brand-identity"
                                                      href="${pageContext.request.contextPath}/main">
        <div class="brand-icon-box"><span class="material-symbols-outlined">menu_book</span></div>
        <div class="brand-text-group"><span class="brand-title">MANGAZ</span> <span
                class="brand-subtitle">COLLECTOR EXCHANGE</span></div>
    </a> <!-- Search Input -->
        <div class="search-container">
            <div class="search-field"> <span class="search-prefix-icon"> <span
                    class="material-symbols-outlined">search</span> </span> <input
                    class="search-input-control" placeholder="Tìm kiếm truyện, bài đăng và users" type="text"/>
            </div>
        </div> <!-- Navigation Links -->
        <nav class="main-navigation"><a class="nav-item active-nav" href="#">Trang chủ</a>
            <div class="nav-dropdown-trigger"><span>Khám phá</span> <span
                    class="material-symbols-outlined icon-expand">expand_more</span></div>
            <a
                    class="nav-item live-auction-link" href="#"> <span class="pulse-status-dot"></span> <span>Đấu
                            giá</span> </a> <a class="nav-item" href="#">Cộng đồng</a>
        </nav> <!-- Action Buttons & Utilities -->
        <div class="header-utilities">
            <button class="btn-trade-post" type="button"> <span
                    class="material-symbols-outlined">add_circle</span> <span>Đăng bài / Trade</span></button>
            <div class="icon-utility-button" title="Yêu thích"> <span
                    class="material-symbols-outlined">favorite_border</span> <span
                    class="utility-badge">2</span></div>
            <div class="icon-utility-button" title="Giỏ hàng"> <span
                    class="material-symbols-outlined">shopping_cart</span> <span class="utility-badge">1</span>
            </div>
            <div class="icon-utility-button" title="Thông báo"> <span
                    class="material-symbols-outlined">notifications</span> <span class="utility-badge">0</span>
            </div> <!-- Profile Avatar Trigger -->

            <c:choose>
                <%-- Đã đăng nhập --%>
                <c:when test="${not empty sessionScope.user}">
                    <div class="user-menu is-logged-in" id="userMenu">
                        <div class="user-avatar-trigger"
                             id="userAvatarTrigger"
                             data-logged-in="true"
                             role="button"
                             tabindex="0"
                             aria-haspopup="true">

                            <img alt="User profile avatar image"
                                 class="user-avatar-img"
                                 src="https://lh3.googleusercontent.com/aida-public/AB6AXuCbxKavvR8kUjvRe_85K1vxKIgd4X86LdgGPiu_SkKlzkmzcXB4fOx5vrolj97DVgsrVm_dhA8v6P6lAQuJ8Bv5vzRoWp-_TxJf8PfMNH8oSc5G9qJgn3zgFD0JadKnt0pMIrdWesa3Jm1sN2yr0ah2CIcSApzWEURl1teMgwpWL98wV54jA0VIgIcvQmp2JOFx0ERJdQPpxjIMDNWNBMhoP0z7vOmmxUGgsYkywIM"/>

                            <span class="material-symbols-outlined icon-chevron">
                    expand_more
                </span>
                        </div>

                        <div class="user-menu-dropdown">
                            <div class="user-menu-panel">
                                <div class="user-menu-info">
                                    <p class="user-menu-name">
                                        <c:out value="${not empty fn:trim(sessionScope.user.fullName)
                                ? fn:trim(sessionScope.user.fullName)
                                : sessionScope.user.username}"/>
                                    </p>

                                    <p class="user-menu-username">
                                        @<c:out value="${sessionScope.user.username}"/>
                                    </p>

                                    <p class="user-menu-email">
                                        <c:out value="${sessionScope.user.email}"/>
                                    </p>
                                </div>

                                    <%-- Chỉ Admin mới thấy mục này --%>
                                <c:if test="${sessionScope.user.role eq 'Admin'}">
                                    <a class="user-menu-item"
                                       href="${pageContext.request.contextPath}/admin/categories">
                            <span class="material-symbols-outlined"
                                  style="font-size: 18px; vertical-align: middle; margin-right: 6px;">
                                admin_panel_settings
                            </span>
                                        Admin page
                                    </a>
                                </c:if>

                                <a class="user-menu-item"
                                   href="${pageContext.request.contextPath}/profile">
                                    Profile
                                </a>

                                <a class="user-menu-logout"
                                   href="${pageContext.request.contextPath}/logout">
                                    Đăng xuất
                                </a>
                            </div>
                        </div>
                    </div>
                </c:when>

                <%-- Chưa đăng nhập --%>
                <c:otherwise>
                    <a class="btn-login_register"
                       href="${pageContext.request.contextPath}/Login.jsp">
                        Đăng nhập/Đăng ký
                    </a>
                </c:otherwise>
            </c:choose>

        </div>
    </div>
</header>