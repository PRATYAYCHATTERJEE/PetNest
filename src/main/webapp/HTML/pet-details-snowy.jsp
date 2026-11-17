<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Snowy | PawCare</title>

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
        }

        .back-btn:hover {
            color: #2563eb;
        }

        .back-icon {
            font-size: 28px;
        }

        .pet-details-container {
            max-width: 1250px;
            margin: 10px auto 60px;
            padding: 0 30px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
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
        }

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
        }

        .gallery-arrow {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            width: 45px;
            height: 45px;
            border: none;
            border-radius: 50%;
            background: white;
            font-size: 32px;
            cursor: pointer;
        }

        .gallery-arrow.previous {
            left: 18px;
        }

        .gallery-arrow.next {
            right: 18px;
        }

        .thumbnail-container {
            display: flex;
            gap: 12px;
            margin-top: 16px;
        }

        .thumbnail {
            width: 85px;
            height: 85px;
            padding: 0;
            border: 3px solid transparent;
            border-radius: 12px;
            overflow: hidden;
            cursor: pointer;
        }

        .thumbnail img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .thumbnail.active {
            border-color: #2563eb;
        }

        .pet-information {
            padding-top: 10px;
        }

        .status-row {
            display: flex;
            gap: 10px;
            margin-bottom: 18px;
        }

        .status {
            padding: 8px 14px;
            border-radius: 30px;
            font-size: 13px;
            font-weight: 700;
        }

        .available {
            background: #dcfce7;
            color: #15803d;
        }

        .healthy {
            background: #dbeafe;
            color: #2563eb;
        }

        .pet-title {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .pet-title h1 {
            font-size: 52px;
        }

        .paw-icon {
            font-size: 32px;
        }

        .breed {
            font-size: 23px;
            color: #64748b;
            margin: 5px 0 22px;
        }

        .pet-description {
            color: #64748b;
            font-size: 16px;
            line-height: 1.8;
            margin-bottom: 30px;
        }

        .pet-stats {
            display: grid;
            grid-template-columns: repeat(3,1fr);
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
            border-radius: 12px;
        }

        .orange { background: #ffedd5; }
        .pink { background: #fce7f3; }
        .blue { background: #dbeafe; }
        .purple { background: #ede9fe; }
        .dark { background: #e2e8f0; }

        .stat small {
            display: block;
            color: #94a3b8;
            font-size: 12px;
            margin-bottom: 4px;
        }

        .stat strong {
            color: #1e293b;
            font-size: 14px;
        }

        .purchase-section {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 30px;
            padding-top: 25px;
            border-top: 1px solid #e2e8f0;
        }

        .price-section h3 {
            margin: 5px 0;
            font-size: 34px;
        }

        .price-section span {
            color: #64748b;
            font-size: 14px;
            font-weight: 600;
        }

        .price-section p {
            color: #94a3b8;
            font-size: 12px;
        }

        .action-buttons {
            display: flex;
            flex-direction: column;
            gap: 10px;
            min-width: 190px;
        }

        .action-buttons button {
            width: 100%;
            min-height: 48px;
            border: none;
            border-radius: 11px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
        }

        .add-cart-btn {
            background: #eff6ff;
            color: #2563eb;
        }

        .buy-btn {
            background: #2563eb;
            color: white;
        }

        @media (max-width:1000px) {

            .pet-details-container {
                grid-template-columns: 1fr;
                max-width: 750px;
            }

        }

        @media (max-width:600px) {

            .pet-details-container {
                padding: 0 18px;
            }

            .main-image-container {
                height: 360px;
            }

            .pet-title h1 {
                font-size: 38px;
            }

            .pet-stats {
                grid-template-columns: repeat(2,1fr);
            }

            .purchase-section {
                flex-direction: column;
                align-items: stretch;
            }

        }

        @media (max-width:400px) {

            .main-image-container {
                height: 300px;
            }

            .pet-stats {
                grid-template-columns: 1fr;
            }

        }

    </style>

</head>


<body>

<div class="top-bar">

    <button class="back-btn" onclick="goBack()">

        <span class="back-icon">←</span>

        <span>Back</span>

    </button>

</div>


<main class="pet-details-container">


    <section class="pet-gallery">

        <div class="main-image-container">

            <img id="mainPetImage"
                 src="images/snowy.jpg"
                 alt="Snowy">

            <button class="favorite-btn"
                    id="favoriteBtn"
                    onclick="toggleFavorite()">
                ♥
            </button>

            <button class="gallery-arrow previous"
                    onclick="previousImage()">
                ‹
            </button>

            <button class="gallery-arrow next"
                    onclick="nextImage()">
                ›
            </button>

        </div>


        <div class="thumbnail-container">

            <button class="thumbnail active"
                    onclick="changeImage(0)">
                <img src="images/snowy.jpg" alt="Snowy">
            </button>

            <button class="thumbnail"
                    onclick="changeImage(1)">
                <img src="images/snowy.jpg" alt="Snowy">
            </button>

            <button class="thumbnail"
                    onclick="changeImage(2)">
                <img src="images/snowy.jpg" alt="Snowy">
            </button>

            <button class="thumbnail"
                    onclick="changeImage(3)">
                <img src="images/snowy.jpg" alt="Snowy">
            </button>

            <button class="thumbnail"
                    onclick="changeImage(4)">
                <img src="images/snowy.jpg" alt="Snowy">
            </button>

        </div>

    </section>


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

            <h1>Snowy</h1>

            <span class="paw-icon">🐾</span>

        </div>


        <h2 class="breed">
            Persian Cat
        </h2>


        <p class="pet-description">

            Snowy is a calm, gentle, and affectionate cat.
            She enjoys peaceful surroundings and loves spending
            time with people.

            Snowy is looking for a caring family that can provide
            her with a safe and loving forever home.

        </p>


        <div class="pet-stats">


            <div class="stat">

                <span class="stat-icon orange">🐾</span>

                <div>
                    <small>Species</small>
                    <strong>Cat</strong>
                </div>

            </div>


            <div class="stat">

                <span class="stat-icon pink">🎂</span>

                <div>
                    <small>Age</small>
                    <strong>1 year</strong>
                </div>

            </div>


            <div class="stat">

                <span class="stat-icon blue">♀</span>

                <div>
                    <small>Gender</small>
                    <strong>Female</strong>
                </div>

            </div>


            <div class="stat">

                <span class="stat-icon purple">⚖</span>

                <div>
                    <small>Weight</small>
                    <strong>Not specified</strong>
                </div>

            </div>


            <div class="stat">

                <span class="stat-icon dark">📏</span>

                <div>
                    <small>Size</small>
                    <strong>Medium</strong>
                </div>

            </div>


            <div class="stat">

                <span class="stat-icon orange">📍</span>

                <div>
                    <small>Location</small>
                    <strong>Kolkata</strong>
                </div>

            </div>


        </div>


        <div class="purchase-section">


            <div class="price-section">

                <span>Adoption Fee</span>

                <h3>₹ 3,499</h3>

                <p>
                    Includes basic health checkup,
                    vaccination records, and starter kit.
                </p>

            </div>


            <div class="action-buttons">

                <button class="add-cart-btn"
                        onclick="addToCart()">

                    <i class="fa-solid fa-cart-shopping"></i>

                    Add to Cart

                </button>


                <button class="buy-btn"
                        onclick="buyNow()">

                    ⚡ Buy Now

                </button>

            </div>

        </div>


    </section>

</main>


<script>

    const petImages = [
        "images/snowy.jpg",
        "images/snowy.jpg",
        "images/snowy.jpg",
        "images/snowy.jpg",
        "images/snowy.jpg"
    ];

</script>

<script src="Js/pet-details.js"></script>

</body>

</html>