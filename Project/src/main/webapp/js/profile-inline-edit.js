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


