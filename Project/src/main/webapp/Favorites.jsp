<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Sản phẩm yêu thích - MangaZ</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/Main.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/Favorites.css">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined">

</head>
<body class="site-body">

<jsp:include page="/common/header.jsp"/>

<main class="favorites-container">

    <div class="favorites-heading">
        <div>
            <h1>Sản phẩm yêu thích</h1>
            <p>Những câu chuyện bạn muốn lưu lại và theo dõi.</p>
        </div>

        <span class="favorites-count">
            ${favoriteCount} sản phẩm
        </span>
    </div>

    <c:choose>

        <%-- Có sản phẩm yêu thích --%>
        <c:when test="${not empty favorites}">

            <div class="favorites-grid">

                <c:forEach var="product" items="${favorites}">

                    <div class="product-card">

                        <div class="product-image">

                            <c:choose>
                                <c:when test="${not empty product.imageUrl}">
                                    <img src="<c:out value='${product.imageUrl}'/>"
                                         alt="<c:out value='${product.title}'/>">
                                </c:when>

                                <c:otherwise>
                                    <img src="https://placehold.co/400x500/f0eee9/555555?text=No+Image"
                                         alt="Chưa có ảnh">
                                </c:otherwise>
                            </c:choose>

                            <button class="bookmark-btn active"
                                    type="button"
                                    data-listing-id="${product.listingId}"
                                    aria-label="Bỏ yêu thích">

                                <span class="material-symbols-outlined">
                                    favorite
                                </span>

                            </button>

                        </div>

                        <div class="product-info">

                            <span class="product-type-tag">
                                <c:out value="${product.productTypeName}"/>
                            </span>

                            <h3 class="product-name">
                                <a href="${pageContext.request.contextPath}/product-detail?id=${product.listingId}">
                                    <c:out value="${product.title}"/>
                                </a>
                            </h3>

                            <div class="product-price">
                                <fmt:formatNumber
                                        value="${product.price}"
                                        type="number"
                                        groupingUsed="true"/> đ
                            </div>

                            <div class="favorites-actions">
                                <a href="${pageContext.request.contextPath}/product-detail?id=${product.listingId}"
                                   class="btn-view-product">
                                    Xem sản phẩm
                                </a>
                            </div>

                        </div>

                    </div>

                </c:forEach>

            </div>

        </c:when>

        <%-- Chưa có sản phẩm yêu thích --%>
        <c:otherwise>

            <div class="favorites-empty">

                <span class="material-symbols-outlined">
                    favorite_border
                </span>

                <h2>Chưa có sản phẩm yêu thích</h2>

                <p>
                    Hãy khám phá MangaZ và lưu lại những bộ truyện
                    mà bạn quan tâm nhé!
                </p>

                <a href="${pageContext.request.contextPath}/main">
                    Khám phá sản phẩm
                </a>

            </div>

        </c:otherwise>

    </c:choose>

</main>

<script>
    const contextPath = '${pageContext.request.contextPath}';

    function updateFavoriteCount(count) {
        const favoriteLink = document.querySelector('.header-favorite');

        if (!favoriteLink) return;

        let badge = favoriteLink.querySelector('.favorite-count');

        if (count > 0) {
            if (!badge) {
                badge = document.createElement('span');
                badge.className = 'favorite-count';
                favoriteLink.appendChild(badge);
            }

            badge.textContent = count;
        } else if (badge) {
            badge.remove();
        }
    }
    // Bỏ sản phẩm khỏi danh sách yêu thích
    document.querySelectorAll('.bookmark-btn').forEach(function (button) {

        button.addEventListener('click', async function () {

            const listingId = button.dataset.listingId;

            try {
                const response = await fetch(
                    contextPath + '/favorite/toggle',
                    {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        },
                        body: new URLSearchParams({
                            listingId: listingId
                        })
                    }
                );

                if (response.status === 401) {
                    window.location.href = contextPath + '/Login.jsp';
                    return;
                }

                const result = await response.json();

                if (!response.ok || !result.success) {
                    alert(result.message || 'Không thể cập nhật yêu thích!');
                    return;
                }
                updateFavoriteCount(result.favoriteCount);

                // Xóa card khỏi giao diện
                if (!result.isFavorite) {
                    const card = button.closest('.product-card');
                    if (card) {
                        card.remove();
                    }

                    // Nếu không còn sản phẩm, tải lại để hiện trạng thái rỗng
                    if (!document.querySelector('.favorites-grid .product-card')) {
                        window.location.reload();
                    }
                }

            } catch (error) {
                console.error('Favorite error:', error);
                alert('Đã xảy ra lỗi!');
            }

        });

    });
</script>

</body>
</html>
