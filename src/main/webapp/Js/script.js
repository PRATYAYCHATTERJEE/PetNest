document.addEventListener("DOMContentLoaded", function () {

    const menuToggle = document.getElementById("menuToggle");
    const navMenu = document.getElementById("navMenu");

    /* =====================================
       MOBILE MENU
    ===================================== */

    if (menuToggle && navMenu) {

        menuToggle.addEventListener("click", function () {

            navMenu.classList.toggle("active");

        });
    }


    /* =====================================
       CLOSE MOBILE MENU
       WHEN CLICKING A NAV LINK
    ===================================== */

    const navLinks = document.querySelectorAll(".nav-link");

    navLinks.forEach(function (link) {

        link.addEventListener("click", function () {

            navMenu.classList.remove("active");

        });

    });


    /* =====================================
       SEARCH
    ===================================== */

    const searchInput = document.getElementById("searchInput");

    if (searchInput) {

        searchInput.addEventListener("keypress", function (event) {

            if (event.key === "Enter") {

                const searchValue = searchInput.value.trim();

                if (searchValue !== "") {

                    console.log("Searching for:", searchValue);

                }

            }

        });

    }

});


/* =========================================
   PET FAVORITE BUTTON
========================================= */

function toggleFavorite(button) {

    button.classList.toggle("active");

}


/* =========================================
   PET CARD BUTTON
========================================= */

document.querySelectorAll(".details-btn").forEach(button => {

    button.addEventListener("click", function () {

        const card = this.closest(".pet-card");
        const petName = card.querySelector("h3").textContent;

        console.log("Opening details for:", petName);

        // Later we can change this to:
        // window.location.href = "pet-details.jsp";

    });

});


