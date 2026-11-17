```jsp
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%!
    private String esc(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    Map<String, Object> doctor =
        (Map<String, Object>) request.getAttribute("doctor");

    if (doctor == null) {
        response.sendError(
            HttpServletResponse.SC_NOT_FOUND,
            "Doctor profile not found."
        );
        return;
    }

    String doctorName = (String) doctor.get("fullName");
    String specialization = (String) doctor.get("specialization");
    String qualification = (String) doctor.get("qualification");
    String clinicName = (String) doctor.get("clinicName");
    String clinicAddress = (String) doctor.get("clinicAddress");
    String city = (String) doctor.get("city");
    String state = (String) doctor.get("state");
    String pinCode = (String) doctor.get("pinCode");
    String email = (String) doctor.get("email");
    String phone = (String) doctor.get("phone");
    String registrationNumber = (String) doctor.get("registrationNumber");
    Object experience = doctor.get("experienceYears");
    Object doctorId = doctor.get("id");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Profile | PawCare</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', sans-serif;
            color: #172333;
            background: #f4f8f5;
        }

        .page {
            width: min(1100px, 100%);
            margin: auto;
            padding: 35px 24px 55px;
        }

        .back-link {
            display: inline-flex;
            gap: 9px;
            align-items: center;
            margin-bottom: 25px;
            color: #187746;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
        }

        .profile-card {
            overflow: hidden;
            background: #fff;
            border: 1px solid #e5ece7;
            border-radius: 22px;
            box-shadow: 0 8px 28px rgba(25, 70, 45, .05);
        }

        .profile-banner {
            height: 150px;
            background: linear-gradient(120deg, #dff1e2, #eff8f0, #dcefe3);
        }

        .profile-content {
            padding: 0 36px 35px;
        }

        .profile-heading {
            display: flex;
            align-items: flex-end;
            gap: 22px;
            margin-top: -54px;
            margin-bottom: 28px;
        }

        .doctor-avatar {
            display: grid;
            place-items: center;
            flex-shrink: 0;
            width: 112px;
            height: 112px;
            border: 6px solid #fff;
            border-radius: 22px;
            background: #e8f5e9;
            color: #187746;
            font-size: 40px;
        }

        .profile-title {
            padding-bottom: 5px;
            min-width: 0;
        }

        .profile-title h1 {
            margin-bottom: 9px;
            font-size: clamp(22px, 4vw, 30px);
            overflow-wrap: anywhere;
        }

        .specialty {
            display: inline-block;
            padding: 7px 12px;
            border-radius: 20px;
            background: #e8f5e9;
            color: #187746;
            font-size: 12px;
            font-weight: 600;
        }

        .verified {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            margin-left: 7px;
            color: #16804b;
            font-size: 11px;
            font-weight: 700;
        }

        .section-title {
            margin: 28px 0 17px;
            font-size: 16px;
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 14px;
        }

        .detail-box {
            display: flex;
            align-items: flex-start;
            gap: 13px;
            padding: 17px;
            border: 1px solid #e8eee9;
            border-radius: 13px;
            background: #fcfdfc;
            min-width: 0;
        }

        .detail-icon {
            display: grid;
            place-items: center;
            flex-shrink: 0;
            width: 39px;
            height: 39px;
            border-radius: 11px;
            background: #e8f5e9;
            color: #187746;
        }

        .detail-text {
            min-width: 0;
        }

        .detail-text small {
            display: block;
            margin-bottom: 6px;
            color: #7a8790;
            font-size: 11px;
        }

        .detail-text p {
            font-size: 13px;
            font-weight: 600;
            line-height: 1.6;
            overflow-wrap: anywhere;
        }

        .clinic-box {
            padding: 21px;
            border: 1px solid #e5ece7;
            border-radius: 15px;
            background: #f8fbf8;
        }

        .clinic-box h3 {
            margin-bottom: 12px;
            font-size: 15px;
        }

        .clinic-box p {
            margin: 8px 0;
            color: #64717a;
            font-size: 13px;
            line-height: 1.7;
            overflow-wrap: anywhere;
        }

        .clinic-box i {
            width: 19px;
            color: #187746;
        }

        .profile-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 27px;
        }

        .btn {
            display: inline-flex;
            justify-content: center;
            align-items: center;
            gap: 9px;
            padding: 13px 19px;
            border: 0;
            border-radius: 11px;
            font-family: inherit;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
        }

        .btn-primary {
            background: #167a43;
            color: #fff;
        }

        .btn-primary:hover {
            background: #106536;
        }

        .btn-secondary {
            border: 1px solid #dce8df;
            background: #fff;
            color: #187746;
        }

        @media (max-width: 650px) {
            .page {
                padding: 22px 14px 35px;
            }

            .profile-content {
                padding: 0 18px 25px;
            }

            .profile-heading {
                align-items: flex-start;
                flex-direction: column;
                gap: 12px;
            }

            .doctor-avatar {
                width: 92px;
                height: 92px;
                font-size: 32px;
            }

            .details-grid {
                grid-template-columns: 1fr;
            }

            .verified {
                margin: 10px 0 0;
            }

            .profile-actions .btn {
                width: 100%;
            }
        }
    </style>
</head>

<body>
<main class="page">

    <a class="back-link"
       href="<%= request.getContextPath() %>/MyPetsServlet">
        <i class="fa-solid fa-arrow-left"></i>
        Back to PawCare
    </a>

    <article class="profile-card">

        <div class="profile-banner"></div>

        <div class="profile-content">

            <div class="profile-heading">
                <div class="doctor-avatar">
                    <i class="fa-solid fa-user-doctor"></i>
                </div>

                <div class="profile-title">
                    <h1>Dr. <%= esc(doctorName) %></h1>

                    <span class="specialty">
                        <%= esc(specialization) %>
                    </span>

                    <div class="verified">
                        <i class="fa-solid fa-circle-check"></i>
                        Approved Veterinarian
                    </div>
                </div>
            </div>

            <h2 class="section-title">Professional Information</h2>

            <div class="details-grid">

                <div class="detail-box">
                    <div class="detail-icon">
                        <i class="fa-solid fa-graduation-cap"></i>
                    </div>
                    <div class="detail-text">
                        <small>Qualification</small>
                        <p><%= esc(qualification) %></p>
                    </div>
                </div>

                <div class="detail-box">
                    <div class="detail-icon">
                        <i class="fa-solid fa-briefcase"></i>
                    </div>
                    <div class="detail-text">
                        <small>Experience</small>
                        <p><%= experience %> years</p>
                    </div>
                </div>

                <div class="detail-box">
                    <div class="detail-icon">
                        <i class="fa-solid fa-id-card"></i>
                    </div>
                    <div class="detail-text">
                        <small>Registration Number</small>
                        <p><%= esc(registrationNumber) %></p>
                    </div>
                </div>

                <div class="detail-box">
                    <div class="detail-icon">
                        <i class="fa-solid fa-hospital"></i>
                    </div>
                    <div class="detail-text">
                        <small>Clinic / Hospital</small>
                        <p><%= esc(clinicName) %></p>
                    </div>
                </div>

            </div>

            <h2 class="section-title">Clinic Location</h2>

            <div class="clinic-box">
                <h3><i class="fa-solid fa-location-dot"></i>
                    <%= esc(clinicName) %>
                </h3>

                <p>
                    <i class="fa-solid fa-map-pin"></i>
                    <%= esc(clinicAddress) %>
                </p>

                <p>
                    <i class="fa-solid fa-city"></i>
                    <%= esc(city) %>, <%= esc(state) %>
                    <%= esc(pinCode) %>
                </p>
            </div>

            <h2 class="section-title">Contact Information</h2>

            <div class="details-grid">

                <div class="detail-box">
                    <div class="detail-icon">
                        <i class="fa-solid fa-envelope"></i>
                    </div>
                    <div class="detail-text">
                        <small>Email Address</small>
                        <p><%= esc(email) %></p>
                    </div>
                </div>

                <div class="detail-box">
                    <div class="detail-icon">
                        <i class="fa-solid fa-phone"></i>
                    </div>
                    <div class="detail-text">
                        <small>Phone Number</small>
                        <p><%= esc(phone) %></p>
                    </div>
                </div>

            </div>

            <div class="profile-actions">
                <a class="btn btn-primary"
   href="<%= request.getContextPath() %>/book-appointment.jsp?doctorId=<%= doctorId %>"
   style="text-decoration:none;">
    <i class="fa-solid fa-calendar-check"></i>
    Book Appointment
</a>

                <a class="btn btn-secondary"
                   href="<%= request.getContextPath() %>/MyPetsServlet">
                    <i class="fa-solid fa-arrow-left"></i>
                    Back to Doctors
                </a>
            </div>

        </div>
    </article>
</main>
</body>
</html>
```