// Confirm before deleting a record
function confirmDelete(event) {
    if (!confirm("Are you sure you want to delete this record?")) {
        event.preventDefault();
    }
}

// Attach delete confirmation to all delete buttons
document.addEventListener("DOMContentLoaded", function () {
    let deleteForms = document.querySelectorAll("form[action*='/delete/']");
    deleteForms.forEach(function (form) {
        form.addEventListener("submit", confirmDelete);
    });
});

// Toggle visibility of password fields
function togglePasswordVisibility(id) {
    let passwordField = document.getElementById(id);
    if (passwordField.type === "password") {
        passwordField.type = "text";
    } else {
        passwordField.type = "password";
    }
}

// Add active class to the current navigation link
document.addEventListener("DOMContentLoaded", function () {
    let currentPath = window.location.pathname;
    let navLinks = document.querySelectorAll(".sidebar a");

    navLinks.forEach(function (link) {
        if (link.getAttribute("href") === currentPath) {
            link.classList.add("active");
        }
    });
});

// Sidebar Toggle for Mobile View
document.addEventListener("DOMContentLoaded", function () {
    let toggleButton = document.getElementById("sidebar-toggle");
    let sidebar = document.querySelector(".sidebar");

    if (toggleButton) {
        toggleButton.addEventListener("click", function () {
            sidebar.classList.toggle("collapsed");
        });
    }
});
