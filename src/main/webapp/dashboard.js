/* =========================================
   PAWCARE DASHBOARD JS
   Works with the current home.jsp
========================================= */

function openLogoutPopup() {
    document.getElementById("logoutPopup").style.display = "flex";
}

function closeLogoutPopup() {
    document.getElementById("logoutPopup").style.display = "none";
}
/* =========================================
   SECTION SWITCHING
========================================= */

window.showSection = function (sectionId, clickedItem) {

    // -----------------------------------------
    // 1. Get all dashboard sections
    // -----------------------------------------

    const sections = document.querySelectorAll(".page-section");


    // -----------------------------------------
    // 2. Hide ALL sections
    // -----------------------------------------

    sections.forEach(function (section) {

        section.classList.remove("active");

    });


    // -----------------------------------------
    // 3. Show ONLY selected section
    // -----------------------------------------

    const selectedSection =
        document.getElementById(sectionId);


    if (!selectedSection) {

        console.error(
            "Section not found:",
            sectionId
        );

        return;

    }


    selectedSection.classList.add("active");


    // -----------------------------------------
    // 4. Update sidebar active item
    // -----------------------------------------

    const sidebarItems =
        document.querySelectorAll(
            ".sidebar-nav .nav-item"
        );


    sidebarItems.forEach(function (item) {

        item.classList.remove("active");

    });


    // If sidebar item was clicked directly
    if (clickedItem) {

        clickedItem.classList.add("active");

    }

    // If section was opened from another button
    else {

        const sectionToNavItem = {

            dashboard: 0,
            buyPets: 1,
            myPets: 2,
            adoption: 3,
            veterinary: 4,
            store: 5,
            community: 6,
            messages: 7,
            settings: 8

        };


        const navIndex =
            sectionToNavItem[sectionId];


        if (
            navIndex !== undefined &&
            sidebarItems[navIndex]
        ) {

            sidebarItems[navIndex]
                .classList.add("active");

        }

    }


    // -----------------------------------------
    // 5. Close mobile sidebar
    // -----------------------------------------

    closeMobileSidebar();


    // -----------------------------------------
    // 6. Scroll content to top
    // -----------------------------------------

    window.scrollTo({
        top: 0,
        behavior: "smooth"
    });

};


/* =========================================
   MOBILE SIDEBAR
========================================= */

function closeMobileSidebar() {

    const sidebar =
        document.getElementById("sidebar");

    const overlay =
        document.getElementById("mobileOverlay");


    if (sidebar) {

        sidebar.classList.remove("open");

    }


    if (overlay) {

        overlay.classList.remove("active");

    }

}


/* =========================================
   DASHBOARD INITIALIZATION
========================================= */

function initializeDashboard() {

    const mobileMenu =
        document.getElementById("mobileMenu");

    const sidebar =
        document.getElementById("sidebar");

    const overlay =
        document.getElementById("mobileOverlay");


    /* -----------------------------------------
       MOBILE MENU BUTTON
    ----------------------------------------- */

    if (mobileMenu) {

        mobileMenu.addEventListener(
            "click",
            function () {

                if (!sidebar) {
                    return;
                }


                sidebar.classList.toggle("open");


                if (overlay) {

                    overlay.classList.toggle(
                        "active"
                    );

                }

            }
        );

    }


    /* -----------------------------------------
       MOBILE OVERLAY
    ----------------------------------------- */

    if (overlay) {

        overlay.addEventListener(
            "click",
            function () {

                closeMobileSidebar();

            }
        );

    }


    /* -----------------------------------------
       BUY PETS FILTERS
    ----------------------------------------- */

    const petSearch =
        document.getElementById("petSearch");

    const animalFilter =
        document.getElementById("animalFilter");

    const genderFilter =
        document.getElementById("genderFilter");


    if (petSearch) {

        petSearch.addEventListener(
            "input",
            filterPets
        );

    }


    if (animalFilter) {

        animalFilter.addEventListener(
            "change",
            filterPets
        );

    }


    if (genderFilter) {

        genderFilter.addEventListener(
            "change",
            filterPets
        );

    }


    /* -----------------------------------------
       TOP SEARCH
    ----------------------------------------- */

    const searchInput =
        document.getElementById("searchInput");


    if (searchInput) {

        searchInput.addEventListener(
            "keydown",
            function (event) {

                if (event.key !== "Enter") {
                    return;
                }


                const searchText =
                    searchInput.value
                        .trim();


                if (searchText === "") {
                    return;
                }


                // Open Buy Pets
                window.showSection(
                    "buyPets",
                    null
                );


                // Put search text
                // into Buy Pets search
                const buyPetSearch =
                    document.getElementById(
                        "petSearch"
                    );


                if (buyPetSearch) {

                    buyPetSearch.value =
                        searchText;

                    filterPets();

                }

            }
        );

    }


    /* -----------------------------------------
       FAVORITE BUTTONS
    ----------------------------------------- */

    document.addEventListener(
        "click",
        function (event) {

            const favoriteButton =
                event.target.closest(
                    ".pet-favorite"
                );


            if (!favoriteButton) {
                return;
            }


            event.preventDefault();


            favoriteButton.classList.toggle(
                "active"
            );


            const icon =
                favoriteButton.querySelector(
                    "i"
                );


            if (!icon) {
                return;
            }


            if (
                favoriteButton
                    .classList
                    .contains("active")
            ) {

                icon.classList.remove(
                    "fa-regular"
                );

                icon.classList.add(
                    "fa-solid"
                );

            }

            else {

                icon.classList.remove(
                    "fa-solid"
                );

                icon.classList.add(
                    "fa-regular"
                );

            }

        }
    );


    /* -----------------------------------------
       INITIAL PET FILTER
    ----------------------------------------- */

    filterPets();


    /* -----------------------------------------
       MAKE SURE DASHBOARD IS OPEN
    ----------------------------------------- */

    const sections =
        document.querySelectorAll(
            ".page-section"
        );


    // If somehow multiple sections
    // are active, fix it.

    let activeFound = false;


    sections.forEach(function (section) {

        if (
            section.classList.contains(
                "active"
            )
        ) {

            if (!activeFound) {

                activeFound = true;

            }

            else {

                section.classList.remove(
                    "active"
                );

            }

        }

    });


    // If no section is active,
    // open Dashboard.

    if (!activeFound) {

        window.showSection(
            "dashboard",
            null
        );

    }

}


/* =========================================
   BUY PETS FILTER
========================================= */

function filterPets() {

    const petSearch =
        document.getElementById("petSearch");

    const animalFilter =
        document.getElementById(
            "animalFilter"
        );

    const genderFilter =
        document.getElementById(
            "genderFilter"
        );


    const cards =
        document.querySelectorAll(
            ".buy-pet-card"
        );


    // If Buy Pets cards don't exist,
    // simply stop.

    if (!cards.length) {
        return;
    }


    const searchValue =
        petSearch
            ? petSearch.value
                .toLowerCase()
                .trim()
            : "";


    const animalValue =
        animalFilter
            ? animalFilter.value
            : "all";


    const genderValue =
        genderFilter
            ? genderFilter.value
            : "all";


    let visibleCount = 0;


    cards.forEach(function (card) {

        const searchData =
            (
                card.dataset.search ||
                ""
            )
            .toLowerCase();


        const animal =
            (
                card.dataset.animal ||
                ""
            )
            .toLowerCase();


        const gender =
            (
                card.dataset.gender ||
                ""
            )
            .toLowerCase();


        const matchesSearch =
            searchData.includes(
                searchValue
            );


        const matchesAnimal =
            animalValue === "all" ||
            animal === animalValue;


        const matchesGender =
            genderValue === "all" ||
            gender === genderValue;


        const shouldShow =
            matchesSearch &&
            matchesAnimal &&
            matchesGender;


        if (shouldShow) {

            card.style.display = "";

            visibleCount++;

        }

        else {

            card.style.display = "none";

        }

    });


    /* -----------------------------------------
       UPDATE PET COUNT
    ----------------------------------------- */

    const petCount =
        document.getElementById(
            "petCount"
        );


    if (petCount) {

        petCount.textContent =
            visibleCount +
            (
                visibleCount === 1
                    ? " Pet Available"
                    : " Pets Available"
            );

    }

}


/* =========================================
   START
========================================= */

if (
    document.readyState === "loading"
) {

    document.addEventListener(
        "DOMContentLoaded",
        initializeDashboard
    );

}

else {

    initializeDashboard();

}





function showStoreCategory(category, clickedButton) {
    document.querySelectorAll(".store-category-btn").forEach(button => {
        button.classList.toggle("active", button === clickedButton);
    });

    document.querySelectorAll(".store-category-content").forEach(content => {
        content.hidden = true;
    });

    const selected = document.getElementById("store-" + category);
    if (selected) selected.hidden = false;

    const headings = {
        food: ["Pet Foods", "Nutritious choices for happier, healthier pets."],
        health: ["Health Care", "Everyday care and wellness essentials."],
        accessories: ["Dress & Accessories", "Comfort, style and fun for your pets."]
    };

    const heading = document.getElementById("storeHeading");
    const subtitle = document.getElementById("storeSubtitle");

    if (headings[category] && heading && subtitle) {
        heading.textContent = headings[category][0];
        subtitle.textContent = headings[category][1];
    }

    filterStoreProducts();
}

function filterStoreProducts() {
    const activeCategory =
        document.querySelector(".store-category-btn.active");

    if (!activeCategory) return;

    const visiblePanel = Array.from(
        document.querySelectorAll(".store-category-content")
    ).find(panel => !panel.hidden);

    if (!visiblePanel) return;

    const query = (
        document.getElementById("storeSearch")?.value || ""
    ).trim().toLowerCase();

    const petFilter =
        document.getElementById("storePetFilter")?.value || "all";

    const sort =
        document.getElementById("storeSort")?.value || "default";

    const grid = visiblePanel.querySelector(".store-product-grid");
    if (!grid) return;

    const products = Array.from(grid.querySelectorAll(".store-product"));

    products.forEach(product => {
        const name = (product.dataset.name || "").toLowerCase();
        const pet = product.dataset.pet || "all";

        const matchesName = name.includes(query);
        const matchesPet = petFilter === "all" ||
            pet === petFilter || pet === "all";

        product.hidden = !(matchesName && matchesPet);
    });

    const visibleProducts = products.filter(product => !product.hidden);

    visibleProducts.sort((a, b) => {
        if (sort === "low") {
            return Number(a.dataset.price) - Number(b.dataset.price);
        }
        if (sort === "high") {
            return Number(b.dataset.price) - Number(a.dataset.price);
        }
        if (sort === "name") {
            return a.dataset.name.localeCompare(b.dataset.name);
        }
        return 0;
    });

    visibleProducts.forEach(product => grid.appendChild(product));

    const empty = document.getElementById("storeEmpty");
    if (empty) empty.hidden = visibleProducts.length > 0;
}

function toggleWishlist(button) {
    const selected = button.classList.toggle("selected");
    button.innerHTML = selected
        ? '<i class="fa-solid fa-heart"></i>'
        : '<i class="fa-regular fa-heart"></i>';

    button.setAttribute(
        "aria-label",
        selected ? "Remove from wishlist" : "Add to wishlist"
    );
}


function addStoreItem(name, price) {
    const formData = new URLSearchParams();
    formData.append("productName", name);
    formData.append("price", price);

    fetch("AddToCartServlet", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: formData.toString(),
        credentials: "same-origin"
    })
    .then(async response => {
        const message = await response.text();

        if (response.status === 401) {
            alert("Please log in before adding products.");
            window.location.href = "login.jsp";
            return;
        }

        if (!response.ok) {
            throw new Error(message || "Could not add the product.");
        }

        alert("🐾 " + name + " added to your cart!");

    })
    .catch(error => {
        console.error("Add to cart error:", error);
        alert("Unable to add this product. Please try again.");
    });
}






document.addEventListener("DOMContentLoaded", function () {
    const button = document.getElementById("notificationBtn");
    const dropdown = document.getElementById("notificationDropdown");
    const content = document.getElementById("notificationContent");
    const dot = document.getElementById("notificationDot");

    if (!button || !dropdown || !content || !dot) {
        console.error("Notification elements not found.");
        return;
    }

    const endpoint =
        window.location.pathname.substring(
            0, window.location.pathname.lastIndexOf("/")
        ) + "/DoctorNotificationServlet";

    async function loadNotifications() {
        content.replaceChildren();

        const loading = document.createElement("p");
        loading.textContent = "Loading notifications...";
        content.appendChild(loading);

        try {
            const response = await fetch(endpoint, {
                credentials: "same-origin",
                cache: "no-store"
            });

            if (!response.ok) {
                throw new Error("HTTP " + response.status);
            }

            const data = await response.json();
            const notifications = data.notifications || [];

            content.replaceChildren();

            if (notifications.length === 0) {
                const empty = document.createElement("p");
                empty.textContent = "No appointment responses yet.";
                content.appendChild(empty);
                dot.style.display = "none";
                return;
            }

            dot.style.display = "block";

            notifications.forEach(function (item) {
                const card = document.createElement("div");
                card.className = "notification-item";

				// Create remove button
				const closeBtn = document.createElement("button");

				closeBtn.className = "notification-close";
				closeBtn.type = "button";
				closeBtn.innerHTML = "&times;";
				closeBtn.setAttribute("aria-label", "Remove notification");

				closeBtn.addEventListener("click", function () {
				    card.remove();

				    // Hide notification dot if no cards remain
				    if (content.querySelectorAll(".notification-item").length === 0) {
				        dot.style.display = "none";

				        const empty = document.createElement("p");
				        empty.textContent = "No appointment responses yet.";
				        content.appendChild(empty);
				    }
				});

				card.appendChild(closeBtn);
				
				
				
                const title = document.createElement("strong");
                title.textContent = item.title || "Appointment Update";

                const doctor = document.createElement("p");
                doctor.textContent = "Dr. " + (item.doctor || "Veterinarian");

                const pet = document.createElement("p");
                pet.textContent = "Pet: " + (item.petName || "Your pet");

                const date = document.createElement("p");
                date.textContent =
                    "Appointment: " + (item.date || "N/A") +
                    " at " + (item.time || "N/A");

                const status = document.createElement("p");
                status.textContent = "Status: " + (item.status || "UPDATED");

                const message = document.createElement("p");
                message.textContent =
                    "Doctor's message: " + (item.message || "");

                card.append(title, doctor, pet, date, status, message);
                content.appendChild(card);
            });

        } catch (error) {
            console.error("Notification loading failed:", error);

            content.replaceChildren();

            const errorMessage = document.createElement("p");
            errorMessage.textContent =
                "Unable to load notifications. Please refresh and try again.";

            content.appendChild(errorMessage);
        }
    }

    button.addEventListener("click", function (event) {
        event.stopPropagation();

        const opening = dropdown.style.display === "none" ||
                        getComputedStyle(dropdown).display === "none";

        dropdown.style.display = opening ? "block" : "none";
        button.setAttribute("aria-expanded", String(opening));

        if (opening) {
            loadNotifications();
        }
    });

    dropdown.addEventListener("click", function (event) {
        event.stopPropagation();
    });

    document.addEventListener("click", function (event) {
        if (!event.target.closest(".notification-wrapper")) {
            dropdown.style.display = "none";
            button.setAttribute("aria-expanded", "false");
        }
    });

    loadNotifications();
});


function removeNotification(button) {

    const notification = button.closest(".notification-card");

    if (notification) {
        notification.style.transition = "opacity 0.25s ease, transform 0.25s ease";
        notification.style.opacity = "0";
        notification.style.transform = "translateX(20px)";

        setTimeout(() => {
            notification.remove();
        }, 250);
    }
}



/* ==========================================
   LOAD SELLER LISTINGS INTO CUSTOMER DASHBOARD
   ========================================== */

async function loadMarketplaceListings() {
    try {
        const response = await fetch("MarketplaceListingsServlet");

        if (!response.ok) {
            throw new Error("Failed to load marketplace listings");
        }

        const data = await response.json();

        if (!data.success) {
            throw new Error(data.message || "Marketplace loading failed");
        }

        /* ==========================================
           SELLER PETS — MATCH PAWCARE PET CARD DESIGN
           ========================================== */

        const petGrid = document.getElementById("buyPetsGrid");
		
		if (petGrid && Array.isArray(data.pets)) {

		    const availablePetIds = new Set(
		        data.pets.map(pet => String(pet.id))
		    );

		    petGrid.querySelectorAll("[data-seller-listing-id]").forEach(card => {

		        const listingId = card.dataset.sellerListingId;

		        if (!availablePetIds.has(String(listingId))) {
		            card.remove();
		        }

		    });

		}
		
		

        if (petGrid && Array.isArray(data.pets)) {
            data.pets.forEach(pet => {
                if (
                    petGrid.querySelector(
                        `[data-seller-listing-id="${pet.id}"]`
                    )
                ) {
                    return;
                }

                const card = document.createElement("article");
                card.className = "buy-pet-card seller-pet-card";

                card.dataset.sellerListingId = pet.id;
                card.dataset.animal = (pet.animalType || "other").toLowerCase();
                card.dataset.gender = (pet.gender || "unknown").toLowerCase();

                card.dataset.search = [
                    pet.title,
                    pet.animalType,
                    pet.breed,
                    pet.age,
                    pet.gender,
                    pet.location
                ].filter(Boolean).join(" ").toLowerCase();

                // Pet image
                const imageBox = document.createElement("div");
                imageBox.className = "buy-pet-image";

                const img = document.createElement("img");
                img.src = pet.imageUrl || "";
                img.alt = pet.title || "Seller-listed pet";

                img.onerror = function () {
                    this.onerror = null;
                    this.style.display = "none";
                };

                imageBox.appendChild(img);

                // Availability badge
                const badge = document.createElement("span");
                badge.className = "pet-status-badge";
                badge.textContent = "Available";

                imageBox.appendChild(badge);

                // Card information
                const info = document.createElement("div");
                info.className = "buy-pet-info";

                const title = document.createElement("h3");
                title.textContent = pet.title || "Pet";

                const breed = document.createElement("p");
                breed.className = "seller-pet-breed";
                breed.textContent = [
                    pet.animalType,
                    pet.breed
                ].filter(Boolean).join(" ");

                // Age and location
                const meta = document.createElement("div");
                meta.className = "seller-pet-meta";

                const age = document.createElement("span");
                const ageIcon = document.createElement("i");
                ageIcon.className = "fa-solid fa-cake-candles";
                age.appendChild(ageIcon);
                age.appendChild(document.createTextNode(
                    " " + (pet.age ? pet.age + " years" : "Age not specified")
                ));

                const location = document.createElement("span");
                const locationIcon = document.createElement("i");
                locationIcon.className = "fa-solid fa-location-dot";
                location.appendChild(locationIcon);
                location.appendChild(document.createTextNode(
                    " " + (pet.location || "Location not specified")
                ));

                meta.append(age, location);

                // Divider
                const divider = document.createElement("div");
                divider.className = "seller-pet-divider";

                // Price and details button
                const footer = document.createElement("div");
                footer.className = "seller-pet-footer";

                const feeBox = document.createElement("div");
                feeBox.className = "seller-pet-fee";

                const feeLabel = document.createElement("span");
                feeLabel.textContent = "Adoption Fee";

                const price = document.createElement("strong");
                price.textContent =
                    "₹" + Number(pet.price || 0).toLocaleString("en-IN", {
                        minimumFractionDigits: 2,
                        maximumFractionDigits: 2
                    });

                feeBox.append(feeLabel, price);

                const detailsButton = document.createElement("button");
                detailsButton.type = "button";
                detailsButton.className = "seller-pet-details";
                detailsButton.innerHTML =
                    'View Details <i class="fa-solid fa-arrow-right"></i>';

					detailsButton.addEventListener("click", function () {
					    window.location.href =
					        "seller-pet-details.jsp?id=" + encodeURIComponent(pet.id);
					});

                footer.append(feeBox, detailsButton);

                info.append(title, breed, meta, divider, footer);
                card.append(imageBox, info);

                // Append without removing existing pet cards
                petGrid.appendChild(card);
            });

            // Keep existing pet search and filters working
            if (typeof filterPets === "function") {
                filterPets();
            }
        }

        /* ==========================================
           SELLER PRODUCTS — KEEP EXISTING CATEGORIES
           ========================================== */

        if (Array.isArray(data.products)) {
            data.products.forEach(product => {
                const category = (product.category || "")
                    .trim()
                    .toLowerCase();

                let panelId;

                if (category === "pet foods") {
                    panelId = "store-food";
                } else if (category === "health care") {
                    panelId = "store-health";
                } else if (category === "dress & accessories") {
                    panelId = "store-accessories";
                } else {
                    return;
                }

                const panel = document.getElementById(panelId);
                const grid = panel?.querySelector(".store-product-grid");

                if (
                    !grid ||
                    grid.querySelector(
                        `[data-seller-listing-id="${product.id}"]`
                    )
                ) {
                    return;
                }

                const card = document.createElement("article");
                card.className = "store-product";

                card.dataset.sellerListingId = product.id;
                card.dataset.category =
                    panelId === "store-food" ? "food" :
                    panelId === "store-health" ? "health" :
                    "accessories";

                const petType =
                    (product.foodAnimalType || "all").toLowerCase();

                card.dataset.pet =
                    petType === "dog" ? "dogs" :
                    petType === "cat" ? "cats" :
                    "all";

                card.dataset.name = product.title || "Seller product";
                card.dataset.price = product.price || 0;

                // Product image
                const imageBox = document.createElement("div");
                imageBox.className = "store-product-image";

                const img = document.createElement("img");
                img.src = product.imageUrl || "";
                img.alt = product.title || "Seller product";

                img.onerror = function () {
                    this.onerror = null;
                    this.style.display = "none";
                };

                imageBox.appendChild(img);

                // Product information
                const info = document.createElement("div");
                info.className = "store-product-info";

                const title = document.createElement("h3");
                title.textContent = product.title || "Seller product";

                const description = document.createElement("p");
                description.textContent =
                    product.description || "Seller-listed product";

                const price = document.createElement("div");
                price.className = "store-price";
                price.textContent =
                    "₹" + Number(product.price || 0).toFixed(2);

                // Preserve the existing Add to Cart workflow
                const addButton = document.createElement("button");
                addButton.type = "button";
                addButton.className = "store-add-btn";
                addButton.innerHTML =
                    '<i class="fa-solid fa-cart-plus"></i> Add to Cart';

                addButton.addEventListener("click", function () {
                    if (typeof addStoreItem === "function") {
                        addStoreItem(
                            product.title,
                            Number(product.price || 0)
                        );
                    }
                });

                info.append(title, description, price, addButton);
                card.append(imageBox, info);

                grid.appendChild(card);
            });

            // Preserve existing store search and sorting
            if (typeof filterStoreProducts === "function") {
                filterStoreProducts();
            }
        }

    } catch (error) {
        console.error(
            "Marketplace listings could not be loaded:",
            error
        );
    }
}

document.addEventListener(
    "DOMContentLoaded",
    loadMarketplaceListings
);



