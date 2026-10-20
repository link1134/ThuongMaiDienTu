<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.title}</title> <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link
            href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,600;0,700;0,800;1,600&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
            rel="stylesheet"> <!-- Google Material Symbols Outlined -->
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"/>
    <!-- Tệp CSS trang chi tiết -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/BookDetail.css"/>
</head>

<body class="site-body">
<jsp:include page="/common/header.jsp"/>
<main class="main-page-container">
    <!-- Breadcrumb & Tiện ích đầu trang (Đúng chuẩn breadcrumb thông tin cá nhân) -->
    <div class="breadcrumb-bar-row">
        <nav class="breadcrumb-nav"><a href="#">Trang chủ</a> <span class="bc-sep">/</span> <a href="#">Danh mục
            Manga</a> <span class="bc-sep">/</span> <a href="#">Shonen</a> <span class="bc-sep">/</span> <a
                href="#">One Piece</a> <span class="bc-sep">/</span> <span class="bc-current">One Piece – Tập 1 (Bản
                    in đầu 2003)</span></nav>
        <div class="detail-top-actions">
            <button class="btn-save-shelf" type="button" title="Theo dõi"> <span
                    class="material-symbols-outlined">favorite_border</span>
            </button>
            <button class="btn-icon-action" type="button" title="Chia sẻ bài đăng"> <span
                    class="material-symbols-outlined">share</span></button>
            <button class="btn-icon-action"
                    type="button" title="Báo cáo tin đăng"><span class="material-symbols-outlined">flag</span>
            </button>
        </div>
    </div> <!-- BỐ CỤC CHI TIẾT SẢN PHẨM: 2 CỘT (SLAB TRƯNG BÀY & THÔNG TIN MUA BÁN) -->
    <div class="product-detail-layout">
        <!-- CỘT TRÁI: KHUNG TRƯNG BÀY SLAB ACRYLIC GRADE & HÌNH ẢNH CHI TIẾT -->
        <div class="slab-gallery-column">
            <div class="slab-showcase-card">
                <div class="manga-acrylic-slab">
                    <div class="slab-inner-book"> <!-- Chèn ảnh bìa sách chính -->
                        <c:choose>
                            <c:when test="${not empty product.coverImageUrl}">
                                <img class="slab-book-cover"
                                     src="<c:out value='${product.coverImageUrl}'/>"
                                     alt="<c:out value='${product.title}'/>">
                            </c:when>
                            <c:otherwise>
                                <div class="slab-book-cover">Chưa có ảnh sản phẩm</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <!-- <div class="slab-zoom-hint"> <span class="material-symbols-outlined"
                        style="font-size: 16px;">zoom_in</span> <span>Hover để soi rõ
                        </span> </div> -->
            </div> <!-- Dải ảnh thu nhỏ đa góc chụp -->
            <div class="gallery-thumbnails-strip">
                <c:forEach var="imageUrl" items="${product.imageUrls}" varStatus="status">
                    <div class="thumb-item ${status.first ? 'active' : ''}">
                        <div class="thumb-frame">
                            <img class="thumb-img"
                                 src="<c:out value='${imageUrl}'/>"
                                 alt="Ảnh sản phẩm ${status.count}">
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
        <div class="product-info-column">
            <div class="small-description">
                <!-- Chỗ này có nhiều hơn 1 tác giả thì TRƯỚC TÁC GIẢ CUỐI, cho nó cái ,&nbsp; -->
                <span class="author-row">
                        <h6>Tác giả:&nbsp;<a href="">Eiichiro Oda <span>,&nbsp;</span></a> <a href="">Tác giả gì gì
                                đó</a></h6>
                    </span>
                <h1 class="product-headline-title"><c:out value="${product.title}"/></h1>
                <p class="sell-number">Bài đăng #<c:out value="${product.productId}"/></p>
                <p class="product-synopsis"><c:out value="${product.shortDescription}"
                                                   default="Chưa có mô tả cho sản phẩm này."/></p>
                <!-- Tình trạng sách tóm tắt -->
                <div class="price-main-cluster">
                        <span class="main-price">
                            <fmt:formatNumber value="${product.price}" pattern="#,##0"/> đ
                        </span>
                    <c:if test="${product.originalPrice != null and product.originalPrice gt product.price}">
                        <span class="original-price">
                            <fmt:formatNumber value="${product.originalPrice}" pattern="#,##0"/> đ
                        </span>
                        <span class="discount-badge">
                            -<fmt:formatNumber
                                value="${(product.originalPrice - product.price) / product.originalPrice * 100}"
                                maxFractionDigits="0"/>%
                        </span>
                    </c:if>
                </div>
            </div>
            <div class="purchase-commerce-card">


                <div class="price-listing-row">
                    <div class="quantity-section">
                        <div class="price-listing-label">Số lượng</div>

                        <div class="quantity-control-row">
                            <div class="quantity-row">
                                <button type="button" class="quantity-btn">−</button>
                                <input type="number" class="quantity-input" value="1" min="1"
                                       max="${product.stockQuantity}">
                                <button type="button" class="quantity-btn">+</button>
                            </div>

                            <span class="stock-quantity"><c:out
                                    value="${product.stockQuantity}"/> sản phẩm có sẵn</span>
                        </div>
                    </div>

                    <div class="subtotal-section">
                        <div class="price-listing-label">Tạm tính</div>
                        <span class="current-price"><fmt:formatNumber value="${product.price}"
                                                                      pattern="#,##0"/> đ</span>
                    </div>
                </div>


                <div class="escrow-guarantee-note"><span class="material-symbols-outlined">verified</span>
                    <span>Đã hoàn tất giám định vật lý bởi MangaVault Labs</span>
                </div>
                <div class="checkout-buttons-row">
                    <button class="btn-buy-now" type="button"> <span
                            class="material-symbols-outlined">shopping_bag</span> <span>Mua ngay</span>
                    </button>
                    <button class="btn-cart-square" type="button" title="Thêm vào giỏ hàng"> <span
                            class="material-symbols-outlined">shopping_cart</span></button>
                </div>

            </div>
            <div class="seller-profile-card">
                <!-- Hàng 1: Avatar, Tên, Huy hiệu uy tín và Thời gian phản hồi -->
                <div class="seller-top-row">
                    <div class="seller-identity-cluster"><img class="seller-avatar-img"
                                                              src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=120&q=80"
                                                              alt="Kenji Vault">
                        <div class="seller-info-meta">
                            <div class="seller-name-row"> <span class="seller-display-name">Kenji
                                        Vault</span> <span class="material-symbols-outlined icon-verified-blue"
                                                           title="Đã xác minh">verified</span>
                            </div>
                            <span class="seller-reputation-badge">Online 30 phút trước</span>
                            <button class="seller-info-action-btn">Nhắn tin riêng</button>
                        </div>
                    </div>
                    <div class="seller-response-pill"><span class="pulse-status-dot-green"></span>
                        <span>Phản hồi &lt; 15 phút</span>
                    </div>
                </div>

            </div>

        </div>
    </div> <!-- BẢNG THÔNG SỐ VÀ TÌNH TRẠNG KỸ THUẬT CHI TIẾT -->

    <!-- BANG THONG SO, TINH TRANG VA MO TA SAN PHAM -->
    <div class="spec-tabs-container">

        <!-- Cac tab dieu huong -->
        <div class="spec-tabs-nav">
            <button class="tab-nav-btn active"
                    type="button"
                    data-tab="condition">
                <span>Bảng Thông Số &amp; Tình Trạng</span>
            </button>

            <button class="tab-nav-btn"
                    type="button"
                    data-tab="description">
                <span>Mô tả sản phẩm</span>
            </button>

            <!-- Chua trien khai binh luan -->
            <button class="tab-nav-btn"
                    type="button"
                    disabled
                    title="Tính năng đang được phát triển">
                <span>Bình luận &amp; Hỏi Đáp</span>
                <span class="tab-counter-badge">4</span>
            </button>
        </div>

        <!-- TAB 1: THONG SO VA TINH TRANG -->
        <div class="spec-tab-panel" id="condition-panel">

            <div class="spec-table-grid">

                <!-- Cot trai -->
                <div>
                    <div class="spec-row">
                        <span class="spec-label">Tác giả &amp; Minh hoạ</span>
                        <span class="spec-value">Eiichiro Oda</span>
                    </div>

                    <div class="spec-row">
                        <span class="spec-label">Số trang thực tế</span>
                        <span class="spec-value">208 / 208 trang (Đầy đủ)</span>
                    </div>

                    <div class="spec-row">
                        <span class="spec-label">Mức độ ố vàng giấy</span>
                        <span class="spec-value highlight-blue">
                        ~10% viền mép ngoài tự nhiên
                    </span>
                    </div>

                    <div class="spec-row">
                        <span class="spec-label">Tình trạng viết vẽ / Tẩy xóa</span>
                        <span class="spec-value highlight-blue">
                        Không có dấu vết (Pristine)
                    </span>
                    </div>
                </div>

                <!-- Cot phai -->
                <div>
                    <div class="spec-row">
                        <span class="spec-label">Năm phát hành</span>
                        <span class="spec-value">2003 (Bản in đầu)</span>
                    </div>

                    <div class="spec-row">
                        <span class="spec-label">Quy cách đóng gáy</span>
                        <span class="spec-value">Thẳng đều, keo zin 9.5/10</span>
                    </div>

                    <div class="spec-row">
                        <span class="spec-label">Phụ kiện đi kèm</span>
                        <span class="spec-value">01 Áo bọc ngoài, 01 Bookmark</span>
                    </div>

                    <div class="spec-row">
                        <span class="spec-label">Độ phẳng của bìa lót</span>
                        <span class="spec-value">Phẳng 100%, không quăn mép</span>
                    </div>
                </div>

            </div>
        </div>

        <!-- TAB 2: MO TA CHI TIET -->
        <div class="spec-tab-panel"
             id="description-panel"
             hidden>

            <div class="product-description-content">
                <c:choose>
                    <c:when test="${not empty product.description}">
                        <p class="product-long-description"><c:out
                                value="${product.description}"/></p>
                    </c:when>

                    <c:otherwise>
                        <p class="product-description-empty">
                            Người bán chưa cung cấp mô tả chi tiết cho sản phẩm này.
                        </p>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>

    </div>
    <!-- BỘ SƯU TẬP TƯƠNG QUAN / TẬP KHÁC CÙNG BỘ -->
    <section class="related-collection-section">
        <div class="related-section-header">
            <div>
                <div class="related-eyebrow">BỘ SƯU TẬP TƯƠNG QUAN</div>
                <h2 class="related-title">Tập Khác Cùng Bộ &amp; Bản Hiếm Tuyển Chọn</h2>
            </div>
            <a href="#" class="related-link-all"> <span>Xem tất cả One Piece Vault</span> <span
                    class="material-symbols-outlined" style="font-size: 16px;">arrow_forward</span> </a>
        </div>
        <div class="related-books-grid"> <!-- Sách 1 --> <a href="#" class="related-book-card">
            <div class="related-cover-wrapper"> <span class="related-top-pill pill-edition">1st
                            Edition</span> <img class="related-cover-img"
                                                src="https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&w=300&q=80"
                                                alt="One Piece #2"></div>
            <div class="related-info-body"><span class="related-book-series">ONE PIECE #2</span>
                <div class="related-book-name">Tập 2: Chàng Thợ Săn Hải Tặc</div>
                <div class="related-price-row"><span class="related-price-val">380.000 đ</span> <span
                        class="related-grade-val">Grade 8.8</span></div>
            </div>
        </a> <!-- Sách 2 --> <a href="#" class="related-book-card">
            <div class="related-cover-wrapper"> <span class="related-top-pill pill-obi">Kèm Obi
                            Gốc</span> <img class="related-cover-img"
                                            src="https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&w=300&q=80"
                                            alt="One Piece #4"></div>
            <div class="related-info-body"><span class="related-book-series">ONE PIECE #4</span>
                <div class="related-book-name">Tập 4: Lưỡi Kiếm Nguyện Ước</div>
                <div class="related-price-row"><span class="related-price-val">420.000 đ</span> <span
                        class="related-grade-val">Grade 9.0</span></div>
            </div>
        </a> <!-- Sách 3 --> <a href="#" class="related-book-card">
            <div class="related-cover-wrapper"> <span class="related-top-pill pill-rare">Hiếm Cực
                            Độ</span> <img class="related-cover-img"
                                           src="https://images.unsplash.com/photo-1589829085413-56de8ae18c73?auto=format&fit=crop&w=300&q=80"
                                           alt="Dragon Ball 1996"></div>
            <div class="related-info-body"><span class="related-book-series">DRAGON BALL 1996</span>
                <div class="related-book-name">Tập 1: Viên Ngọc Rồng Đầu Tiên</div>
                <div class="related-price-row"><span class="related-price-val">1.250.000 đ</span> <span
                        class="related-grade-val">Grade 8.5</span></div>
            </div>
        </a> <!-- Sách 4 --> <a href="#" class="related-book-card">
            <div class="related-cover-wrapper"> <span class="related-top-pill pill-year">Bản In
                            2008</span> <img class="related-cover-img"
                                             src="https://images.unsplash.com/photo-1543002588-bfa74002ed7e?auto=format&fit=crop&w=300&q=80"
                                             alt="Bleach #1"></div>
            <div class="related-info-body"><span class="related-book-series">BLEACH #1</span>
                <div class="related-book-name">Tập 1: Tử Thần &amp; Dâu Tây</div>
                <div class="related-price-row"><span class="related-price-val">520.000 đ</span> <span
                        class="related-grade-val">Grade 9.4</span></div>
            </div>
        </a></div>
    </section>
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

<script>
    const tabButtons = document.querySelectorAll(
        '.spec-tabs-nav button[data-tab]'
    );
    const conditionPanel = document.getElementById('condition-panel');
    const descriptionPanel = document.getElementById('description-panel');
    tabButtons.forEach(function(button) {
        button.addEventListener('click', function() {
            const selectedTab = button.dataset.tab;
            // Cap nhat trang thai active cua cac tab
            tabButtons.forEach(function(tab) {
                tab.classList.remove('active');
            });
            button.classList.add('active');
            // Hien thi noi dung tuong ung
            conditionPanel.hidden = selectedTab !== 'condition';
            descriptionPanel.hidden = selectedTab !== 'description';
        });
    });
</script>
</body>

</body>
</html>