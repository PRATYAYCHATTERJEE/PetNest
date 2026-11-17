<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Luna | PawCare</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #f7f8fc;
            color: #222;
        }

        /* =========================
           TOP BAR
        ========================== */

        .top-bar {
            width: 100%;
            padding: 25px 45px;
        }

        .back-btn {
            display: flex;
            align-items: center;
            gap: 10px;
            border: none;
            background: transparent;
            font-size: 17px;
            font-weight: 600;
            color: #333;
            cursor: pointer;
            transition: 0.3s;
        }

        .back-btn:hover {
            color: #2563eb;
        }

        .back-icon {
            font-size: 28px;
            line-height: 1;
        }


        /* =========================
           MAIN CONTAINER
        ========================== */

        .pet-details-container {

            max-width: 1250px;

            margin: 10px auto 60px;

            padding: 0 30px;

            display: grid;

            grid-template-columns: 1fr 1fr;

            gap: 60px;

            align-items: start;
        }


        /* =========================
           PET GALLERY
        ========================== */

        .pet-gallery {
            width: 100%;
        }

        .main-image-container {

            position: relative;

            width: 100%;

            height: 520px;

            overflow: hidden;

            border-radius: 24px;

            background: #eee;

            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.10);
        }

        .main-image-container > img {

            width: 100%;

            height: 100%;

            object-fit: cover;

            display: block;

            transition: 0.3s ease;
        }


        /* =========================
           FAVORITE
        ========================== */

        .favorite-btn {

            position: absolute;

            top: 20px;

            right: 20px;

            width: 50px;

            height: 50px;

            border: none;

            border-radius: 50%;

            background: white;

            color: #555;

            font-size: 25px;

            cursor: pointer;

            box-shadow: 0 5px 18px rgba(0,0,0,0.15);

            transition: 0.3s;
        }

        .favorite-btn:hover {

            transform: scale(1.08);

            color: #ef4444;
        }

        .favorite-btn.active {
            color: #ef4444;
        }


        /* =========================
           GALLERY ARROWS
        ========================== */

        .gallery-arrow {

            position: absolute;

            top: 50%;

            transform: translateY(-50%);

            width: 45px;

            height: 45px;

            border: none;

            border-radius: 50%;

            background: rgba(255,255,255,0.92);

            color: #333;

            font-size: 32px;

            line-height: 1;

            cursor: pointer;

            box-shadow: 0 4px 15px rgba(0,0,0,0.12);

            transition: 0.3s;
        }

        .gallery-arrow:hover {

            background: white;

            transform: translateY(-50%) scale(1.08);
        }

        .gallery-arrow.previous {
            left: 18px;
        }

        .gallery-arrow.next {
            right: 18px;
        }


        /* =========================
           THUMBNAILS
        ========================== */

        .thumbnail-container {

            display: flex;

            gap: 12px;

            margin-top: 16px;

            overflow-x: auto;

            padding-bottom: 5px;
        }

        .thumbnail {

            flex: 0 0 85px;

            width: 85px;

            height: 85px;

            padding: 0;

            border: 3px solid transparent;

            border-radius: 12px;

            background: white;

            overflow: hidden;

            cursor: pointer;

            transition: 0.3s;
        }

        .thumbnail img {

            width: 100%;

            height: 100%;

            object-fit: cover;

            display: block;
        }

        .thumbnail:hover {
            transform: translateY(-2px);
        }

        .thumbnail.active {
            border-color: #2563eb;
        }


        /* =========================
           PET INFORMATION
        ========================== */

        .pet-information {
            padding-top: 10px;
        }


        /* =========================
           STATUS
        ========================== */

        .status-row {

            display: flex;

            align-items: center;

            gap: 10px;

            margin-bottom: 18px;
        }

        .status {

            display: inline-flex;

            align-items: center;

            padding: 8px 14px;

            border-radius: 30px;

            font-size: 13px;

            font-weight: 700;
        }

        .status.available {

            background: #dcfce7;

            color: #15803d;
        }

        .status.healthy {

            background: #dbeafe;

            color: #2563eb;
        }


        /* =========================
           PET TITLE
        ========================== */

        .pet-title {

            display: flex;

            align-items: center;

            gap: 12px;

            margin-bottom: 5px;
        }

        .pet-title h1 {

            font-size: 52px;

            line-height: 1.1;

            color: #111827;

            font-weight: 800;
        }

        .paw-icon {
            font-size: 32px;
        }


        /* =========================
           BREED
        ========================== */

        .breed {

            font-size: 23px;

            font-weight: 600;

            color: #64748b;

            margin-bottom: 22px;
        }


        /* =========================
           DESCRIPTION
        ========================== */

        .pet-description {

            color: #64748b;

            font-size: 16px;

            line-height: 1.8;

            margin-bottom: 30px;

            max-width: 600px;
        }


        /* =========================
           PET STATS
        ========================== */

        .pet-stats {

            display: grid;

            grid-template-columns: repeat(3, 1fr);

            gap: 14px;

            margin-bottom: 30px;
        }

        .stat {

            display: flex;

            align-items: center;

            gap: 11px;

            padding: 14px;

            background: white;

            border-radius: 14px;

            box-shadow: 0 5px 18px rgba(0,0,0,0.05);
        }

        .stat-icon {

            width: 42px;

            height: 42px;

            display: flex;

            align-items: center;

            justify-content: center;

            flex-shrink: 0;

            border-radius: 12px;

            font-size: 19px;
        }

        .stat-icon.orange {
            background: #ffedd5;
        }

        .stat-icon.pink {
            background: #fce7f3;
        }

        .stat-icon.blue {
            background: #dbeafe;
        }

        .stat-icon.purple {
            background: #ede9fe;
        }

        .stat-icon.dark {
            background: #e2e8f0;
        }

        .stat small {

            display: block;

            color: #94a3b8;

            font-size: 12px;

            margin-bottom: 4px;
        }

        .stat strong {

            display: block;

            color: #1e293b;

            font-size: 14px;

            text-transform: capitalize;
        }


        /* =========================
           PURCHASE SECTION
        ========================== */

        .purchase-section {

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 30px;

            padding-top: 25px;

            border-top: 1px solid #e2e8f0;
        }

        .price-section span {

            color: #64748b;

            font-size: 14px;

            font-weight: 600;
        }

        .price-section h3 {

            margin: 5px 0;

            font-size: 34px;

            color: #111827;
        }

        .price-section p {

            color: #94a3b8;

            font-size: 12px;

            line-height: 1.5;

            max-width: 280px;
        }


        /* =========================
           ACTION BUTTONS
        ========================== */

        .action-buttons {

            display: flex;

            flex-direction: column;

            gap: 10px;

            min-width: 190px;
        }

        .action-buttons button {

            width: 100%;

            min-height: 48px;

            border-radius: 11px;

            border: none;

            font-size: 15px;

            font-weight: 700;

            cursor: pointer;

            transition: 0.3s;

            display: flex;

            align-items: center;

            justify-content: center;

            gap: 9px;
        }

        .add-cart-btn {

            background: #eff6ff;

            color: #2563eb;
        }

        .add-cart-btn:hover {

            background: #dbeafe;

            transform: translateY(-2px);
        }

        .buy-btn {

            background: #2563eb;

            color: white;

            box-shadow: 0 8px 20px rgba(37,99,235,0.25);
        }

        .buy-btn:hover {

            background: #1d4ed8;

            transform: translateY(-2px);
        }


        /* =========================
           SCROLLBAR
        ========================== */

        .thumbnail-container::-webkit-scrollbar {
            height: 5px;
        }

        .thumbnail-container::-webkit-scrollbar-thumb {

            background: #cbd5e1;

            border-radius: 10px;
        }


        /* =========================
           TABLET
        ========================== */

        @media (max-width: 1000px) {

            .pet-details-container {

                grid-template-columns: 1fr;

                gap: 40px;

                max-width: 750px;
            }

            .main-image-container {
                height: 500px;
            }

        }


        /* =========================
           MOBILE
        ========================== */

        @media (max-width: 600px) {

            .top-bar {
                padding: 18px 20px;
            }

            .pet-details-container {

                padding: 0 18px;

                margin-top: 5px;

                gap: 30px;
            }

            .main-image-container {

                height: 360px;

                border-radius: 18px;
            }

            .pet-title h1 {
                font-size: 38px;
            }

            .breed {
                font-size: 20px;
            }

            .pet-description {
                font-size: 15px;
            }

            .pet-stats {

                grid-template-columns: repeat(2, 1fr);

                gap: 10px;
            }

            .stat {
                padding: 11px;
            }

            .stat-icon {

                width: 38px;

                height: 38px;

                font-size: 17px;
            }

            .purchase-section {

                flex-direction: column;

                align-items: stretch;
            }

            .action-buttons {
                width: 100%;
            }

            .price-section h3 {
                font-size: 30px;
            }

            .thumbnail {

                width: 70px;

                height: 70px;

                flex-basis: 70px;
            }

        }


        /* =========================
           SMALL MOBILE
        ========================== */

        @media (max-width: 400px) {

            .main-image-container {
                height: 300px;
            }

            .pet-stats {
                grid-template-columns: 1fr;
            }

            .pet-title h1 {
                font-size: 34px;
            }

        }

    </style>

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
                    src="images/luna.jpg"
                    alt="Luna">


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

                    <img
                        src="images/luna.jpg"
                        alt="Luna">

                </button>


                <button
                    class="thumbnail"
                    onclick="changeImage(1)">

                    <img
                        src="images/luna.jpg"
                        alt="Luna">

                </button>


                <button
                    class="thumbnail"
                    onclick="changeImage(2)">

                    <img
                        src="images/luna.jpg"
                        alt="Luna">

                </button>


                <button
                    class="thumbnail"
                    onclick="changeImage(3)">

                    <img
                        src="images/luna.jpg"
                        alt="Luna">

                </button>


                <button
                    class="thumbnail"
                    onclick="changeImage(4)">

                    <img
                        src="images/luna.jpg"
                        alt="Luna">

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

                <h1>Luna</h1>

                <span class="paw-icon">🐾</span>

            </div>



            <!-- BREED -->

            <h2 class="breed">
                Indian Cat
            </h2>



            <!-- DESCRIPTION -->

            <p class="pet-description">

                Luna is a sweet, playful, and affectionate Indian Cat.
                She loves spending time with people, exploring her
                surroundings, and enjoying a peaceful home.

                Luna is looking for a loving family who can give her
                a safe and happy forever home.

            </p>



            <!-- ================= PET STATS ================= -->

            <div class="pet-stats">


                <!-- SPECIES -->

                <div class="stat">

                    <span class="stat-icon orange">
                        🐾
                    </span>

                    <div>

                        <small>Species</small>

                        <strong>Cat</strong>

                    </div>

                </div>



                <!-- AGE -->

                <div class="stat">

                    <span class="stat-icon pink">
                        🎂
                    </span>

                    <div>

                        <small>Age</small>

                        <strong>1 year</strong>

                    </div>

                </div>



                <!-- GENDER -->

                <div class="stat">

                    <span class="stat-icon blue">
                        ♀
                    </span>

                    <div>

                        <small>Gender</small>

                        <strong>Female</strong>

                    </div>

                </div>



                <!-- WEIGHT -->

                <div class="stat">

                    <span class="stat-icon purple">
                        ⚖
                    </span>

                    <div>

                        <small>Weight</small>

                        <strong>Not specified</strong>

                    </div>

                </div>



                <!-- SIZE -->

                <div class="stat">

                    <span class="stat-icon dark">
                        📏
                    </span>

                    <div>

                        <small>Size</small>

                        <strong>Not specified</strong>

                    </div>

                </div>



                <!-- LOCATION -->

                <div class="stat">

                    <span class="stat-icon orange">
                        📍
                    </span>

                    <div>

                        <small>Location</small>

                        <strong>Howrah</strong>

                    </div>

                </div>


            </div>



            <!-- ================= PRICE + BUTTONS ================= -->

            <div class="purchase-section">


                <div class="price-section">

                    <span>
                        Adoption Fee
                    </span>

                    <h3>
                        ₹ 2,999
                    </h3>

                    <p>

                        Includes basic health checkup,
                        vaccination records, and starter kit.

                    </p>

                </div>



                <div class="action-buttons">


                    <button
                        class="add-cart-btn"
                        onclick="addToCart()">

                        <i class="fa-solid fa-cart-shopping"></i>

                        Add to Cart

                    </button>



                  <a href="checkout1.jsp" class="buy-button">
    Buy Now <i class="fa-solid fa-arrow-right"></i>
</a>


                </div>

            </div>


        </section>

    </main>



    <!-- ================= LUNA IMAGE DATA ================= -->

    <script>

        const petImages = [

            "images/luna.jpg",
            "images/luna.jpg",
            "images/luna.jpg",
            "images/luna.jpg",
            "images/luna.jpg"

        ];

        async function addToCart() {

            const formData = new URLSearchParams();

            // Seller listing ID of the current pet
            formData.append("sellerListingId", currentPet.id);

            const button = document.querySelector(".add-cart-btn");
            button.disabled = true;

            try {

                const response = await fetch(
                    contextPath + "/AddToCartServlet",
                    {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/x-www-form-urlencoded"
                        },
                        body: formData.toString(),
                        credentials: "same-origin"
                    }
                );

                const message = await response.text();

                if (response.status === 401) {
                    alert("Please login before adding pets to your cart.");
                    window.location.href = contextPath + "/login.jsp";
                    return;
                }

                if (!response.ok) {
                    throw new Error(message);
                }

                alert("🐾 " + currentPet.title + " added to your cart!");

                window.location.href = contextPath + "/cart.jsp";

            } catch (error) {

                console.error("Add to cart error:", error);
                alert(error.message || "Unable to add pet to cart.");

            } finally {
                button.disabled = false;
            }
        }
        
    </script>



    <!-- ================= JAVASCRIPT ================= -->

    <script src="Js/pet-details.js"></script>


</body>

</html>