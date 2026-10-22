<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:forEach var="address" items="${addresses}">
    <div class="address-detail-card">

        <div class="address-top-row">
            <div class="address-identity-meta">
                <c:if test="${address.defaultAddress}">
                    <span class="default-badge">MẶC ĐỊNH</span>
                </c:if>
            </div>

            <div class="address-actions-inline">
                <button class="address-btn"
                        type="button"
                        data-address-id="${address.id}">
                    <span class="material-symbols-outlined">edit</span>
                    <span>Chỉnh sửa</span>
                </button>

                <button class="address-btn"
                        type="button"
                        data-address-id="${address.id}">
                    <span class="material-symbols-outlined">delete</span>
                    <span>Xóa</span>
                </button>
            </div>
        </div>

        <div class="recipient-heading">
            <span class="recipient-name">
                <c:out value="${address.recipientName}"/>
            </span>

            <span class="recipient-phone">
                <c:out value="${address.phoneNumber}"/>
            </span>
        </div>

        <p class="recipient-address">
            <c:out value="${address.addressDetail}"/>,
            <c:out value="${address.ward}"/>,
            <c:out value="${address.cityProvince}"/>.
        </p>

    </div>
</c:forEach>
