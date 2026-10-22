// Script số 1: fetch api chỉnh sửa
document.addEventListener("DOMContentLoaded", function () {

    var editableFields = document.querySelectorAll(".editable-field");

    editableFields.forEach(function (field) {

        var editButton = field.querySelector(".edit-trigger");
        var actionGroup = field.querySelector(".group-action-icon");
        var valueElement = field.querySelector(".field-value");
        var saveButton = field.querySelector(".save-trigger");
        var cancelButton = field.querySelector(".cancel-trigger");

        if (!editButton || !actionGroup || !valueElement) {
            return;
        }

        var originalValue = "";
        var inputElement = null;

        // Riêng trường giới tính
        var isGenderField = field.classList.contains("gender-field");
        var genderOptions = field.querySelector(".gender-options");
        var genderButtons = field.querySelectorAll(".gender-btn");
        var genderOther = field.querySelector(".gender-other");

        function selectGender(value) {
            genderButtons.forEach(function (button) {
                button.classList.toggle(
                    "selected",
                    button.dataset.gender === value
                );
            });

            if (value === "Nam" || value === "Nữ") {
                genderOther.value = "";
            } else {
                genderOther.value =
                    value === "Chưa cập nhật" ? "" : value;
            }
        }

        function closeGenderEditor() {
            if (genderOptions) {
                genderOptions.style.display = "none";
            }

            valueElement.style.display = "";
        }

        // Nhấn edit
        editButton.addEventListener("click", function () {

            if (field.classList.contains("is-editing")) {
                return;
            }

            originalValue = valueElement.textContent.trim();

            field.classList.add("is-editing");
            actionGroup.style.display = "flex";

            if (isGenderField) {
                valueElement.style.display = "none";
                genderOptions.style.display = "flex";
                selectGender(originalValue);
                return;
            }

            // Xử lý các trường nhập thông thường
            inputElement = document.createElement("input");
            inputElement.className = "field-value editing-input";

            if (field.classList.contains("date-field")) {
                inputElement.type = "date";
            } else {
                inputElement.type = "text";
            }

            if (field.classList.contains("date-field")) {
                inputElement.value = valueElement.dataset.value || "";
            } else {
                inputElement.value = originalValue === "Chưa cập nhật"
                    ? ""
                    : originalValue;
            }

            valueElement.replaceWith(inputElement);
            inputElement.focus();
            inputElement.select();
        });
        // Chọn Nam hoặc Nữ
        if (isGenderField) {
            genderButtons.forEach(function (button) {
                button.addEventListener("click", function () {
                    selectGender(button.dataset.gender);
                });
            });
            genderOther.addEventListener("focus", function () {
                genderButtons.forEach(function (button) {
                    button.classList.remove("selected");
                });
            });
            genderOther.addEventListener("input", function () {
                genderButtons.forEach(function (button) {
                    button.classList.remove("selected");
                });
            });
        }


        saveButton.addEventListener("click", async function () {
            var newValue;
            if (isGenderField) {
                var selectedButton = field.querySelector(".gender-btn.selected");
                newValue = selectedButton
                    ? selectedButton.dataset.gender
                    : genderOther.value.trim();
            } else {
                if (!inputElement) {
                    return;
                }

                newValue = inputElement.value.trim();
            }
            // Lấy tên trường từ data-field trong JSP
            var fieldName = field.dataset.field;
            if (!fieldName) {
                alert("Thiếu thuộc tính data-field.");
                return;
            }

            saveButton.disabled = true;

            try {
                var response = await fetch(
                    window.location.pathname.replace(/\/profile$/, "") +
                    "/profile/update",
                    {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
                        },
                        body: new URLSearchParams({
                            field: fieldName,
                            value: newValue
                        })
                    }
                );

                var result = await response.json();

                if (!response.ok || !result.success) {
                    alert(result.message || "Cập nhật thất bại.");
                    return;
                }

                // Chỉ cập nhật giao diện sau khi server báo thành công
                if (isGenderField) {
                    valueElement.textContent = newValue || "Chưa cập nhật";
                    closeGenderEditor();
                } else {
                    valueElement.textContent = newValue || "Chưa cập nhật";

                    if (field.classList.contains("date-field")) {
                        valueElement.dataset.value = newValue;
                    }

                    inputElement.replaceWith(valueElement);
                    inputElement = null;
                }

                field.classList.remove("is-editing");
                actionGroup.style.display = "none";

            } catch (error) {
                console.error("Lỗi cập nhật:", error);
                alert("Không thể kết nối đến máy chủ. Vui lòng thử lại.");
            } finally {
                saveButton.disabled = false;
            }
        });


        // Nhấn close: hủy thay đổi
        cancelButton.addEventListener("click", function () {

            if (isGenderField) {
                valueElement.textContent = originalValue;
                selectGender(originalValue);
                closeGenderEditor();
            } else {
                if (!inputElement) {
                    return;
                }

                valueElement.textContent = originalValue;

                inputElement.replaceWith(valueElement);
                inputElement = null;
            }

            field.classList.remove("is-editing");
            actionGroup.style.display = "none";
        });
    });
});
(function () {
    var toggle = document.getElementById("passwordToggle");
    var form = document.getElementById("passwordChangeForm");
    var icon = document.getElementById("passwordToggleIcon");

    if (!toggle || !form || !icon) {
        return;
    }

    function togglePasswordForm() {
        var isOpen = form.classList.contains("open");

        if (isOpen) {
            form.classList.remove("open");
            icon.textContent = "keyboard_arrow_down";
            toggle.setAttribute("aria-expanded", "false");
        } else {
            form.hidden = false;

            // Đợi trình duyệt áp dụng trạng thái ban đầu
            requestAnimationFrame(function () {
                form.classList.add("open");
            });

            icon.textContent = "keyboard_arrow_up";
            toggle.setAttribute("aria-expanded", "true");
        }
    }

    toggle.addEventListener("click", togglePasswordForm);
    toggle.addEventListener("keydown", function (e) {
        if (e.key === "Enter" || e.key === " ") {
            e.preventDefault();
            togglePasswordForm();
        }
    });
})();

(function () {
    var form = document.getElementById("changePasswordForm");

    if (!form) {
        return;
    }

    form.addEventListener("submit", async function (e) {
        e.preventDefault();

        var saveButton = form.querySelector(".password-save-btn");
        saveButton.disabled = true;

        try {

            var data = new FormData(form);

            console.log("URL:", form.dataset.url);
            console.log("Có mật khẩu hiện tại:", data.has("currentPassword"));
            console.log("Có mật khẩu mới:", data.has("newPassword"));
            console.log("Có xác nhận mật khẩu:", data.has("confirmPassword"));

            var params = new URLSearchParams();

            params.append("currentPassword", data.get("currentPassword"));
            params.append("newPassword", data.get("newPassword"));
            params.append("confirmPassword", data.get("confirmPassword"));

            var response = await fetch(form.dataset.url, {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
                },
                body: params
            });

            var result = await response.json();


            if (response.ok && result.success) {
                alert("Đổi mật khẩu thành công!");

                form.reset();

                var panel = document.getElementById("passwordChangeForm");
                var toggle = document.getElementById("passwordToggle");
                var icon = document.getElementById("passwordToggleIcon");

                if (panel) {
                    panel.classList.remove("open");
                }

                if (toggle && icon) {
                    toggle.setAttribute("aria-expanded", "false");
                    icon.textContent = "keyboard_arrow_down";
                }
            } else {
                alert(result.message || "Đổi mật khẩu thất bại.");
            }
        } catch (error) {
            console.error("Lỗi đổi mật khẩu:", error);
            alert("Không thể kết nối máy chủ. Vui lòng thử lại.");
        } finally {
            saveButton.disabled = false;
        }
    });
})();

//Script số 2: Khiến 4 nút quản lý có thể nhấn và thay đổi tab

document.addEventListener("DOMContentLoaded", function () {
    var menuItems = document.querySelectorAll(
        ".sidebar-nav-item[data-section]"
    );

    var sections = {
        orders: [document.getElementById("ordersSection")],
        address: [document.getElementById("addressSection")],
        followList: [document.getElementById("followListSection")],
        settings: [
            document.getElementById("profileSection"),
            document.getElementById("settingsSection")
        ]
    };

    var allSections = Object.values(sections).flat();

    function showSection(sectionName) {
        allSections.forEach(function (section) {
            if (section) {
                section.style.display = "none";
            }
        });

        if (!sections[sectionName]) {
            return;
        }

        sections[sectionName].forEach(function (section) {
            if (section) {
                section.style.display = "";
            }
        });

        menuItems.forEach(function (item) {
            item.classList.remove("active");
        });

        var activeItem = document.querySelector(
            '.sidebar-nav-item[data-section="' + sectionName + '"]'
        );

        if (activeItem) {
            activeItem.classList.add("active");
        }
    }

    menuItems.forEach(function (item) {
        item.addEventListener("click", function (event) {
            event.preventDefault();

            showSection(item.getAttribute("data-section"));
        });
    });

    showSection("settings");
});

//Script số 3: Hiển thị ô địa chỉ và fetch api tạo địa chỉ mới

const addressModal = document.getElementById("addressModal");
const addAddressBtn = document.getElementById("addAddressBtn");
const closeAddressModal = document.getElementById("closeAddressModal");
const cancelAddressBtn = document.getElementById("cancelAddressBtn");
const addAddressForm = document.getElementById("addAddressForm");
const addressItems = document.getElementById("addressItems");
const provinceSelect = document.getElementById("province");
const wardSelect = document.getElementById("ward");

const confirmAddressBtn = addAddressForm.querySelector(
    'button[type="submit"]'
);

const contextPath = document.body.dataset.contextPath;
console.log("Context path:", contextPath);
console.log("URL:", `${contextPath}/delivery-addresses`);
const addressModalTitle = document.getElementById("addressModalTitle");
const addressIdInput = document.getElementById("addressId");

addAddressBtn.addEventListener("click", function () {
    addAddressForm.reset();
    addressIdInput.value = "";
    addressModalTitle.textContent = "Thêm địa chỉ";

    wardSelect.innerHTML =
        '<option value="" selected disabled>Chọn phường / xã</option>';
    wardSelect.disabled = true;

    addressModal.hidden = false;
    document.body.style.overflow = "hidden";
});

function closeAddressPopup() {
    addressModal.hidden = true;
    document.body.style.overflow = "";
}

closeAddressModal.addEventListener("click", closeAddressPopup);
cancelAddressBtn.addEventListener("click", closeAddressPopup);


// Click vùng nền bên ngoài popup
addressModal.addEventListener("click", function (event) {
    if (event.target === addressModal) {
        closeAddressPopup();
    }
});

// Nhấn Escape
document.addEventListener("keydown", function (event) {
    if (event.key === "Escape" && !addressModal.hidden) {
        closeAddressPopup();
    }
});

async function loadAddresses() {
    try {
        const response = await fetch(
            `${contextPath}/delivery-addresses`,
            {
                method: "GET",
                headers: {
                    "Accept": "text/html"
                }
            }
        );

        const html = await response.text();

        console.log("URL:", `${contextPath}/delivery-addresses`);
        console.log("HTTP Status:", response.status);
        console.log("Response:", html);

        if (!response.ok) {
            throw new Error(
                `Không thể tải danh sách địa chỉ. HTTP ${response.status}`
            );
        }

        addressItems.innerHTML = html;

    } catch (error) {
        console.error("Lỗi tải danh sách địa chỉ:", error);
        alert(error.message);
    }
}

addAddressForm.addEventListener("submit", async function (event) {
    event.preventDefault();

    if (!addAddressForm.checkValidity()) {
        addAddressForm.reportValidity();
        return;
    }

    const provinceOption =
        provinceSelect.options[provinceSelect.selectedIndex];
    const wardOption =
        wardSelect.options[wardSelect.selectedIndex];

    if (!provinceSelect.value || !wardSelect.value ||
        !provinceOption || !wardOption) {
        alert("Vui lòng chọn tỉnh/thành và phường/xã.");
        return;
    }

    const formData = new FormData(addAddressForm);

    formData.set("provinceCode", provinceSelect.value);
    formData.set("provinceName", provinceOption.textContent);
    formData.set("wardCode", wardSelect.value);
    formData.set("wardName", wardOption.textContent);

    formData.set(
        "isDefault",
        document.getElementById("isDefaultAddress").checked
    );

    confirmAddressBtn.disabled = true;

    try {
        const response = await fetch(
            `${contextPath}/delivery-addresses`,
            {
                method: "POST",
                headers: {
                    "Accept": "text/plain"
                },
                body: new URLSearchParams(formData)
            }
        );

        const message = await response.text();

        if (!response.ok) {
            throw new Error(message || "Không thể lưu địa chỉ.");
        }

        closeAddressPopup();
        addAddressForm.reset();
        addressIdInput.value = "";
        addressModalTitle.textContent = "Thêm địa chỉ";

        wardSelect.innerHTML =
            '<option value="" selected disabled>Chọn phường / xã</option>';
        wardSelect.disabled = true;

        await loadAddresses();

    } catch (error) {
        console.error("Lỗi xử lý địa chỉ:", error);
        alert(error.message || "Có lỗi xảy ra. Vui lòng thử lại.");
    } finally {
        confirmAddressBtn.disabled = false;
    }
});
loadAddresses().catch(error => {
    console.error("Lỗi tải địa chỉ:", error);
});

addressItems.addEventListener("click", async function (event) {
    const editButton = event.target.closest(".edit-address-btn");
    const deleteButton = event.target.closest(".delete-address-btn");

    // CHỈNH SỬA ĐỊA CHỈ
    if (editButton) {
        addAddressForm.reset();

        addressIdInput.value = editButton.dataset.id;
        addressModalTitle.textContent = "Chỉnh sửa địa chỉ";

        document.getElementById("recipientName").value =
            editButton.dataset.name || "";

        document.getElementById("recipientPhone").value =
            editButton.dataset.phone || "";

        document.getElementById("detailAddress").value =
            editButton.dataset.detail || "";

        document.getElementById("isDefaultAddress").checked =
            editButton.dataset.default === "true";

        const provinceCode = editButton.dataset.provinceCode;
        const wardCode = editButton.dataset.wardCode;

        // Chọn tỉnh cũ
        provinceSelect.value = provinceCode || "";

        // Tải các phường/xã thuộc tỉnh đó
        wardSelect.innerHTML =
            '<option value="">Đang tải phường/xã...</option>';
        wardSelect.disabled = true;

        addressModal.hidden = false;
        document.body.style.overflow = "hidden";

        try {
            const response = await fetch(
                `https://provinces.open-api.vn/api/v2/p/${provinceCode}?depth=2`
            );

            if (!response.ok) {
                throw new Error("Không thể tải danh sách phường/xã.");
            }

            const province = await response.json();

            wardSelect.innerHTML =
                '<option value="" disabled>Chọn phường / xã</option>';

            province.wards.forEach(function (ward) {
                const option = document.createElement("option");
                option.value = ward.code;
                option.textContent = ward.name;

                if (String(ward.code) === String(wardCode)) {
                    option.selected = true;
                }

                wardSelect.appendChild(option);
            });

            wardSelect.disabled = false;

        } catch (error) {
            console.error("Lỗi tải phường/xã:", error);
            alert(error.message);
        }

        return;
    }

    // XÓA ĐỊA CHỈ
    if (deleteButton) {
        if (!confirm("Bạn có chắc chắn muốn xóa địa chỉ này không?")) {
            return;
        }

        try {
            const data = new URLSearchParams();
            data.set("action", "delete");
            data.set("addressId", deleteButton.dataset.id);

            const response = await fetch(
                `${contextPath}/delivery-addresses`,
                {
                    method: "POST",
                    headers: {
                        "Content-Type":
                            "application/x-www-form-urlencoded;charset=UTF-8",
                        "Accept": "text/plain"
                    },
                    body: data.toString()
                }
            );

            const message = await response.text();

            if (!response.ok) {
                throw new Error(message || "Không thể xóa địa chỉ.");
            }

            await loadAddresses();

        } catch (error) {
            console.error("Lỗi xóa địa chỉ:", error);
            alert(error.message || "Không thể xóa địa chỉ.");
        }
    }
});

//Script số 4
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
        if (!menu.contains(e.target)) {
            menu.classList.remove("open");
        }
    });
})();

//Script số 5
// Lấy danh sách tỉnh/thành khi mở trang
async function loadProvinces() {
    try {
        const response = await fetch(
            "https://provinces.open-api.vn/api/v2/"
        );
        if (!response.ok) {
            throw new Error("Không thể tải danh sách tỉnh/thành");
        }
        const provinces = await response.json();
        provinces.forEach(province => {
            const option = document.createElement("option");
            option.value = province.code;
            option.textContent = province.name;
            provinceSelect.appendChild(option);
        });
    } catch (error) {
        console.error(error);
        alert("Không thể tải danh sách tỉnh/thành.");
    }
}

// Khi chọn tỉnh/thành, tải danh sách phường/xã tương ứng

provinceSelect.addEventListener("change", async function () {
    const provinceCode = this.value;

    wardSelect.innerHTML =
        '<option value="" selected disabled>Chọn phường / xã</option>';
    wardSelect.disabled = true;

    if (!provinceCode) {
        return;
    }

    try {
        const url =
            `https://provinces.open-api.vn/api/v2/p/${provinceCode}?depth=2`;

        console.log("API đang gọi:", url);

        const response = await fetch(url);

        if (!response.ok) {
            throw new Error(`HTTP ${response.status}`);
        }

        const province = await response.json();

        console.log("Dữ liệu tỉnh/thành:", province);

        if (!Array.isArray(province.wards)) {
            throw new Error("API không trả về danh sách wards");
        }

        province.wards.forEach(ward => {
            const option = document.createElement("option");

            option.value = ward.code;
            option.textContent = ward.name;

            wardSelect.appendChild(option);
        });

        wardSelect.disabled = false;

        console.log("Số phường/xã:", province.wards.length);

    } catch (error) {
        console.error("Lỗi tải phường/xã:", error);
        alert("Không thể tải danh sách phường/xã. Hãy mở Console để kiểm tra.");
    }
});

loadProvinces();
