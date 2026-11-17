<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Petora | Checkout</title>

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    background: #f3f8f4;
    font-family: 'Segoe UI', sans-serif;
    color: #173d35;
}

.checkout-page {
    width: 100%;
    min-height: 100vh;
    padding: 35px 7%;
}

/* HEADER */

.checkout-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding-bottom: 28px;
    border-bottom: 1px solid #dce7df;
}

.back-link {
    text-decoration: none;
    color: #128653;
    font-size: 17px;
    font-weight: 600;
}

.checkout-header h2 {
    font-size: 30px;
    font-weight: 750;
}

.checkout-header h2 span {
    color: #128653;
}

.secure-checkout {
    color: #128653;
    font-size: 16px;
}

/* INTRO */

.checkout-intro {
    margin: 48px 0 34px;
}

.intro-label {
    color: #128653;
    font-size: 14px;
    font-weight: 800;
    letter-spacing: 4px;
}

.checkout-intro h1 {
    margin: 15px 0;
    font-size: 38px;
    font-weight: 750;
}

.checkout-intro p {
    color: #788b86;
    font-size: 18px;
}

/* MAIN LAYOUT */

.checkout-container {
    display: grid;
    grid-template-columns: 1.55fr 1fr;
    gap: 30px;
    align-items: start;
}

/* CARDS */

.selected-pet-card,
.order-summary-card {
    background: #fff;
    border-radius: 24px;
    padding: 35px;
    box-shadow: 0 12px 40px rgba(31,70,52,0.06);
}

.selected-pet-card h2,
.order-summary-card h2 {
    font-size: 24px;
    font-weight: 750;
    margin-bottom: 32px;
}

.selected-pet-card h2 i {
    color: #128653;
    margin-right: 10px;
}

/* PET DETAILS */

.selected-pet-content {
    display: flex;
    gap: 27px;
    align-items: flex-start;
}

.selected-pet-image {
    width: 250px;
    height: 250px;
    object-fit: cover;
    border-radius: 17px;
    flex-shrink: 0;
}

.pet-details h3 {
    font-size: 29px;
    margin-bottom: 10px;
}

.pet-details > p {
    color: #84938f;
    font-size: 17px;
    margin-bottom: 18px;
}

.pet-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    margin-bottom: 20px;
}

.pet-tags span {
    background: #edf7ee;
    color: #138654;
    padding: 10px 15px;
    border-radius: 30px;
    font-size: 14px;
}

.pet-details .pet-description {
    color: #82918c;
    line-height: 1.7;
}

/* ORDER SUMMARY */

.order-summary-card h2 {
    margin-bottom: 22px;
}

.summary-divider {
    height: 1px;
    background: #e6ece8;
    margin: 20px 0 30px;
}

.summary-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 28px;
    font-size: 18px;
}

.summary-row span {
    color: #84938f;
}

.summary-row strong {
    color: #173d35;
}

.dashed {
    border-top: 1px dashed #cddbd2;
    background: transparent;
}

.summary-total {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin: 28px 0 40px;
}

.summary-total h3 {
    font-size: 23px;
}

.summary-total strong {
    color: #128653;
    font-size: 23px;
}

/* BUTTON */

.confirm-purchase-btn {
    width: 100%;
    padding: 19px;
    border: none;
    border-radius: 13px;
    background: #128653;
    color: white;
    font-size: 17px;
    font-weight: 700;
    cursor: pointer;
    transition: 0.3s;
}

.confirm-purchase-btn i {
    margin-left: 15px;
}

.confirm-purchase-btn:hover {
    background: #0c7043;
    transform: translateY(-2px);
}

.checkout-thankyou {
    text-align: center;
    color: #879790;
    font-size: 14px;
    margin-top: 27px;
}

.checkout-thankyou i {
    color: #128653;
}

/* RESPONSIVE */

@media (max-width: 900px) {
    .checkout-container {
        grid-template-columns: 1fr;
    }

    .checkout-header h2 {
        font-size: 23px;
    }
}

@media (max-width: 600px) {
    .checkout-page {
        padding: 20px 5%;
    }

    .checkout-header {
        flex-wrap: wrap;
        gap: 15px;
    }

    .checkout-header h2 {
        order: -1;
        width: 100%;
        text-align: center;
    }

    .checkout-intro h1 {
        font-size: 28px;
    }

    .selected-pet-card,
    .order-summary-card {
        padding: 22px;
        border-radius: 18px;
    }

    .selected-pet-content {
        flex-direction: column;
    }

    .selected-pet-image {
        width: 100%;
        height: 230px;
    }

    .summary-total h3,
    .summary-total strong {
        font-size: 19px;
    }
}
</style>
</head>

<body>

<div class="checkout-page">

    <!-- HEADER -->
    <header class="checkout-header">

        <a href="javascript:history.back()" class="back-link">
            <i class="fa-solid fa-arrow-left"></i> Back
        </a>

        <h2>Petora <span>Checkout</span></h2>

        <div class="secure-checkout">
            <i class="fa-solid fa-shield-halved"></i>
            Secure Checkout
        </div>

    </header>

    <!-- INTRO -->
    <div class="checkout-intro">

        <span class="intro-label">ALMOST YOURS!</span>

        <h1>Complete Your Purchase 🐾</h1>

        <p>Review your selected pet before confirming.</p>

    </div>

    <!-- CHECKOUT CONTENT -->
    <div class="checkout-container">

        <!-- SELECTED PET -->
        <div class="selected-pet-card">

            <h2>
                <i class="fa-solid fa-paw"></i>
                Your Selected Pet
            </h2>

            <div class="selected-pet-content">

                <img
                    src="${pageContext.request.contextPath}/uploads/sunny.jpg"
                    alt="Selected Pet"
                    class="selected-pet-image"
                    id="checkoutPetImage">

                <div class="pet-details">

                    <h3 id="checkoutPetName">Sunny</h3>

                    <p id="checkoutPetBreed">Beagle</p>

                    <div class="pet-tags">
                        <span id="checkoutPetAge">10 Months</span>
                        <span id="checkoutPetGender">Female</span>
                        <span id="checkoutPetType">Dog</span>
                    </div>

                    <p class="pet-description" id="checkoutPetDescription">
                        Your new furry friend is waiting for you!
                    </p>

                </div>

            </div>

        </div>

        <!-- ORDER SUMMARY -->
        <div class="order-summary-card">

            <h2>Order Summary</h2>

            <div class="summary-divider"></div>

            <div class="summary-row">
                <span>Pet Price</span>
                <strong id="petPrice">₹4,499</strong>
            </div>

            <div class="summary-row">
                <span>Delivery Fee</span>
                <strong id="deliveryFee">₹0</strong>
            </div>

            <div class="summary-divider dashed"></div>

            <div class="summary-total">
                <h3>Total Amount</h3>
                <strong id="totalAmount">₹4,499</strong>
            </div>

            <form action="${pageContext.request.contextPath}/BuyPetServlet" method="post">
    <input type="hidden" name="petId" value="7">

    <button type="submit" class="buy-now-btn">
        Buy Now
    </button>
</form>

            <p class="checkout-thankyou">
                <i class="fa-solid fa-heart"></i>
                Thank you for supporting our pet community.
            </p>

        </div>

    </div>

</div>

</body>
</html>