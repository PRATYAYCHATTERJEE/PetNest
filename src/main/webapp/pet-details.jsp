<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Max | PawCare</title>
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="pet-details.css">
</head>

<body>

    <!-- ================= BACK BUTTON ================= -->

    <div class="top-bar">

        <button class="back-btn" onclick="goBack()">
            <span class="back-icon">←</span>
            <span>Back</span>
        </button>

    </div>


    <!-- ================= MAIN PET DETAILS ================= -->

    <main class="pet-details-container">


        <!-- ================= LEFT SIDE ================= -->

        <section class="pet-gallery">

            <div class="main-image-container">

                <img
                    id="mainPetImage"
                    src="images/max.jpg"
                    alt="Max">

                <!-- Favorite -->

                <button
                    class="favorite-btn"
                    id="favoriteBtn"
                    onclick="toggleFavorite()">

                    ♥
                    
                </button>


                <!-- Previous -->

                <button
                    class="gallery-arrow previous"
                    onclick="previousImage()">

                    ‹

                </button>


                <!-- Next -->

                <button
                    class="gallery-arrow next"
                    onclick="nextImage()">

                    ›

                </button>

            </div>


            <!-- ================= THUMBNAILS ================= -->

            <div class="thumbnail-container">

                <button
                    class="thumbnail active"
                    onclick="changeImage(0)">

                    <img src="images/max.jpg" alt="Max">

                </button>


                <button
                    class="thumbnail"
                    onclick="changeImage(1)">

                    <img src="images/max2.jpg" alt="Max">

                </button>


                <button
                    class="thumbnail"
                    onclick="changeImage(2)">

                    <img src="images/max3.jpg" alt="Max">

                </button>


                <button
                    class="thumbnail"
                    onclick="changeImage(3)">

                    <img src="images/max4.jpg" alt="Max">

                </button>


                <button
                    class="thumbnail"
                    onclick="changeImage(4)">

                    <img src="images/max5.jpg" alt="Max">

                </button>

            </div>

        </section>



        <!-- ================= RIGHT SIDE ================= -->

        <section class="pet-information">


            <!-- STATUS -->

            <div class="status-row">

                <span class="status available">
                    Available for Adoption
                </span>

                <span class="status healthy">
                    Healthy
                </span>

            </div>


            <!-- NAME -->

            <div class="pet-title">

                <h1>Max</h1>

                <span class="paw-icon">🐾</span>

            </div>


            <!-- BREED -->

            <h2 class="breed">
                Golden Retriever
            </h2>


            <!-- DESCRIPTION -->

            <p class="pet-description">

                Max is a friendly, energetic, and loving Golden Retriever.
                He loves playing with people, enjoys outdoor activities,
                and is always ready to make new friends.

                Max is looking for a caring family who can give him a
                forever home filled with love and attention.

            </p>



            <!-- ================= PET STATS ================= -->

            <div class="pet-stats">


                <div class="stat">

                    <span class="stat-icon orange">
                        🐾
                    </span>

                    <div>
                        <small>Species</small>
                        <strong>Dog</strong>
                    </div>

                </div>


                <div class="stat">

                    <span class="stat-icon pink">
                        🎂
                    </span>

                    <div>
                        <small>Age</small>
                        <strong>1 year</strong>
                    </div>

                </div>


                <div class="stat">

                    <span class="stat-icon blue">
                        ♂
                    </span>

                    <div>
                        <small>Gender</small>
                        <strong>Male</strong>
                    </div>

                </div>


                <div class="stat">

                    <span class="stat-icon purple">
                        ⚖
                    </span>

                    <div>
                        <small>Weight</small>
                        <strong>28 kg</strong>
                    </div>

                </div>


                <div class="stat">

                    <span class="stat-icon dark">
                        📏
                    </span>

                    <div>
                        <small>Size</small>
                        <strong>Large</strong>
                    </div>

                </div>


                <div class="stat">

                    <span class="stat-icon orange">
                        📍
                    </span>

                    <div>
                        <small>Location</small>
                        <strong>Kolkata, WB</strong>
                    </div>

                </div>

            </div>



            <!-- ================= PRICE + BUTTONS ================= -->

            <div class="purchase-section">


                <div class="price-section">

                    <span>Adoption Fee</span>

                    <h3>
                        ₹ 4,999
                    </h3>

                    <p>
                        Includes basic health checkup,
                        vaccination records, and starter kit.
                    </p>

                </div>


                <div class="action-buttons">

                    <button class="add-cart-btn" onclick="addToCart()">
    <i class="fa-solid fa-cart-shopping"></i>
    Add to Cart
</button>


                    <button
                        class="buy-btn"
                        onclick="buyNow()">

                        <span>⚡</span>

                        Buy Now

                    </button>

                </div>

            </div>


        </section>

    </main>



    <!-- ================= JAVASCRIPT ================= -->

    <script src="Js/pet-details.js"></script>

</body>

</html>