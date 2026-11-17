// ================================
// CART
// ================================

document.addEventListener("DOMContentLoaded", loadCart);


function loadCart() {

    const cartContent = document.getElementById("cartContent");

    // Get cart from localStorage
    const cart = JSON.parse(localStorage.getItem("petCart")) || [];


    // ================================
    // EMPTY CART
    // ================================

    if (cart.length === 0) {

        cartContent.innerHTML = `
            <div class="empty-cart">

                <div class="empty-cart-icon">
                    <i class="fa-solid fa-cart-shopping"></i>
                </div>

                <h2>Your Cart is Empty</h2>

                <p>
                    You haven't added any pets to your cart yet.
                </p>

                <a href="index.jsp" class="browse-btn">
                    Browse Pets
                </a>

            </div>
        `;

        return;
    }


    // ================================
    // CART WITH ITEMS
    // ================================

    let total = 0;

    let itemsHTML = "";

    cart.forEach((pet, index) => {

        total += pet.price;

        itemsHTML += `

            <div class="cart-item">

                <img src="${pet.image}" alt="${pet.name}">

                <div class="pet-info">

                    <h2>${pet.name}</h2>

                    <p class="breed">
                        ${pet.breed}
                    </p>

                    <div class="pet-details">

                        <span>
                            <i class="fa-solid fa-cake-candles"></i>
                            ${pet.age}
                        </span>

                        <span>
                            <i class="fa-solid fa-mars"></i>
                            ${pet.gender}
                        </span>

                        <span>
                            <i class="fa-solid fa-location-dot"></i>
                            ${pet.location}
                        </span>

                    </div>

                </div>


                <div class="pet-price">

                    <span>Adoption Fee</span>

                    <strong>
                        ₹ ${pet.price.toLocaleString("en-IN")}
                    </strong>

                </div>


                <button
                    class="remove-btn"
                    onclick="removeFromCart('${pet.id}')">

                    <i class="fa-solid fa-trash"></i>

                </button>

            </div>

        `;
    });


    cartContent.innerHTML = `

        <div class="cart-wrapper">

            <div class="cart-title">

                <div>
                    <h2>Your Selected Pets</h2>
                    <p>${cart.length} pet${cart.length > 1 ? "s" : ""} in your cart</p>
                </div>

            </div>


            <div class="cart-items">

                ${itemsHTML}

            </div>


            <div class="cart-summary">

                <div class="summary-row">

                    <span>Subtotal</span>

                    <strong>
                        ₹ ${total.toLocaleString("en-IN")}
                    </strong>

                </div>


                <div class="summary-row">

                    <span>Health & Care</span>

                    <strong>Included</strong>

                </div>


                <hr>


                <div class="summary-total">

                    <span>Total</span>

                    <strong>
                        ₹ ${total.toLocaleString("en-IN")}
                    </strong>

                </div>


                <button class="checkout-btn"
                        onclick="checkout()">

                    <i class="fa-solid fa-paw"></i>

                    Proceed to Adoption

                </button>

            </div>

        </div>

    `;
}


// ================================
// REMOVE FROM CART
// ================================

function removeFromCart(id) {

    let cart = JSON.parse(localStorage.getItem("petCart")) || [];

    cart = cart.filter(pet => pet.id !== id);

    localStorage.setItem("petCart", JSON.stringify(cart));

    loadCart();
}


// ================================
// CHECKOUT
// ================================

function checkout() {

    alert("Proceeding to adoption checkout! 🐾");

}