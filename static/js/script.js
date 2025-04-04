function confirmDelete(event) {
    if (!confirm("Are you sure you want to delete this record?")) {
        event.preventDefault();
    }
}
document.addEventListener("DOMContentLoaded", function () {
    let deleteForms = document.querySelectorAll("form[action*='/delete/']");
    deleteForms.forEach(function (form) {
        form.addEventListener("submit", confirmDelete);
    });
});
function togglePasswordVisibility(id) {
    let passwordField = document.getElementById(id);
    if (passwordField.type === "password") {
        passwordField.type = "text";
    } else {
        passwordField.type = "password";
    }
}
document.addEventListener("DOMContentLoaded", function () {
    let currentPath = window.location.pathname;
    let navLinks = document.querySelectorAll(".sidebar a");
    navLinks.forEach(function (link) {
        if (link.getAttribute("href") === currentPath) {
            link.classList.add("active");
        }
    });
});
document.addEventListener("DOMContentLoaded", function () {
    let toggleButton = document.getElementById("sidebar-toggle");
    let sidebar = document.querySelector(".sidebar");
    if (toggleButton) {
        toggleButton.addEventListener("click", function () {
            sidebar.classList.toggle("collapsed");
        });
    }
});
