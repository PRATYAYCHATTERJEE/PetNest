
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
                <i class="fa-solid fa-house"></i><span>Dashboard</span>
            </button>
            <button class="nav-item" data-section="users">
                <i class="fa-solid fa-users"></i><span>Users</span>
            </button>
            <button class="nav-item" data-section="contacts">
                <i class="fa-solid fa-envelope"></i><span>Contacts</span>
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
            <button class="nav-item" data-section="settings">
                <i class="fa-solid fa-gear"></i><span>Settings</span>
            </button>
            <button class="nav-item" data-section="notifications">
                <i class="fa-solid fa-bell"></i><span>Notifications</span>
                <span class="notification-dot">3</span>
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
        <section class="content-section active" id="dashboard">

            <div class="welcome-banner">
                <div class="welcome-copy">
                    <span class="eyebrow">ADMINISTRATION</span>
                    <h1>Welcome back,<br>Administrator! <span>👋</span></h1>
                    <p>Here's an overview of your PawCare platform.</p>
                </div>

                <div class="welcome-art">
                    <div class="art-paw paw-one"><i class="fa-solid fa-paw"></i></div>
                    <div class="art-pets">🐕 🐈</div>
                    <div class="art-quote">
                        <i class="fa-solid fa-heart"></i>
                        <p>Together for<br>Healthier, Happier Pets.</p>
                        <span class="quote-line"></span>
                    </div>
                    <div class="art-paw paw-two"><i class="fa-solid fa-paw"></i></div>
                </div>
            </div>

            <!-- STATISTICS -->
            <div class="stats-grid">

                <article class="stat-card">
                    <div class="stat-top">
                        <span class="stat-icon blue"><i class="fa-solid fa-users"></i></span>
                        <i class="fa-solid fa-arrow-trend-up trend blue-text"></i>
                    </div>
                    <h2>1,248</h2>
                    <div class="stat-label">Total Users</div>
                    <div class="stat-bottom">
                        <span>Registered accounts</span>
                        <b class="positive">↑ 12%</b>
                    </div>
                </article>

                <article class="stat-card">
                    <div class="stat-top">
                        <span class="stat-icon green"><i class="fa-solid fa-stethoscope"></i></span>
                        <i class="fa-solid fa-arrow-trend-up trend"></i>
                    </div>
                    <h2>24</h2>
                    <div class="stat-label">Doctor Applications</div>
                    <div class="stat-bottom">
                        <span class="pending-text"><i class="fa-regular fa-clock"></i> 8 Pending</span>
                        <span class="mini-status orange-status">Review</span>
                    </div>
                </article>

                <article class="stat-card">
                    <div class="stat-top">
                        <span class="stat-icon amber"><i class="fa-solid fa-store"></i></span>
                        <i class="fa-solid fa-arrow-trend-up trend amber-text"></i>
                    </div>
                    <h2>36</h2>
                    <div class="stat-label">Pet Seller Applications</div>
                    <div class="stat-bottom">
                        <span class="pending-text"><i class="fa-regular fa-clock"></i> 5 Pending</span>
                        <span class="mini-status orange-status">Review</span>
                    </div>
                </article>

                <article class="stat-card">
                    <div class="stat-top">
                        <span class="stat-icon purple"><i class="fa-solid fa-paw"></i></span>
                        <i class="fa-solid fa-arrow-trend-up trend"></i>
                    </div>
                    <h2>482</h2>
                    <div class="stat-label">Pets Sold</div>
                    <div class="stat-bottom">
                        <span>Completed purchases</span>
                        <b class="positive">↑ 18%</b>
                    </div>
                </article>

                <article class="stat-card">
                    <div class="stat-top">
                        <span class="stat-icon pink"><i class="fa-solid fa-envelope"></i></span>
                        <i class="fa-solid fa-arrow-trend-up trend"></i>
                    </div>
                    <h2>29</h2>
                    <div class="stat-label">Contact Messages</div>
                    <div class="stat-bottom">
                        <span>New this week</span>
                        <b class="positive">↑ 6%</b>
                    </div>
                </article>

            </div>

            <!-- ACTIVITY AND APPROVALS -->
            <div class="dashboard-panels">

                <article class="panel activity-panel">
                    <div class="panel-header">
                        <h2><i class="fa-regular fa-clock green-text"></i> Recent Activity</h2>
                        <button class="text-link" data-section="notifications">View All</button>
                    </div>

                    <div class="activity-list searchable-list">
                        <div class="activity-row">
                            <span class="activity-icon blue"><i class="fa-solid fa-user"></i></span>
                            <div class="activity-info">
                                <strong>New user registered</strong>
                                <small>priya@email.com</small>
                            </div>
                            <time>10 minutes ago</time>
                            <span class="activity-dot green-dot"></span>
                        </div>

                        <div class="activity-row">
                            <span class="activity-icon green"><i class="fa-solid fa-stethoscope"></i></span>
                            <div class="activity-info">
                                <strong>Doctor application submitted</strong>
                                <small>Dr. Rahul Mehta</small>
                            </div>
                            <time>35 minutes ago</time>
                            <span class="activity-dot orange-dot"></span>
                        </div>

                        <div class="activity-row">
                            <span class="activity-icon amber"><i class="fa-solid fa-store"></i></span>
                            <div class="activity-info">
                                <strong>Pet seller application submitted</strong>
                                <small>Happy Paws Store</small>
                            </div>
                            <time>1 hour ago</time>
                            <span class="activity-dot orange-dot"></span>
                        </div>

                        <div class="activity-row">
                            <span class="activity-icon pink"><i class="fa-solid fa-envelope"></i></span>
                            <div class="activity-info">
                                <strong>New contact message</strong>
                                <small>From: ankit@example.com</small>
                            </div>
                            <time>2 hours ago</time>
                            <span class="activity-dot green-dot"></span>
                        </div>

                        <div class="activity-row">
                            <span class="activity-icon purple"><i class="fa-solid fa-paw"></i></span>
                            <div class="activity-info">
                                <strong>Pet purchased</strong>
                                <small>Golden Retriever</small>
                            </div>
                            <time>3 hours ago</time>
                            <span class="activity-dot green-dot"></span>
                        </div>
                    </div>
                </article>

                <article class="panel approvals-panel">
                    <div class="panel-header">
                        <h2><i class="fa-solid fa-hourglass-half amber-text"></i> Pending Approvals</h2>
                        <button class="text-link" data-section="doctors">View All</button>
                    </div>

                    <div class="approval-tabs">
                        <button class="approval-tab active" data-approval="doctor-list">
                            Doctor Approvals <span>8</span>
                        </button>
                        <button class="approval-tab" data-approval="seller-list">
                            Seller Approvals <span class="seller-count">5</span>
                        </button>
                    </div>

                    <div class="approval-list" id="doctor-list">
                        <div class="approval-row searchable-item">
                            <span class="doctor-avatar avatar-one">NS</span>
                            <div class="approval-info">
                                <strong>Dr. Neha Sharma</strong>
                                <small>neha.sharma@example.com</small>
                                <small>General Veterinary Care</small>
                            </div>
                            <div class="approval-meta">
                                <span class="status-pill">Pending</span>
                                <small>Submitted 1 day ago</small>
                            </div>
                            <button class="row-arrow" data-section="doctors" aria-label="View doctor approvals">
                                <i class="fa-solid fa-chevron-right"></i>
                            </button>
                        </div>

                        <div class="approval-row searchable-item">
                            <span class="doctor-avatar avatar-two">AP</span>
                            <div class="approval-info">
                                <strong>Dr. Arjun Patel</strong>
                                <small>arjun.patel@example.com</small>
                                <small>Veterinary Surgery</small>
                            </div>
                            <div class="approval-meta">
                                <span class="status-pill">Pending</span>
                                <small>Submitted 2 days ago</small>
                            </div>
                            <button class="row-arrow" data-section="doctors" aria-label="View doctor approvals">
                                <i class="fa-solid fa-chevron-right"></i>
                            </button>
                        </div>

                        <div class="approval-row searchable-item">
                            <span class="doctor-avatar avatar-three">PD</span>
                            <div class="approval-info">
                                <strong>Dr. Priya Desai</strong>
                                <small>priya.desai@example.com</small>
                                <small>Dermatology</small>
                            </div>
                            <div class="approval-meta">
                                <span class="status-pill">Pending</span>
                                <small>Submitted 3 days ago</small>
                            </div>
                            <button class="row-arrow" data-section="doctors" aria-label="View doctor approvals">
                                <i class="fa-solid fa-chevron-right"></i>
                            </button>
                        </div>
                    </div>

                    <div class="approval-list hidden" id="seller-list">
                        <div class="approval-row searchable-item">
                            <span class="doctor-avatar avatar-one"><i class="fa-solid fa-store"></i></span>
                            <div class="approval-info">
                                <strong>Happy Paws Store</strong>
                                <small>happy@example.com</small>
                                <small>Pet supplies seller</small>
                            </div>
                            <div class="approval-meta">
                                <span class="status-pill">Pending</span>
                                <small>Submitted 1 day ago</small>
                            </div>
                            <button class="row-arrow" data-section="sellers" aria-label="View seller approvals">
                                <i class="fa-solid fa-chevron-right"></i>
                            </button>
                        </div>

                        <div class="approval-row searchable-item">
                            <span class="doctor-avatar avatar-two"><i class="fa-solid fa-store"></i></span>
                            <div class="approval-info">
                                <strong>Pet World</strong>
                                <small>petworld@example.com</small>
                                <small>Pet supplies seller</small>
                            </div>
                            <div class="approval-meta">
                                <span class="status-pill">Pending</span>
                                <small>Submitted 2 days ago</small>
                            </div>
                            <button class="row-arrow" data-section="sellers" aria-label="View seller approvals">
                                <i class="fa-solid fa-chevron-right"></i>
                            </button>
                        </div>
                    </div>
                </article>

            </div>

            <!-- QUICK ACTIONS -->
            <section class="quick-actions">
                <div class="quick-title">
                    <i class="fa-solid fa-bolt"></i>
                    <h2>Quick Actions</h2>
                </div>

                <button class="quick-action" data-section="users">
                    <i class="fa-solid fa-users"></i><span>View All Users</span>
                    <i class="fa-solid fa-arrow-right action-arrow"></i>
                </button>

                <button class="quick-action" data-section="doctors">
                    <i class="fa-solid fa-stethoscope"></i><span>Manage Doctors</span>
                    <i class="fa-solid fa-arrow-right action-arrow"></i>
                </button>

                <button class="quick-action" data-section="sellers">
                    <i class="fa-solid fa-store"></i><span>Manage Pet Sellers</span>
                    <i class="fa-solid fa-arrow-right action-arrow"></i>
                </button>

                <button class="quick-action" data-section="contacts">
                    <i class="fa-solid fa-envelope"></i><span>View Contacts</span>
                    <i class="fa-solid fa-arrow-right action-arrow"></i>
                </button>

                <button class="quick-action" data-section="settings">
                    <i class="fa-solid fa-gear"></i><span>System Settings</span>
                    <i class="fa-solid fa-arrow-right action-arrow"></i>
                </button>
            </section>

        </section>

        <!-- PLACEHOLDER SECTIONS -->
        <section class="content-section placeholder-section" id="users">
            <span class="eyebrow">ADMINISTRATION</span>
            <h1>Users</h1>
            <p>Manage PawCare user accounts here.</p>
            <div class="placeholder-card"><i class="fa-solid fa-users"></i><h2>User Management</h2><p>Database integration will be added next.</p></div>
        </section>

        <section class="content-section placeholder-section" id="contacts">
            <span class="eyebrow">COMMUNICATION</span>
            <h1>Contact Messages</h1>
            <p>Review messages sent by PawCare users.</p>
            <div class="placeholder-card"><i class="fa-solid fa-envelope"></i><h2>Contact Management</h2><p>Message retrieval and replies will be added later.</p></div>
        </section>

        

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


        <section class="content-section placeholder-section" id="settings">
            <span class="eyebrow">CONFIGURATION</span>
            <h1>Settings</h1>
            <p>Manage your administrator preferences.</p>
            <div class="placeholder-card"><i class="fa-solid fa-gear"></i><h2>System Settings</h2><p>Configuration options will be added later.</p></div>
        </section>

        <section class="content-section placeholder-section" id="notifications">
            <span class="eyebrow">UPDATES</span>
            <h1>Notifications</h1>
            <p>Keep track of recent activity across PawCare.</p>
            <div class="placeholder-card"><i class="fa-solid fa-bell"></i><h2>All Notifications</h2><p>Live notifications will be connected later.</p></div>
        </section>

    </main>
</div>

<div class="mobile-overlay" id="mobileOverlay"></div>

<script src="Js/admin.js"></script>
</body>
</html>
