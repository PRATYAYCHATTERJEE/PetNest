<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    // Check customer login
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Ensure dashboard data is loaded through MyPetsServlet
    if (request.getAttribute("myPets") == null ||
        request.getAttribute("approvedDoctors") == null) {

        response.sendRedirect(request.getContextPath() + "/MyPetsServlet");
        return;
    }

    String userName = (String) session.getAttribute("userName");

    if (userName == null || userName.trim().isEmpty()) {
        userName = "Customer";
    }
%>






<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>PawCare | Dashboard</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet" href="dashboard.css">
</head>

<body>

    <!-- MOBILE OVERLAY -->
    <div class="mobile-overlay" id="mobileOverlay"></div>

    <!-- SIDEBAR -->
    <aside class="sidebar" id="sidebar">

        <div class="logo">
            <div class="logo-paw">
                <i class="fa-solid fa-paw"></i>
            </div>

            <div>
                <h2>Paw<span>Nest</span></h2>
                <small>Pets. Belong. Always.</small>
            </div>
        </div>

        <nav class="sidebar-nav">

            <a href="#" class="nav-item active"
               onclick="showSection('dashboard', this); return false;">
                <i class="fa-solid fa-house"></i>
                <span>Dashboard</span>
            </a>

            <a href="#" class="nav-item"
               onclick="showSection('buyPets', this); return false;">
                <i class="fa-solid fa-paw"></i>
                <span>Buy Pets</span>
            </a>

            <a href="#" class="nav-item"
               onclick="showSection('myPets', this); return false;">
                <i class="fa-solid fa-dog"></i>
                <span>My Pets</span>
            </a>

            <a href="#" class="nav-item"
               onclick="showSection('adoption', this); return false;">
              <i class="fa-solid fa-hand-holding-dollar"></i>
                <span>Sell a Pet</span>
            </a>

            <a href="#" class="nav-item"
               onclick="showSection('veterinary', this); return false;">
                <i class="fa-solid fa-stethoscope"></i>
                <span>Veterinary Services</span>
            </a>

            <a href="#" class="nav-item"
               onclick="showSection('store', this); return false;">
                <i class="fa-solid fa-bag-shopping"></i>
                <span>Pet Care Store</span>
            </a>

            

            <a href="#" class="nav-item"
               onclick="showSection('settings', this); return false;">
                <i class="fa-solid fa-gear"></i>
                <span>Settings</span>
            </a>

			<button type="button" class="nav-item"
        onclick="openLogoutPopup(); return false;">
    <i class="fa-solid fa-sign-out-alt"></i>
    <span>Logout</span>
</button>

        </nav>

        <div class="help-card">
            <div class="help-content">
                <h3>Need Help?</h3>
                <p>We're here for you and your pets.</p>

                <button type="button" onclick="showSection('messages', null)">
                    Contact Support
                    <i class="fa-solid fa-arrow-right"></i>
                </button>
            </div>

            <div class="help-decoration">
                <i class="fa-solid fa-heart"></i>
                <i class="fa-solid fa-paw"></i>
            </div>
        </div>

    </aside>


    <!-- MAIN -->
    <main class="main">

        <!-- TOP NAVBAR -->
        
<header class="topbar">

    <button class="mobile-menu" id="mobileMenu" type="button"
            aria-label="Open sidebar">
        <i class="fa-solid fa-bars"></i>
    </button>

    <!-- Search -->
    <div class="search-box">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="text"
               placeholder="Search pets, breeds, services..."
               id="searchInput">
    </div>

    <!-- Doctor application notifications -->
    <div class="notification-wrapper">
        <button class="notification-btn"
                id="notificationBtn"
                type="button"
                aria-label="Doctor application notifications"
                aria-expanded="false">
            <i class="fa-regular fa-bell"></i>
            <span class="notification-dot" id="notificationDot"
                  style="display:none;"></span>
        </button>

        <div class="notification-dropdown" id="notificationDropdown"
             style="display:none;">
            <div class="notification-heading">
                <strong>Notifications</strong>
                
            </div>

            <div id="notificationContent" class="notification-content">
                <p>No new doctor application notifications.</p>
            </div>
        </div>
    </div>

    <!-- Existing cart -->
    <button class="cart-btn"
            onclick="window.location.href='cart.jsp'"
            aria-label="Cart"
            type="button">
        <i class="fa-solid fa-cart-shopping"></i>
    </button>

    <!-- Existing user profile -->
    <div class="top-user">
        <div class="user-avatar">
            <i class="fa-solid fa-user"></i>
        </div>

        <strong><%= userName %></strong>

        <i class="fa-solid fa-chevron-down"></i>
    </div>

</header>



        <!-- =================================================
             DASHBOARD SECTION
        ================================================== -->

        <section id="dashboard" class="page-section dashboard-content active">

            <!-- WELCOME HERO -->
            <div class="dashboard-hero">

                <div class="hero-text">

                    <span class="hero-label">WELCOME BACK</span>

                    <h1>
                        Welcome back,
                        <br>
                        <span><%= userName %>!</span>
                        <i class="fa-solid fa-paw"></i>
                    </h1>

                    <p>
                        Let's make today a happy day for you and your pets.
                        <br>
                        Together for a healthier, happier tomorrow.
                    </p>

                    <button class="primary-btn"
                            onclick="showSection('buyPets', null)">
                        Explore Pets
                        <i class="fa-solid fa-arrow-right"></i>
                    </button>

                </div>

                <div class="hero-image">
                    <img src="images/heropet1.png"
                         alt="Happy dog and cat">
                </div>

                <div class="hero-decoration heart">♥</div>
                <div class="hero-decoration paw">🐾</div>

                <div class="hero-message">
                    <span>Good</span>
                    <span>Pets</span>
                    <span>Happy</span>
                    <span>People</span>
                </div>

            </div>


            <!-- STAT CARDS -->
            <div class="stats-grid">

                <div class="stat-card green"
                     onclick="showSection('myPets', null)">
                    <div class="stat-icon">
                        <i class="fa-solid fa-paw"></i>
                    </div>
                    <div class="stat-info">
                        <strong>${totalPets}</strong>
                        <h3>My Pets</h3>
                        <p>View & manage</p>
                    </div>
                    <i class="fa-solid fa-chevron-right stat-arrow"></i>
                </div>

                <div class="stat-card orange"
                     onclick="showSection('veterinary', null)">
                    <div class="stat-icon">
                        <i class="fa-regular fa-calendar-check"></i>
                    </div>
                    <div class="stat-info">
                       <strong>${totalAppointments}</strong>
                        <h3>Appointments</h3>
                        <p>View details</p>
                    </div>
                    <i class="fa-solid fa-chevron-right stat-arrow"></i>
                </div>

               <div class="stat-card purple"
                     onclick="window.location.href='cart.jsp'">
                    <div class="stat-icon">
                        <i class="fa-solid fa-cart-shopping"></i>
                    </div>
                    <div class="stat-info">
                        <strong>${totalOrderedItems}</strong>
                        <h3>Orders</h3>
                        <p>View orders</p>
                    </div>
                    <i class="fa-solid fa-chevron-right stat-arrow"></i>
                </div>

                <div class="stat-card orange"
                     onclick="window.location.href='cart.jsp'">
                    <div class="stat-icon">
                       <i class="fa-solid fa-bag-shopping"></i>
                    </div>
                    <div class="stat-info">
                        <strong>More</strong>
                        <h3>items</h3>
                        <p>Pets and more</p>
                    </div>
                    <i class="fa-solid fa-chevron-right stat-arrow"></i>
                </div>

            </div>


            <!-- MIDDLE -->
            
<!-- INFORMATION CARDS -->
<section class="info-cards-section">

    <div class="info-section-heading">
        <span>WHY PETORA?</span>
        <h2>Everything for a Happier Pet Life</h2>
        <p>Making pet care simpler, safer and better for everyone.</p>
    </div>

    <div class="info-cards-grid">

        <!-- CARD 1 -->
        <div class="info-card">
            <div class="info-card-icon green">
                <i class="fa-solid fa-shield-heart"></i>
            </div>
            <h3>Safe & Secure</h3>
            <p>
                A trusted platform designed to make pet adoption,
                shopping and care safer and more reliable.
            </p>
            <span class="info-card-tag">Your Trust Matters</span>
        </div>

        <!-- CARD 2 -->
        <div class="info-card">
            <div class="info-card-icon orange">
                <i class="fa-solid fa-bolt"></i>
            </div>
            <h3>Fast & Easy</h3>
            <p>
                Explore pets, discover products and access
                essential services through one simple platform.
            </p>
            <span class="info-card-tag">Simple Experience</span>
        </div>

        <!-- CARD 3 -->
        <div class="info-card">
            <div class="info-card-icon purple">
                <i class="fa-solid fa-headset"></i>
            </div>
            <h3>24/7 Support</h3>
            <p>
                Get assistance whenever you need help navigating
                your pet care journey.
            </p>
            <span class="info-card-tag">We're Here to Help</span>
        </div>

        <!-- CARD 4 -->
        <div class="info-card">
            <div class="info-card-icon pink">
                <i class="fa-solid fa-book-open"></i>
            </div>
            <h3>Useful Resources</h3>
            <p>
                Discover helpful information about pet health,
                nutrition, grooming and responsible ownership.
            </p>
            <span class="info-card-tag">Learn & Care</span>
        </div>

    </div>

    <div class="info-bottom-banner">
        <div>
            <span>PAWS, LOVE & HAPPINESS</span>
            <h2>Every Pet Deserves a Better Tomorrow.</h2>
            <p>Small acts of care make a lifetime of difference.</p>
        </div>
        <i class="fa-solid fa-paw"></i>
    </div>

</section>


        </section>


        <!-- =================================================
             BUY PETS
        ================================================== -->

        <section id="buyPets" class="page-section">

            <div class="section-page-header">
                <div>
                    <span class="section-label">PAWCARE MARKETPLACE</span>
                    <h1>Find Your Perfect Companion 🐾</h1>
                    <p>Discover loving pets waiting for their forever home.</p>
                </div>
            </div>

            <div class="pet-filter-bar">

                <div class="pet-search">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text"
                           id="petSearch"
                           placeholder="Search by pet name or breed...">
                </div>

                <select id="animalFilter">
                    <option value="all">All Animals</option>
                    <option value="dog">Dogs</option>
                    <option value="cat">Cats</option>
                    <option value="rabbit">Rabbits</option>
                </select>

                <select id="genderFilter">
                    <option value="all">Any Gender</option>
                    <option value="male">Male</option>
                    <option value="female">Female</option>
                </select>

            </div>

            <div class="section-page-title">
                <div>
                    <h2>Available Pets</h2>
                    <p>Find a new best friend today.</p>
                </div>
                <span id="petCount">6 Pets Available</span>
            </div>

            <div class="buy-pets-grid" id="buyPetsGrid">

               

            </div>

        </section>


        <!-- =================================================
             MY PETS
        ================================================== -->

       
<section id="myPets" class="page-section">

    <div class="section-page-header">
        <span class="section-label">MY COMPANIONS</span>
        <h1>My Pets 🐾</h1>
        <p>View and manage all your pets.</p>
    </div>

    <div class="dashboard-card page-card">

        <div class="card-header">
            <div>
                <span class="card-icon green-icon">
                    <i class="fa-solid fa-paw"></i>
                </span>
                <h2>My Pets</h2>
            </div>
        </div>

        <div class="large-pet-list">

            <%
                java.util.List<java.util.Map<String, Object>> myPets =
                    (java.util.List<java.util.Map<String, Object>>)
                        request.getAttribute("myPets");

                if (myPets != null && !myPets.isEmpty()) {

                    for (java.util.Map<String, Object> pet : myPets) {

                        String petName = String.valueOf(pet.get("name"));
                        String breed = String.valueOf(pet.get("breed"));
                        String age = String.valueOf(pet.get("age"));
                        String gender = String.valueOf(pet.get("gender"));
                        String image = String.valueOf(pet.get("image"));

                        String sourceType = String.valueOf(
                            pet.get("sourceType")
                        );

                        if (image == null || image.trim().isEmpty()
                                || "null".equals(image)) {

                            image = request.getContextPath()
                                    + "/images/default-pet.jpg";

                        } else if (!image.startsWith("http://")
                                && !image.startsWith("https://")
                                && !image.startsWith(request.getContextPath() + "/")) {

                            image = request.getContextPath() + "/" + image;
                        }
            %>

            <div class="large-pet-row">

                <img src="<%= image %>"
                     alt="<%= petName %>"
                     onerror="this.src='<%= request.getContextPath() %>/images/default-pet.jpg'">

                <div class="large-pet-info">

                    <h3><%= petName %></h3>

                    <p><%= breed %></p>

                    <span>
                        <%= age %> • <%= gender %>
                    </span>

                    <% if ("SELLER".equals(sourceType)) { %>
                        <small class="seller-pet-label">
                            Seller Marketplace
                        </small>
                    <% } %>

                </div>

                <span class="healthy">Owned</span>

            </div>

            <%
                    }
                } else {
            %>

            <div class="large-pet-row">

                <div class="large-pet-info">
                    <h3>No pets yet 🐾</h3>
                    <p>Pets you purchase will appear here.</p>
                </div>

            </div>

            <%
                }
            %>

        </div>

    </div>

</section>



        <!-- =================================================
             ADOPTION
        ================================================== -->

       
<section id="adoption" class="page-section seller-partner-section">

    <!-- HERO SECTION -->
    <div class="seller-hero">

        <div class="seller-hero-content">

            <span class="seller-label">SELL WITH PETORA</span>

            <h1>
                Become a <span>Petora Seller</span>
            </h1>

            <h2>Turn Your Love for Pets into a Partnership</h2>

            <p>
                List your pets, reach genuine pet lovers and find
                caring, responsible homes with Petora.
            </p>

            <div class="seller-hero-buttons">

                <a href="seller-login.jsp" class="seller-login-btn">
                    <i class="fa-solid fa-right-to-bracket"></i>
                    Login as Seller
                    <span>→</span>
                </a>

                <a href="seller-register.jsp" class="seller-register-btn">
                    <i class="fa-solid fa-user-plus"></i>
                    Register as Seller
                    <span>→</span>
                </a>

            </div>

        </div>

        <!-- PET ILLUSTRATION -->
        <div class="seller-hero-visual">

            <div class="seller-paw paw-one">🐾</div>
            <div class="seller-paw paw-two">🐾</div>

            <div class="seller-pet-circle">
                <span class="seller-main-pet">🐶</span>
                <span class="seller-side-pet">🐱</span>
                <span class="seller-rabbit">🐰</span>
            </div>

            <div class="seller-floating-card">
                <span>💚</span>
                <div>
                    <strong>Happy Partnerships</strong>
                    <small>Connecting pets with loving homes</small>
                </div>
            </div>

        </div>

    </div>


    <!-- SELLER BENEFITS -->
    <div class="seller-benefits-section">

        <div class="seller-section-heading">
            <span>WHY JOIN US?</span>
            <h2>Why Become a Seller on <span>Petora?</span></h2>
            <p>Grow your reach while helping pets find loving homes.</p>
        </div>

        <div class="seller-benefits-grid">

            <div class="seller-benefit-card benefit-green">
                <div class="benefit-icon">
                    <i class="fa-solid fa-users"></i>
                </div>

                <div>
                    <h3>Reach More Pet Lovers</h3>
                    <p>
                        Showcase your pets to a large and trusted community.
                    </p>
                </div>
            </div>


            <div class="seller-benefit-card benefit-blue">
                <div class="benefit-icon">
                    <i class="fa-solid fa-list-check"></i>
                </div>

                <div>
                    <h3>Manage Your Listings</h3>
                    <p>
                        Easily add, update and manage your pet details.
                    </p>
                </div>
            </div>


            <div class="seller-benefit-card benefit-orange">
                <div class="benefit-icon">
                    <i class="fa-solid fa-shield-heart"></i>
                </div>

                <div>
                    <h3>Connect with Genuine Buyers</h3>
                    <p>
                        Connect with caring people looking for a new companion.
                    </p>
                </div>
            </div>


            <div class="seller-benefit-card benefit-purple">
                <div class="benefit-icon">
                    <i class="fa-solid fa-chart-column"></i>
                </div>

                <div>
                    <h3>Track Your Sales</h3>
                    <p>
                        Keep track of your listings, inquiries and sales.
                    </p>
                </div>
            </div>

        </div>

    </div>


    <!-- HOW IT WORKS -->
    <div class="seller-how-section">

        <div class="seller-section-heading">
            <h2>How It Works?</h2>
            <p>Start your seller journey in three simple steps.</p>
        </div>

        <div class="seller-steps">

            <div class="seller-step">

                <span class="step-number">1</span>

                <div class="step-icon">
                    <i class="fa-solid fa-user-plus"></i>
                </div>

                <div class="step-content">
                    <h3>Register as Seller</h3>
                    <p>
                        Create your seller account with basic details.
                    </p>
                </div>

            </div>


            <div class="step-arrow">→</div>


            <div class="seller-step">

                <span class="step-number">2</span>

                <div class="step-icon step-blue">
                    <i class="fa-solid fa-circle-check"></i>
                </div>

                <div class="step-content">
                    <h3>Get Approved</h3>
                    <p>
                        Our team reviews and verifies your application.
                    </p>
                </div>

            </div>


            <div class="step-arrow">→</div>


            <div class="seller-step">

                <span class="step-number">3</span>

                <div class="step-icon">
                    <i class="fa-solid fa-store"></i>
                </div>

                <div class="step-content">
                    <h3>Start Selling</h3>
                    <p>
                        List your pets and connect with loving buyers.
                    </p>
                </div>

            </div>

        </div>

    </div>

</section>



        <!-- =================================================
             VETERINARY SERVICES
        ================================================== -->

        
<%@ page import="java.util.List" %>
<%@ page import="com.petcare.servlet.ApprovedDoctorsServlet.Doctor" %>

<%
    List<Doctor> approvedDoctors =
        (List<Doctor>) request.getAttribute("approvedDoctors");
%>
<%!
    private String escapeHTML(String value) {
        if (value == null) {
            return "";
        }

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>
<section id="veterinary" class="page-section">

    <div class="section-page-header">
        <span class="section-label">HEALTH &amp; WELLNESS</span>
        <h1>Veterinary Services 🩺</h1>
        <p>Meet our approved veterinarians.</p>
    </div>

    <div class="service-grid doctor-grid">

        <% if (approvedDoctors == null || approvedDoctors.isEmpty()) { %>

            <div class="service-card doctor-empty">
                <div class="service-icon green-icon">
                    <i class="fa-solid fa-stethoscope"></i>
                </div>
                <h3>No Veterinarians Available</h3>
                <p>
                    Approved veterinarians will appear here once
                    their profiles are available.
                </p>
            </div>

        <% } else {
            for (Doctor doctor : approvedDoctors) {
        %>

            <article class="service-card doctor-card">

                <div class="service-icon green-icon">
                    <i class="fa-solid fa-user-doctor"></i>
                </div>

                <h3>
                    Dr. <%= escapeHTML(doctor.getFullName()) %>
                </h3>

                <span class="doctor-specialty">
                    <%= escapeHTML(doctor.getSpecialization()) %>
                </span>

                <p class="doctor-detail">
                    <i class="fa-solid fa-graduation-cap"></i>
                    <%= escapeHTML(doctor.getQualification()) %>
                </p>

                <p class="doctor-detail">
                    <i class="fa-solid fa-briefcase"></i>
                    <%= doctor.getExperienceYears() %> Years Experience
                </p>

                <p class="doctor-detail">
                    <i class="fa-solid fa-hospital"></i>
                    <%= escapeHTML(doctor.getClinicName()) %>
                </p>

                <p class="doctor-detail">
                    <i class="fa-solid fa-location-dot"></i>
                    <%= escapeHTML(doctor.getCity()) %>,
                    <%= escapeHTML(doctor.getState()) %>
                </p>

                <a class="primary-btn doctor-profile-btn"
   href="<%= request.getContextPath() %>/DoctorProfileServlet?id=<%= doctor.getId() %>"
   style="text-decoration:none;">
    View Profile
    <i class="fa-solid fa-arrow-right"></i>
</a>

            </article>

        <%  }
           } %>

    </div>
</section>



        <!-- =================================================
             PET CARE STORE
        ================================================== -->

        <section id="store" class="page-section">

            
<div class="store-page">

    <!-- Store Hero -->
    <div class="store-hero">
        <div class="store-hero-copy">
            <span class="store-eyebrow">PAWCARE STORE</span>
            <h1>Everything for Your <span>Furry Friends</span></h1>
            <p>Healthy, happy pets start with the right care.</p>
            <p>Explore products selected for your beloved companions.</p>

            <div class="store-trust">
                <span><i class="fa-solid fa-shield-heart"></i> Quality Products</span>
                <span><i class="fa-solid fa-leaf"></i> Pet Friendly</span>
                <span><i class="fa-solid fa-heart"></i> Made for Pets</span>
            </div>
        </div>

        <div class="store-hero-image">
            <img src="images/store-hero.jpg"
                 alt="Happy pets and pet care products">
        </div>
    </div>

    <!-- Three Categories -->
    <nav class="store-category-nav">
        <button class="store-category-btn active"
                onclick="showStoreCategory('food', this)">
            <i class="fa-solid fa-bowl-food"></i> Pet Foods
        </button>

        <button class="store-category-btn"
                onclick="showStoreCategory('health', this)">
            <i class="fa-solid fa-kit-medical"></i> Health Care
        </button>

        <button class="store-category-btn"
                onclick="showStoreCategory('accessories', this)">
            <i class="fa-solid fa-shirt"></i> Dress & Accessories
        </button>
    </nav>

    <!-- Store Toolbar -->
    <div class="store-toolbar">
        <div>
            <h2 id="storeHeading">Pet Foods</h2>
            <p id="storeSubtitle">Nutritious choices for happier, healthier pets.</p>
        </div>

        <div class="store-tools">
            <label class="store-search">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="search" id="storeSearch"
                       placeholder="Search products..."
                       oninput="filterStoreProducts()">
            </label>

            <select id="storeSort" onchange="filterStoreProducts()"
                    aria-label="Sort products">
                <option value="default">Featured</option>
                <option value="low">Price: Low to High</option>
                <option value="high">Price: High to Low</option>
                <option value="name">Name: A to Z</option>
            </select>
        </div>
    </div>

    <!-- Product Filters and Grid -->
    <div class="store-layout">
        <aside class="store-filters">
            <h3>Filter Products</h3>

            <label for="storePetFilter">Pet type</label>
            <select id="storePetFilter" onchange="filterStoreProducts()">
                <option value="all">All Pets</option>
                <option value="dogs">Dogs</option>
                <option value="cats">Cats</option>
                <option value="all">Other Pets</option>
            </select>

            <div class="store-filter-divider"></div>

            <h3>Quick categories</h3>
            <p class="store-filter-note">Choose a category above to explore its products.</p>

            <div class="store-filter-help">
                <i class="fa-solid fa-paw"></i>
                <p>Find something special for your companion.</p>
            </div>
        </aside>

        <div class="store-products-area">
            <!-- Pet Foods -->
            <div id="store-food" class="store-category-content">
                <div class="store-product-grid">

                    <article class="store-product"
                             data-category="food" data-pet="dogs"
                             data-name="Royal Canin Puppy Food" data-price="899">
                        <div class="store-product-image">
                            <img src="images/products/royal-canin.jpg" alt="Puppy food"
                                 onerror="this.style.display='none'">
                            <span class="store-badge">Bestseller</span>
                            <button class="store-wishlist" onclick="toggleWishlist(this)"
                                    aria-label="Add to wishlist">
                                <i class="fa-regular fa-heart"></i>
                            </button>
                        </div>
                        <div class="store-product-info">
                            <h3>Royal Canin Puppy Food</h3>
                            <p>Dry food · For puppies</p>
                            <div class="store-rating">★ <span>4.8 (120)</span></div>
                            <div class="store-price">₹899 <del>₹1,100</del></div>
                            <button class="store-add-btn"
                                    onclick="addStoreItem('Royal Canin Puppy Food', 899)">
                                <i class="fa-solid fa-cart-plus"></i> Add to Cart
                            </button>
                        </div>
                    </article>

                    <article class="store-product"
                             data-category="food" data-pet="dogs"
                             data-name="Pedigree Adult Dog Food" data-price="749">
                        <div class="store-product-image">
                            <img src="images/products/pedigree.jpg" alt="Adult dog food"
                                 onerror="this.style.display='none'">
                            <span class="store-badge popular">Popular</span>
                            <button class="store-wishlist" onclick="toggleWishlist(this)"
                                    aria-label="Add to wishlist">
                                <i class="fa-regular fa-heart"></i>
                            </button>
                        </div>
                        <div class="store-product-info">
                            <h3>Pedigree Adult Dog Food</h3>
                            <p>Dry food · Adult dogs</p>
                            <div class="store-rating">★ <span>4.6 (98)</span></div>
                            <div class="store-price">₹749 <del>₹950</del></div>
                            <button class="store-add-btn"
                                    onclick="addStoreItem('Pedigree Adult Dog Food', 749)">
                                <i class="fa-solid fa-cart-plus"></i> Add to Cart
                            </button>
                        </div>
                    </article>

                    <article class="store-product"
                             data-category="food" data-pet="cats"
                             data-name="Whiskas Cat Food" data-price="499">
                        <div class="store-product-image">
                            <img src="images/products/whiskas.jpg" alt="Cat food"
                                 onerror="this.style.display='none'">
                            <span class="store-badge new">Popular</span>
                            <button class="store-wishlist" onclick="toggleWishlist(this)"
                                    aria-label="Add to wishlist">
                                <i class="fa-regular fa-heart"></i>
                            </button>
                        </div>
                        <div class="store-product-info">
                            <h3>Whiskas Cat Food</h3>
                            <p>Dry food · Adult cats</p>
                            <div class="store-rating">★ <span>4.7 (76)</span></div>
                            <div class="store-price">₹499 <del>₹650</del></div>
                            <button class="store-add-btn"
                                    onclick="addStoreItem('Whiskas Cat Food', 499)">
                                <i class="fa-solid fa-cart-plus"></i> Add to Cart
                            </button>
                        </div>
                    </article>

                    <article class="store-product"
                             data-category="food" data-pet="cats"
                             data-name="Sheba Wet Cat Food" data-price="699">
                        <div class="store-product-image">
                            <img src="images/products/sheba.jpg" alt="Wet cat food"
                                 onerror="this.style.display='none'">
                            <button class="store-wishlist" onclick="toggleWishlist(this)"
                                    aria-label="Add to wishlist">
                                <i class="fa-regular fa-heart"></i>
                            </button>
                        </div>
                        <div class="store-product-info">
                            <h3>Sheba Wet Cat Food</h3>
                            <p>Wet food · Real chicken</p>
                            <div class="store-rating">★ <span>4.5 (64)</span></div>
                            <div class="store-price">₹699 <del>₹850</del></div>
                            <button class="store-add-btn"
                                    onclick="addStoreItem('Sheba Wet Cat Food', 699)">
                                <i class="fa-solid fa-cart-plus"></i> Add to Cart
                            </button>
                        </div>
                    </article>

                </div>
            </div>

            <!-- Health Care -->
            <div id="store-health" class="store-category-content" hidden>
                <div class="store-product-grid">

                    <article class="store-product"
                             data-category="health" data-pet="dogs"
                             data-name="Pet Shampoo" data-price="299">
                        <div class="store-product-image">
                            <img src="images/pet-shampoo.jpg" alt="Pet shampoo"
                                 onerror="this.style.display='none'">
                            <span class="store-badge">Essential</span>
                            <button class="store-wishlist" onclick="toggleWishlist(this)"
                                    aria-label="Add to wishlist">
                                <i class="fa-regular fa-heart"></i>
                            </button>
                        </div>
                        <div class="store-product-info">
                            <h3>Gentle Pet Shampoo</h3>
                            <p>Bathing · Coat care</p>
                            <div class="store-rating">★ <span>4.6</span></div>
                            <div class="store-price">₹299</div>
                            <button class="store-add-btn"
                                    onclick="addStoreItem('Gentle Pet Shampoo', 299)">
                                <i class="fa-solid fa-cart-plus"></i> Add to Cart
                            </button>
                        </div>
                    </article>

                    <article class="store-product"
                             data-category="health" data-pet="all"
                             data-name="Pet First Aid Kit" data-price="599">
                        <div class="store-product-image">
                            <img src="images/pet-first-aid.jpg" alt="Pet first aid kit"
                                 onerror="this.style.display='none'">
                            <button class="store-wishlist" onclick="toggleWishlist(this)"
                                    aria-label="Add to wishlist">
                                <i class="fa-regular fa-heart"></i>
                            </button>
                        </div>
                        <div class="store-product-info">
                            <h3>Pet First Aid Kit</h3>
                            <p>Care essentials</p>
                            <div class="store-rating">★ <span>4.7</span></div>
                            <div class="store-price">₹599</div>
                            <button class="store-add-btn"
                                    onclick="addStoreItem('Pet First Aid Kit', 599)">
                                <i class="fa-solid fa-cart-plus"></i> Add to Cart
                            </button>
                        </div>
                    </article>

                    <article class="store-product"
                             data-category="health" data-pet="cats"
                             data-name="Cat Grooming Brush" data-price="249">
                        <div class="store-product-image">
                            <img src="images/cat-brush.jpg" alt="Cat grooming brush"
                                 onerror="this.style.display='none'">
                            <button class="store-wishlist" onclick="toggleWishlist(this)"
                                    aria-label="Add to wishlist">
                                <i class="fa-regular fa-heart"></i>
                            </button>
                        </div>
                        <div class="store-product-info">
                            <h3>Cat Grooming Brush</h3>
                            <p>Coat care</p>
                            <div class="store-rating">★ <span>4.5</span></div>
                            <div class="store-price">₹249</div>
                            <button class="store-add-btn"
                                    onclick="addStoreItem('Cat Grooming Brush', 249)">
                                <i class="fa-solid fa-cart-plus"></i> Add to Cart
                            </button>
                        </div>
                    </article>

                </div>
            </div>

            <!-- Dress & Accessories -->
            <div id="store-accessories" class="store-category-content" hidden>
                <div class="store-product-grid">

                    <article class="store-product"
                             data-category="accessories" data-pet="dogs"
                             data-name="Dog Collar" data-price="199">
                        <div class="store-product-image">
                            <img src="images/dog-collar.jpg" alt="Dog collar"
                                 onerror="this.style.display='none'">
                            <button class="store-wishlist" onclick="toggleWishlist(this)"
                                    aria-label="Add to wishlist">
                                <i class="fa-regular fa-heart"></i>
                            </button>
                        </div>
                        <div class="store-product-info">
                            <h3>Adjustable Dog Collar</h3>
                            <p>Accessories · Dogs</p>
                            <div class="store-rating">★ <span>4.6</span></div>
                            <div class="store-price">₹199</div>
                            <button class="store-add-btn"
                                    onclick="addStoreItem('Adjustable Dog Collar', 199)">
                                <i class="fa-solid fa-cart-plus"></i> Add to Cart
                            </button>
                        </div>
                    </article>

                    <article class="store-product"
                             data-category="accessories" data-pet="dogs"
                             data-name="Pet Hoodie" data-price="499">
                        <div class="store-product-image">
                            <img src="images/pet-hoodie.jpg" alt="Pet hoodie"
                                 onerror="this.style.display='none'">
                            <button class="store-wishlist" onclick="toggleWishlist(this)"
                                    aria-label="Add to wishlist">
                                <i class="fa-regular fa-heart"></i>
                            </button>
                        </div>
                        <div class="store-product-info">
                            <h3>Cozy Pet Hoodie</h3>
                            <p>Clothing · Dogs</p>
                            <div class="store-rating">★ <span>4.5</span></div>
                            <div class="store-price">₹499</div>
                            <button class="store-add-btn"
                                    onclick="addStoreItem('Cozy Pet Hoodie', 499)">
                                <i class="fa-solid fa-cart-plus"></i> Add to Cart
                            </button>
                        </div>
                    </article>

                    <article class="store-product"
                             data-category="accessories" data-pet="all"
                             data-name="Rope Toy Set" data-price="349">
                        <div class="store-product-image">
                            <img src="images/rope-toy.jpg" alt="Pet rope toys"
                                 onerror="this.style.display='none'">
                            <button class="store-wishlist" onclick="toggleWishlist(this)"
                                    aria-label="Add to wishlist">
                                <i class="fa-regular fa-heart"></i>
                            </button>
                        </div>
                        <div class="store-product-info">
                            <h3>Rope Toy Set</h3>
                            <p>Playtime · Accessories</p>
                            <div class="store-rating">★ <span>4.8</span></div>
                            <div class="store-price">₹349</div>
                            <button class="store-add-btn"
                                    onclick="addStoreItem('Rope Toy Set', 349)">
                                <i class="fa-solid fa-cart-plus"></i> Add to Cart
                            </button>
                        </div>
                    </article>

                </div>
            </div>

            <p id="storeEmpty" class="store-empty" hidden>
                No products match your search. Try another keyword or filter.
            </p>
        </div>
    </div>

</div>

				

        </section>


        <!-- =================================================
             COMMUNITY
        ================================================== -->

        <section id="community" class="page-section">

            <div class="section-page-header">
                <span class="section-label">PAWCARE COMMUNITY</span>
                <h1>Community 👥</h1>
                <p>Connect with other pet lovers.</p>
            </div>

            <div class="community-grid">

                <div class="community-card">
                    <div class="community-icon">
                        <i class="fa-solid fa-users"></i>
                    </div>
                    <h3>Pet Lovers</h3>
                    <p>Meet people who love pets just like you.</p>
                    <button type="button">Explore Community</button>
                </div>

                <div class="community-card">
                    <div class="community-icon">
                        <i class="fa-solid fa-comments"></i>
                    </div>
                    <h3>Discussions</h3>
                    <p>Share experiences and ask questions.</p>
                    <button type="button">Join Discussion</button>
                </div>

                <div class="community-card">
                    <div class="community-icon">
                        <i class="fa-solid fa-heart"></i>
                    </div>
                    <h3>Pet Stories</h3>
                    <p>Share your pet's special moments.</p>
                    <button type="button">View Stories</button>
                </div>

            </div>

        </section>


        <!-- =================================================
             MESSAGES
        ================================================== -->

        <section id="messages" class="page-section">

            <div class="section-page-header">
                <span class="section-label">COMMUNICATION</span>
                <h1>Messages 💬</h1>
                <p>Stay connected with PawCare.</p>
            </div>

            <div class="dashboard-card page-card">

                <div class="empty-state">
                    <div class="empty-icon">
                        <i class="fa-regular fa-message"></i>
                    </div>

                    <h2>No New Messages</h2>

                    <p>
                        Your conversations and support messages
                        will appear here.
                    </p>

                    <button class="primary-btn" type="button">
                        Contact Support
                    </button>
                </div>

            </div>

        </section>


        <!-- =================================================
             SETTINGS
        ================================================== -->

         <section id="settings" class="page-section">

            <div class="section-page-header">
                <span class="section-label">ACCOUNT</span>
                <h1>Settings ⚙️</h1>
                <p>Manage your PawCare account.</p>
            </div>

            <div class="settings-card">

                <div class="settings-row">
                    <div>
                        <h3>Profile Information</h3>
                        <p>Update your name and account information.</p>
                    </div>

                    <button type="button">Edit</button>
                </div>

                <div class="settings-row">
                    <div>
                        <h3>Email Notifications</h3>
                        <p>Receive important PawCare updates.</p>
                    </div>

                    <label class="switch">
                        <input type="checkbox" checked>
                        <span class="slider"></span>
                    </label>
                </div>

                <div class="settings-row">
                    <div>
                        <h3>Pet Health Reminders</h3>
                        <p>Get reminders for appointments and vaccinations.</p>
                    </div>

                    <label class="switch">
                        <input type="checkbox" checked>
                        <span class="slider"></span>
                    </label>
                </div>

            </div>

        </section>
    </main>

<div id="logoutPopup" class="logout-popup">
    <div class="logout-box">
        <i class="fa-solid fa-sign-out-alt"></i>
        <h3>Logout Confirmation</h3>
        <p>Are you sure you want to logout?</p>

        <div class="logout-actions">
            <button type="button" onclick="closeLogoutPopup()">Cancel</button>

            <form action="LogoutServlet" method="POST">
                <button type="submit" class="confirm-logout">Logout</button>
            </form>
        </div>
    </div>
</div>


<%
    String purchasedPetName =
        (String) session.getAttribute("purchasedPetName");

    boolean purchaseSuccess =
        Boolean.TRUE.equals(session.getAttribute("purchaseSuccess"));

    // Remove the message after reading it so it appears only once
    session.removeAttribute("purchaseSuccess");
    session.removeAttribute("purchasedPetName");
%>

<!-- PURCHASE SUCCESS POPUP -->
<div id="purchaseSuccessModal"
     class="purchase-success-overlay"
     style="display: <%= purchaseSuccess ? "flex" : "none" %>;">

    <div class="purchase-success-box">

        <!-- Success Icon -->
        <div class="success-check">
            <i class="fa-solid fa-check"></i>
        </div>

        <!-- Heading -->
        <h2>Purchase Successful!</h2>

        <!-- Pet Name -->
        <p class="success-pet-name">
            <%= purchasedPetName != null
                ? "Congratulations! " + purchasedPetName + " is now yours! 🐾"
                : "Your new pet is now part of your family! 🐾" %>
        </p>

        <p class="success-description">
            Your pet has been successfully purchased
            and added to your My Pets section.
        </p>

        <!-- Dashboard Button -->
        <button type="button" onclick="goToPurchaseDashboard()">
            Go to Dashboard
            <i class="fa-solid fa-arrow-right"></i>
        </button>

        <!-- Decoration -->
        <div class="success-paw">
            <i class="fa-solid fa-paw"></i>
        </div>

    </div>

</div>

<script>
    function goToPurchaseDashboard() {
        window.location.href =
            "<%= request.getContextPath() %>/MyPetsServlet";
    }
</script>



    <script src="dashboard.js"></script>

</body>
</html>
