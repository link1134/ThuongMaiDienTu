//Script 1
const selectAll = document.getElementById("select-all");
const itemCheckboxes = document.querySelectorAll(".item-checkbox");
if (selectAll) {
    selectAll.addEventListener("change", function () {
        itemCheckboxes.forEach(checkbox => checkbox.checked = selectAll.checked);
    });
    itemCheckboxes.forEach(function (checkbox) {
        checkbox.addEventListener("change", function () {
            selectAll.checked = [...itemCheckboxes].every(item => item.checked);
        });
    });
}
