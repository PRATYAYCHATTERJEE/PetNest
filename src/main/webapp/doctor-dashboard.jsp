<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.petcare.util.DBConnection" %>

<%
    Object doctorIdObject = session.getAttribute("doctorId");
    if (!Boolean.TRUE.equals(session.getAttribute("isDoctor"))
            || !(doctorIdObject instanceof Integer)) {
        response.sendRedirect(request.getContextPath() + "/Doclogin.jsp");
        return;
    }

    int doctorId = (Integer) doctorIdObject;

    String doctorName = "Doctor";
    String doctorEmail = "";
    String doctorPhone = "";
    String qualification = "";
    String specialization = "";
    String registrationNumber = "";
    String experience = "0";
    String clinicName = "";
    String clinicAddress = "";
    String city = "";
    String state = "";
    String pinCode = "";
    String submittedAt = "Not available";

    int totalAppointments = 0;
    int pendingAppointments = 0;
    int completedAppointments = 0;
    int confirmedAppointments = 0;

    List<Map<String, Object>> appointmentList = new ArrayList<>();

    java.util.function.Function<String, String> esc = value -> {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    };

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(
             "SELECT full_name, email, phone, qualification, specialization, " +
             "registration_number, experience_years, clinic_name, clinic_address, " +
             "city, state, pin_code, status, submitted_at " +
             "FROM doctor_applications WHERE id = ?")) {
        ps.setInt(1, doctorId);
        try (ResultSet rs = ps.executeQuery()) {
            if (!rs.next() || !"APPROVED".equals(rs.getString("status"))) {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/Doclogin.jsp?error=pending");
                return;
            }
            doctorName = rs.getString("full_name");
            doctorEmail = rs.getString("email");
            doctorPhone = rs.getString("phone");
            qualification = rs.getString("qualification");
            specialization = rs.getString("specialization");
            registrationNumber = rs.getString("registration_number");
            experience = String.valueOf(rs.getInt("experience_years"));
            clinicName = rs.getString("clinic_name");
            clinicAddress = rs.getString("clinic_address");
            city = rs.getString("city");
            state = rs.getString("state");
            pinCode = rs.getString("pin_code");
            Timestamp submitted = rs.getTimestamp("submitted_at");
            if (submitted != null) submittedAt = submitted.toString();
            session.setAttribute("doctorName", doctorName);
            session.setAttribute("doctorEmail", doctorEmail);
        }
    } catch (Exception e) {
        throw new javax.servlet.ServletException("Unable to load doctor profile.", e);
    }

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(
             "SELECT id, user_id, pet_name, pet_type, appointment_date, " +
             "appointment_time, reason, status, doctor_message, responded_at, created_at " +
             "FROM appointments WHERE doctor_id = ? " +
             "ORDER BY appointment_date DESC, appointment_time DESC")) {
        ps.setInt(1, doctorId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> a = new LinkedHashMap<>();
                a.put("id", rs.getInt("id"));
                a.put("userId", rs.getInt("user_id"));
                a.put("petName", rs.getString("pet_name"));
                a.put("petType", rs.getString("pet_type"));
                a.put("date", rs.getDate("appointment_date"));
                a.put("time", rs.getTime("appointment_time"));
                a.put("reason", rs.getString("reason"));
                a.put("status", rs.getString("status"));
                a.put("doctorMessage", rs.getString("doctor_message"));
                a.put("respondedAt", rs.getTimestamp("responded_at"));
                a.put("createdAt", rs.getTimestamp("created_at"));
                appointmentList.add(a);
                totalAppointments++;
                String status = rs.getString("status");
                if ("PENDING".equals(status)) pendingAppointments++;
                if ("CONFIRMED".equals(status)) confirmedAppointments++;
                if ("COMPLETED".equals(status)) completedAppointments++;
            }
        }
    } catch (Exception e) {
        throw new javax.servlet.ServletException("Unable to load appointments.", e);
    }

    String initials = "D";
    if (doctorName != null && !doctorName.trim().isEmpty()) {
        String[] parts = doctorName.trim().split("\\s+");
        initials = parts[0].substring(0, 1).toUpperCase();
        if (parts.length > 1) initials += parts[parts.length - 1].substring(0, 1).toUpperCase();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Doctor Dashboard | Petora</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
<style>
:root{--primary:#2563eb;--primary-light:#eff6ff;--dark:#172033;--muted:#7c879b;--border:#e8edf4;--background:#f6f8fc;--white:#fff;--green:#15966b;--red:#dc4545}
*{margin:0;padding:0;box-sizing:border-box}
html{scroll-behavior:smooth;scroll-padding-top:95px}
body{font-family:'Inter',sans-serif;background:var(--background);color:var(--dark)}
button,a{font:inherit}a{text-decoration:none;color:inherit}
.layout{display:flex;min-height:100vh}
.sidebar{width:255px;flex-shrink:0;background:#fff;border-right:1px solid var(--border);padding:26px 17px;display:flex;flex-direction:column}
.brand{display:flex;align-items:center;gap:11px;padding:0 12px 32px;font-size:23px;font-weight:800;letter-spacing:-1px}
.brand-icon{display:grid;place-items:center;width:39px;height:39px;border-radius:13px;color:#fff;background:linear-gradient(135deg,#3678f5,#2154d8)}
.brand span{color:var(--primary)}
.menu-label{padding:0 12px;margin-bottom:12px;color:#9aa4b5;font-size:10px;font-weight:800;letter-spacing:1.4px}
.nav-menu{display:grid;gap:7px}
.nav-link{display:flex;align-items:center;gap:13px;padding:13px 14px;border-radius:11px;color:#667085;font-size:13px;font-weight:600;transition:.2s}
.nav-link i{width:19px;text-align:center;font-size:15px}
.nav-link:hover,.nav-link.active{background:var(--primary-light);color:var(--primary)}
.sidebar-bottom{margin-top:auto;padding-top:25px}
.help-card{padding:17px;background:#f5f8ff;border:1px solid #e8efff;border-radius:14px;margin-bottom:17px}
.help-card i{color:var(--primary);font-size:20px;margin-bottom:10px}
.help-card h4{font-size:12px;margin-bottom:7px}.help-card p{color:var(--muted);font-size:11px;line-height:1.6}
.logout-link{display:flex;align-items:center;gap:12px;padding:12px 14px;color:var(--red);font-size:13px;font-weight:600;border-radius:10px}
.logout-link:hover{background:#fff1f1}
.main{flex:1;min-width:0}
.topbar{position:sticky;top:0;z-index:20;min-height:82px;padding:18px 34px;background:#fff;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;gap:20px}
.topbar h1{font-size:21px;font-weight:800;letter-spacing:-.6px}.topbar p{color:var(--muted);font-size:12px;margin-top:5px}
.topbar-right{display:flex;align-items:center;gap:13px}
.verified-pill{display:inline-flex;align-items:center;gap:7px;padding:8px 11px;border-radius:30px;background:#eafaf3;color:#14865f;font-size:11px;font-weight:700}
.avatar{width:43px;height:43px;display:grid;place-items:center;border-radius:50%;background:#e8efff;color:var(--primary);font-size:13px;font-weight:800}
.content{max-width:1500px;padding:30px 34px 45px;margin:auto}
.welcome{display:flex;align-items:center;justify-content:space-between;gap:20px;margin-bottom:26px}
.welcome h2{font-size:24px;letter-spacing:-.7px}.welcome p{margin-top:8px;color:var(--muted);font-size:13px}
.date-pill{padding:11px 14px;border:1px solid var(--border);border-radius:10px;background:#fff;color:#667085;font-size:12px}
.stats-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:17px;margin-bottom:25px}
.stat-card{padding:22px;background:#fff;border:1px solid var(--border);border-radius:15px;box-shadow:0 4px 16px rgba(27,49,94,.025)}
.stat-top{display:flex;align-items:center;justify-content:space-between;gap:12px}.stat-top p{color:var(--muted);font-size:12px;font-weight:600}
.stat-icon{display:grid;place-items:center;width:42px;height:42px;border-radius:12px;background:var(--primary-light);color:var(--primary)}
.stat-number{margin-top:19px;font-size:28px;font-weight:800;letter-spacing:-1px}.stat-foot{margin-top:8px;color:var(--muted);font-size:11px}
.section-grid{display:grid;grid-template-columns:minmax(0,1.5fr) minmax(280px,1fr);gap:20px;align-items:start}
.panel{background:#fff;border:1px solid var(--border);border-radius:15px;overflow:hidden;scroll-margin-top:100px}
.panel-heading{padding:21px 23px;display:flex;align-items:center;justify-content:space-between;gap:12px;border-bottom:1px solid var(--border)}
.panel-heading h3{font-size:14px;font-weight:800}.panel-heading p{margin-top:5px;font-size:11px;color:var(--muted)}
.panel-body{padding:22px}
.profile-summary{display:flex;align-items:center;gap:15px;padding-bottom:20px;border-bottom:1px solid var(--border)}
.profile-avatar{width:58px;height:58px;flex-shrink:0;display:grid;place-items:center;border-radius:16px;background:linear-gradient(135deg,#e6eeff,#d5e2ff);color:var(--primary);font-size:18px;font-weight:800}
.profile-summary h4{font-size:15px;margin-bottom:6px}.profile-summary p{font-size:12px;color:var(--muted)}
.detail-list{display:grid;gap:17px;padding-top:21px}
.detail-row{display:grid;grid-template-columns:135px minmax(0,1fr);gap:12px;font-size:12px}
.detail-label{color:var(--muted)}.detail-value{font-weight:600;overflow-wrap:anywhere}
.status-tag{display:inline-block;padding:5px 9px;border-radius:20px;background:#eafaf3;color:#14865f;font-size:10px;font-weight:800}
.quick-actions{display:grid;gap:12px}.quick-action{display:flex;align-items:center;gap:13px;padding:15px;border:1px solid var(--border);border-radius:12px;transition:.2s}
.quick-action:hover{border-color:#b9ceff;background:#f9fbff;transform:translateY(-1px)}
.action-icon{width:40px;height:40px;flex-shrink:0;display:grid;place-items:center;border-radius:11px;color:var(--primary);background:var(--primary-light)}
.quick-action h4{font-size:12px;margin-bottom:5px}.quick-action p{color:var(--muted);font-size:10px;line-height:1.5}
.action-arrow{margin-left:auto;color:#a0a9b8;font-size:12px}
.notice{margin-top:20px;padding:15px 17px;border:1px solid #dbe8ff;border-radius:12px;background:#f4f8ff;color:#42609a;font-size:11px;line-height:1.7}
.notice i{margin-right:6px}
.appointment-list{display:grid;gap:14px}
.appointment-response-form{margin-top:18px;padding-top:16px;border-top:1px solid var(--border)}
.appointment-response-form label{display:block;font-size:12px;font-weight:700;margin-bottom:8px}
.appointment-response-form textarea{display:block;width:100%;min-height:88px;resize:vertical;padding:12px;border:1px solid #dbe3ee;border-radius:10px;font:inherit;font-size:12px;color:var(--dark);outline:none}
.appointment-response-form textarea:focus{border-color:var(--primary);box-shadow:0 0 0 3px rgba(37,99,235,.1)}
.response-actions{display:flex;gap:10px;flex-wrap:wrap;margin-top:12px}
.response-btn{display:inline-flex;align-items:center;justify-content:center;gap:8px;padding:11px 17px;border:0;border-radius:9px;color:#fff;font-size:12px;font-weight:700;cursor:pointer;transition:.2s}
.response-btn:hover{transform:translateY(-1px);filter:brightness(.96)}
.approve-btn{background:#16804a}.reject-btn{background:#c93434}
@media(max-width:480px){.response-actions{display:grid;grid-template-columns:1fr 1fr}.response-btn{padding:11px 8px}}

.appointment-card{border:1px solid var(--border);border-radius:13px;padding:18px;background:#fff}
.appointment-head{display:flex;justify-content:space-between;align-items:flex-start;gap:12px;flex-wrap:wrap}
.appointment-head h4{font-size:15px;margin-bottom:7px}
.appointment-meta{font-size:11px;color:var(--muted)}
.appointment-card .detail-list{padding-top:15px;gap:12px}
.empty-state{text-align:center;padding:35px 15px;color:var(--muted)}
.empty-state i{font-size:35px;color:var(--primary);margin-bottom:15px}
.empty-state h3{font-size:15px;color:var(--dark);margin-bottom:8px}
.empty-state p{font-size:12px}
.footer{padding:22px 34px;color:#8993a5;font-size:11px;text-align:center}
.dashboard-section{display:none;margin-bottom:20px}.dashboard-section.active{display:block}#appointments,#patients,#settings{margin-top:0!important}
.mobile-menu{display:none;border:0;background:transparent;font-size:20px;color:var(--dark);cursor:pointer}
@media(max-width:1050px){.sidebar{width:220px}.section-grid{grid-template-columns:1fr}.content{padding:25px 22px 35px}.topbar{padding:18px 22px}}
@media(max-width:700px){.sidebar{position:fixed;z-index:100;top:0;bottom:0;left:0;width:255px;transform:translateX(-105%);transition:transform .25s ease;box-shadow:10px 0 35px rgba(0,0,0,.08)}.sidebar.open{transform:translateX(0)}.mobile-menu{display:block}.topbar{min-height:72px;padding:15px 17px}.topbar h1{font-size:17px}.topbar p{font-size:10px}.topbar-right{gap:8px}.verified-pill{font-size:0;padding:10px}.verified-pill i{font-size:13px}.avatar{width:37px;height:37px}.content{padding:23px 15px 30px}.welcome{align-items:flex-start;flex-direction:column}.welcome h2{font-size:21px}.stats-grid{grid-template-columns:1fr;gap:12px}.stat-card{padding:18px}.stat-number{font-size:25px}.panel-heading,.panel-body{padding:17px}.detail-row{grid-template-columns:110px minmax(0,1fr);font-size:11px}.footer{padding:20px 15px}}
</style>
</head>
<body>
<div class="layout">
<aside class="sidebar" id="sidebar">
    <a href="#overview" class="brand"><div class="brand-icon"><i class="fa-solid fa-paw"></i></div>Pet<span>ora</span></a>
    <div class="menu-label">DOCTOR WORKSPACE</div>
    <nav class="nav-menu">
        <a href="#overview" class="nav-link active"><i class="fa-solid fa-house"></i>Dashboard</a>
        <a href="#profile" class="nav-link"><i class="fa-solid fa-user-doctor"></i>My Profile</a>
        <a href="#appointments" class="nav-link"><i class="fa-solid fa-calendar-check"></i>Appointments <span style="margin-left:auto;background:#fee2e2;color:#b91c1c;padding:3px 7px;border-radius:20px;font-size:10px;"><%= pendingAppointments %></span></a>
        <a href="#patients" class="nav-link"><i class="fa-solid fa-paw"></i>Patients</a>
        <a href="#settings" class="nav-link"><i class="fa-solid fa-gear"></i>Settings</a>
    </nav>
    <div class="sidebar-bottom">
        <div class="help-card"><i class="fa-solid fa-headset"></i><h4>Need assistance?</h4><p>Contact the Petora support team if you need help with your doctor account.</p></div>
        <a class="logout-link" href="<%= request.getContextPath() %>/DoctorLogoutServlet" onclick="return confirm('Are you sure you want to log out?');"><i class="fa-solid fa-right-from-bracket"></i>Logout</a>
    </div>
</aside>

<main class="main">
<header class="topbar">
    <div style="display:flex;align-items:center;gap:14px;">
        <button class="mobile-menu" id="mobileMenu" type="button" aria-label="Open menu"><i class="fa-solid fa-bars"></i></button>
        <div><h1>Doctor Dashboard</h1><p>Welcome to your Petora workspace</p></div>
    </div>
    <div class="topbar-right"><span class="verified-pill"><i class="fa-solid fa-circle-check"></i>Verified Doctor</span><div class="avatar"><%= esc.apply(initials) %></div></div>
</header>

<div class="content">
<section class="dashboard-section active" id="overview">
<section class="welcome">
    <div><h2>Hello, Dr. <%= esc.apply(doctorName) %> 👋</h2><p>Here is an overview of your doctor account.</p></div>
    <div class="date-pill"><i class="fa-regular fa-calendar"></i> Account overview</div>
</section>

<section class="stats-grid">
    <div class="stat-card"><div class="stat-top"><p>Total Appointments</p><div class="stat-icon"><i class="fa-solid fa-calendar-days"></i></div></div><div class="stat-number"><%= totalAppointments %></div><div class="stat-foot"><%= pendingAppointments %> requests awaiting your response</div></div>
    <div class="stat-card"><div class="stat-top"><p>Pending Requests</p><div class="stat-icon"><i class="fa-solid fa-clock"></i></div></div><div class="stat-number"><%= pendingAppointments %></div><div class="stat-foot">Appointments requiring action</div></div>
    <div class="stat-card"><div class="stat-top"><p>Account Status</p><div class="stat-icon"><i class="fa-solid fa-shield-heart"></i></div></div><div class="stat-number" style="font-size:22px;color:#15966b;">Approved</div><div class="stat-foot">Your doctor account is active</div></div>
</section>

<section class="section-grid">
    <div class="panel" id="profile">
        <div class="panel-heading"><div><h3>Doctor Profile</h3><p>Your registered professional information</p></div><span class="status-tag"><i class="fa-solid fa-check"></i> APPROVED</span></div>
        <div class="panel-body">
            <div class="profile-summary"><div class="profile-avatar"><%= esc.apply(initials) %></div><div><h4>Dr. <%= esc.apply(doctorName) %></h4><p><%= esc.apply(specialization) %></p></div></div>
            <div class="detail-list">
                <div class="detail-row"><div class="detail-label">Email address</div><div class="detail-value"><%= esc.apply(doctorEmail) %></div></div>
                <div class="detail-row"><div class="detail-label">Phone number</div><div class="detail-value"><%= esc.apply(doctorPhone) %></div></div>
                <div class="detail-row"><div class="detail-label">Qualification</div><div class="detail-value"><%= esc.apply(qualification) %></div></div>
                <div class="detail-row"><div class="detail-label">Specialization</div><div class="detail-value"><%= esc.apply(specialization) %></div></div>
                <div class="detail-row"><div class="detail-label">Registration No.</div><div class="detail-value"><%= esc.apply(registrationNumber) %></div></div>
                <div class="detail-row"><div class="detail-label">Experience</div><div class="detail-value"><%= esc.apply(experience) %> years</div></div>
                <div class="detail-row"><div class="detail-label">Clinic / Hospital</div><div class="detail-value"><%= esc.apply(clinicName) %></div></div>
                <div class="detail-row"><div class="detail-label">Clinic address</div><div class="detail-value"><%= esc.apply(clinicAddress) %></div></div>
                <div class="detail-row"><div class="detail-label">Location</div><div class="detail-value"><%= esc.apply(city) %>, <%= esc.apply(state) %> <%= esc.apply(pinCode) %></div></div>
                <div class="detail-row"><div class="detail-label">Applied on</div><div class="detail-value"><%= esc.apply(submittedAt) %></div></div>
            </div>
        </div>
    </div>
    <div class="panel">
        <div class="panel-heading"><div><h3>Quick Actions</h3><p>Access your workspace</p></div></div>
        <div class="panel-body">
            <div class="quick-actions">
                <a href="#appointments" class="quick-action"><div class="action-icon"><i class="fa-solid fa-calendar-plus"></i></div><div><h4>Appointments</h4><p>Review patient appointment requests</p></div><i class="fa-solid fa-chevron-right action-arrow"></i></a>
                <a href="#patients" class="quick-action"><div class="action-icon"><i class="fa-solid fa-paw"></i></div><div><h4>Patient Records</h4><p>View patients from your appointments</p></div><i class="fa-solid fa-chevron-right action-arrow"></i></a>
                <a href="#settings" class="quick-action"><div class="action-icon"><i class="fa-solid fa-user-gear"></i></div><div><h4>Account Settings</h4><p>Review your account information</p></div><i class="fa-solid fa-chevron-right action-arrow"></i></a>
            </div>
            <div class="notice"><i class="fa-solid fa-circle-info"></i>Your professional account has been approved by the Petora administrator.</div>
        </div>
    </div>
</section>
</section>

<section class="dashboard-section" id="appointments">
    <div class="panel-heading"><div><h3>Appointment Requests</h3><p>Review appointments booked by pet owners.</p></div><span class="status-tag"><%= pendingAppointments %> PENDING</span></div>
    <div class="panel-body">
        <div class="stats-grid" style="grid-template-columns:repeat(3,minmax(0,1fr));margin-bottom:20px;">
            <div class="stat-card"><div class="stat-foot">Total appointments</div><div class="stat-number"><%= totalAppointments %></div></div>
            <div class="stat-card"><div class="stat-foot">Pending requests</div><div class="stat-number"><%= pendingAppointments %></div></div>
            <div class="stat-card"><div class="stat-foot">Confirmed</div><div class="stat-number"><%= confirmedAppointments %></div></div>
        </div>
        <% if (appointmentList.isEmpty()) { %>
            <div class="empty-state"><i class="fa-regular fa-calendar-check"></i><h3>No appointment requests yet</h3><p>New bookings will appear here automatically.</p></div>
        <% } else { %>
            <div class="appointment-list">
            <% for (Map<String, Object> a : appointmentList) {
                String appointmentStatus = String.valueOf(a.get("status"));
                String badgeBackground = "PENDING".equals(appointmentStatus) ? "#fff7e6" : ("CONFIRMED".equals(appointmentStatus) ? "#eafaf3" : "#eff6ff");
                String badgeColor = "PENDING".equals(appointmentStatus) ? "#a16207" : ("CONFIRMED".equals(appointmentStatus) ? "#14865f" : "#2563eb");
            %>
                <article class="appointment-card">
                    <div class="appointment-head">
                        <div><h4><i class="fa-solid fa-paw" style="color:#2563eb;"></i> <%= esc.apply(String.valueOf(a.get("petName"))) %></h4><p class="appointment-meta">Request #<%= a.get("id") %> · User ID: <%= a.get("userId") %></p></div>
                        <span class="status-tag" style="background:<%= badgeBackground %>;color:<%= badgeColor %>;"><%= esc.apply(appointmentStatus) %></span>
                    </div>
                    <div class="detail-list">
                        <div class="detail-row"><div class="detail-label">Pet type</div><div class="detail-value"><%= a.get("petType") == null ? "Not specified" : esc.apply(String.valueOf(a.get("petType"))) %></div></div>
                        <div class="detail-row"><div class="detail-label">Appointment date</div><div class="detail-value"><%= a.get("date") %></div></div>
                        <div class="detail-row"><div class="detail-label">Appointment time</div><div class="detail-value"><%= a.get("time") %></div></div>
                        <div class="detail-row"><div class="detail-label">Reason</div><div class="detail-value"><%= a.get("reason") == null || String.valueOf(a.get("reason")).trim().isEmpty() ? "Not specified" : esc.apply(String.valueOf(a.get("reason"))) %></div></div>
                        <div class="detail-row"><div class="detail-label">Requested on</div><div class="detail-value"><%= a.get("createdAt") == null ? "Not available" : esc.apply(String.valueOf(a.get("createdAt"))) %></div></div>
                        <% if (a.get("doctorMessage") != null && !String.valueOf(a.get("doctorMessage")).trim().isEmpty()) { %>
                            <div class="detail-row"><div class="detail-label">Your response</div><div class="detail-value"><%= esc.apply(String.valueOf(a.get("doctorMessage"))) %></div></div>
                        <% } %>
                    </div>

                    <% if ("PENDING".equals(appointmentStatus)) { %>
                        <form class="appointment-response-form"
                              method="post"
                              action="<%= request.getContextPath() %>/DoctorAppointmentsServlet">
                            <input type="hidden" name="appointmentId" value="<%= a.get("id") %>">

                            <label for="doctorMessage<%= a.get("id") %>">
                                Message to pet owner <span style="color:#dc4545;">*</span>
                            </label>
                            <textarea id="doctorMessage<%= a.get("id") %>"
                                      name="doctorMessage"
                                      maxlength="500"
                                      required
                                      placeholder="Write the reason or details for your decision (max 500 characters)..."></textarea>

                            <div class="response-actions">
                                <button class="response-btn approve-btn"
                                        type="submit"
                                        name="action"
                                        value="APPROVE"
                                        onclick="return confirm('Approve this appointment and send your message to the pet owner?');">
                                    <i class="fa-solid fa-check"></i> Approve
                                </button>

                                <button class="response-btn reject-btn"
                                        type="submit"
                                        name="action"
                                        value="REJECT"
                                        onclick="return confirm('Reject this appointment and send your message to the pet owner?');">
                                    <i class="fa-solid fa-xmark"></i> Reject
                                </button>
                            </div>
                        </form>
                    <% } %>
                </article>
            <% } %>
            </div>
        <% } %>
    </div>
</section>

<section class="dashboard-section panel" id="patients">
    <div class="panel-heading"><div><h3>Patients</h3><p>Your patient management area</p></div></div>
    <div class="panel-body"><p style="font-size:12px;color:#7c879b;line-height:1.8;">Patient records can be expanded after the appointment approval workflow is connected.</p></div>
</section>

<section class="dashboard-section panel" id="settings">
    <div class="panel-heading"><div><h3>Account Information</h3><p>Current account details</p></div></div>
    <div class="panel-body"><div class="detail-list" style="padding-top:0;">
        <div class="detail-row"><div class="detail-label">Account name</div><div class="detail-value">Dr. <%= esc.apply(doctorName) %></div></div>
        <div class="detail-row"><div class="detail-label">Email</div><div class="detail-value"><%= esc.apply(doctorEmail) %></div></div>
        <div class="detail-row"><div class="detail-label">Account status</div><div class="detail-value"><span class="status-tag">APPROVED</span></div></div>
    </div></div>
</section>
</div>
<footer class="footer">© <%= java.time.Year.now().getValue() %> Petora. Caring for every paw.</footer>
</main>
</div>
<script>
const sidebar = document.getElementById("sidebar");
const mobileMenu = document.getElementById("mobileMenu");

if (mobileMenu) {
    mobileMenu.addEventListener("click", function () {
        sidebar.classList.toggle("open");
    });
}

function showDoctorSection(sectionId) {
    const validIds = ["overview", "profile", "appointments", "patients", "settings"];
    if (!validIds.includes(sectionId)) sectionId = "overview";

    // Profile belongs to the overview content, so show overview and scroll to profile.
    const displayId = sectionId === "profile" ? "overview" : sectionId;

    document.querySelectorAll(".dashboard-section").forEach(function (section) {
        section.classList.toggle("active", section.id === displayId);
    });

    document.querySelectorAll(".nav-link").forEach(function (link) {
        const target = link.getAttribute("href").substring(1);
        link.classList.toggle("active", target === sectionId ||
            (sectionId === "profile" && target === "profile"));
    });

    sidebar.classList.remove("open");

    if (sectionId === "profile") {
        setTimeout(function () {
            const profile = document.getElementById("profile");
            if (profile) profile.scrollIntoView({ behavior: "smooth", block: "start" });
        }, 20);
    } else {
        window.scrollTo({ top: 0, behavior: "smooth" });
    }

    if (history.replaceState) {
        history.replaceState(null, "", "#" + sectionId);
    }
}

document.querySelectorAll(".nav-link, .quick-action").forEach(function (link) {
    link.addEventListener("click", function (event) {
        const target = link.getAttribute("href");
        if (target && target.startsWith("#")) {
            event.preventDefault();
            showDoctorSection(target.substring(1));
        }
    });
});

window.addEventListener("hashchange", function () {
    showDoctorSection(window.location.hash.substring(1) || "overview");
});

document.addEventListener("click", function (event) {
    if (window.innerWidth <= 700 &&
        sidebar.classList.contains("open") &&
        !sidebar.contains(event.target) &&
        mobileMenu && !mobileMenu.contains(event.target)) {
        sidebar.classList.remove("open");
    }
});

// Open the section specified in the URL, or the dashboard by default.
showDoctorSection(window.location.hash.substring(1) || "overview");
</script>
</body>
</html>
