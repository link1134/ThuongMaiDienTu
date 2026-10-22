<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - MangaVault Collector Exchange</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,600;0,700&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
          rel="stylesheet">
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"/>
    <!-- Đảm bảo đường dẫn CSS chính xác -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Cart.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Main.css">
</head>
<body class="site-body">
<jsp:include page="/common/header.jsp"/>

<main class="cart-page-container">
    <div class="back-navigation-bar">
        <a href="${pageContext.request.contextPath}/" class="btn-continue-shopping">
            <span class="material-symbols-outlined">chevron_left</span>
            <span>Tiếp tục mua</span>
        </a>
    </div>
    <hr class="cart-header-divider">

    <div class="cart-layout-grid">
        <!-- CỘT TRÁI: DANH SÁCH GIỎ HÀNG -->
        <div>
            <div class="cart-items-list-header">
                <label class="all-item-check">
                    <input type="checkbox" class="check-box-mod" id="select-all">
                    <span>Tất cả&nbsp;(${cart.items.size()} sản phẩm)</span>
                </label>
                <span>Đơn giá</span>
                <span>Số lượng</span>
                <span>Thành tiền</span>
                <span class="material-symbols-outlined">delete</span>
            </div>

            <div class="infinite-scroll-component">
                <c:choose>
                    <c:when test="${empty cart.items}">
                        <div style="text-align:center; padding: 50px 0;">Giỏ hàng của bạn đang trống.</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="item" items="${cart.items}">
                            <div class="cart-item">
                                <div class="cart-item-information">
                                    <input type="checkbox" class="check-box-mod item-checkbox">
                                    <a href="${pageContext.request.contextPath}/product-detail?id=${item.listingId}">
                                        <img src="${item.productImageUrl}"
                                             alt="Hình ảnh truyện" class="cart-item-image"
                                             >
                                    </a>
                                    <div class="cart-item-more-information">
                                        <a href="${pageContext.request.contextPath}/product-detail?id=${item.listingId}">${item.productTitle}</a>
                                    </div>
                                </div>
                                <div class="cart-item-base-price">
                                    <div class="item-price">
                                        <fmt:formatNumber value="${item.productPrice}" type="currency" currencySymbol=""
                                                          maxFractionDigits="0"/><sup>đ</sup>
                                    </div>
                                </div>
                                <div class="quantity-btn-wrapper">
                                    <!-- Form cập nhật số lượng -->
                                    <form action="${pageContext.request.contextPath}/cart/update" method="POST"
                                          class="quantity-btn">
                                        <input type="hidden" name="cartItemId" value="${item.cartItemId}">
                                        <button type="submit" name="quantity" value="${item.quantity - 1}"
                                                class="material-symbols-outlined quantity-btn-decrease"
                                                style="border:none; background:none; cursor:pointer;">remove
                                        </button>
                                        <input type="tel" value="${item.quantity}" readonly class="quantity-btn-input">
                                        <button type="submit" name="quantity" value="${item.quantity + 1}"
                                                class="material-symbols-outlined quantity-btn-increase"
                                                style="border:none; background:none; cursor:pointer;" ${item.quantity >= item.stockQuantity ? 'disabled' : ''}>
                                            add
                                        </button>
                                    </form>
                                </div>
                                <div>
                                    <div class="item-price">
                                        <fmt:formatNumber value="${item.totalPrice}" type="currency" currencySymbol=""
                                                          maxFractionDigits="0"/><sup>đ</sup>
                                    </div>
                                </div>
                                <!-- Form xóa sản phẩm -->
                                <form action="${pageContext.request.contextPath}/cart/remove" method="POST"
                                      style="margin: 0;">
                                    <input type="hidden" name="cartItemId" value="${item.cartItemId}">
                                    <button type="submit" class="delete-btn"
                                            style="border:none; background:none; cursor:pointer;">
                                        <span class="material-symbols-outlined">delete</span>
                                    </button>
                                </form>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- CỘT PHẢI: THẺ TÓM TẮT & ĐỊA CHỈ -->
        <aside class="cart-summary-column">
            <div class="card-address">
                <div class="card-address-header">
                    <h3>Địa chỉ giao hàng</h3>
                    <button class="change-address-btn">Thay đổi</button>
                </div>

                <div class="card-address-content"
                     id="current-address"
                     data-address-id="${not empty defaultAddress ? defaultAddress.id : ''}">

                    <c:choose>
                        <c:when test="${not empty defaultAddress}">
                            <div class="customer-info">
                                <p id="current-address-name">
                                    <c:out value="${defaultAddress.recipientName}"/>
                                </p>
                                <i></i>
                                <p id="current-address-phone">
                                    <c:out value="${defaultAddress.phoneNumber}"/>
                                </p>
                            </div>

                            <div class="address">
                                <p class="address-content" id="current-address-text">
                                    <c:out value="${defaultAddress.addressDetail}"/>,
                                    <c:out value="${defaultAddress.ward}"/>,
                                    <c:out value="${defaultAddress.cityProvince}"/>
                                </p>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <p style="color: #666;" id="no-current-address">
                                Vui lòng chọn địa chỉ giao hàng.
                            </p>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div>

            <div class="cart-summary-card">
                <div class="summary-breakdown-list">
                    <div class="summary-row total-row">
                        <span class="summary-row-label">Tổng tiền thanh toán</span>
                        <span class="summary-row-val">
                                <fmt:formatNumber value="${cart.cartTotal}" type="currency" currencySymbol=""
                                                  maxFractionDigits="0"/> đ
                            </span>
                    </div>
                </div>
                <div class="checkout-btn-wrapper">
                    <form action="${pageContext.request.contextPath}/checkout" method="GET">
                        <button class="btn-checkout-now" type="submit" ${empty cart.items ? 'disabled' : ''}>
                            <span>Đặt hàng</span>
                        </button>
                    </form>
                </div>
            </div>
        </aside>
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
</footer>
<!-- Script xử lý Select All Checkbox -->


<script src="${pageContext.request.contextPath}/js/Cart.js"></script>
</body>
</html>