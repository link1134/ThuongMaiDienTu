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

                <button class="address-btn edit-address-btn"
                        type="button"
                        data-id="<c:out value='${address.id}'/>"
                        data-name="<c:out value='${address.recipientName}'/>"
                        data-phone="<c:out value='${address.phoneNumber}'/>"
                        data-province-code="<c:out value='${address.provinceCode}'/>"
                        data-province-name="<c:out value='${address.cityProvince}'/>"
                        data-ward-code="<c:out value='${address.wardCode}'/>"
                        data-ward-name="<c:out value='${address.ward}'/>"
                        data-detail="<c:out value='${address.addressDetail}'/>"
                        data-default="${address.defaultAddress}">
                    <span class="material-symbols-outlined">edit</span>
                    <span>Chỉnh sửa</span>
                </button>

                <button class="address-btn delete-address-btn"
                        type="button"
                        data-id="<c:out value='${address.id}'/>">
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
