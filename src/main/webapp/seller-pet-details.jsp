
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
    <title>Pet Details | PawCare</title>
    <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet"
        href="<%= contextPath %>/CSS/seller-pet-details.css">
</head>
<body>

<main class="details-page">
    <a class="back-link" href="<%= contextPath %>/home.jsp#buyPets">
        <i class="fa-solid fa-arrow-left"></i> Back to Pets
    </a>

    <div id="loadingMessage" class="message">Loading pet details...</div>
    <div id="errorMessage" class="message error" hidden></div>

    <section id="petDetails" class="details-layout" hidden>
        <div class="gallery">
            <div class="main-image">
                <img id="petImage" src="" alt="Pet photo">
                <span class="availability">
                    <i class="fa-solid fa-circle-check"></i>
                    Available for Adoption
                </span>
            </div>
        </div>

        <div class="pet-information">
            <div class="status-row">
                <span class="status-pill">Available for Adoption</span>
                <span class="health-pill">Seller Listed</span>
            </div>

            <h1 id="petName">Pet Name</h1>
            <h2 id="petBreed">Pet Breed</h2>
            <p id="petDescription" class="description"></p>

            <div class="facts-grid">
                <div class="fact-card">
                    <span class="fact-icon purple"><i class="fa-solid fa-paw"></i></span>
                    <div><small>Species</small><strong id="petSpecies">—</strong></div>
                </div>

                <div class="fact-card">
                    <span class="fact-icon pink"><i class="fa-solid fa-cake-candles"></i></span>
                    <div><small>Age</small><strong id="petAge">—</strong></div>
                </div>

                <div class="fact-card">
                    <span class="fact-icon blue"><i class="fa-solid fa-venus-mars"></i></span>
                    <div><small>Gender</small><strong id="petGender">—</strong></div>
                </div>

                <div class="fact-card">
                    <span class="fact-icon violet"><i class="fa-solid fa-weight-scale"></i></span>
                    <div><small>Weight</small><strong id="petWeight">—</strong></div>
                </div>

                <div class="fact-card">
                    <span class="fact-icon grey"><i class="fa-solid fa-ruler"></i></span>
                    <div><small>Size</small><strong id="petSize">—</strong></div>
                </div>

                <div class="fact-card">
                    <span class="fact-icon orange"><i class="fa-solid fa-location-dot"></i></span>
                    <div><small>Location</small><strong id="petLocation">—</strong></div>
                </div>
            </div>

            <div class="purchase-area">
                <div class="price-area">
                    <span>Adoption Fee</span>
                    <strong id="petPrice">₹0.00</strong>
                    <small>Seller-listed pet</small>
                </div>

                <div class="purchase-buttons">
                    <button type="button" id="addToCartButton" class="cart-button">
                        <i class="fa-solid fa-cart-shopping"></i> Add to Cart
                    </button>
                    <button type="button" id="buyNowButton" class="buy-button">
                        Buy Now <i class="fa-solid fa-arrow-right"></i>
                    </button>
                </div>
            </div>
        </div>
    </section>
</main>

<script>
    const contextPath = "<%= contextPath %>";
    const listingId = new URLSearchParams(window.location.search).get("id");

    const loadingMessage = document.getElementById("loadingMessage");
    const errorMessage = document.getElementById("errorMessage");
    const details = document.getElementById("petDetails");

    let currentPet = null;

    function showError(message) {
        loadingMessage.hidden = true;
        details.hidden = true;
        errorMessage.textContent = message;
        errorMessage.hidden = false;
    }

    function setText(id, value, fallback = "Not specified") {
        document.getElementById(id).textContent =
            value !== null && value !== undefined && String(value).trim() !== ""
                ? value
                : fallback;
    }

    async function loadPetDetails() {
        if (!listingId || !/^\d+$/.test(listingId)) {
            showError("Invalid pet listing. Please return to Buy Pets.");
            return;
        }

        try {
            const response = await fetch(
                contextPath + "/MarketplaceListingsServlet",
                { cache: "no-store" }
            );

            if (!response.ok) {
                throw new Error("Unable to contact the marketplace.");
            }

            const data = await response.json();

            if (!data.success) {
                throw new Error(data.message || "Unable to load pet details.");
            }

            currentPet = (data.pets || []).find(
                pet => String(pet.id) === String(listingId)
            );

            if (!currentPet) {
                showError("This pet listing was not found or is no longer available.");
                return;
            }

            const image = document.getElementById("petImage");
            image.src = currentPet.imageUrl || "";
            image.alt = currentPet.title || "Pet photo";
            image.onerror = function () {
                this.onerror = null;
                this.style.visibility = "hidden";
            };

            setText("petName", currentPet.title, "Pet");
            setText(
                "petBreed",
                [currentPet.breed, currentPet.animalType]
                    .filter(Boolean).join(" · "),
                currentPet.animalType || "Pet"
            );
            setText(
                "petDescription",
                currentPet.description,
                "Contact the seller for more information about this pet."
            );
            setText("petSpecies", currentPet.animalType);
            setText(
                "petAge",
                currentPet.age ? currentPet.age + " years" : ""
            );
            setText("petGender", currentPet.gender);
            setText(
                "petWeight",
                currentPet.weight ? currentPet.weight + " kg" : ""
            );
            setText("petSize", currentPet.size);
            setText("petLocation", currentPet.location);

            document.getElementById("petPrice").textContent =
                "₹" + Number(currentPet.price || 0).toLocaleString("en-IN", {
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                });

            loadingMessage.hidden = true;
            errorMessage.hidden = true;
            details.hidden = false;

        } catch (error) {
            console.error("Pet details error:", error);
            showError(error.message || "Could not load pet details.");
        }
    }

    // These buttons will be connected to the seller-listing cart
    // and purchase backend in the next step.
   
document.getElementById("addToCartButton").addEventListener("click", async () => {

    if (!currentPet) return;

    const formData = new URLSearchParams();
    formData.append("sellerListingId", currentPet.id);

    const button = document.getElementById("addToCartButton");
    button.disabled = true;

    try {
        const response = await fetch(contextPath + "/AddToCartServlet", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: formData.toString(),
            credentials: "same-origin"
        });

        const message = await response.text();

        if (response.status === 401) {
            alert("Please log in before adding a pet.");
            window.location.href = contextPath + "/login.jsp";
            return;
        }

        if (!response.ok) {
            throw new Error(message);
        }

        alert("🐾 " + currentPet.title + " added to your cart!");

        window.location.href = contextPath + "/cart.jsp";

    } catch (error) {
        console.error(error);
        alert(error.message || "Unable to add pet to cart.");
    } finally {
        button.disabled = false;
    }
});


document.getElementById("buyNowButton").addEventListener("click", () => {

    if (!currentPet || !currentPet.id) {
        alert("Pet details are not loaded. Please try again.");
        return;
    }

    window.location.href =
        contextPath + "/seller-checkout.jsp?id=" +
        encodeURIComponent(currentPet.id);

});


    loadPetDetails();
</script>
</body>
</html>
