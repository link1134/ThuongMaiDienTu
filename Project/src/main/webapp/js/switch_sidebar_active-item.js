document.addEventListener("DOMContentLoaded", function () {
    // Lấy 4 mục lục quản lý
    var menuItems = document.querySelectorAll(
        ".sidebar-nav-item[data-section]"
    );

    // Lấy các khu vực nội dung
    var ordersSection = document.getElementById("ordersSection");
    var profileSection = document.getElementById("profileSection");
    var addressSection = document.getElementById("addressSection");
    var followListSection = document.getElementById("followListSection");
    var settingsSection = document.getElementById("settingsSection");

    // Nhóm các khu vực theo từng mục lục
    var sections = {
        orders: [ordersSection],
        address: [addressSection],
        followList: [followListSection],
        settings: [profileSection, settingsSection]
    };

    // Gom tất cả khu vực cần điều khiển
    var allSections = [
        ordersSection,
        profileSection,
        addressSection,
        followListSection,
        settingsSection
    ];

    // Ẩn tất cả, sau đó hiện các khu vực được chọn
    function showSection(sectionName) {
        allSections.forEach(function (section) {
            if (section) {
                section.style.display = "none";
            }
        });

        if (sections[sectionName]) {
            sections[sectionName].forEach(function (section) {
                if (section) {
                    section.style.display = "";
                }
            });
        }

        // Cập nhật mục lục đang được chọn
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

    // Gắn sự kiện click cho từng mục lục
    menuItems.forEach(function (item) {
        item.addEventListener("click", function (event) {
            event.preventDefault();
            var sectionName = item.getAttribute("data-section");
            showSection(sectionName);
        });
    });

    // Mặc định mở mục Đơn hàng
    showSection("settings");
});
