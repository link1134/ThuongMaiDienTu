<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html lang="vi">

<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Tìm kiếm</title> <!-- Google Fonts & Material Symbols -->
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&display=swap"
          rel="stylesheet"/>
    <link
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
            rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Search.css"/>
</head>

<body class="site-body"> <!-- BEGIN: SiteHeader -->
<jsp:include page="/common/header.jsp"/>
<main class="main-page-container"> <!-- Hero Section -->

    <nav class="breadcrumb" aria-label="Breadcrumb">
        <a href="${pageContext.request.contextPath}/main">
            Trang chủ
        </a>

        <span class="breadcrumb-separator">›</span>

        <span class="breadcrumb-current">
                Tìm kiếm
            </span>
    </nav>


    <%--    <div style="display: flex; justify-content: flex-start; flex: 1; width: 100%;">--%>
    <%--        <div class="search-result">--%>
    <%--            <h1>"${keyword}"</h1>--%>
    <%--            <span>--%>
    <%--    (<c:out value="${totalResults}"/> kết quả tìm thấy)--%>
    <%--</span>--%>
    <%--        </div>--%>
    <%--    </div>--%>
    <div class="product-filter-bar">
        <!-- Các tab loại bài đăng -->
        <div class="filter-tabs">

            <button type="button"
                    class="filter-tab ${selectedType eq 'All' ? 'active' : ''}"
                    data-type="All">
                Tất cả (<c:out value="${allCount}"/>)
            </button>

            <button type="button"
                    class="filter-tab ${selectedType eq 'Sale' ? 'active' : ''}"
                    data-type="Sale">
                Mua ngay (<c:out value="${saleCount}"/>)
            </button>

            <button type="button"
                    class="filter-tab ${selectedType eq 'Auction' ? 'active' : ''}"
                    data-type="Auction">
                Đấu giá (<c:out value="${auctionCount}"/>)
            </button>
        </div>
        <div class="filter-divider"></div>
        <!-- Các bộ lọc -->
        <div class="filter-options">
            <button class="filter-select">
                Thể loại
                <span class="chevron"></span>
            </button>
            <button class="filter-select">
                Tình trạng sách
                <span class="chevron"></span>
            </button>
            <button class="filter-select">
                Khoảng giá
                <span class="chevron"></span>
            </button>
            <button class="filter-select">
                Nhà xuất bản
                <span class="chevron"></span>
            </button>
        </div>
        <!-- Sắp xếp -->
        <div class="filter-sort">
            <span class="sort-label">Sắp xếp theo:</span>

            <button class="sort-select">
                Phổ biến nhất
                <span class="chevron"></span>
            </button>
        </div>

    </div>

    <!-- Khu vực chứa danh sách sản phẩm -->


    <%--    <div class="product-grid">--%>

    <%--        <c:choose>--%>
    <%--            <c:when test="${not empty products}">--%>

    <%--                <c:forEach var="product" items="${products}">--%>

    <%--                    <div class="product-card">--%>
    <%--                        <div class="product-image">--%>

    <%--                            <c:choose>--%>
    <%--                                <c:when test="${not empty product.imageUrl}">--%>
    <%--                                    <img--%>
    <%--                                            src="<c:out value='${product.imageUrl}'/>"--%>
    <%--                                            alt="<c:out value='${product.title}'/>">--%>
    <%--                                </c:when>--%>
    <%--                                <c:otherwise>--%>
    <%--                                    <img--%>
    <%--                                            src="https://placehold.co/400x500/f0eee9/555555?text=No+Image"--%>
    <%--                                            alt="Chưa có ảnh sản phẩm">--%>
    <%--                                </c:otherwise>--%>
    <%--                            </c:choose>--%>

    <%--                            <span class="product-type">--%>
    <%--                            <c:choose>--%>
    <%--                                <c:when test="${product.listingType eq 'Auction'}">--%>
    <%--                                    Đấu giá--%>
    <%--                                </c:when>--%>
    <%--                                <c:when test="${product.listingType eq 'Trade'}">--%>
    <%--                                    Trao đổi--%>
    <%--                                </c:when>--%>
    <%--                                <c:otherwise>--%>
    <%--                                    Mua ngay--%>
    <%--                                </c:otherwise>--%>
    <%--                            </c:choose>--%>
    <%--                        </span>--%>

    <%--                            <div class="product-condition-and-bookmark">--%>
    <%--                            <span class="product-condition">--%>
    <%--                                Rất tốt--%>
    <%--                            </span>--%>

    <%--                                <button class="bookmark-btn"--%>
    <%--                                        type="button"--%>
    <%--                                        aria-label="Lưu sản phẩm">--%>
    <%--                                <span class="material-symbols-outlined">--%>
    <%--                                    bookmark--%>
    <%--                                </span>--%>
    <%--                                </button>--%>
    <%--                            </div>--%>
    <%--                        </div>--%>

    <%--                        <div class="product-info">--%>

    <%--                            <div class="product-tags">--%>
    <%--                            <span class="product-type-tag">--%>
    <%--                                <c:out value="${product.productTypeName}"/>--%>
    <%--                            </span>--%>

    <%--                                <span class="product-tag">Shonen</span>--%>
    <%--                                <span class="product-tag">Bản giới hạn</span>--%>
    <%--                                <span class="product-tag-more">+3</span>--%>
    <%--                            </div>--%>

    <%--                            <h3 class="product-name">--%>
    <%--                                <c:out value="${product.title}"/>--%>
    <%--                            </h3>--%>

    <%--                            <div class="product-price">--%>
    <%--                                <span>Giá niêm yết</span>--%>

    <%--                                <strong>--%>
    <%--                                    <c:choose>--%>
    <%--                                        <c:when test="${product.price ne null}">--%>
    <%--                                            <fmt:formatNumber--%>
    <%--                                                    value="${product.price}"--%>
    <%--                                                    pattern="#,##0"/> đ--%>
    <%--                                        </c:when>--%>
    <%--                                        <c:otherwise>--%>
    <%--                                            Chưa có giá--%>
    <%--                                        </c:otherwise>--%>
    <%--                                    </c:choose>--%>
    <%--                                </strong>--%>
    <%--                            </div>--%>

    <%--                            <a--%>
    <%--                                    class="buy-btn"--%>
    <%--                                    href="${pageContext.request.contextPath}/product-detail?id=${product.listingId}">--%>
    <%--                                Xem chi tiết--%>
    <%--                            </a>--%>

    <%--                        </div>--%>
    <%--                    </div>--%>

    <%--                </c:forEach>--%>

    <%--            </c:when>--%>

    <%--            <c:otherwise>--%>
    <%--                <div class="search-empty-state">--%>
    <%--                    <h3>Không tìm thấy sản phẩm</h3>--%>
    <%--                    <p>--%>
    <%--                        Không có bài đăng nào phù hợp với từ khóa--%>
    <%--                        "<c:out value="${keyword}"/>".--%>
    <%--                    </p>--%>
    <%--                </div>--%>
    <%--            </c:otherwise>--%>
    <%--        </c:choose>--%>

    <%--    </div>--%>
    <div id="search-results-content">
        <jsp:include page="/SearchResult.jsp"/>
    </div>

<%--    <div class="pagination-section">--%>

<%--        <div class="pagination">--%>

<%--            <button class="pagination-btn pagination-arrow" type="button" aria-label="Trang trước">--%>
<%--                    <span class="material-symbols-outlined">--%>
<%--                        keyboard_arrow_left--%>
<%--                    </span>--%>
<%--            </button>--%>

<%--            <button class="pagination-btn active" type="button">1</button>--%>
<%--            <button class="pagination-btn" type="button">2</button>--%>
<%--            <button class="pagination-btn" type="button">3</button>--%>
<%--            <button class="pagination-btn" type="button">4</button>--%>

<%--            <span class="pagination-dots">...</span>--%>

<%--            <button class="pagination-btn pagination-next" type="button">--%>
<%--                Tiếp theo <span class="material-symbols-outlined">--%>
<%--                        keyboard_arrow_right--%>
<%--                    </span>--%>
<%--            </button>--%>

<%--        </div>--%>

<%--    </div>--%>


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
<input type="hidden"
       id="search-keyword"
       value="<c:out value='${keyword}'/>">
<script>
    const searchUrl = '${pageContext.request.contextPath}/search';

    document.querySelectorAll(".filter-tab").forEach(button => {
        button.addEventListener("click", async function () {

            const selectedType = this.dataset.type;
            const keywordElement = document.getElementById("search-keyword");
            const keyword = keywordElement.value;

            // Đánh dấu tab đang chọn
            document.querySelectorAll(".filter-tab").forEach(tab => {
                tab.classList.remove("active");
            });

            this.classList.add("active");

            const resultsContainer =
                document.getElementById("search-results-content");

            resultsContainer.style.opacity = "0.5";

            try {
                const params = new URLSearchParams({
                    keyword: keyword,
                    type: selectedType,
                    partial: "true"
                });


                const response = await fetch(searchUrl + "?" + params.toString());

                const html = await response.text();

                if (!response.ok) {
                    console.error("HTTP status:", response.status);
                    console.error("Response body:", html);
                    throw new Error("Server trả về HTTP " + response.status);
                }

                const parser = new DOMParser();
                const documentResult = parser.parseFromString(html, "text/html");
                const newContent = documentResult.querySelector(".search-results-content");

                if (!newContent) {
                    console.error("HTML server trả về:", html);
                    throw new Error("Không tìm thấy .search-results-content trong response.");
                }

                resultsContainer.innerHTML = newContent.innerHTML;


            } catch (error) {
                console.error(error);
                alert("Không thể tải kết quả. Vui lòng thử lại.");
            } finally {
                resultsContainer.style.opacity = "1";
            }
        });
    });
</script>
</body>

</html>