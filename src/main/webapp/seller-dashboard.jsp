<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Keep the existing seller session protection.
    if (session.getAttribute("sellerLoggedIn") != Boolean.TRUE
            || session.getAttribute("sellerId") == null) {
        response.sendRedirect(request.getContextPath() + "/seller-login.jsp");
        return;
    }

    String sellerName = String.valueOf(session.getAttribute("sellerName"));
    String sellerType = String.valueOf(session.getAttribute("sellerType"));
    boolean petSeller = "PET_SELLER".equals(sellerType);

    // Escape seller name before rendering it into HTML.
    String safeSellerName = sellerName.replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seller Dashboard | PetNest</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/seller-login.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --green-950: #073d28;
            --green-900: #0b5134;
            --green-800: #126b42;
            --green-700: #16804c;
            --green-100: #e7f5eb;
            --green-50: #f2faf4;
            --ink: #173328;
            --muted: #718078;
            --line: #e3ece6;
            --surface: #ffffff;
            --page: #f4f8f5;
            --shadow: 0 12px 35px rgba(17, 69, 42, .07);
        }
        
        .edit-listing-button {
    width: 100%;
    margin-top: 12px;
    padding: 10px;
    border: none;
    border-radius: 9px;
    background: #e7f5eb;
    color: #126b42;
    font-weight: 800;
    cursor: pointer;
    transition: 0.2s ease;
}

.edit-listing-button:hover {
    background: #126b42;
    color: #fff;
}
        
        
        /* ================= EDIT LISTING MODAL ================= */

.edit-modal-overlay {
    position: fixed;
    inset: 0;
    z-index: 9999;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
    background: rgba(7, 35, 22, 0.65);
    backdrop-filter: blur(5px);
}

.edit-modal {
    width: 100%;
    max-width: 520px;
    max-height: 90vh;
    overflow-y: auto;
    padding: 26px;
    border-radius: 18px;
    background: #fff;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
    animation: editModalIn 0.25s ease;
}

@keyframes editModalIn {
    from {
        opacity: 0;
        transform: translateY(15px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.edit-modal-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 22px;
}

.edit-modal-header h2 {
    margin: 0;
    color: #126b42;
    font-size: 23px;
}

.edit-modal-header p {
    margin: 6px 0 0;
    color: #718078;
    font-size: 13px;
}

.close-edit-modal {
    width: 35px;
    height: 35px;
    border: none;
    border-radius: 9px;
    background: #f1f6f2;
    color: #176b40;
    font-size: 25px;
    cursor: pointer;
}

.edit-modal-actions {
    display: flex;
    gap: 12px;
    margin-top: 22px;
}

.edit-modal-actions button {
    flex: 1;
}

.cancel-edit-button {
    padding: 13px;
    border: 1px solid #d9e5dd;
    border-radius: 11px;
    background: #f4f8f5;
    color: #176b40;
    font-weight: 700;
    cursor: pointer;
}

.cancel-edit-button:hover {
    background: #e7f2e9;
}

@media (max-width: 500px) {
    .edit-modal {
        padding: 20px;
    }

    .edit-modal-actions {
        flex-direction: column;
    }
}
        * { box-sizing: border-box; }
        html { scroll-behavior: smooth; }
        body {
            margin: 0;
            min-height: 100vh;
            background: var(--page);
            color: var(--ink);
            font-family: 'DM Sans', Arial, Helvetica, sans-serif;
        }
        .dashboard-wrapper { width: min(1380px, 94%); margin: 24px auto 55px; }
        .topbar {
            display: flex; align-items: center; justify-content: space-between;
            gap: 18px; margin-bottom: 20px;
        }
        .brand {
            display: inline-flex; align-items: center; gap: 11px;
            color: var(--green-800); text-decoration: none;
            font-size: 27px; font-weight: 800; letter-spacing: -.7px;
        }
        .brand-icon {
            display: grid; place-items: center; width: 45px; height: 45px;
            border-radius: 15px; background: #e2f3e7; font-size: 25px;
        }
        .logout-button {
            display: inline-flex; align-items: center; gap: 8px;
            padding: 11px 18px; border-radius: 11px;
            background: #e8f4eb; color: var(--green-900);
            text-decoration: none; font-weight: 700; transition: .2s ease;
        }
        .logout-button:hover { background: #d6eadc; transform: translateY(-1px); }
        .welcome-card {
            position: relative; isolation: isolate; overflow: hidden;
            min-height: 190px; padding: 31px 36px; margin-bottom: 22px;
            border-radius: 22px; color: #fff;
            background: linear-gradient(115deg, #0d6540 0%, #16804e 58%, #24945d 100%);
            box-shadow: 0 15px 35px rgba(13, 101, 64, .15);
        }
        .welcome-card::after {
            content: '🐾'; position: absolute; z-index: -1;
            right: 55px; bottom: -35px; font-size: 170px;
            opacity: .12; transform: rotate(-17deg);
        }
        .welcome-card h1 { margin: 0 0 9px; max-width: 850px; font-size: clamp(25px, 3vw, 36px); line-height: 1.2; }
        .welcome-card > p { margin: 0 0 16px; color: rgba(255,255,255,.92); line-height: 1.6; }
        .welcome-meta { display: flex; align-items: center; flex-wrap: wrap; gap: 13px; }
        .seller-badge {
            display: inline-flex; align-items: center; gap: 7px;
            padding: 7px 12px; border-radius: 30px;
            background: rgba(255,255,255,.19); color: #fff;
            font-size: 12px; font-weight: 800; letter-spacing: .3px;
        }
        .seller-type { font-size: 14px; color: #fff; }
        .overview-grid {
            display: grid; grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px; margin-bottom: 22px;
        }
        .overview-card {
            display: flex; align-items: center; gap: 15px;
            min-height: 94px; padding: 19px 22px;
            border: 1px solid var(--line); border-radius: 17px;
            background: #fff; box-shadow: var(--shadow);
        }
        .overview-icon {
            display: grid; place-items: center; flex: 0 0 48px;
            width: 48px; height: 48px; border-radius: 15px;
            background: var(--green-100); font-size: 23px;
        }
        .overview-value { display: block; font-size: 25px; line-height: 1.1; font-weight: 800; color: var(--green-950); }
        .overview-label { display: block; margin-top: 5px; color: var(--muted); font-size: 13px; }
        .dashboard-grid {
            display: grid; grid-template-columns: minmax(330px, .82fr) minmax(0, 1.45fr);
            gap: 20px; align-items: start;
        }
        .right-column { display: grid; gap: 18px; min-width: 0; }
        .panel {
            min-width: 0; padding: 25px;
            border: 1px solid var(--line); border-radius: 19px;
            background: var(--surface); box-shadow: var(--shadow);
        }
        .panel-heading { display: flex; align-items: center; gap: 10px; margin-bottom: 7px; }
        .panel-heading .heading-icon { font-size: 21px; }
        .panel h2 { margin: 0; color: var(--green-800); font-size: 21px; letter-spacing: -.3px; }
        .panel-description { margin: 0 0 20px; color: var(--muted); font-size: 14px; line-height: 1.65; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 7px; color: #294638; font-size: 13px; font-weight: 700; }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%; min-width: 0; padding: 11px 12px;
            border: 1px solid #d9e5dd; border-radius: 10px;
            outline: none; background: #fff; color: var(--ink);
            font: inherit; font-size: 14px; transition: .2s ease;
        }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
            border-color: #24945d; box-shadow: 0 0 0 3px rgba(36,148,93,.11);
        }
        .form-group textarea { min-height: 100px; resize: vertical; }
        .form-group input[type="file"] { padding: 8px; background: #fbfdfb; }
        .form-group small { display: block; margin-top: 6px; color: var(--muted); font-size: 12px; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .submit-button {
            width: 100%; padding: 13px 18px; border: 0; border-radius: 11px;
            background: var(--green-700); color: #fff;
            font: inherit; font-size: 15px; font-weight: 800; cursor: pointer;
            transition: .2s ease;
        }
        .submit-button:hover { background: var(--green-900); transform: translateY(-1px); }
        .seller-info-box {
            display: grid; gap: 15px; padding: 18px;
            border-radius: 13px; background: #f4f8f5;
        }
        .info-row { display: flex; align-items: flex-start; gap: 11px; color: #5f7066; font-size: 14px; line-height: 1.55; }
        .info-row strong { color: #294638; }
        .info-icon { width: 20px; flex: 0 0 20px; color: var(--green-700); }
        .listings-panel { padding: 25px; }
        .listings-header {
            display: flex; justify-content: space-between; align-items: center;
            flex-wrap: wrap; gap: 14px; margin-bottom: 17px;
        }
        .listings-header .panel-description { margin: 5px 0 0; }
        .refresh-button {
            display: inline-flex; align-items: center; gap: 7px;
            padding: 10px 14px; border: 1px solid #cfe2d5;
            border-radius: 10px; background: #f1f8f3;
            color: var(--green-800); font: inherit; font-size: 13px;
            font-weight: 800; cursor: pointer; transition: .2s ease;
        }
        .refresh-button:hover { background: #e2f2e7; }
        .listing-message {
            margin-bottom: 14px; padding: 13px 15px;
            border-radius: 11px; background: #f4f8f5;
            color: #66766c; font-size: 13px; line-height: 1.55;
        }
        .listing-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 14px; }
        .listing-card {
            min-width: 0; overflow: hidden;
            border: 1px solid var(--line); border-radius: 14px;
            background: #fff; transition: .2s ease;
        }
        .listing-card:hover { transform: translateY(-3px); box-shadow: 0 10px 24px rgba(17,69,42,.09); }
        .listing-card img {
            display: block; width: 100%; height: 155px;
            object-fit: cover; background: #edf4ef;
        }
        .listing-card-content { padding: 13px; }
        .listing-card h3 { margin: 0 0 8px; color: #244b32; font-size: 15px; overflow-wrap: anywhere; }
        .listing-card p { margin: 6px 0; color: #718078; font-size: 12px; line-height: 1.5; overflow-wrap: anywhere; }
        .listing-price { color: var(--green-700) !important; font-size: 16px !important; font-weight: 800; }
        .listing-category {
            display: inline-block; margin-top: 5px; padding: 5px 9px;
            border-radius: 20px; background: #e8f5eb;
            color: var(--green-800); font-size: 11px; font-weight: 800;
        }
        .hidden { display: none !important; }
        @media (max-width: 900px) {
            .dashboard-grid { grid-template-columns: minmax(290px, .9fr) minmax(0, 1.1fr); }
            .panel { padding: 20px; }
            .listing-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
        }
        @media (max-width: 700px) {
            .dashboard-wrapper { width: 93%; margin: 17px auto 35px; }
            .dashboard-grid { grid-template-columns: 1fr; }
            .right-column { grid-row: auto; }
            .welcome-card { min-height: 0; padding: 24px 21px; }
            .welcome-card::after { right: 8px; font-size: 105px; }
            .overview-grid { grid-template-columns: 1fr 1fr; gap: 10px; }
            .overview-card { min-height: 82px; padding: 13px; gap: 10px; }
            .overview-icon { flex-basis: 39px; width: 39px; height: 39px; font-size: 19px; }
            .overview-value { font-size: 21px; }
            .overview-label { font-size: 11px; }
        }
        @media (max-width: 440px) {
            .brand { font-size: 22px; }
            .brand-icon { width: 39px; height: 39px; }
            .logout-button { padding: 9px 12px; font-size: 13px; }
            .form-row { grid-template-columns: 1fr; gap: 0; }
            .listing-grid { grid-template-columns: 1fr 1fr; gap: 9px; }
            .listing-card img { height: 115px; }
            .listing-card-content { padding: 10px; }
            .panel, .listings-panel { padding: 17px; }
        }
    </style>
</head>
<body>
<div class="dashboard-wrapper">
    <header class="topbar">
        <a class="brand" href="${pageContext.request.contextPath}/home.jsp">
            <span class="brand-icon">🐾</span><span>PetNest</span>
        </a>
        <a class="logout-button" href="${pageContext.request.contextPath}/SellerLogoutServlet">⇥ Log Out</a>
    </header>

    <section class="welcome-card">
        <h1>Welcome, <%= safeSellerName %>!</h1>
        <p>Manage your listings and help pets and their owners find what they need.</p>
        <div class="welcome-meta">
            <span class="seller-badge">✓ APPROVED SELLER</span>
            <span class="seller-type"><strong>Seller type:</strong> <%= petSeller ? "Pet Seller" : "Product Seller" %></span>
        </div>
    </section>

    <!-- These figures are populated from the existing listings response; no new backend API is required. -->
    <section class="overview-grid" aria-label="Seller overview">
        <div class="overview-card">
            <span class="overview-icon">🐾</span>
            <div><span class="overview-value" id="totalListingsCount">—</span><span class="overview-label">Total Listings</span></div>
        </div>
        <div class="overview-card">
            <span class="overview-icon">✓</span>
            <div><span class="overview-value"><%= petSeller ? "Pets" : "Products" %></span><span class="overview-label">Your listing type</span></div>
        </div>
    </section>

    <main class="dashboard-grid">
        <section class="panel" id="uploadPanel">
            <div class="panel-heading"><span class="heading-icon">☁</span><h2><%= petSeller ? "Upload a Pet" : "Upload a Product" %></h2></div>
            <p class="panel-description">Add your listing. Once saved successfully, it can be shown to customers.</p>

            <form id="listingForm" action="${pageContext.request.contextPath}/SellerListingServlet" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="title"><%= petSeller ? "Pet Name" : "Product Name" %></label>
                    <input type="text" id="title" name="title" maxlength="150" required>
                </div>
                <div class="form-group">
                    <label for="image">Listing Image</label>
                    <input type="file" id="image" name="image" accept=".jpg,.jpeg,.png,.webp,image/jpeg,image/png,image/webp" required>
                    <small>JPG, PNG or WebP. Maximum 5 MB.</small>
                </div>

                <% if (petSeller) { %>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="animalType">Species</label>
                            <select id="animalType" name="animalType" required>
                                <option value="">Select species</option>
                                <option value="Dog">Dog</option><option value="Cat">Cat</option>
                                <option value="Bird">Bird</option><option value="Fish">Fish</option>
                                <option value="Rabbit">Rabbit</option><option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="form-group"><label for="breed">Breed</label><input type="text" id="breed" name="breed" maxlength="100"></div>
                    </div>
                    <div class="form-row">
                        <div class="form-group"><label for="age">Approximate Age</label><input type="text" id="age" name="age" maxlength="50" placeholder="e.g. 3 months"></div>
                        <div class="form-group">
                            <label for="gender">Gender</label>
                            <select id="gender" name="gender"><option value="">Select gender</option><option value="Male">Male</option><option value="Female">Female</option><option value="Unknown">Unknown</option></select>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group"><label for="weight">Weight</label><input type="text" id="weight" name="weight" maxlength="50" placeholder="e.g. 2 kg"></div>
                        <div class="form-group">
                            <label for="size">Size</label>
                            <select id="size" name="size"><option value="">Select size</option><option value="Small">Small</option><option value="Medium">Medium</option><option value="Large">Large</option></select>
                        </div>
                    </div>
                    <div class="form-group"><label for="location">Location</label><input type="text" id="location" name="location" maxlength="200" required></div>
                <% } else { %>
                    <div class="form-group">
                        <label for="category">Product Category</label>
                        <select id="category" name="category" required>
                            <option value="">Select Category</option>
                            <option value="Pet Foods">Pet Foods</option>
                            <option value="Health Care">Health Care</option>
                            <option value="Dress &amp; Accessories">Dress &amp; Accessories</option>
                        </select>
                    </div>
                    <div class="form-group hidden" id="foodAnimalGroup">
                        <label for="foodAnimalType">Food For</label>
                        <select id="foodAnimalType" name="foodAnimalType">
                            <option value="">Select Animal</option><option value="Dog">Dog</option><option value="Cat">Cat</option>
                            <option value="Bird">Bird</option><option value="Fish">Fish</option><option value="Rabbit">Rabbit</option><option value="Other">Other</option>
                        </select>
                    </div>
                    <div class="form-group"><label for="quantity">Quantity Available</label><input type="number" id="quantity" name="quantity" min="1" step="1" value="1" required></div>
                <% } %>

                <div class="form-group">
                    <label for="price"><%= petSeller ? "Approximate Price (₹)" : "Price (₹)" %></label>
                    <input type="number" id="price" name="price" min="0.01" step="0.01" required>
                </div>
                <div class="form-group"><label for="description">Description</label><textarea id="description" name="description" maxlength="5000" placeholder="Add details about your listing..."></textarea></div>
                <button type="submit" class="submit-button"><%= petSeller ? "Upload Pet" : "Upload Product" %></button>
            </form>
        </section>

        <div class="right-column">
            <section class="panel">
                <div class="panel-heading"><span class="heading-icon">●</span><h2>Seller Information</h2></div>
                <p class="panel-description">Your seller account is approved. You can use this dashboard to manage your own listings.</p>
                <div class="seller-info-box">
                    <div class="info-row"><span class="info-icon">♟</span><span><strong>Account:</strong> Approved seller</span></div>
                    <div class="info-row"><span class="info-icon">◆</span><span><strong>Listing type:</strong> <%= petSeller ? "Pets" : "Pet products" %></span></div>
                    <div class="info-row"><span class="info-icon">▣</span><span><strong>Listing approval:</strong> Not required. New listings are intended to be available to customers after they are successfully saved.</span></div>
                </div>
            </section>

            <section class="panel listings-panel" id="myListingsPanel">
                <div class="listings-header">
                    <div>
                        <div class="panel-heading"><span class="heading-icon">☷</span><h2>My Listings</h2></div>
                        <p class="panel-description">View the listings associated with your seller account.</p>
                    </div>
                    <button type="button" class="refresh-button" id="refreshListings">⟳ Refresh Listings</button>
                </div>
                <div id="listingMessage" class="listing-message">Your saved listings will appear here once SellerListingServlet is connected to the database.</div>
                <div id="listingGrid" class="listing-grid"></div>
            </section>
        </div>
    </main>
</div>
<!-- Edit Listing Modal -->
<div class="edit-modal-overlay hidden" id="editListingModal">
    <div class="edit-modal">

        <div class="edit-modal-header">
            <div>
                <h2>Edit Listing</h2>
                <p>Update your listing information</p>
            </div>

            <button type="button" id="closeEditModal"
                    class="close-edit-modal">&times;</button>
        </div>

        <form id="editListingForm"
              enctype="multipart/form-data">

            <input type="hidden" id="editListingId" name="listingId">

            <!-- Pet-only fields -->
            <div id="editPetFields">

                <div class="form-group">
                    <label for="editAge">Age</label>
                    <input type="text" id="editAge" name="age"
                           maxlength="50">
                </div>

                <div class="form-group">
                    <label for="editWeight">Weight</label>
                    <input type="text" id="editWeight" name="weight"
                           maxlength="50">
                </div>

                <div class="form-group">
                    <label for="editSize">Size</label>
                    <select id="editSize" name="size">
                        <option value="">Select Size</option>
                        <option value="Small">Small</option>
                        <option value="Medium">Medium</option>
                        <option value="Large">Large</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="editLocation">Location</label>
                    <input type="text" id="editLocation" name="location"
                           maxlength="200">
                </div>

            </div>

            <!-- Common price field -->
            <div class="form-group">
                <label for="editPrice">Price (₹)</label>
                <input type="number" id="editPrice" name="price"
                       min="0.01" step="0.01" required>
            </div>

            <!-- Image field -->
            <div class="form-group">
                <label for="editImage">Change Image (Optional)</label>
                <input type="file" id="editImage" name="image"
                       accept=".jpg,.jpeg,.png,.webp">
                <small>Leave empty to keep the current image.</small>
            </div>

            <div class="edit-modal-actions">
                <button type="button" id="cancelEdit"
                        class="cancel-edit-button">Cancel</button>

                <button type="submit"
                        class="submit-button">Save Changes</button>
            </div>

        </form>
    </div>
</div>
<script>
    const APP_PATH = "${pageContext.request.contextPath}";
    const SELLER_TYPE = "<%= petSeller ? "PET_SELLER" : "PRODUCT_SELLER" %>";

    // Keep the existing product-food animal selector behavior.
    document.addEventListener("DOMContentLoaded", function () {
        const category = document.getElementById("category");
        const foodAnimalGroup = document.getElementById("foodAnimalGroup");
        const foodAnimalType = document.getElementById("foodAnimalType");

        if (category && foodAnimalGroup && foodAnimalType) {
            function updateFoodAnimalField() {
                const isFood = category.value === "Pet Foods";
                foodAnimalGroup.classList.toggle("hidden", !isFood);
                foodAnimalType.required = isFood;
                if (!isFood) foodAnimalType.value = "";
            }
            category.addEventListener("change", updateFoodAnimalField);
            updateFoodAnimalField();
        }

        document.getElementById("refreshListings").addEventListener("click", loadListings);
        loadListings();
    });

    // Existing GET request and JSON response contract are retained.
    async function loadListings() {
        const message = document.getElementById("listingMessage");
        const grid = document.getElementById("listingGrid");
        const count = document.getElementById("totalListingsCount");

        message.textContent = "Loading your listings...";
        grid.replaceChildren();

        try {
            const response = await fetch(APP_PATH + "/SellerListingServlet", {
                method: "GET",
                headers: { "Accept": "application/json" },
                credentials: "same-origin"
            });

            if (!response.ok) throw new Error("Could not load listings.");
            const data = await response.json();
            if (!data.success) throw new Error(data.message || "Could not load listings.");

            const listings = Array.isArray(data.listings) ? data.listings : [];
            count.textContent = listings.length;

            if (listings.length === 0) {
                message.textContent = "You have not uploaded any listings yet.";
                return;
            }

            message.textContent = listings.length + " listing(s) found.";

            listings.forEach(function (listing) {
                const card = document.createElement("article");
                card.className = "listing-card";

                if (listing.image) {
                    const img = document.createElement("img");
                    img.src = APP_PATH + "/uploads/seller-listings/" + encodeURIComponent(listing.image);
                    img.alt = listing.title || "Listing image";
                    img.loading = "lazy";
                    card.appendChild(img);
                }

                const content = document.createElement("div");
                content.className = "listing-card-content";

                const title = document.createElement("h3");
                title.textContent = listing.title || "Untitled listing";
                content.appendChild(title);

                const price = document.createElement("p");
                price.className = "listing-price";
                price.textContent = "₹" + Number(listing.price || 0).toFixed(2);
                content.appendChild(price);

                if (listing.category) {
                    const categoryTag = document.createElement("span");
                    categoryTag.className = "listing-category";
                    categoryTag.textContent = listing.category;
                    content.appendChild(categoryTag);
                } else if (listing.animalType) {
                    const species = document.createElement("p");
                    species.textContent = "Species: " + listing.animalType;
                    content.appendChild(species);
                }

                if (listing.description) {
                    const description = document.createElement("p");
                    description.textContent = listing.description;
                    content.appendChild(description);
                }

                if (listing.quantity !== undefined && listing.quantity !== null) {
                    const quantity = document.createElement("p");
                    quantity.textContent = "Quantity: " + listing.quantity;
                    content.appendChild(quantity);
                }

             // Edit button
                const editButton = document.createElement("button");
                editButton.type = "button";
                editButton.className = "edit-listing-button";
                editButton.textContent = "✏ Edit Listing";

                editButton.addEventListener("click", function () {
                    openEditModal(listing);
                });

                content.appendChild(editButton);

                card.appendChild(content);
                grid.appendChild(card);
            });
        } catch (error) {
            count.textContent = "—";
            message.textContent = error.message || "Listings could not be loaded. Check SellerListingServlet.";
        }
    }
    
 // Open Edit Listing Modal
    function openEditModal(listing) {
        const modal = document.getElementById("editListingModal");

        document.getElementById("editListingId").value = listing.id;
        document.getElementById("editPrice").value = listing.price ?? "";
        document.getElementById("editImage").value = "";

        const petFields = document.getElementById("editPetFields");
        const isPetSeller = SELLER_TYPE === "PET_SELLER";

        petFields.classList.toggle("hidden", !isPetSeller);

        if (isPetSeller) {
            document.getElementById("editAge").value = listing.age ?? "";
            document.getElementById("editWeight").value = listing.weight ?? "";
            document.getElementById("editSize").value = listing.size ?? "";
            document.getElementById("editLocation").value = listing.location ?? "";
        }

        modal.classList.remove("hidden");
        document.body.style.overflow = "hidden";
    }

    // Close Edit Listing Modal
    function closeEditModal() {
        document.getElementById("editListingModal").classList.add("hidden");
        document.body.style.overflow = "";
    }

    // Close button
    document.getElementById("closeEditModal")
        .addEventListener("click", closeEditModal);

    // Cancel button
    document.getElementById("cancelEdit")
        .addEventListener("click", closeEditModal);

    // Close when clicking outside the modal
    document.getElementById("editListingModal")
        .addEventListener("click", function(event) {
            if (event.target === this) {
                closeEditModal();
            }
        });
    
 // Submit Edit Listing Form
    document.getElementById("editListingForm")
        .addEventListener("submit", async function(event) {
            event.preventDefault();

            const form = this;
            const submitButton = form.querySelector('button[type="submit"]');
            const formData = new FormData(form);

            submitButton.disabled = true;
            submitButton.textContent = "Saving...";

            try {
                const response = await fetch(
                    APP_PATH + "/EditSellerListingServlet",
                    {
                        method: "POST",
                        body: formData,
                        credentials: "same-origin"
                    }
                );

                const result = await response.json();

                if (!response.ok || !result.success) {
                    alert(result.message || "Unable to update listing.");
                    return;
                }

                alert("Listing updated successfully!");
                closeEditModal();
                form.reset();

                // Refresh seller listings
                loadListings();

            } catch (error) {
                console.error("Edit listing error:", error);
                alert("Something went wrong. Please try again.");
            } finally {
                submitButton.disabled = false;
                submitButton.textContent = "Save Changes";
            }
        });
    
    
</script>
</body>
</html>
