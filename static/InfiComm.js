document.addEventListener("DOMContentLoaded", function () {
    const addRecordHeading = document.getElementById("add-record-heading");
    const addRecordSection = document.getElementById("add-record-section");

    if (addRecordHeading && addRecordSection) {
        addRecordHeading.addEventListener("click", function () {
            addRecordSection.style.display = addRecordSection.style.display === "none" ? "block" : "none";
            if (addRecordSection.style.display === "block") {
                addRecordSection.scrollIntoView({ behavior: "smooth", block: "start" });
            }
        });
    }

    // Form validation
    const forms = document.querySelectorAll("form");
    forms.forEach(form => {
        form.addEventListener("submit", function (event) {
            const inputs = form.querySelectorAll("input[required]");
            let valid = true;
            inputs.forEach(input => {
                if (!input.value.trim()) {
                    input.style.border = "2px solid red";
                    valid = false;
                } else {
                    input.style.border = "";
                }
            });
            if (!valid) {
                event.preventDefault();
                alert("Please fill in all required fields.");
            }
        });
    });

    // Confirmation before delete action
    const deleteButtons = document.querySelectorAll(".delete-btn");
    deleteButtons.forEach(button => {
        button.addEventListener("click", function (event) {
            if (!confirm("Are you sure you want to delete this record?")) {
                event.preventDefault();
            }
        });
    });

    // AJAX for table updates (optional, requires backend modifications)
    const searchForms = document.querySelectorAll(".search-form");
    searchForms.forEach(form => {
        form.addEventListener("submit", function (event) {
            event.preventDefault();
            const formData = new FormData(form);
            const tableName = form.getAttribute("action").split("/").pop();

            fetch(`/search/${tableName}`, {
                method: "POST",
                body: formData
            })
            .then(response => response.text())
            .then(html => {
                document.querySelector(".table-wrapper").innerHTML = html;
            })
            .catch(error => console.error("Error:", error));
        });
    });
});
