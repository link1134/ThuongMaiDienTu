<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="search-results-content">

    <div style="display: flex; justify-content: flex-start; width: 100%; margin-bottom: 1rem">
        <div class="search-result">
            <h1>"<c:out value="${keyword}"/>"</h1>
            <span>
                (<c:out value="${totalResults}"/> kết quả tìm thấy)
            </span>
        </div>
    </div>

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
                                <span class="product-condition">Rất tốt</span>

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

                            <a class="buy-btn"
                               href="${pageContext.request.contextPath}/product-detail?id=${product.listingId}">
                                Xem chi tiết
                            </a>

                        </div>
                    </div>
                </c:forEach>

            </c:when>

            <c:otherwise>
                <div class="search-empty-state">
                    <h3>Không tìm thấy sản phẩm</h3>
                    <p>
                        Không có bài đăng nào phù hợp với từ khóa
                        "<c:out value="${keyword}"/>".
                    </p>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</div>