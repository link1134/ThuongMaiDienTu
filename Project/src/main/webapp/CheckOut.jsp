<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán - MangaVault Collector Exchange</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,600;0,700;0,800;1,600&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/CheckOut.css">

</head>

<body class="site-body">
<!-- Modal chọn địa chỉ -->
<div class="address-modal-overlay" id="address-modal">
    <div class="address-modal">
        <div class="address-modal-header">
            <h3>Danh sách địa chỉ đã lưu</h3>
            <a href="${pageContext.request.contextPath}/profile">Quản lý địa chỉ</a>
        </div>
        <div class="address-modal-list" id="address-list"></div>
        <div class="address-modal-footer">
            <button type="button" id="cancel-address">Hủy bỏ</button>
            <button type="button" id="confirm-address">Xác nhận</button>
        </div>
    </div>
</div>

<jsp:include page="/common/header.jsp"/>

<main class="cart-page-container">
    <div class="back-navigation-bar">
        <a href="${pageContext.request.contextPath}/cart" class="btn-continue-shopping">
            <span class="material-symbols-outlined">chevron_left</span>
            <span>Quay lại giỏ hàng</span>
        </a>
    </div>

    <hr class="cart-header-divider">

    <c:if test="${not empty errorMessage}">
        <div style="color: red; padding: 10px; font-weight: bold;">${errorMessage}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/checkout" method="POST" id="checkout-form">
        <!-- Hidden Input Địa chỉ -->
        <input type="hidden" name="recipientName" id="input-recipient-name" value="${defaultAddress.recipientName}">
        <input type="hidden" name="phoneNumber" id="input-phone-number" value="${defaultAddress.phoneNumber}">
        <input type="hidden" name="shippingAddress" id="input-shipping-address"
               value="${defaultAddress.addressDetail}, ${defaultAddress.ward}, ${defaultAddress.cityProvince}">

        <div class="cart-layout-grid">
            <div class="cart-left">
                <!-- CHỌN VẬN CHUYỂN -->
                <div class="delivery-type-container">
                    <h3>Chọn hình thức giao hàng</h3>
                    <label class="delivery-type active">
                        <div><input type="radio" name="delivery" value="Vận chuyển nhanh"
                                    class="check-box-mod item-checkbox" checked data-fee="41000"></div>
                        <div class="deliver-type-wrapper">
                            <div class="delivery-info">
                                <span>24 Thg 10 - 26 Thg 10</span>
                                <div class="item-price">41.000<sup>đ</sup></div>
                            </div>
                            <div class="deliver-name-and-des">
                                <span>Vận chuyển nhanh</span>
                            </div>
                        </div>
                    </label>
                    <label class="delivery-type">
                        <div><input type="radio" name="delivery" value="Vận chuyển trong ngày"
                                    class="check-box-mod item-checkbox" data-fee="81000"></div>
                        <div class="deliver-type-wrapper">
                            <div class="delivery-info">
                                <span>Trong ngày</span>
                                <div class="item-price">81.000<sup>đ</sup></div>
                            </div>
                            <div class="deliver-name-and-des">
                                <span>Vận chuyển trong ngày</span>
                            </div>
                        </div>
                    </label>
                </div>

                <!-- CHỌN PHƯƠNG THỨC THANH TOÁN -->
                <div class="payment-method-wrapper">
                    <h3>Chọn cách thanh toán</h3>
                    <label class="payment-method active">
                        <div><input type="radio" name="payment-method" value="COD" class="check-box-mod" checked></div>
                        <div class="payment-method-information">
                            <span class="material-symbols-outlined payment-google-icon-mod">
payments
</span>
                            <div class="payment-method-name-des">
                                <span class="payment-method-name">Thanh toán trực tiếp (COD)</span>
                                <span class="payment-method-des">Trả bằng tiền mặt khi hàng giao tới bạn</span>
                            </div>
                        </div>
                    </label>
                    <label class="payment-method">
                        <div><input type="radio" name="payment-method" value="MoMo" class="check-box-mod"></div>
                        <div class="payment-method-information">
                            <img src="https://cdn.haitrieu.com/wp-content/uploads/2022/10/Logo-MoMo-Square.png" alt="">
                            <div class="payment-method-name-des">
                                <span class="payment-method-name">Ví MoMo</span>
                            </div>
                        </div>
                    </label>
                    <label class="payment-method">
                        <div><input type="radio" name="payment-method" value="ZaloPay" class="check-box-mod"></div>
                        <div class="payment-method-information">
                            <img src="https://cdn.haitrieu.com/wp-content/uploads/2022/10/Logo-ZaloPay-Square.png" alt="">
                            <div class="payment-method-name-des">
                                <span class="payment-method-name">Ví ZaloPay</span>
                            </div>
                        </div>
                    </label>
                </div>
            </div>

            <!-- CỘT PHẢI: TÓM TẮT ĐƠN HÀNG -->
            <aside class="cart-summary-column">
                <div class="card-address">
                    <div class="card-address-header">
                        <h3>Địa chỉ giao hàng</h3>
                        <button type="button" class="change-address-btn">Thay đổi</button>
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
                                <p style="color: red;">Vui lòng cập nhật địa chỉ giao hàng trước khi đặt hàng.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="card-checkout">
                    <div class="card-checkout-header-block">
                        <div class="card-checkout-header">
                            <h3>Đơn hàng</h3>
                        </div>
                        <div class="card-checkout-subheader">
                            <p>${cart.items.size()} sản phẩm</p>
                            <div class="more-checkout-info-btn" style="cursor: pointer;">
                                <p>Xem thông tin</p>
                                <span class="material-symbols-outlined">keyboard_arrow_down</span>
                            </div>
                        </div>
                    </div>

                    <!-- DANH SÁCH MẶT HÀNG -->
                    <div class="order-item-list" style="display: none;">
                        <c:forEach var="item" items="${cart.items}">
                            <div class="order-item">
                                <div class="item-info">
                                    <div class="item-info-quantity">${item.quantity}x</div>
                                    <div class="item-info-name">${item.productTitle}</div>
                                </div>
                                <div class="order-item-price" style="color: black;">
                                    <fmt:formatNumber value="${item.totalPrice}" pattern="#,##0"/><sup>đ</sup>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="card-checkout-content">
                        <div class="summary-checkout-info">
                            <div class="summary-checkout-info-label">Tổng tiền hàng</div>
                            <div class="item-price" style="color: black;">
                                    <span id="merchandise-total" data-value="${cart.cartTotal}">
                                        <fmt:formatNumber value="${cart.cartTotal}" pattern="#,##0"/>
                                    </span><sup>đ</sup>
                            </div>
                        </div>
                        <div class="summary-checkout-info">
                            <div class="summary-checkout-info-label">Phí vận chuyển</div>
                            <div class="item-price" style="color: black;">
                                <span id="shipping-fee-display">41.000</span><sup>đ</sup>
                            </div>
                        </div>
                    </div>

                    <div class="crossbar"></div>

                    <div class="summary-checkout-totalPrice">
                        <div class="summary-checkout-total-label">Tổng tiền thanh toán</div>
                        <div class="summary-checkout-total-value">
                                <span id="final-total-display">
                                    <fmt:formatNumber value="${cart.cartTotal + 41000}" pattern="#,##0"/>
                                </span><sup>đ</sup>
                        </div>
                    </div>

                    <p class="summary-additional-text">
                        (Giá này đã bao gồm thuế GTGT, phí đóng gói, phí vận chuyển và các chi phí phát sinh khác)
                    </p>

                    <div class="checkout-btn-wrapper">
                        <button type="submit" class="checkout-btn" ${empty defaultAddress ? 'disabled' : ''}>
                            Đặt hàng
                        </button>
                    </div>
                </div>
            </aside>
        </div>
    </form>
</main>

<footer class="site-main-footer">
    <div class="footer-inner-shell">
        <div class="footer-legal-bar">
            <p>© 2025 MangaVault Exchange Inc. Mọi quyền được bảo lưu.</p>
        </div>
    </div>
</footer>

<!-- Scripts -->
<script>
    // Toggle Danh sách mặt hàng
    const toggleBtn = document.querySelector('.more-checkout-info-btn');
    const orderList = document.querySelector('.order-item-list');
    const arrowIcon = toggleBtn.querySelector('.material-symbols-outlined');

    toggleBtn.addEventListener('click', function () {
        if (orderList.style.display === 'none') {
            orderList.style.display = 'grid';
            arrowIcon.textContent = 'keyboard_arrow_up';
        } else {
            orderList.style.display = 'none';
            arrowIcon.textContent = 'keyboard_arrow_down';
        }
    });

    // Tính toán tổng tiền động khi chọn hình thức vận chuyển
    const deliveryRadios = document.querySelectorAll('input[name="delivery"]');
    const merchTotal = parseFloat(document.getElementById('merchandise-total').dataset.value);
    const shippingFeeDisplay = document.getElementById('shipping-fee-display');
    const finalTotalDisplay = document.getElementById('final-total-display');

    deliveryRadios.forEach(radio => {
        radio.addEventListener('change', function () {
            document.querySelectorAll('.delivery-type').forEach(item => item.classList.remove('active'));
            if (this.checked) {
                this.closest('.delivery-type').classList.add('active');
                const fee = parseFloat(this.dataset.fee);
                shippingFeeDisplay.innerText = new Intl.NumberFormat('vi-VN').format(fee);
                finalTotalDisplay.innerText = new Intl.NumberFormat('vi-VN').format(merchTotal + fee);
            }
        });
    });

    // Đổi active cho phương thức thanh toán
    const paymentRadios = document.querySelectorAll('input[name="payment-method"]');
    paymentRadios.forEach(radio => {
        radio.addEventListener('change', function () {
            document.querySelectorAll('.payment-method').forEach(item => item.classList.remove('active'));
            if (this.checked) {
                this.closest('.payment-method').classList.add('active');
            }
        });
    });

    // Modal Chọn Địa chỉ giao hàng
    const addressModal = document.getElementById("address-modal");
    const addressList = document.getElementById("address-list");
    const currentName = document.getElementById("current-address-name");
    const currentPhone = document.getElementById("current-address-phone");
    const currentAddress = document.getElementById("current-address-text");

    const savedAddresses = [
        <c:forEach var="addr" items="${addresses}" varStatus="st">
        {
            name: "${addr.recipientName}",
            phone: "${addr.phoneNumber}",
            address: "${addr.addressDetail}, ${addr.ward}, ${addr.cityProvince}",
            isDefault: ${addr.defaultAddress}
        }${!st.last ? ',' : ''}
        </c:forEach>
    ];

    document.querySelector(".change-address-btn").addEventListener("click", function () {
        addressList.innerHTML = "";
        savedAddresses.forEach(function (address, index) {
            const label = document.createElement("label");
            label.className = "address-option";
            label.style.display = "block";
            label.style.marginBottom = "10px";
            label.innerHTML = `
                    <input type="radio" name="selected-address" value="\${index}" \${index === 0 ? "checked" : ""}>
                    <strong>\${address.name}</strong> (\${address.phone}) - \${address.address}
                `;
            addressList.appendChild(label);
        });
        addressModal.style.display = "flex";
    });

    document.getElementById("cancel-address").addEventListener("click", () => addressModal.style.display = "none");

    document.getElementById("confirm-address").addEventListener("click", function () {
        const selected = document.querySelector('input[name="selected-address"]:checked');
        if (selected && savedAddresses[selected.value]) {
            const addr = savedAddresses[selected.value];
            if (currentName) currentName.textContent = addr.name;
            if (currentPhone) currentPhone.textContent = addr.phone;
            if (currentAddress) currentAddress.textContent = addr.address;

            document.getElementById('input-recipient-name').value = addr.name;
            document.getElementById('input-phone-number').value = addr.phone;
            document.getElementById('input-shipping-address').value = addr.address;
        }
        addressModal.style.display = "none";
    });
</script>
<!-- XỬ LÝ POPUP THÔNG BÁO THÀNH CÔNG VÀ CHUYỂN HƯỚNG VỀ TRANG CHỦ -->
<c:if test="${orderSuccess eq true}">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            Swal.fire({
                title: 'Đặt hàng thành công!',
                text: 'Cảm ơn bạn đã mua hàng tại MangaZ. Đơn hàng của bạn đang được hệ thống xử lý!',
                icon: 'success',
                confirmButtonText: 'Trở về trang chủ',
                confirmButtonColor: '#10b981',
                allowOutsideClick: false, // Bắt buộc người dùng tương tác
                allowEscapeKey: false
            }).then((result) => {
                if (result.isConfirmed) {
                    // Chuyển hướng về Trang chủ sau khi người dùng bấm nút
                    window.location.href = '${pageContext.request.contextPath}/';
                }
            });
        });
    </script>
</c:if>

<!-- POPUP BÁO LỖI NẾU ĐẶT HÀNG THẤT BẠI -->
<c:if test="${not empty errorMessage}">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            Swal.fire({
                title: 'Đặt hàng không thành công!',
                text: '${errorMessage}',
                icon: 'error',
                confirmButtonText: 'Thử lại',
                confirmButtonColor: '#ef4444'
            });
        });
    </script>
</c:if>
</body>
</html>