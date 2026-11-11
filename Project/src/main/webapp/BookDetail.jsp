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
                        <h6>Tác giả:&nbsp;<a href="">Eiichiro Oda <span>,&nbsp;</span></a>
<%--                            <a href="">Tác giả gì gì--%>
<%--                                đó</a>--%>
                        </h6>
                    </span>
                <h1 class="product-headline-title"><c:out value="${product.title}"/></h1>
                <%--                <p class="sell-number">Bài đăng #<c:out value="${product.productId}"/></p>--%>
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
            <form action="${pageContext.request.contextPath}/cart/add" method="POST" class="purchase-commerce-card">
                <input type="hidden" name="listingId" value="${product.productId}"/>
                <div class="price-listing-row">
                    <div class="quantity-section">
                        <div class="price-listing-label">Số lượng</div>

                        <div class="quantity-control-row">
                            <div class="quantity-row">
                                <button type="button" class="quantity-btn" id="btn-decrease">−</button>
                                <input type="number" class="quantity-input" name="quantity" value="1" min="1"
                                       id="quantity-input"
                                       max="${product.stockQuantity}">
                                <button type="button" class="quantity-btn" id="btn-increase">+</button>
                            </div>

                            <span class="stock-quantity"><c:out
                                    value="${product.stockQuantity}"/> sản phẩm có sẵn</span>
                        </div>
                    </div>

                    <div class="subtotal-section">
                        <div class="price-listing-label">Tạm tính</div>
                        <span class="current-price" id="subtotal-display"><fmt:formatNumber value="${product.price}"
                                                                                            pattern="#,##0"/> đ</span>
                    </div>
                </div>


                <div class="escrow-guarantee-note"><span class="material-symbols-outlined">verified</span>
                    <span>Đã hoàn tất giám định vật lý bởi MangaVault Labs</span>
                </div>
                <div class="checkout-buttons-row">
                    <button class="btn-buy-now" type="button" id="btn-buy-now"> <span
                            class="material-symbols-outlined">shopping_bag</span> <span>Mua ngay</span>
                    </button>
                    <button class="btn-cart-square" type="submit" title="Thêm vào giỏ hàng">
                        <span class="material-symbols-outlined">shopping_cart</span>
                    </button>
                </div>
            </form>
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
                    data-tab="comment">
                <span>Bình luận &amp; Hỏi Đáp</span>
                <span class="tab-counter-badge">${commentCount != null ? commentCount : 0}</span>
            </button>
        </div>

        <!-- TAB 1: THONG SO VA TINH TRANG -->
        <div class="spec-tab-panel" id="condition-panel">
            <div class="spec-table-grid">

                <c:choose>
                    <c:when test="${not empty product.attributes}">

                        <c:forEach var="attribute"
                                   items="${product.attributes}">

                            <div class="spec-row">
                    <span class="spec-label">
                        <c:out value="${attribute.attributeName}"/>
                    </span>

                                <span class="spec-value">
                        <c:out value="${attribute.valueText}"/>
                    </span>
                            </div>

                        </c:forEach>

                    </c:when>

                    <c:otherwise>
                        <div class="spec-row">
                            <span class="spec-label">Thông tin sản phẩm</span>
                            <span class="spec-value">
                    Chưa có thông số chi tiết.
                </span>
                        </div>
                    </c:otherwise>
                </c:choose>

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
        <!-- TAB 3: BÌNH LUẬN & HỎI ĐÁP -->
        <!-- TAB 3: BÌNH LUẬN & HỎI ĐÁP -->
        <div class="spec-tab-panel" id="comment-panel" hidden>
            <div style="padding: 20px 0;">

                <!-- Form gửi câu hỏi mới -->
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <form action="${pageContext.request.contextPath}/comment/add" method="POST"
                              style="margin-bottom: 30px;">
                            <input type="hidden" name="listingId" value="${product.productId}"/>
                            <div style="display: flex; gap: 12px; align-items: flex-start;">
                                <textarea name="content" rows="3" required
                                          placeholder="Hỏi người bán về tình trạng sách, phí ship..."
                                          style="flex: 1; padding: 12px; border-radius: 8px; border: 1px solid #d1d5db; font-family: inherit; font-size: 14px; resize: vertical;"></textarea>
                                <button type="submit"
                                        style="padding: 12px 24px; background: #111827; color: #fff; border: none; border-radius: 8px; font-weight: 600; cursor: pointer;">
                                    Gửi câu hỏi
                                </button>
                            </div>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div style="background: #f9fafb; padding: 16px; border-radius: 8px; text-align: center; margin-bottom: 24px; border: 1px solid #e5e7eb;">
                            Vui lòng <a href="${pageContext.request.contextPath}/Login.jsp"
                                        style="color: #2563eb; font-weight: 600;">đăng nhập</a> để đặt câu hỏi cho người
                            bán.
                        </div>
                    </c:otherwise>
                </c:choose>

                <!-- Danh sách các bình luận -->
                <c:choose>
                    <c:when test="${empty comments}">
                        <div style="text-align: center; padding: 30px; color: #6b7280;">
                            Chưa có bình luận nào. Hãy là người đầu tiên đặt câu hỏi!
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="comment-list-container"  style="display: flex; flex-direction: column; gap: 20px; max-height: 500px; overflow-y:auto ">
                            <c:forEach var="c" items="${comments}">
                                <div style="border-bottom: 1px solid #f3f4f6; padding-bottom: 16px;">

                                    <!-- THÔNG TIN NGƯỜI ĐĂNG CÂU HỎI CHA -->
                                    <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 6px;">
                                        <strong style="font-size: 14px; color: #111827;">
                                            <c:out value="${not empty c.userFullName ? c.userFullName : c.username}"/>
                                        </strong>
                                        <c:if test="${c.seller}">
                                            <span style="background: #dbeafe; color: #1e40af; font-size: 11px; padding: 2px 8px; border-radius: 12px; font-weight: 600;">Người bán</span>
                                        </c:if>
                                        <!-- NHÃN CẢM XÚC  -->
                                        <c:choose>
                                            <c:when test="${c.sentiment eq 'POSITIVE'}">
                                                <span class="badge-sentiment positive">Tích cực</span>
                                            </c:when>
                                            <c:when test="${c.sentiment eq 'NEGATIVE'}">
                                                <span class="badge-sentiment negative">Tiêu cực</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-sentiment neutral">Trung tính</span>
                                            </c:otherwise>
                                        </c:choose>
                                        <span style="font-size: 12px; color: #9ca3af;">
                                            <fmt:formatDate value="${c.createdAt}" pattern="HH:mm dd/MM/yyyy"/>
                                        </span>
                                        <!-- Nhãn đã chỉnh sửa -->
                                        <c:if test="${c.edited}">
                                            <span style="font-size: 11px; color: #6b7280; font-style: italic;">(Đã chỉnh sửa)</span>
                                        </c:if>
                                    </div>

                                    <!-- Nội dung bình luận cha -->
                                    <div id="comment-text-${c.commentId}"
                                         style="font-size: 14px; color: #374151; line-height: 1.5; margin-bottom: 8px;">
                                        <c:out value="${c.content}"/>
                                    </div>

                                    <!-- NÚT THAO TÁC (Trả lời, Sửa, Xóa) -->
                                    <div style="display: flex; gap: 12px; align-items: center; margin-bottom: 10px;">
                                        <c:if test="${not empty sessionScope.user}">
                                            <button type="button"
                                                    onclick="document.getElementById('reply-form-${c.commentId}').hidden = !document.getElementById('reply-form-${c.commentId}').hidden"
                                                    style="background: none; border: none; color: #2563eb; font-size: 13px; font-weight: 600; cursor: pointer; padding: 0;">
                                                Trả lời
                                            </button>
                                        </c:if>

                                        <!-- Nút Sửa / Xóa (Chỉ hiện khi là chính chủ) -->
                                        <c:if test="${not empty sessionScope.user and sessionScope.user.id eq c.userId}">
                                            <button type="button" onclick="toggleEditForm(${c.commentId})"
                                                    style="background: none; border: none; color: #059669; font-size: 13px; font-weight: 600; cursor: pointer; padding: 0;">
                                                Sửa
                                            </button>

                                            <form action="${pageContext.request.contextPath}/comment/delete"
                                                  method="POST"
                                                  style="display: inline-flex; align-items: center; margin: 0;"
                                                  onsubmit="return confirm('Bạn có chắc chắn muốn xóa bình luận này không?');">
                                                <input type="hidden" name="listingId" value="${product.productId}"/>
                                                <input type="hidden" name="commentId" value="${c.commentId}"/>
                                                <button type="submit"
                                                        style="background: none; border: none; color: #dc2626; font-size: 13px; font-weight: 600; cursor: pointer; padding: 0;">
                                                    Xóa
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>

                                    <!-- Form Chỉnh sửa inline cho bình luận cha (Ẩn mặc định) -->
                                    <div id="edit-form-${c.commentId}" hidden style="margin-bottom: 12px;">
                                        <form action="${pageContext.request.contextPath}/comment/update" method="POST"
                                              style="display: flex; gap: 8px;">
                                            <input type="hidden" name="listingId" value="${product.productId}"/>
                                            <input type="hidden" name="commentId" value="${c.commentId}"/>
                                            <input type="text" name="content" value="<c:out value='${c.content}'/>"
                                                   required
                                                   style="flex: 1; padding: 8px 12px; border-radius: 6px; border: 1px solid #d1d5db; font-size: 13px;"/>
                                            <button type="submit"
                                                    style="padding: 8px 16px; background: #059669; color: #fff; border: none; border-radius: 6px; font-size: 13px; cursor: pointer;">
                                                Lưu
                                            </button>
                                            <button type="button" onclick="toggleEditForm(${c.commentId})"
                                                    style="padding: 8px 12px; background: #9ca3af; color: #fff; border: none; border-radius: 6px; font-size: 13px; cursor: pointer;">
                                                Hủy
                                            </button>
                                        </form>
                                    </div>

                                    <!-- Form Trả lời (Ẩn mặc định) -->
                                    <div id="reply-form-${c.commentId}" hidden
                                         style="margin-top: 10px; padding-left: 20px;">
                                        <form action="${pageContext.request.contextPath}/comment/add" method="POST"
                                              style="display: flex; gap: 8px;">
                                            <input type="hidden" name="listingId" value="${product.productId}"/>
                                            <input type="hidden" name="parentCommentId" value="${c.commentId}"/>
                                            <input type="text" name="content" required placeholder="Viết câu trả lời..."
                                                   style="flex: 1; padding: 8px 12px; border-radius: 6px; border: 1px solid #d1d5db; font-size: 13px;"/>
                                            <button type="submit"
                                                    style="padding: 8px 16px; background: #374151; color: #fff; border: none; border-radius: 6px; font-size: 13px; cursor: pointer;">
                                                Gửi
                                            </button>
                                        </form>
                                    </div>

                                    <!-- DANH SÁCH CÂU TRẢ LỜI CON (REPLIES) -->
                                    <c:if test="${not empty c.replies}">
                                        <div style="margin-top: 12px; padding-left: 20px; border-left: 2px solid #e5e7eb; display: flex; flex-direction: column; gap: 12px;">
                                            <c:forEach var="reply" items="${c.replies}">
                                                <div>
                                                    <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 4px;">
                                                        <strong style="font-size: 13px; color: #111827;">
                                                            <c:out value="${not empty reply.userFullName ? reply.userFullName : reply.username}"/>
                                                        </strong>
                                                        <c:if test="${reply.seller}">
                                                            <span style="background: #dbeafe; color: #1e40af; font-size: 10px; padding: 1px 6px; border-radius: 10px; font-weight: 600;">Người bán</span>
                                                        </c:if>
                                                        <!-- NHÃN CẢM XÚC CHO REPLIES  -->
                                                        <c:choose>
                                                            <c:when test="${reply.sentiment eq 'POSITIVE'}">
                                                                <span class="badge-sentiment positive"
                                                                      style="font-size: 10px; padding: 2px 6px;">Tích cực</span>
                                                            </c:when>
                                                            <c:when test="${reply.sentiment eq 'NEGATIVE'}">
                                                                <span class="badge-sentiment negative"
                                                                      style="font-size: 10px; padding: 2px 6px;">Tiêu cực</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge-sentiment neutral"
                                                                      style="font-size: 10px; padding: 2px 6px;">Trung tính</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <span style="font-size: 11px; color: #9ca3af;">
                                                            <fmt:formatDate value="${reply.createdAt}"
                                                                            pattern="HH:mm dd/MM/yyyy"/>
                                                        </span>
                                                        <c:if test="${reply.edited}">
                                                            <span style="font-size: 10px; color: #6b7280; font-style: italic;">(Đã chỉnh sửa)</span>
                                                        </c:if>
                                                    </div>

                                                    <div id="comment-text-${reply.commentId}"
                                                         style="font-size: 13px; color: #4b5563; margin-bottom: 4px;">
                                                        <c:out value="${reply.content}"/>
                                                    </div>

                                                    <!-- Nút Sửa / Xóa cho câu trả lời con -->
                                                    <c:if test="${not empty sessionScope.user and sessionScope.user.id eq reply.userId}">
                                                        <div style="display: flex; gap: 10px; margin-bottom: 6px;">
                                                            <button type="button"
                                                                    onclick="toggleEditForm(${reply.commentId})"
                                                                    style="background: none; border: none; color: #059669; font-size: 12px; font-weight: 600; cursor: pointer; padding: 0;">
                                                                Sửa
                                                            </button>
                                                            <form action="${pageContext.request.contextPath}/comment/delete"
                                                                  method="POST"
                                                                  style="display: inline-flex; align-items: center; margin: 0;"
                                                                  onsubmit="return confirm('Bạn có chắc chắn muốn xóa câu trả lời này không?');">
                                                                <input type="hidden" name="listingId"
                                                                       value="${product.productId}"/>
                                                                <input type="hidden" name="commentId"
                                                                       value="${reply.commentId}"/>
                                                                <button type="submit"
                                                                        style="background: none; border: none; color: #dc2626; font-size: 12px; font-weight: 600; cursor: pointer; padding: 0;">
                                                                    Xóa
                                                                </button>
                                                            </form>
                                                        </div>

                                                        <!-- Form sửa cho câu trả lời con -->
                                                        <div id="edit-form-${reply.commentId}" hidden
                                                             style="margin-bottom: 8px;">
                                                            <form action="${pageContext.request.contextPath}/comment/update"
                                                                  method="POST" style="display: flex; gap: 6px;">
                                                                <input type="hidden" name="listingId"
                                                                       value="${product.productId}"/>
                                                                <input type="hidden" name="commentId"
                                                                       value="${reply.commentId}"/>
                                                                <input type="text" name="content"
                                                                       value="<c:out value='${reply.content}'/>"
                                                                       required
                                                                       style="flex: 1; padding: 6px 10px; border-radius: 4px; border: 1px solid #d1d5db; font-size: 12px;"/>
                                                                <button type="submit"
                                                                        style="padding: 6px 12px; background: #059669; color: #fff; border: none; border-radius: 4px; font-size: 12px; cursor: pointer;">
                                                                    Lưu
                                                                </button>
                                                                <button type="button"
                                                                        onclick="toggleEditForm(${reply.commentId})"
                                                                        style="padding: 6px 10px; background: #9ca3af; color: #fff; border: none; border-radius: 4px; font-size: 12px; cursor: pointer;">
                                                                    Hủy
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:if>

                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>

            </div>
        </div>

    </div>
    <!-- BỘ SƯU TẬP TƯƠNG QUAN / TẬP KHÁC CÙNG BỘ -->
    <%--    <section class="related-collection-section">--%>
    <%--        <div class="related-section-header">--%>
    <%--            <div>--%>
    <%--                <div class="related-eyebrow">BỘ SƯU TẬP TƯƠNG QUAN</div>--%>
    <%--                <h2 class="related-title">Tập Khác Cùng Bộ &amp; Bản Hiếm Tuyển Chọn</h2>--%>
    <%--            </div>--%>
    <%--            <a href="#" class="related-link-all"> <span>Xem tất cả One Piece Vault</span> <span--%>
    <%--                    class="material-symbols-outlined" style="font-size: 16px;">arrow_forward</span> </a>--%>
    <%--        </div>--%>
    <%--        <div class="related-books-grid"> <!-- Sách 1 --> <a href="#" class="related-book-card">--%>
    <%--            <div class="related-cover-wrapper"> <span class="related-top-pill pill-edition">1st--%>
    <%--                            Edition</span> <img class="related-cover-img"--%>
    <%--                                                src="https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&w=300&q=80"--%>
    <%--                                                alt="One Piece #2"></div>--%>
    <%--            <div class="related-info-body"><span class="related-book-series">ONE PIECE #2</span>--%>
    <%--                <div class="related-book-name">Tập 2: Chàng Thợ Săn Hải Tặc</div>--%>
    <%--                <div class="related-price-row"><span class="related-price-val">380.000 đ</span> <span--%>
    <%--                        class="related-grade-val">Grade 8.8</span></div>--%>
    <%--            </div>--%>
    <%--        </a> <!-- Sách 2 --> <a href="#" class="related-book-card">--%>
    <%--            <div class="related-cover-wrapper"> <span class="related-top-pill pill-obi">Kèm Obi--%>
    <%--                            Gốc</span> <img class="related-cover-img"--%>
    <%--                                            src="https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&w=300&q=80"--%>
    <%--                                            alt="One Piece #4"></div>--%>
    <%--            <div class="related-info-body"><span class="related-book-series">ONE PIECE #4</span>--%>
    <%--                <div class="related-book-name">Tập 4: Lưỡi Kiếm Nguyện Ước</div>--%>
    <%--                <div class="related-price-row"><span class="related-price-val">420.000 đ</span> <span--%>
    <%--                        class="related-grade-val">Grade 9.0</span></div>--%>
    <%--            </div>--%>
    <%--        </a> <!-- Sách 3 --> <a href="#" class="related-book-card">--%>
    <%--            <div class="related-cover-wrapper"> <span class="related-top-pill pill-rare">Hiếm Cực--%>
    <%--                            Độ</span> <img class="related-cover-img"--%>
    <%--                                           src="https://images.unsplash.com/photo-1589829085413-56de8ae18c73?auto=format&fit=crop&w=300&q=80"--%>
    <%--                                           alt="Dragon Ball 1996"></div>--%>
    <%--            <div class="related-info-body"><span class="related-book-series">DRAGON BALL 1996</span>--%>
    <%--                <div class="related-book-name">Tập 1: Viên Ngọc Rồng Đầu Tiên</div>--%>
    <%--                <div class="related-price-row"><span class="related-price-val">1.250.000 đ</span> <span--%>
    <%--                        class="related-grade-val">Grade 8.5</span></div>--%>
    <%--            </div>--%>
    <%--        </a> <!-- Sách 4 --> <a href="#" class="related-book-card">--%>
    <%--            <div class="related-cover-wrapper"> <span class="related-top-pill pill-year">Bản In--%>
    <%--                            2008</span> <img class="related-cover-img"--%>
    <%--                                             src="https://images.unsplash.com/photo-1543002588-bfa74002ed7e?auto=format&fit=crop&w=300&q=80"--%>
    <%--                                             alt="Bleach #1"></div>--%>
    <%--            <div class="related-info-body"><span class="related-book-series">BLEACH #1</span>--%>
    <%--                <div class="related-book-name">Tập 1: Tử Thần &amp; Dâu Tây</div>--%>
    <%--                <div class="related-price-row"><span class="related-price-val">520.000 đ</span> <span--%>
    <%--                        class="related-grade-val">Grade 9.4</span></div>--%>
    <%--            </div>--%>
    <%--        </a></div>--%>
    <%--    </section>--%>
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
    // 1. Chuyển Tab
    const tabButtons = document.querySelectorAll('.spec-tabs-nav button[data-tab]');
    const conditionPanel = document.getElementById('condition-panel');
    const descriptionPanel = document.getElementById('description-panel');
    const commentPanel = document.getElementById('comment-panel');

    tabButtons.forEach(function (button) {
        button.addEventListener('click', function () {
            const selectedTab = button.dataset.tab;
            tabButtons.forEach(tab => tab.classList.remove('active'));
            button.classList.add('active');
            if (conditionPanel) conditionPanel.hidden = selectedTab !== 'condition';
            if (descriptionPanel) descriptionPanel.hidden = selectedTab !== 'description';
            if (commentPanel) commentPanel.hidden = selectedTab !== 'comment';
        });
    });
    if (window.location.hash === '#comment-panel') {
        const commentTabBtn = document.querySelector('.spec-tabs-nav button[data-tab="comment"]');
        if (commentTabBtn) commentTabBtn.click();
    }

    // 2. Xử lý Nút Tăng/Giảm số lượng & Tự động tính Tạm tính
    const unitPrice = ${product.price};
    const maxStock = ${product.stockQuantity};
    const quantityInput = document.getElementById('quantity-input');
    const btnDecrease = document.getElementById('btn-decrease');
    const btnIncrease = document.getElementById('btn-increase');
    const subtotalDisplay = document.getElementById('subtotal-display');

    function updateSubtotal() {
        let qty = parseInt(quantityInput.value) || 1;
        if (qty < 1) qty = 1;
        if (qty > maxStock) qty = maxStock;
        quantityInput.value = qty;

        const subtotal = unitPrice * qty;
        subtotalDisplay.innerText = new Intl.NumberFormat('vi-VN').format(subtotal) + ' đ';
    }

    if (btnDecrease && btnIncrease && quantityInput) {
        btnDecrease.addEventListener('click', function () {
            let current = parseInt(quantityInput.value) || 1;
            if (current > 1) {
                quantityInput.value = current - 1;
                updateSubtotal();
            }
        });

        btnIncrease.addEventListener('click', function () {
            let current = parseInt(quantityInput.value) || 1;
            if (current < maxStock) {
                quantityInput.value = current + 1;
                updateSubtotal();
            }
        });

        quantityInput.addEventListener('input', updateSubtotal);
    }

    // 3. Xử lý nút Mua ngay
    const buyNowButton = document.getElementById('btn-buy-now');

    if (buyNowButton) {
        buyNowButton.addEventListener('click', function () {

            const form = buyNowButton.closest('form');

            const listingId = form.querySelector('input[name="listingId"]').value;
            const quantity = quantityInput ? quantityInput.value : 1;

            if (!listingId || quantity < 1) {
                alert('Thông tin sản phẩm không hợp lệ!');
                return;
            }

            window.location.href =
                contextPath + '/checkout?buyNow=true'
                + '&listingId=' + encodeURIComponent(listingId)
                + '&quantity=' + encodeURIComponent(quantity);
        });
    }

    function toggleEditForm(commentId) {
        const editForm = document.getElementById('edit-form-' + commentId);
        const commentText = document.getElementById('comment-text-' + commentId);
        if (editForm) {
            editForm.hidden = !editForm.hidden;
        }
        if (commentText) {
            commentText.style.display = editForm.hidden ? 'block' : 'none';
        }
    }

    //TỪ ĐÂY TRỞ ĐI LÀ CODE FETCH API CỦA BÌNH LUẬN
    const contextPath = '${pageContext.request.contextPath}';

    document.addEventListener('submit', async function (event) {

        const form = event.target;

        // Chỉ xử lý các form liên quan đến bình luận
        if (!form.matches('form[action*="/comment/"]')) {
            return;
        }

        // Ngăn trình duyệt reload trang
        event.preventDefault();

        const submitButton = form.querySelector('button[type="submit"]');

        if (submitButton && submitButton.disabled) {
            return;
        }

        try {
            if (submitButton) {
                submitButton.disabled = true;
            }

            // 1. Gửi dữ liệu đến CommentServlet
            const formData = new FormData(form);
            const submittedContent = (formData.get('content') || '').trim();
            const isAddingComment = form.action.includes('/comment/add');
            const response = await fetch(form.action, {
                method: 'POST',
                body: new URLSearchParams(formData)
            });

            const responseText = await response.text();

            console.log("HTTP Status:", response.status);
            console.log("Response:", responseText);

            const result = JSON.parse(responseText);

            // 2. Kiểm tra kết quả
            if (!response.ok || !result.success) {
                alert(result.message || 'Thao tác thất bại!');
                return;
            }

            // 3. Lấy lại HTML mới nhất của trang chi tiết
            const listingId = formData.get('listingId');

            const pageResponse = await fetch(
                contextPath + '/product-detail?id=' + encodeURIComponent(listingId)
            );

            if (!pageResponse.ok) {
                throw new Error('Không thể tải lại danh sách bình luận!');
            }

            const html = await pageResponse.text();

            // 4. Phân tích HTML trả về
            const parser = new DOMParser();
            const newDocument = parser.parseFromString(html, 'text/html');

            const newCommentPanel = newDocument.getElementById('comment-panel');
            const currentCommentPanel = document.getElementById('comment-panel');

            if (!newCommentPanel || !currentCommentPanel) {
                throw new Error('Không tìm thấy khu vực bình luận!');
            }
            // Lưu vị trí thanh cuộn hiện tại
            const currentCommentList = currentCommentPanel.querySelector('.comment-list-container');
            const scrollPosition = currentCommentList ? currentCommentList.scrollTop : 0;
            // 5. Chỉ cập nhật nội dung khu vực bình luận
            currentCommentPanel.innerHTML = newCommentPanel.innerHTML;
            // 6. Cuộn đến bình luận vừa gửi
            const updatedCommentList = currentCommentPanel.querySelector('.comment-list-container');

            if (updatedCommentList) {
                updatedCommentList.scrollTop = scrollPosition;
            }
            if (isAddingComment && !formData.get('parentCommentId')) {
                const commentElements = currentCommentPanel.querySelectorAll(
                    '[id^="comment-text-"]'
                );

                let newCommentElement = null;

                commentElements.forEach(function (element) {
                    if (element.textContent.trim() === submittedContent) {
                        newCommentElement = element;
                    }
                });

                if (newCommentElement) {

                    // 1. Cuộn đến bình luận
                    newCommentElement.scrollIntoView({
                        behavior: 'smooth',
                        block: 'center'
                    });

                    // 2. Chờ cuộn xong rồi làm sáng bình luận
                    setTimeout(function () {

                        newCommentElement.classList.add('comment-highlight');

                        // 3. Giữ màu xanh trong 1 giây
                        setTimeout(function () {

                            // 4. Từ từ đưa màu nền về ban đầu
                            newCommentElement.classList.add('comment-highlight-fade');

                            // 5. Xóa class sau khi hiệu ứng hoàn tất
                            setTimeout(function () {
                                newCommentElement.classList.remove(
                                    'comment-highlight',
                                    'comment-highlight-fade'
                                );
                            }, 1500);

                        }, 1000);

                    }, 500);
                }
            }

            // 6. Cập nhật số lượng bình luận trên tab
            const newCounter = newDocument.querySelector('.tab-counter-badge');
            const currentCounter = document.querySelector('.tab-counter-badge');

            if (newCounter && currentCounter) {
                currentCounter.textContent = newCounter.textContent;
            }

        } catch (error) {

            console.error('Comment error:', error);
            alert('Đã xảy ra lỗi khi xử lý bình luận!');

        } finally {

            if (submitButton) {
                submitButton.disabled = false;
            }
        }
    });
</script>
</body>
</html>