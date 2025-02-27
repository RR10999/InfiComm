document.addEventListener("DOMContentLoaded", function () {
    
    // Enable Edit Mode
    window.enableEdit = function(userId) {
        const phoneElement = document.querySelector(`#phone-${userId}`);
        const planElement = document.querySelector(`#plan-${userId}`);
        const priceElement = document.querySelector(`#price-${userId}`);

        // Save original values in case user cancels
        phoneElement.dataset.original = phoneElement.textContent;
        planElement.dataset.original = planElement.textContent;
        priceElement.dataset.original = priceElement.textContent;

        // Convert text to input fields
        phoneElement.innerHTML = `<input type="text" id="edit-phone-${userId}" value="${phoneElement.textContent}">`;
        planElement.innerHTML = `<input type="text" id="edit-plan-${userId}" value="${planElement.textContent}">`;
        priceElement.innerHTML = `<input type="text" id="edit-price-${userId}" value="${priceElement.textContent}">`;

        // Show/Hide buttons
        document.querySelector(`#user-${userId} .edit-btn`).classList.add("hidden");
        document.querySelector(`#user-${userId} .update-btn`).classList.remove("hidden");
        document.querySelector(`#user-${userId} .cancel-btn`).classList.remove("hidden");
    };

    // Cancel Edit Mode (Restore Original Values)
    window.cancelEdit = function(userId) {
        document.querySelector(`#phone-${userId}`).textContent = document.querySelector(`#phone-${userId}`).dataset.original;
        document.querySelector(`#plan-${userId}`).textContent = document.querySelector(`#plan-${userId}`).dataset.original;
        document.querySelector(`#price-${userId}`).textContent = document.querySelector(`#price-${userId}`).dataset.original;

        // Show/Hide buttons
        document.querySelector(`#user-${userId} .edit-btn`).classList.remove("hidden");
        document.querySelector(`#user-${userId} .update-btn`).classList.add("hidden");
        document.querySelector(`#user-${userId} .cancel-btn`).classList.add("hidden");
    };

    // Update User Data
    window.updateUser = function(userId) {
        const phone = document.querySelector(`#edit-phone-${userId}`).value;
        const plan = document.querySelector(`#edit-plan-${userId}`).value;
        const price = document.querySelector(`#edit-price-${userId}`).value;

        fetch(`/update_user/${userId}`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ phone, plan, price })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert("User updated successfully!");
                
                // Update displayed values
                document.querySelector(`#phone-${userId}`).textContent = phone;
                document.querySelector(`#plan-${userId}`).textContent = plan;
                document.querySelector(`#price-${userId}`).textContent = price;

                // Show/Hide buttons
                document.querySelector(`#user-${userId} .edit-btn`).classList.remove("hidden");
                document.querySelector(`#user-${userId} .update-btn`).classList.add("hidden");
                document.querySelector(`#user-${userId} .cancel-btn`).classList.add("hidden");
            } else {
                alert("Update failed!");
            }
        })
        .catch(error => {
            console.error("Error updating user:", error);
            alert("An error occurred while updating the user.");
        });
    };

    // Confirm Delete Popup
    window.confirmDelete = function(userId) {
        if (confirm("Are you sure you want to delete this user?")) {
            fetch(`/delete_user/${userId}`, { method: "POST" })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert("User deleted successfully!");
                    document.querySelector(`#user-${userId}`).remove();
                } else {
                    alert("Delete failed!");
                }
            })
            .catch(error => {
                console.error("Error deleting user:", error);
                alert("An error occurred while deleting the user.");
            });
        }
    };
});
