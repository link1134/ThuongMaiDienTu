<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>MANGAZ - Collector Exchange</title> <!-- Google Fonts & Material Symbols -->
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link
            href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&display=swap"
            rel="stylesheet"/>
    <link
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
            rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Main.css"/>
</head>
<body class="site-body"> <!-- BEGIN: SiteHeader -->
<jsp:include page="/common/header.jsp"/> <!-- END: SiteHeader --> <!-- BEGIN: Segmented Mall/Shop Switcher -->
<section class="mode-switch-section">
    <div class="segmented-switcher-group">
        <button class="switcher-pill-btn active-pill" type="button"> Manga
            Mall
        </button>
        <button class="switcher-pill-btn inactive-pill" type="button"> Manga Shop</button>
    </div>
</section> <!-- END: Segmented Mall/Shop Switcher --> <!-- BEGIN: Main Page Content -->
<main class="main-page-container"> <!-- Hero Section -->
    <section class="hero-showcase-section">
        <div class="hero-text-column">
            <h1 class="hero-headline"> Manga là linh hồn<br/> Sàn là điểm hẹn. </h1>
            <div class="hero-cta-group">
                <button class="btn-primary-action" type="button"> Khám phá</button>
                <button class="btn-secondary-action" type="button"> Tạo gian hàng</button>
            </div>
            <div class="hero-metric-stats">
                <div class="metric-item">
                    <p class="metric-value">100+</p>
                    <p class="metric-label">Nhà xuất bản</p>
                </div>
                <div class="metric-item">
                    <p class="metric-value">20k+</p>
                    <p class="metric-label">Shop</p>
                </div>
            </div>
        </div> <!-- Manga Collage Grid -->
        <div class="hero-visual-collage">
            <div class="collage-column-stack">
                <div class="collage-image-card card-aspect-tall"><img alt="Naruto Manga cover edition"
                                                                      class="collage-photo"
                                                                      src="https://lh3.googleusercontent.com/aida-public/AB6AXuBK188BGRaruxJGW2NAh8nBrfC_V8qoPIVPoSSdfySxIEoXUo8bqfPLZFNQ5DfaxiEBOSVJh9kEvJOsqb7RIiGTDnUE7ModiutSt-Zv-q5CFsDhOqWf3-CI42I9ACgNP51Ye-K8aKXvc3WwhKn4vIltk5ita3ozQGxbBO8zWhZAY-Ad7-ypBfG_y628px3apbMGd--Mbs2SB1Efl8wkwnfjdEW-2rEe73fkyMAaN8c"/>
                </div>
                <div class="collage-image-card card-aspect-square"><img
                        alt="Framed manga collectible art piece" class="collage-photo"
                        src="https://lh3.googleusercontent.com/aida-public/AB6AXuAVL1AsEpGRmRSg24sUP0eddTkN5deO-eV18ChER5xFxyDNhz4xS2wbaPH4GFb_6_bsfvS4MrX4Rbkcdj2sTqStWCbpV-PqAoV2liEAT5YTm9OsU0GlDOD0IN80ZCJLnFwfJ0e8g5zG0h0tcaDQvqhHnHDYOfr16JbcfGoQCz718JndduMFIvJ4kqR-NomRc_evCVh_o9jOfarzVyahDggG6Seh_gnCXOH6Y8sfVm0"/>
                </div>
            </div>
            <div class="collage-column-stack">
                <div class="collage-image-card card-aspect-tall"><img alt="Blue Lock Manga volume"
                                                                      class="collage-photo"
                                                                      src="https://lh3.googleusercontent.com/aida-public/AB6AXuBQ4yhaFL_0bzLUb1koTDYI8HU-PADgEuB32uyA-jvOW4bmlOj2CJPHmOSy__HJOTE18zJwsKIRTtEEw8bypGp682J5AT5M9bOPy1r58P6uG-0cm_-F_rUCUJrpiCB58Lge58DCiZCqO782UyIpG02fxxRiMVfpkz25Qv593n6V2LNggLiciwRLqeTbDWTt2DpzhMtXoePii94fdIzcIKvgnqyeLZWddzejmRM_yH0"/>
                </div>
                <div class="collage-image-card card-aspect-tall"><img
                        alt="Dragon Ball Super manga illustration" class="collage-photo"
                        src="https://lh3.googleusercontent.com/aida-public/AB6AXuBQ-T7F6lzU6sXuJvJVIpbL-GRbmimdP_8yq45kM-1Mg7QMo2IrhVD25s0bY1TL330Ey444RDwBh0qvIjYgaWQViVxeQDjBzGnT2FsHhMwpeIRGlNQM1ANXBUuDMO_XyLBpfH5-8_Pmu-V9wnF3iWC23T7lPwJTS3h8LtrfK_LYMjtaz6s_Ul3Z-T-Z61HiGoRoXaKGZ6PDRHcwnBfConxexobFtlPpfB6kyoWH1wg"/>
                </div>
            </div>
            <div class="collage-column-single">
                <div class="collage-image-card card-aspect-extra-tall bg-purple-pastel"><img
                        alt="Doraemon collector edition volume" class="collage-photo"
                        src="https://lh3.googleusercontent.com/aida-public/AB6AXuDEzpZgZjtzJbp-f2vLLBITHHahoZ9mO4SLXhgvTNvYqeFiLi01vK27csTsgTfIRN2g1bf23UX6vhS3eEtjDM1Gsfgu8BNuWmFvG9Zlo3-mRbCCfVY74xvThNliVzb8gWVBUrq4zYgHlkTrcYNkBdtCdKSGPTPh39BAp73BMjt_Ud_5VZ-SU_2EEbcyrnCiA1_Ea6jvsP9osF9OBLQeidT1RQyNRf1aQ3QvAr2RaMU"/>
                </div>
            </div>
        </div>
    </section> <!-- Publishers Partner Strip -->
    <section class="publishers-partner-strip">
        <div class="publishers-inner-flex"> <!-- Kim Đồng -->
            <div class="publisher-brand-item">
                <div class="kimdong-round-badge"> <span class="kd-star-mark">★<br/><span
                        class="kd-initial">KD</span></span></div>
                <div class="publisher-text-details"><span class="publisher-name">KIM ĐỒNG</span> <span
                        class="publisher-type">Nhà xuất bản</span></div>
            </div> <!-- Trẻ Publishing House -->
            <div class="publisher-brand-item">
                <div class="tre-icon-box"> <span
                        class="material-symbols-outlined tre-fire-icon">local_fire_department</span></div>
                <div class="publisher-text-details">
                    <h3 class="publisher-name">NHÀ XUẤT BẢN TRẺ</h3>
                    <p class="tre-sub-english">TRE PUBLISHING HOUSE</p>
                    <p class="tre-url">www.nxbtre.com.vn</p>
                </div>
            </div> <!-- AMAK Store -->
            <div class="publisher-brand-item">
                <div class="amak-brand-typography"><span class="amak-strong">AMAK</span> <span
                        class="amak-italic-store">Store</span></div>
            </div>
        </div>
    </section> <!-- Featured Products Grid & Tabs -->
    <section class="products-showcase-section"> <!-- Filter Tabs -->
        <h2 class="display-section-title">Sản phẩm mới nhất</h2>

        <div class="category-tabs-bar">
            <!-- Giữ các tab hiện tại nếu bạn vẫn muốn sử dụng -->
            <button class="category-tab-btn active-tab" type="button">
                Mới nhất
            </button>
            <button class="category-tab-btn" type="button">Kim Đồng</button>
            <button class="category-tab-btn" type="button">Nhà xuất bản trẻ</button>
            <button class="category-tab-btn" type="button">AMAKstore</button>
            <button class="category-tab-btn" type="button">FAHASA</button>
        </div><!-- 9 Product Cards Grid -->
        <div class="product-grid">
            <c:choose>
                <c:when test="${not empty products}">
                    <c:forEach var="product" items="${products}">
                        <div class="product-card">
                            <div class="product-image">
                                <c:choose>
                                    <c:when test="${not empty product.imageUrl}">
                                        <img
                                                src="<c:out value='${product.imageUrl}'/>"
                                                alt="<c:out value='${product.title}'/>">
                                    </c:when>
                                    <c:otherwise>
                                        <img
                                                src="https://placehold.co/400x500/f0eee9/555555?text=No+Image"
                                                alt="Chưa có ảnh sản phẩm">
                                    </c:otherwise>
                                </c:choose>
                                <span class="product-type">
                            <c:choose>
                                <c:when test="${product.listingType eq 'Auction'}">
                                    Đấu giá
                                </c:when>
                                <c:when test="${product.listingType eq 'Trade'}">
                                    Trao đổi
                                </c:when>
                                <c:otherwise>
                                    Mua ngay
                                </c:otherwise>
                            </c:choose>
                        </span>
                                <div class="product-condition-and-bookmark">
                            <span class="product-condition">
                                Rất tốt
                            </span>
                                    <button class="bookmark-btn"
                                            type="button"
                                            aria-label="Lưu sản phẩm">
                                <span class="material-symbols-outlined">
                                    bookmark
                                </span>
                                    </button>
                                </div>
                            </div>

                            <div class="product-info">

                                <div class="product-tags">
                            <span class="product-type-tag">
                                <c:out value="${product.productTypeName}"/>
                            </span>

                                    <span class="product-tag">Shonen</span>
                                    <span class="product-tag">Bản giới hạn</span>
                                    <span class="product-tag-more">+3</span>
                                </div>

                                <h3 class="product-name">
                                    <c:out value="${product.title}"/>
                                </h3>

                                <div class="product-price">
                                    <span>Giá niêm yết</span>

                                    <strong>
                                        <c:choose>
                                            <c:when test="${product.price ne null}">
                                                <fmt:formatNumber
                                                        value="${product.price}"
                                                        pattern="#,##0"/> đ
                                            </c:when>
                                            <c:otherwise>
                                                Chưa có giá
                                            </c:otherwise>
                                        </c:choose>
                                    </strong>
                                </div>

                                <a
                                        class="buy-btn"
                                        href="${pageContext.request.contextPath}/product-detail?id=${product.listingId}">
                                    Xem chi tiết
                                </a>

                            </div>
                        </div>

                    </c:forEach>

                </c:when>

                <c:otherwise>
                    <div class="search-empty-state">
                        <h3>Chưa có sản phẩm</h3>
                        <p>Hiện tại chưa có bài đăng nào được đăng bán.</p>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>
    </section> <!-- Highlighted Manga Shops Section -->
    <section class="shops-display-section">
        <h2 class="display-section-title">Manga Shop nổi bật</h2>
        <div class="shops-card-grid"> <!-- Shop 1 -->
            <div class="shop-merchant-card">
                <div>
                    <div class="shop-banner-box"><img alt="Colorful abstract marble banner background"
                                                      class="shop-banner-img"
                                                      src="https://lh3.googleusercontent.com/aida-public/AB6AXuBHahm6kfhKaqr9CB1ChZI9h2mTduot_cGuYibH5VwsaiRO1NiKvcYzYoWovb721Wj2aF7rTgo5TdEGNNENjeEBrk3vSnqLR-t7G4k1FWEulsruK9lZwPW4SgQqyUNnJ4x8Bw8KjoVl8rfHeS41_9xITC-Ulw8tQHNw9E5sS5qAiYwC7z92l0ha2t9rk8FOlvbt6IKVi0l5qQ37fZtQZ5gADDldFuZzHrSYy5lFtng"/>
                    </div>
                    <div class="shop-profile-body">
                        <div class="shop-avatar-frame"><img alt="Avatar profile of SHop mang cu"
                                                            class="shop-avatar-img"
                                                            src="https://lh3.googleusercontent.com/aida-public/AB6AXuCqhnW2FpevOzFHgnuiAjfSm0QKMWNAnvU-QmgyYBt2M75sZ0Cp3dDdjmWOE0p4V8kzT49GOQD6Tv5xVTNirQVI3RmyKzcx7iu1BK1wjf6cHCC_EdMV8etCgWS9C5lW7Cx3fWMxVMn1TIqb4j7qC4ivhk8Z9Y8syTLFbw-OwHXvfwvwLgL4U8fAq3v1O_-ZyYNvbEdm9l7inGkkwjVd5GUrsPi8wYwAW23e4XSTj5Zs"/>
                        </div>
                        <h3 class="shop-display-name">SHop măng củ</h3>
                    </div>
                </div>
                <div class="shop-action-box">
                    <button class="btn-follow-shop" type="button">+ Follow</button>
                </div>
            </div> <!-- Shop 2 -->
            <div class="shop-merchant-card">
                <div>
                    <div class="shop-banner-box bg-dark-slate"><img alt="Checkerboard optical illusion banner"
                                                                    class="shop-banner-img"
                                                                    src="https://lh3.googleusercontent.com/aida-public/AB6AXuChL7E5IFTHYwzUd8IFUNEr_ob1mZ5T1t_cHc76N9lOZ4NDcaCbTCU0hZd81xie92qj2hpqTKBTHhdQgP6AOCbSEuoq4mllRsulLTqhVQJFzrO7VQmh6JKDHihhV1RaN_ahCQ2Jlddmr6NN3HqzNKC6MhPypeIqYIzpLG6dOw5DsH86A8Wc3zGtxpAMLfquGMt_uT2KjgVnOcGAB-A_uDSZWSf07owDOu3ixPpOHT0"/>
                    </div>
                    <div class="shop-profile-body">
                        <div class="shop-avatar-frame"><img alt="Avatar profile of O day ban manga"
                                                            class="shop-avatar-img"
                                                            src="https://lh3.googleusercontent.com/aida-public/AB6AXuAL2LVTsN_UFVfeEqNVcR7UcUfpichnFu10jeXYZArBu1Om2wq-3xi5QetdI3fJIaW1rsR6oEX3msd2xrj3hAteiguyBmh04pcaUN4MtODmU42ok013J_ctij13GaRmykJadqzVr2FPep7DUN148P8OE_PSamFdEQIhhPKBXKzrxZSyT7vhTNgmEO5BaANz5dKUMAeW6xiUSgBQfbBe6GwTNWh4y1X0GofylYci5L4"/>
                        </div>
                        <h3 class="shop-display-name">Ở đây bán manga</h3>
                    </div>
                </div>
                <div class="shop-action-box">
                    <button class="btn-followed-shop" type="button">+
                        Followed
                    </button>
                </div>
            </div> <!-- Shop 3 -->
            <div class="shop-merchant-card">
                <div>
                    <div class="shop-banner-box bg-indigo-deep"><img alt="Neon glowing wavy pattern banner"
                                                                     class="shop-banner-img"
                                                                     src="https://lh3.googleusercontent.com/aida-public/AB6AXuByfCyu5RyvdozKFQ0vsZDbSlUsfUwkDPG_qgpZ9LbJ044yvFcPrbmtFJGYacvI2dZC7LODvpHQdLwbj82PR_SKHzNHx7r5cdCKXwqSZArWgcZpuhjR3C3tsb8gsHUImwDvfmubQrJNu7ON5-L_xASAAhQaJ2mtbcC7zz4NcoekBynXvQrgWE2LToi9cLQP3FLuT1wvAe1F8gy2lGHjRraaFfea49ohp50EdcRzLBg"/>
                    </div>
                    <div class="shop-profile-body">
                        <div class="shop-avatar-frame"><img alt="Avatar profile of Ong gia ton kho"
                                                            class="shop-avatar-img"
                                                            src="https://lh3.googleusercontent.com/aida-public/AB6AXuDlw5WqBxvkzVmAKmSzTAcwYQB1f1NyQkAg792ONZRd457r02zRIxdq-_ONNZcA5gdWuGgdKgn3cJcQ_rIkRcCpWjE87pRspIKNEXKQTVWVp_UQJqy5d3VQVnXWzyAiJHmhpZD6zY0e9wuRG2vGatTzxO4u7t6sdcOX3wNLz44i_m7nbHuwyqHcUqjEkWaMMUZF60PXZHM17lECbmTikgQLaIM7tszLEVSqDc1L5JQ"/>
                        </div>
                        <h3 class="shop-display-name">Ông già tồn kho</h3>
                    </div>
                </div>
                <div class="shop-action-box">
                    <button class="btn-follow-shop" type="button">+ Follow</button>
                </div>
            </div>
        </div>
    </section> <!-- Official Mall Shops Section -->
    <section class="shops-display-section">
        <h2 class="display-section-title">Các Shop Mall</h2>
        <div class="shops-card-grid"> <!-- Mall 1: Kim Đồng -->
            <div class="shop-merchant-card">
                <div>
                    <div class="mall-banner-brand-box bg-blue-adidas"> <span
                            class="material-symbols-outlined mall-brand-icon">eco</span> <span
                            class="mall-brand-wordmark">adidas</span></div>
                    <div class="shop-profile-body">
                        <div class="shop-avatar-frame red-kd-avatar"> <span
                                class="kd-avatar-text">★<br/>KD</span></div>
                        <h3 class="shop-display-name">Kim Đồng</h3>
                    </div>
                </div>
                <div class="shop-action-box">
                    <button class="btn-follow-shop" type="button">+ Follow</button>
                </div>
            </div> <!-- Mall 2: NXB Trẻ -->
            <div class="shop-merchant-card">
                <div>
                    <div class="shop-banner-box bg-amber-soft"><img
                            alt="Vietnamese historical illustrated collection banner" class="shop-banner-img"
                            src="https://lh3.googleusercontent.com/aida-public/AB6AXuCqocf_cRPHMYE_eiIHYKiFBT_kJffgschPUxB9Rxrzg8iQ8Bx3SJo-mLm1BxpUp0ez_IboViw0mEC8iIre_uZ_mKI1xtkTdxCOyylyuZJh5utVBIS-uV71IO--n4bqQOadh7LjNm9DyRQln15q71cK9WrQ9TbhP1ab4Ph-FfURlOaHk3w_A1-W4fl5QOTUtVlegzzONLITv5NUgRkb8NCG5WaGPtAhULlXbPKpR1Y"/>
                    </div>
                    <div class="shop-profile-body">
                        <div class="shop-avatar-frame amber-tre-avatar"> <span
                                class="material-symbols-outlined tre-book-avatar-icon">menu_book</span></div>
                        <h3 class="shop-display-name">Nhà xuất bản trẻ</h3>
                    </div>
                </div>
                <div class="shop-action-box">
                    <button class="btn-followed-shop" type="button">+
                        Followed
                    </button>
                </div>
            </div> <!-- Mall 3: AMAK Store -->
            <div class="shop-merchant-card">
                <div>
                    <div class="shop-banner-box bg-slate-dark"><img alt="AMAK store anime merchandise banner"
                                                                    class="shop-banner-img"
                                                                    src="https://lh3.googleusercontent.com/aida-public/AB6AXuC2oeG3h1YXWQBlRQFIg5_ZwUKX04W01oTdaviTJYwRjamSj4k8VvOQS5-2AVrIxfLb-0SUpLIMFboVLDtvumWHVjuuiaDF-yNm_FvoqiThthJ3icCI20_Ue095BprVxezziPMvb7HhfbPi2RpSBLAHGVVR28gDlxr-JSIwJ3F9oLmQM36QI9JBuZyvqGmHng6lo4d-fz6opb62BL8ee80YjxrssoXjzUxUR6c6Uqk"/>
                    </div>
                    <div class="shop-profile-body">
                        <div class="shop-avatar-frame slate-amak-avatar"> AMAK</div>
                        <h3 class="shop-display-name">AMAKA store</h3>
                    </div>
                </div>
                <div class="shop-action-box">
                    <button class="btn-follow-shop" type="button">+ Follow</button>
                </div>
            </div>
        </div>
    </section>
</main> <!-- END: Main Page Content --> <!-- BEGIN: SiteFooter -->
<footer class="site-main-footer">
    <div class="footer-inner-shell">
        <div class="footer-top-columns"> <!-- Brand Description -->
            <div class="footer-brand-column">
                <div class="footer-brand-title">MangaVault</div>
                <p class="footer-brand-mission"> Sàn giao dịch truyện tranh, ấn bản hiếm &amp; vật phẩm sưu tầm
                    xác thực bản quyền số 1 tại Đông Nam Á. </p>
                <div class="escrow-cert-tag"><span class="material-symbols-outlined">verified_user</span>
                    <span>100% Bảo Chứng Escrow</span></div>
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
    (function () {
        var trigger = document.getElementById("userAvatarTrigger");
        var menu = document.getElementById("userMenu");
        if (!trigger || !menu) return;
        var loggedIn = trigger.getAttribute("data-logged-in") === "true";
        var loginUrl = trigger.getAttribute("data-login-url");

        function activate(e) {
            if (!loggedIn) {
                window.location.href = loginUrl;
                return;
            }
            e.stopPropagation();
            menu.classList.toggle("open");
        }

        trigger.addEventListener("click", activate);
        trigger.addEventListener("keydown", function (e) {
            if (e.key === "Enter" || e.key === " ") {
                e.preventDefault();
                activate(e);
            }
        });
        document.addEventListener("click", function (e) {
            if (!menu.contains(e.target)) menu.classList.remove("open");
        });
    })();
</script>
</body>

</html>