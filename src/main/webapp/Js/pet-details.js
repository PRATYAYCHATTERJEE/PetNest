/* =========================================
   PET IMAGE GALLERY
========================================= */

const petImages = [
    "images/max.jpg",
    "images/max2.jpg",
    "images/max3.jpg",
    "images/max4.jpg",
    "images/max5.jpg"
];

let currentImage = 0;


/* =========================================
   PET DETAILS
========================================= */

const pet = {
    id: "max-001",
    name: "Max",
    breed: "Golden Retriever",
    age: "1 year",
    gender: "Male",
    weight: "28 kg",
    size: "Large",
    location: "Kolkata, WB",
    price: 4999,
    image: "images/max.jpg"
};


/* =========================================
   CHANGE IMAGE
========================================= */

function changeImage(index) {

    currentImage = index;

    const mainImage = document.getElementById("mainPetImage");

    if (mainImage) {
        mainImage.src = petImages[index];
    }

    updateThumbnails();
}


/* =========================================
   UPDATE ACTIVE THUMBNAIL
========================================= */

function updateThumbnails() {

    const thumbnails = document.querySelectorAll(".thumbnail");

    thumbnails.forEach((thumbnail, index) => {

        thumbnail.classList.remove("active");

        if (index === currentImage) {
            thumbnail.classList.add("active");
        }

    });
}


/* =========================================
   NEXT IMAGE
========================================= */

function nextImage() {

    currentImage++;

    if (currentImage >= petImages.length) {
        currentImage = 0;
    }

    changeImage(currentImage);
}


/* =========================================
   PREVIOUS IMAGE
========================================= */

function previousImage() {

    currentImage--;

    if (currentImage < 0) {
        currentImage = petImages.length - 1;
    }

    changeImage(currentImage);
}


/* =========================================
   FAVORITE
========================================= */

function toggleFavorite() {

    const button = document.getElementById("favoriteBtn");

    if (!button) return;

    button.classList.toggle("active");

    if (button.classList.contains("active")) {

        console.log("Max added to favorites");

    } else {

        console.log("Max removed from favorites");

    }
}


/* =========================================
   ADD TO CART
========================================= */

function addToCart() {

    console.log("ADD TO CART FUNCTION CALLED");

    try {

        // Get existing cart
        let cart = JSON.parse(localStorage.getItem("petCart")) || [];

        console.log("Current cart:", cart);


        // Check if Max already exists
        const alreadyExists = cart.some(function(item) {

            return item.id === pet.id;

        });


        if (alreadyExists) {

            alert("Max is already in your cart! 🐾");

            return;
        }


        // Add Max
        cart.push(pet);


        // Save cart
        localStorage.setItem(
            "petCart",
            JSON.stringify(cart)
        );


        console.log("Pet saved successfully!");
        console.log(
            "Saved cart:",
            JSON.parse(localStorage.getItem("petCart"))
        );


        alert("Max has been added to your cart! 🐾");


    } catch (error) {

        console.error("Cart Error:", error);

        alert(
            "Something went wrong while adding Max to the cart."
        );

    }
}


/* =========================================
   BUY NOW
========================================= */

function buyNow() {

    alert("Proceeding to checkout for Max!");

    // Later:
    // window.location.href = "checkout.jsp";

}


/* =========================================
   BACK BUTTON
========================================= */

function goBack() {

    if (window.history.length > 1) {

        window.history.back();

    } else {

        window.location.href = "index.jsp";

    }

}


/* =========================================
   KEYBOARD IMAGE NAVIGATION
========================================= */

document.addEventListener("keydown", function(event) {

    if (event.key === "ArrowRight") {

        nextImage();

    }

    if (event.key === "ArrowLeft") {

        previousImage();

    }

});


/* =========================================
   INITIALIZE GALLERY
========================================= */

document.addEventListener("DOMContentLoaded", function() {

    updateThumbnails();

});