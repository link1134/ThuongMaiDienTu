<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Giỏ hàng - MangaVault Collector Exchange</title>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,600;0,700&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
  <!-- Đảm bảo đường dẫn CSS chính xác -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Cart.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Main.css">
</head>
<body class="site-body">
<jsp:include page="/common/header.jsp" />

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
                    <img src="${pageContext.request.contextPath}${item.productImageUrl}" alt="Hình ảnh truyện" class="cart-item-image" onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'">
                  </a>
                  <div class="cart-item-more-information">
                    <a href="${pageContext.request.contextPath}/product-detail?id=${item.listingId}">${item.productTitle}</a>
                  </div>
                </div>
                <div class="cart-item-base-price">
                  <div class="item-price">
                    <fmt:formatNumber value="${item.productPrice}" type="currency" currencySymbol="" maxFractionDigits="0"/><sup>đ</sup>
                  </div>
                </div>
                <div class="quantity-btn-wrapper">
                  <!-- Form cập nhật số lượng -->
                  <form action="${pageContext.request.contextPath}/cart/update" method="POST" class="quantity-btn">
                    <input type="hidden" name="cartItemId" value="${item.cartItemId}">
                    <button type="submit" name="quantity" value="${item.quantity - 1}" class="material-symbols-outlined quantity-btn-decrease" style="border:none; background:none; cursor:pointer;">remove</button>
                    <input type="tel" value="${item.quantity}" readonly class="quantity-btn-input">
                    <button type="submit" name="quantity" value="${item.quantity + 1}" class="material-symbols-outlined quantity-btn-increase" style="border:none; background:none; cursor:pointer;" ${item.quantity >= item.stockQuantity ? 'disabled' : ''}>add</button>
                  </form>
                </div>
                <div>
                  <div class="item-price">
                    <fmt:formatNumber value="${item.totalPrice}" type="currency" currencySymbol="" maxFractionDigits="0"/><sup>đ</sup>
                  </div>
                </div>
                <!-- Form xóa sản phẩm -->
                <form action="${pageContext.request.contextPath}/cart/remove" method="POST" style="margin: 0;">
                  <input type="hidden" name="cartItemId" value="${item.cartItemId}">
                  <button type="submit" class="delete-btn" style="border:none; background:none; cursor:pointer;">
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
        <div class="card-address-content">
          <c:choose>
            <c:when test="${not empty defaultAddress}">
              <div class="customer-info">
                <p id="current-address-name">${defaultAddress.recipientName}</p>
                <i></i>
                <p id="current-address-phone">${defaultAddress.phoneNumber}</p>
              </div>
              <div class="address">
                <p class="address-content" id="current-address-text">
                    ${defaultAddress.addressDetail}, ${defaultAddress.ward}, ${defaultAddress.cityProvince}
                </p>
              </div>
            </c:when>
            <c:otherwise>
              <p style="color: #666;">Vui lòng thêm địa chỉ giao hàng.</p>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

      <div class="cart-summary-card">
        <div class="summary-breakdown-list">
          <div class="summary-row total-row">
            <span class="summary-row-label">Tổng tiền thanh toán</span>
            <span class="summary-row-val">
                                <fmt:formatNumber value="${cart.cartTotal}" type="currency" currencySymbol="" maxFractionDigits="0"/> đ
                            </span>
          </div>
        </div>
        <div class="checkout-btn-wrapper">
          <form action="${pageContext.request.contextPath}/checkout" method="GET">
            <button class="btn-checkout-now" type="submit" ${empty cart.items ? 'disabled' : ''}>
              <span>Tiến Hành Thanh Toán</span>
            </button>
          </form>
        </div>
      </div>
    </aside>
  </div>
</main>

<!-- Script xử lý Select All Checkbox -->
<script>
  const selectAll = document.getElementById("select-all");
  const itemCheckboxes = document.querySelectorAll(".item-checkbox");
  if(selectAll) {
    selectAll.addEventListener("change", function () {
      itemCheckboxes.forEach(checkbox => checkbox.checked = selectAll.checked);
    });
    itemCheckboxes.forEach(function (checkbox) {
      checkbox.addEventListener("change", function () {
        selectAll.checked = [...itemCheckboxes].every(item => item.checked);
      });
    });
  }
</script>
</body>
</html>