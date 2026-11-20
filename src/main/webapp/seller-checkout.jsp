
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%
    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>PetNest | Checkout</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/CSS/seller-checkout.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body>

<div class="checkout-container">

    <header class="checkout-header">
        <a href="javascript:history.back()" class="back-link">
            <i class="fa-solid fa-arrow-left"></i>
            Back
        </a>

        <h2>PetNest <span>Checkout</span></h2>

        <div class="secure-label">
            <i class="fa-solid fa-shield-halved"></i>
            Secure Checkout
        </div>
    </header>

    <main class="checkout-content">

        <div class="checkout-heading">
            <p>ALMOST YOURS!</p>
            <h1>Complete Your Purchase 🐾</h1>
            <span>Review your selected pet before confirming.</span>
        </div>

        <div class="checkout-grid">

            <!-- PET DETAILS -->
            <section class="pet-checkout-card">

                <h3>
                    <i class="fa-solid fa-paw"></i>
                    Your Selected Pet
                </h3>

                <div id="loadingMessage">
                    Loading pet details...
                </div>

                <div id="petDetails" style="display:none;">

                    <img id="petImage" src="" alt="Selected pet">

                    <div class="pet-information">
                        <h2 id="petName"></h2>
                        <p id="petBreed"></p>

                        <div class="pet-meta">
                            <span id="petAge"></span>
                            <span id="petGender"></span>
                            <span id="petLocation"></span>
                        </div>

                        <p id="petDescription"></p>
                    </div>

                </div>

            </section>

            <!-- ORDER SUMMARY -->
            <section class="order-summary">

                <h3>Order Summary</h3>

                <div class="summary-row">
                    <span>Pet Price</span>
                    <strong id="petPrice">₹0</strong>
                </div>

                <div class="summary-row">
                    <span>Delivery Fee</span>
                    <strong>₹0</strong>
                </div>

                <div class="summary-divider"></div>

                <div class="summary-total">
                    <span>Total Amount</span>
                    <strong id="totalPrice">₹0</strong>
                </div>

                <form action="<%= contextPath %>/BuySellerPetServlet"
                      method="POST"
                      id="purchaseForm">

                    <input type="hidden"
                           name="sellerListingId"
                           id="sellerListingId">

                    <button type="submit"
                            id="confirmPurchase"
                            disabled>
                        Confirm Purchase
                        <i class="fa-solid fa-arrow-right"></i>
                    </button>

                </form>

                <p class="checkout-note">
                    <i class="fa-solid fa-heart"></i>
                    Thank you for supporting our pet community.
                </p>

            </section>

        </div>

    </main>

</div>

<script>
    const contextPath = "<%= contextPath %>";

    const params = new URLSearchParams(window.location.search);
    const listingId = params.get("id");

    const loadingMessage = document.getElementById("loadingMessage");
    const petDetails = document.getElementById("petDetails");
    const confirmButton = document.getElementById("confirmPurchase");

    if (!listingId || !/^\d+$/.test(listingId)) {
        loadingMessage.textContent = "Invalid pet listing.";
    } else {

        fetch(contextPath + "/MarketplaceListingsServlet")
            .then(response => {
                if (!response.ok) {
                    throw new Error("Unable to load listings.");
                }
                return response.json();
            })
            .then(data => {

                const pet = (data.pets || []).find(
                    item => String(item.id) === listingId
                );

                if (!pet) {
                    loadingMessage.textContent =
                        "This pet is no longer available.";
                    return;
                }

                if (pet.listingType !== "PET") {
                    loadingMessage.textContent =
                        "This listing is not a pet.";
                    return;
                }

                document.getElementById("sellerListingId").value = pet.id;

                document.getElementById("petName").textContent =
                    pet.title;

                document.getElementById("petBreed").textContent =
                    pet.breed || pet.animalType || "Pet";

                document.getElementById("petAge").textContent =
                    pet.age || "Age not specified";

                document.getElementById("petGender").textContent =
                    pet.gender || "Not specified";

                document.getElementById("petLocation").textContent =
                    pet.location || "Location not specified";

                document.getElementById("petDescription").textContent =
                    pet.description || "";

                const image = document.getElementById("petImage");

                if (pet.imageUrl) {
                    image.src = pet.imageUrl;
                } else {
                    image.alt = "Pet image unavailable";
                }

                image.onerror = function () {
                    this.style.display = "none";
                };

                const price = Number(pet.price);

                if (!Number.isFinite(price) || price < 0) {
                    throw new Error("Invalid pet price.");
                }

                document.getElementById("petPrice").textContent =
                    "₹" + price.toFixed(2);

                document.getElementById("totalPrice").textContent =
                    "₹" + price.toFixed(2);

                loadingMessage.style.display = "none";
                petDetails.style.display = "flex";
                confirmButton.disabled = false;

            })
            .catch(error => {
                console.error(error);
                loadingMessage.textContent =
                    "Unable to load checkout details. Please try again.";
            });
    }
</script>

</body>
</html>
