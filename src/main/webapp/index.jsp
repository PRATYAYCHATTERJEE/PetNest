<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String userName = (String) session.getAttribute("userName");
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">

    <meta name="viewport"
        content="width=device-width, initial-scale=1.0">

    <title>PawCare | Better Pets. Better Life.</title>

    <!-- CSS -->
    <link rel="stylesheet"
        href="${pageContext.request.contextPath}/CSS/main.css">
</head>

<body>

    <!-- ================= NAVBAR ================= -->

    <header class="navbar">

        <div class="nav-container">

            <!-- Logo -->
            
<a href="index.jsp" class="logo">
    <img src="images/PetNest_Logo.png"
         alt="Pet Nest Logo"
         class="logo-image">

    <div class="logo-text">
        <span class="logo-name">Pet Nest</span>
        <span class="logo-tagline">Pets. Belong. Always.</span>
    </div>
</a>



            <!-- Navigation -->
            <nav class="nav-menu" id="navMenu">

                <a href="index.jsp" class="nav-link active">
                    Home
                </a>

                <a href="#" class="nav-link">
                    Pets
                </a>

                <a href="#" class="nav-link">
                    About
                </a>

                <a href="#" class="nav-link">
                    Adoption
                </a>

                <a href="#" class="nav-link">
                    Services
                </a>

                <a href="#" class="nav-link">
                    Contact
                </a>

            </nav>


            <!-- Right side -->
            


                <!-- Login -->
                <div class="nav-auth">

    <% if (userName == null) { %>

        <!-- BEFORE LOGIN -->
        <a href="login.jsp" class="login-btn">Login</a>
        <a href="register.jsp" class="register-btn">Register</a>

    <% } else { %>

        <!-- AFTER LOGIN -->
        <a href="home.jsp" class="user-profile">
            <span class="profile-icon">👤</span>
            <span class="user-name"><%= userName %></span>
        </a>

    <% } %>

</div>

            </div>


            <!-- Mobile menu button -->
            <button
                class="menu-toggle"
                id="menuToggle"
                type="button">

                ☰

            </button>

        </div>

    </header>


    <!-- ================= END NAVBAR ================= -->

<!-- ================= HERO SECTION ================= -->
<section class="hero">

    <!-- Decorative background -->
    <div class="hero-decoration hero-decoration-one"></div>
    <div class="hero-decoration hero-decoration-two"></div>
    <span class="hero-paw paw-one">🐾</span>
    <span class="hero-paw paw-two">🐾</span>
    <span class="hero-heart">♥</span>

    <!-- LEFT CONTENT -->
    <div class="hero-content">

        <div class="hero-eyebrow">
            <span class="eyebrow-paw">🐾</span>
            <span>WELCOME TO PET NEST</span>
        </div>

        <h1>
            A Better World<br>
            for <span>Every Pet</span>
        </h1>

        <p class="hero-description">
            Adopt, care, and give a second chance.<br>
            Because every pet deserves a loving home.
        </p>

        <a href="#pets" class="hero-btn">
            Find Your Companion
            <span class="btn-arrow">→</span>
        </a>

        <!-- Statistics -->
        <div class="hero-stats">

            <div class="hero-stat">
                <div class="stat-icon stat-orange">🐾</div>
                <div class="stat-info">
                    <strong>500+</strong>
                    <span>Pets Adopted</span>
                </div>
            </div>

            <div class="stat-divider"></div>

            <div class="hero-stat">
                <div class="stat-icon stat-green">♟</div>
                <div class="stat-info">
                    <strong>100+</strong>
                    <span>Active Volunteers</span>
                </div>
            </div>

            <div class="stat-divider"></div>

            <div class="hero-stat">
                <div class="stat-icon stat-peach">⌂</div>
                <div class="stat-info">
                    <strong>50+</strong>
                    <span>Partner Shelters</span>
                </div>
            </div>

        </div>
    </div>

    <!-- RIGHT PET GALLERY -->
    <div class="hero-gallery">

        <div class="gallery-orbit"></div>
        <div class="gallery-center-glow"></div>

        <!-- Main dog -->
        <div class="pet-circle pet-main">
            <img src="images/heropet1.png" alt="Happy dog">
        </div>

        <!-- Cat -->
        <div class="pet-circle pet-cat">
            <img src="images/heropet2.png" alt="Adorable cat">
        </div>

        <!-- Rabbit -->
        <div class="pet-circle pet-rabbit">
            <img src="images/heropet3.png" alt="Cute rabbit">
        </div>

        <!-- Parrot -->
        <div class="pet-circle pet-parrot">
            <img src="images/heropet4.png" alt="Colorful parrot">
        </div>

        <!-- Floating badges -->
        <div class="pet-badge badge-love">
            <span class="badge-icon">♥</span>
            <span>Love<br>Them</span>
        </div>

        <div class="pet-badge badge-adopt">
            <span class="badge-icon">🐾</span>
            <span>Adopt<br>Them</span>
        </div>

        <div class="pet-badge badge-care">
            <span class="badge-icon">❧</span>
            <span>Care<br>For Them</span>
        </div>

        <div class="pet-badge badge-home">
            <span class="badge-icon">⌂</span>
            <span>Give<br>A Home</span>
        </div>

        <!-- Small decorations -->
        <span class="gallery-heart heart-one">♥</span>
        <span class="gallery-heart heart-two">♡</span>

        <span class="gallery-leaf leaf-one">❧</span>
        <span class="gallery-leaf leaf-two">❧</span>

    </div>
</section>


<!-- ================= FEATURED PETS ================= -->


<section class="discover-pets" id="pets">

    <div class="discover-container">

        <!-- SECTION HEADING -->
        <div class="discover-heading">
            <span>FIND A FRIEND</span>
            <h2>Discover Your New Best Friend!</h2>
        </div>

        <!-- PET GRID -->
        <div class="discover-grid">

            <!-- PET 1 -->
            <a href="pets.jsp" class="discover-card">
                <div class="discover-image">
                    <img src="<%=request.getContextPath()%>/images/index/june.jpg" alt="June">
                </div>
            </a>

            <!-- PET 2 -->
            <a href="pets.jsp" class="discover-card">
                <div class="discover-image">
                    <img src="<%=request.getContextPath()%>/images/index/quackers.jpg" alt="Quackers">
                </div>
            </a>

            <!-- PET 3 -->
            <a href="pets.jsp" class="discover-card">
                <div class="discover-image">
                    <img src="<%=request.getContextPath()%>/images/pebble.jpg" alt="Pebble">
                </div>
            </a>

            <!-- PET 4 -->
            <a href="pets.jsp" class="discover-card">
                <div class="discover-image">
                    <img src="<%=request.getContextPath()%>/images/freckle.jpg" alt="Freckle">
                </div>
            </a>

            <!-- PET 5 -->
            <a href="pets.jsp" class="discover-card">
                <div class="discover-image">
                    <img src="<%=request.getContextPath()%>/images/brownie.jpg" alt="Brownie">
                </div>
            </a>

            <!-- PET 6 -->
            <a href="pets.jsp" class="discover-card">
                <div class="discover-image">
                    <img src="<%=request.getContextPath()%>/images/marley.jpg" alt="Marley">
                </div>
            </a>

            <!-- PET 7 -->
            <a href="pets.jsp" class="discover-card">
                <div class="discover-image">
                    <img src="<%=request.getContextPath()%>/images/archi.jpg" alt="Archi">
                </div>
            </a>

            <!-- PET 8 -->
            <a href="pets.jsp" class="discover-card">
                <div class="discover-image">
                    <img src="<%=request.getContextPath()%>/images/coolio.jpg" alt="Coolio">
                </div>
            </a>

        </div>

        <!-- FIND MORE FRIENDS -->
        <div class="discover-footer">
            <a href="pets.jsp">
                <span class="paw-icon">🐾</span>
                Find More Friends
                <span class="discover-arrow">→</span>
            </a>
        </div>

    </div>

</section>


<!-- OUR SERVICES SECTION -->
<section class="services-section" id="services">

    <div class="services-container">

        <!-- Heading -->
        <div class="services-heading">
            <span class="services-label">CARE FOR EVERY PAW</span>
            <h2>Our <span>Services</span></h2>
            <p>
                Discover our comprehensive pet services designed
                to cater to all your pet's needs.
            </p>
        </div>

        <!-- Services Cards -->
        <div class="services-grid">

            <!-- Pet Grooming -->
            <div class="service-card grooming-card">

                <div class="service-icon">
                    <i class="fa-solid fa-scissors"></i>
                </div>

                <h3>Pet Grooming</h3>

                <p>
                    Keep your furry friend fresh, clean and
                    looking their absolute best.
                </p>

                <a href="#services" class="service-link">
                    Explore Service <span>→</span>
                </a>

            </div>

            <!-- Teeth Cleaning -->
            <div class="service-card teeth-card">

                <div class="service-icon">
                    <i class="fa-solid fa-tooth"></i>
                </div>

                <h3>Teeth Cleaning</h3>

                <p>
                    Maintain healthy teeth and fresh breath
                    with proper dental care.
                </p>

                <a href="#services" class="service-link">
                    Explore Service <span>→</span>
                </a>

            </div>

            <!-- Veterinary -->
            <div class="service-card veterinary-card">

                <div class="service-icon">
                    <i class="fa-solid fa-stethoscope"></i>
                </div>

                <h3>Veterinary Care</h3>

                <p>
                    Professional health checkups and
                    medical care for your beloved pets.
                </p>

                <a href="#services" class="service-link">
                    Explore Service <span>→</span>
                </a>

            </div>

        </div>

    </div>

</section>







<!-- VETERINARY DOCTORS SECTION -->
<section class="vet-team-section" id="doctors">

    <div class="vet-team-container">

        <!-- Heading -->
        <div class="vet-heading">
            <span>Pet Care Team</span>
            <h2>
                Meet Our Veterinary <strong>Doctors</strong>
            </h2>
        </div>

        <!-- Doctor Profiles -->
        <div class="vet-doctors-grid">

            <!-- Doctor 1 -->
            <div class="vet-doctor-card">

                <div class="vet-doctor-image">
                    <div class="vet-image-ring">
                        <img src="<%=request.getContextPath()%>/images/doctors/emily.jpg"
                             alt="Dr. Emily Carter">
                    </div>
                </div>

                <h3>Dr. Emily Carter</h3>
                <p>Veterinary Doctor</p>

               

            </div>

            <!-- Doctor 2 -->
            <div class="vet-doctor-card">

                <div class="vet-doctor-image">
                    <div class="vet-image-ring">
                        <img src="<%=request.getContextPath()%>/images/doctors/mark.jpg"
                             alt="Mark Burke">
                    </div>
                </div>

                <h3>Mark Burke</h3>
                <p>Veterinary Doctor</p>

               

            </div>

            <!-- Doctor 3 -->
            <div class="vet-doctor-card">

                <div class="vet-doctor-image">
                    <div class="vet-image-ring">
                        <img src="<%=request.getContextPath()%>/images/doctors/ronald.jpg"
                             alt="Ronald Frailey">
                    </div>
                </div>

                <h3>Ronald Frailey</h3>
                <p>Veterinary Doctor</p>

                

            </div>

            <!-- Doctor 4 -->
            <div class="vet-doctor-card">

                <div class="vet-doctor-image">
                    <div class="vet-image-ring">
                        <img src="<%=request.getContextPath()%>/images/doctors/frank.jpg"
                             alt="Frank Wells">
                    </div>
                </div>

                <h3>Frank Wells</h3>
                <p>Veterinary Doctor</p>

               

            </div>

        </div>

        <!-- View All Button -->
        <div class="vet-view-all">
            <a href="doctors.jsp">
                View All <span>→</span>
            </a>
        </div>

    </div>

</section>


<!-- SELL YOUR PET SECTION -->
<section class="sell-pet-section">

    <div class="sell-pet-banner">

        <!-- Pet Image -->
        <div class="sell-pet-image">
            <img src="<%=request.getContextPath()%>/images/sell-pets.png"
                 alt="Dog and cat">
        </div>

        <!-- Banner Content -->
        <div class="sell-pet-content">

            <div class="sell-pet-title">
                <i class="fa-solid fa-tags"></i>
                <h2>Sell Your <span>Pet</span></h2>
            </div>

            <p>
                Looking to find a new and loving home for your pet?
                List them on Pet Nest today!
            </p>

        </div>

        <!-- Action Button -->
        <div class="sell-pet-action">
            <a href="seller-application.jsp">
                List Your Pet
                <span>→</span>
            </a>
        </div>

        <!-- Decorative Paw -->
        <i class="fa-solid fa-paw sell-paw"></i>

    </div>

</section>



<!-- BUY PET PRODUCTS SECTION -->
<section class="buy-products-section">

    <div class="buy-products-banner">

        <!-- Pet and Products Image -->
        <div class="buy-products-image">
            <img src="<%=request.getContextPath()%>/images/buy-products.png"
                 alt="Pets and pet products">
        </div>

        <!-- Banner Content -->
        <div class="buy-products-content">

            <div class="buy-products-title">
                <i class="fa-solid fa-cart-shopping"></i>
                <h2>Buy Pet <span>Products</span></h2>
            </div>

            <p>
                Explore high-quality food, toys, grooming,
                and daily care essentials for your beloved pets.
            </p>

        </div>

        <!-- Action Button -->
        <div class="buy-products-action">
            <a href="products.jsp">
                Shop Now
                <span>→</span>
            </a>
        </div>

        <i class="fa-solid fa-paw buy-products-paw"></i>

    </div>

</section>




<!-- ABOUT PET NEST SECTION -->
<section class="about-pet-section" id="about">

    <div class="about-pet-container">

        <!-- LEFT CONTENT -->
        <div class="about-pet-content">

            <div class="about-eyebrow">
                <i class="fa-solid fa-paw"></i>
                <span>ABOUT US</span>
            </div>

            <h2>
                About <span>Pet Nest</span>
            </h2>

            <p class="about-description">
                <strong>Pet Nest</strong> is a complete pet care platform
                where pet lovers can adopt, buy, sell, and care for
                their beloved companions.

                We connect caring people with pets, trusted products,
                and professional veterinary support — all in one place.
            </p>

            <!-- FEATURE HIGHLIGHTS -->
            <div class="about-features">

                <div class="about-feature">
                    <i class="fa-solid fa-paw"></i>
                    <h4>Adoption<br>& Rehoming</h4>
                </div>

                <div class="about-feature">
                    <i class="fa-solid fa-cart-shopping"></i>
                    <h4>Pet<br>Products</h4>
                </div>

                <div class="about-feature">
                    <i class="fa-solid fa-stethoscope"></i>
                    <h4>Veterinary<br>Care</h4>
                </div>

                <div class="about-feature">
                    <i class="fa-solid fa-heart"></i>
                    <h4>Pet<br>Wellness</h4>
                </div>

            </div>

            <a href="about.jsp" class="about-learn-btn">
                Learn More About Us
                <span>→</span>
            </a>

        </div>

        <!-- RIGHT IMAGE -->
        <div class="about-pet-visual">

            <div class="about-image-frame">
                <img
                    src="<%=request.getContextPath()%>/images/about-pets.jpg"
                    alt="A happy dog and cat together">
            </div>

            <div class="about-heart">
                <i class="fa-regular fa-heart"></i>
            </div>

            <div class="about-paw">
                <i class="fa-solid fa-paw"></i>
            </div>

        </div>

    </div>

</section>




<!-- CONTACT US SECTION -->
<section class="contact-section" id="contact">

    <div class="contact-container">

        <!-- HEADING -->
        <div class="contact-heading">
            <span>
                <i class="fa-solid fa-paw"></i>
                CONTACT US
            </span>

            <h2>Get in Touch with <strong>Pet Nest</strong></h2>

            <p>
                Have a question, suggestion, or need support?
                We're here to help you and your pets.
            </p>
        </div>

        <!-- MAIN CONTENT -->
        <div class="contact-layout">

            <!-- CONTACT DETAILS -->
            <div class="contact-information">

                <div class="contact-info-card">
                    <div class="contact-info-icon">
                        <i class="fa-solid fa-location-dot"></i>
                    </div>
                    <div>
                        <h3>Our Location</h3>
                        <p>Your Pet Nest business address</p>
                    </div>
                </div>

                <div class="contact-info-card">
                    <div class="contact-info-icon">
                        <i class="fa-solid fa-phone"></i>
                    </div>
                    <div>
                        <h3>Call Us</h3>
                        <p>Your contact phone number</p>
                    </div>
                </div>

                <div class="contact-info-card">
                    <div class="contact-info-icon">
                        <i class="fa-solid fa-envelope"></i>
                    </div>
                    <div>
                        <h3>Email Us</h3>
                        <p>support@yourdomain.com</p>
                    </div>
                </div>

                <div class="contact-info-card">
                    <div class="contact-info-icon">
                        <i class="fa-solid fa-clock"></i>
                    </div>
                    <div>
                        <h3>Working Hours</h3>
                        <p>Monday – Saturday: 9:00 AM – 7:00 PM</p>
                    </div>
                </div>

            </div>

            <!-- PET IMAGE -->
            <div class="contact-pet-visual">
                <img
                    src="<%=request.getContextPath()%>/images/contact-pets.png"
                    alt="Happy golden retriever and cat">

                <div class="contact-heart">
                    <i class="fa-regular fa-heart"></i>
                </div>
            </div>

        </div>

    </div>

</section>



    <!-- JavaScript -->
    <script
        src="${pageContext.request.contextPath}/js/script.js">
    </script>

</body>

</html>