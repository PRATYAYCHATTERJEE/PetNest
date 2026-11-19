
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PawCare Admin Dashboard</title>

    <link rel="stylesheet" href="CSS/admin.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
</head>
<body>

<div class="admin-layout">

    <!-- SIDEBAR -->
    <aside class="sidebar" id="sidebar">
        <a href="admin.jsp" class="brand">
            <span class="brand-icon"><i class="fa-solid fa-paw"></i></span>
            <span>PawCare <b>Admin</b></span>
        </a>

        <nav class="sidebar-nav">
            <button class="nav-item active" data-section="dashboard">
                <i class="fa-solid fa-house"></i><span>Home</span>
            </button>
            
         
<button type="button" class="nav-item" data-section="doctors"
        onclick="loadDoctorApplications()">
    <i class="fa-solid fa-stethoscope"></i>
    <span>Doctor Approvals</span>
    <span class="nav-count" id="doctorPendingCount">0</span>
</button>

            <button class="nav-item" data-section="sellers">
                <i class="fa-solid fa-store"></i><span>Pet Seller Approvals</span>
                <span class="nav-count orange">5</span>
            </button>
           
        </nav>

        <div class="sidebar-promo">
            <div class="promo-pets">🐕 🐈</div>
            <h3>PawCare</h3>
            <p>Better Pets. Better Lives.</p>
            <div class="promo-paw"><i class="fa-solid fa-paw"></i></div>
        </div>
    </aside>

    <!-- MAIN AREA -->
    <main class="main-area">

        <header class="topbar">
            <button class="mobile-menu" id="mobileMenu" aria-label="Open menu">
                <i class="fa-solid fa-bars"></i>
            </button>

            <div class="global-search">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="search" id="globalSearch"
                       placeholder="Search users, pets, doctors, sellers...">
            </div>

            <div class="topbar-right">
                <button class="icon-button notification-button"
                        data-section="notifications" aria-label="Notifications">
                    <i class="fa-regular fa-bell"></i>
                    <span class="notification-dot">3</span>
                </button>

                <div class="topbar-divider"></div>

                <button class="admin-profile" id="profileButton">
                    <span class="admin-avatar"><i class="fa-solid fa-user-shield"></i></span>
                    <span>Administrator</span>
                    <i class="fa-solid fa-chevron-down"></i>
                </button>
            </div>
        </header>

        <!-- DASHBOARD SECTION -->
       
<!-- =========================================
     PAWCARE ADMIN - HOME SECTION
========================================= -->

<section class="content-section active" id="dashboard">

    <!-- WELCOME HERO -->
    <div class="admin-home-hero">

        <div class="admin-home-copy">

            <span class="admin-eyebrow">ADMIN PANEL</span>

            <h1>
                Welcome to
                <br>
                PawCare <span>Admin</span>
                <i class="fa-solid fa-paw"></i>
            </h1>

            <p>
                Manage doctor verifications and seller approvals
                from a single, secure panel.
            </p>

        </div>

        <div class="admin-home-image">

            <!-- Add your dog and cat banner image here -->
            <img
                src="<%=request.getContextPath()%>/images/admin/admin-pets.png"
                alt="Happy dog and cat"
            >

        </div>

        <div class="hero-decoration paw-decoration-one">
            <i class="fa-solid fa-paw"></i>
        </div>

        <div class="hero-decoration paw-decoration-two">
            <i class="fa-solid fa-paw"></i>
        </div>

    </div>


    <!-- HOME CONTENT -->
    <div class="admin-home-content">

        <!-- LEFT COLUMN -->
        <div class="admin-home-left">

            <!-- ABOUT PAWCARE -->
            <div class="admin-home-card about-pawcare">

                <div class="home-card-heading">
                    <i class="fa-solid fa-paw"></i>
                    <h2>About PawCare</h2>
                </div>

                <div class="about-content">

                    <div class="about-text">
                        <p>
                            PawCare is a comprehensive pet management
                            platform that connects pet owners,
                            veterinarians, and trusted sellers.
                        </p>

                        <p>
                            Our goal is to make pet adoption,
                            veterinary care, and pet-related
                            services easier and more accessible.
                        </p>
                    </div>

                    <div class="about-image">
                        <img
                            src="<%=request.getContextPath()%>/images/admin/pawcare-office.jpg"
                            alt="PawCare Company"
                        >
                    </div>

                </div>

            </div>


            <!-- COMPANY DETAILS -->
            <div class="admin-home-card company-details">

                <div class="home-card-heading">
                    <i class="fa-solid fa-building"></i>
                    <h2>Company Details</h2>
                </div>

                <div class="company-details-grid">

                    <!-- LOCATION -->
                    <div class="company-detail-item">

                        <div class="detail-icon">
                            <i class="fa-solid fa-location-dot"></i>
                        </div>

                        <div>
                            <strong>Location</strong>
                            <p>Gopal Danga, Asansol, West Bengal</p>
                        </div>

                    </div>


                    <!-- PHONE -->
                    <div class="company-detail-item">

                        <div class="detail-icon">
                            <i class="fa-solid fa-phone"></i>
                        </div>

                        <div>
                            <strong>Phone</strong>
                            <p>Add your company phone number</p>
                        </div>

                    </div>


                    <!-- EMAIL -->
                    <div class="company-detail-item">

                        <div class="detail-icon">
                            <i class="fa-solid fa-envelope"></i>
                        </div>

                        <div>
                            <strong>Email</strong>
                            <p>Add your company email</p>
                        </div>

                    </div>


                    <!-- WEBSITE -->
                    <div class="company-detail-item">

                        <div class="detail-icon">
                            <i class="fa-solid fa-globe"></i>
                        </div>

                        <div>
                            <strong>Website</strong>
                            <p>Add your website address</p>
                        </div>

                    </div>

                </div>

            </div>

        </div>


        <!-- RIGHT COLUMN - LOCATION MAP -->
        <div class="admin-home-card location-card">

            <div class="home-card-heading">

                <i class="fa-solid fa-location-dot"></i>

                <h2>Our Location</h2>

            </div>

            <div class="company-map">

                <iframe
                    src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d6612.386160479411!2d86.98477119046794!3d23.695180239224086!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x39f718d101e3a6bb%3A0x1df6eee26377e04c!2sGopal%20Danga%2C%20Asansol%2C%20West%20Bengal!5e1!3m2!1sen!2sin!4v1795095901035!5m2!1sen!2sin"
                    width="100%"
                    height="100%"
                    style="border:0;"
                    allowfullscreen=""
                    loading="lazy"
                    referrerpolicy="strict-origin-when-cross-origin">
                </iframe>

            </div>

            <div class="map-location-info">

                <i class="fa-solid fa-map-pin"></i>

                <div>
                    <strong>PawCare Location</strong>
                    <p>Gopal Danga, Asansol, West Bengal, India</p>
                </div>

            </div>

        </div>

    </div>


    <!-- BOTTOM BRAND MESSAGE -->
    <div class="admin-home-footer">

        <i class="fa-solid fa-paw"></i>

        <p>
            PawCare — Together for Healthier, Happier Pets.
        </p>

        <i class="fa-solid fa-heart"></i>

    </div>

</section>

<!-- END ADMIN HOME SECTION -->


        <!-- PLACEHOLDER SECTIONS -->
       

        

<section class="content-section" id="doctors">
    <span class="eyebrow">VERIFICATION CENTER</span>
    <h1>Doctor Approvals</h1>
    <p>Review veterinarian applications and credentials.</p>

    <%
        java.util.List<com.petcare.servlet.DoctorApplicationsServlet.DoctorApplication> doctorApplications =
            (java.util.List<com.petcare.servlet.DoctorApplicationsServlet.DoctorApplication>)
            request.getAttribute("doctorApplications");
    %>

    <div class="placeholder-card">
        <h2>Doctor Applications</h2>

        <% if (doctorApplications == null || doctorApplications.isEmpty()) { %>
            <p>No pending doctor applications found.</p>
        <% } else { %>

            <p><strong>Pending applications: <%= doctorApplications.size() %></strong></p>

            <div class="doctor-application-list">
                <% for (com.petcare.servlet.DoctorApplicationsServlet.DoctorApplication doctor : doctorApplications) { %>

                    <div class="doctor-application-card">
                        <h3><%= escapeHtml(doctor.fullName) %></h3>

                        <p><strong>Email:</strong> <%= escapeHtml(doctor.email) %></p>
                        <p><strong>Phone:</strong> <%= escapeHtml(doctor.phone) %></p>
                        <p><strong>Qualification:</strong> <%= escapeHtml(doctor.qualification) %></p>
                        <p><strong>Specialization:</strong> <%= escapeHtml(doctor.specialization) %></p>
                        <p><strong>Registration number:</strong> <%= escapeHtml(doctor.registrationNumber) %></p>
                        <p><strong>Experience:</strong> <%= escapeHtml(doctor.experienceYears) %></p>
                        <p><strong>Clinic:</strong> <%= escapeHtml(doctor.clinicName) %></p>
                        <p><strong>Location:</strong> <%= escapeHtml(doctor.city) %>, <%= escapeHtml(doctor.state) %></p>
                        <p><strong>Submitted:</strong> <%= escapeHtml(doctor.submittedAt) %></p>

                        <p><strong>Status:</strong>
                            <span class="pending-status"><%= escapeHtml(doctor.status) %></span>
                        </p>

                    </div>

                <% } %>
            </div>

        <% } %>
    </div>
</section>

<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;");
    }
%>



        
<section class="content-section" id="sellers">
    <span class="eyebrow">SELLER MANAGEMENT</span>
    <h1>Pet Seller Approvals</h1>
    <p>Review seller applications and manage their approval status.</p>

    <div class="stats-grid">
        <div class="stat-card">
            <span>Total Applications</span>
            <h2 id="sellerTotal">0</h2>
        </div>

        <div class="stat-card">
            <span>Pending</span>
            <h2 id="sellerPending">0</h2>
        </div>

        <div class="stat-card">
            <span>Approved</span>
            <h2 id="sellerApproved">0</h2>
        </div>

        <div class="stat-card">
            <span>Rejected</span>
            <h2 id="sellerRejected">0</h2>
        </div>
    </div>

    <div class="table-container seller-table-container">
        <div class="table-header">
            <h2>Seller Applications</h2>

            <button type="button"
                    class="btn-primary"
                    id="refreshSellers">
                <i class="fa-solid fa-rotate"></i>
                Refresh
            </button>
        </div>

        <div id="sellerMessage" role="status" aria-live="polite"></div>

        <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Seller</th>
                        <th>Business</th>
                        <th>Type</th>
                        <th>Contact</th>
                        <th>Applied On</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>

                <tbody id="sellerApplicationsBody">
                    <tr>
                        <td colspan="8">Loading seller applications...</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</section>


       

    </main>
</div>

<div class="mobile-overlay" id="mobileOverlay"></div>


<!-- =====================================
     DOCTOR CERTIFICATE POPUP
===================================== -->

<div class="certificate-modal" id="certificateModal">

    <div class="certificate-modal-box">

        <!-- HEADER -->
        <div class="certificate-modal-header">

            <div class="certificate-header-icon">
                <i class="fa-solid fa-file-circle-check"></i>
            </div>

            <button type="button"
                    class="certificate-close"
                    onclick="closeCertificateModal()">
                <i class="fa-solid fa-xmark"></i>
            </button>

        </div>

        <!-- TITLE -->
        <div class="certificate-modal-title">

            <h2>Doctor Certificates</h2>

            <p>
                Select the document you want to review.
            </p>

        </div>

        <!-- REGISTRATION CERTIFICATE -->
        <div class="certificate-option">

            <div class="certificate-option-icon">
                <i class="fa-solid fa-file-lines"></i>
            </div>

            <div class="certificate-option-info">
                <h3>Registration Certificate</h3>
                <p>Professional registration document</p>
            </div>

            <span class="certificate-number">01</span>

        </div>

        <button type="button"
                class="certificate-open-btn"
                onclick="openDoctorCertificate('registration')">

            <i class="fa-solid fa-eye"></i>
            View Registration Certificate

        </button>


        <!-- DEGREE CERTIFICATE -->
        <div class="certificate-option">

            <div class="certificate-option-icon degree-icon">
                <i class="fa-solid fa-graduation-cap"></i>
            </div>

            <div class="certificate-option-info">
                <h3>Degree Certificate</h3>
                <p>Educational qualification document</p>
            </div>

            <span class="certificate-number">02</span>

        </div>

        <button type="button"
                class="certificate-open-btn"
                onclick="openDoctorCertificate('degree')">

            <i class="fa-solid fa-eye"></i>
            View Degree Certificate

        </button>


        <!-- CANCEL -->
        <button type="button"
                class="certificate-cancel-btn"
                onclick="closeCertificateModal()">

            Cancel

        </button>

        <div class="certificate-footer">
            <i class="fa-solid fa-shield-halved"></i>
            PawCare Secure Document Viewer
        </div>

    </div>

</div>





<script src="Js/admin.js"></script>
</body>
</html>
