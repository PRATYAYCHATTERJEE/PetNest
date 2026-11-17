<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Misty | PawCare</title>

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
            transition: .3s;
        }

        .back-btn:hover {
            color: #2563eb;
        }

        .back-icon {
            font-size: 28px;
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
        }


        /* =========================
           GALLERY
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

            box-shadow: 0 12px 35px rgba(0,0,0,.10);
        }

        .main-image-container > img {
            width: 100%;
            height: 100%;

            object-fit: cover;

            display: block;
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

            box-shadow: 0 5px 18px rgba(0,0,0,.15);

            transition: .3s;
        }

        .favorite-btn:hover {
            transform: scale(1.08);
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

            background: rgba(255,255,255,.92);

            color: #333;

            font-size: 32px;

            cursor: pointer;

            box-shadow: 0 4px 15px rgba(0,0,0,.12);

            transition: .3s;
        }

        .gallery-arrow:hover {
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
        }

        .thumbnail img {
            width: 100%;
            height: 100%;

            object-fit: cover;

            display: block;
        }

        .thumbnail.active {
            border-color: #2563eb;
        }


        /* =========================
           INFORMATION
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
           TITLE
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
           STATS
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

            box-shadow: 0 5px 18px rgba(0,0,0,.05);
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

        .orange {
            background: #ffedd5;
        }

        .pink {
            background: #fce7f3;
        }

        .blue {
            background: #dbeafe;
        }

        .purple {
            background: #ede9fe;
        }

        .dark {
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
        }


        /* =========================
           PURCHASE
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
           BUTTONS
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

            transition: .3s;

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

            box-shadow: 0 8px 20px rgba(37,99,235,.25);
        }

        .buy-btn:hover {
            background: #1d4ed8;

            transform: translateY(-2px);
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



    <!-- ================= MAIN DETAILS ================= -->

    <main class="pet-details-container">


        <!-- ================= GALLERY ================= -->

        <section class="pet-gallery">


            <div class="main-image-container">

                <img
                    id="mainPetImage"
                    src="images/misty.jpg"
                    alt="Misty">


                <button
                    class="favorite-btn"
                    id="favoriteBtn"
                    onclick="toggleFavorite()">

                    ♥

                </button>


                <button
                    class="gallery-arrow previous"
                    onclick="previousImage()">

                    ‹

                </button>


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
                        src="images/misty.jpg"
                        alt="Misty">

                </button>


                <button
                    class="thumbnail"
                    onclick="changeImage(1)">

                    <img
                        src="images/misty.jpg"
                        alt="Misty">

                </button>


                <button
                    class="thumbnail"
                    onclick="changeImage(2)">

                    <img
                        src="images/misty.jpg"
                        alt="Misty">

                </button>


                <button
                    class="thumbnail"
                    onclick="changeImage(3)">

                    <img
                        src="images/misty.jpg"
                        alt="Misty">

                </button>


                <button
                    class="thumbnail"
                    onclick="changeImage(4)">

                    <img
                        src="images/misty.jpg"
                        alt="Misty">

                </button>

            </div>

        </section>



        <!-- ================= INFORMATION ================= -->

        <section class="pet-information">


            <div class="status-row">

                <span class="status available">
                    Available for Adoption
                </span>

                <span class="status healthy">
                    Healthy
                </span>

            </div>



            <div class="pet-title">

                <h1>Misty</h1>

                <span class="paw-icon">🐾</span>

            </div>



            <h2 class="breed">
                Persian Cat
            </h2>



            <p class="pet-description">

                Misty is a beautiful, gentle, and affectionate Persian Cat.
                She enjoys relaxing in peaceful surroundings and loves
                receiving attention from people.

                Misty is looking for a caring family who can give her
                a comfortable and loving forever home.

            </p>



            <!-- ================= STATS ================= -->

            <div class="pet-stats">


                <div class="stat">

                    <span class="stat-icon orange">
                        🐾
                    </span>

                    <div>

                        <small>Species</small>

                        <strong>Cat</strong>

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
                        ♀
                    </span>

                    <div>

                        <small>Gender</small>

                        <strong>Female</strong>

                    </div>

                </div>



                <div class="stat">

                    <span class="stat-icon purple">
                        ⚖
                    </span>

                    <div>

                        <small>Weight</small>

                        <strong>Not specified</strong>

                    </div>

                </div>



                <div class="stat">

                    <span class="stat-icon dark">
                        📏
                    </span>

                    <div>

                        <small>Size</small>

                        <strong>Medium</strong>

                    </div>

                </div>



                <div class="stat">

                    <span class="stat-icon orange">
                        📍
                    </span>

                    <div>

                        <small>Location</small>

                        <strong>Salt Lake</strong>

                    </div>

                </div>


            </div>



            <!-- ================= PURCHASE ================= -->

            <div class="purchase-section">


                <div class="price-section">

                    <span>
                        Adoption Fee
                    </span>

                    <h3>
                        ₹ 3,499
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



                    </button>



                   <form action="${pageContext.request.contextPath}/BuyPetServlet" method="post">
    <input type="hidden" name="petId" value="9">

    <button type="submit" class="buy-now-btn">
        Buy Now
    </button>


                </div>

            </div>


        </section>

    </main>



    <!-- ================= MISTY IMAGE DATA ================= -->

    <script>

        const petImages = [

            "images/misty.jpg",
            "images/misty.jpg",
            "images/misty.jpg",
            "images/misty.jpg",
            "images/misty.jpg"

        ];

    </script>



    <!-- ================= JAVASCRIPT ================= -->

    <script src="Js/pet-details.js"></script>


</body>

</html>