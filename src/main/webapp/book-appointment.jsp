
<%
String appointmentStatus = request.getParameter("appointment");
String errorStatus = request.getParameter("error");
%>

<% if ("success".equals(appointmentStatus)) { %>
    <div class="appointment-message success-message">
        <i class="fa-solid fa-circle-check"></i>
        Appointment request submitted successfully! Your appointment is pending confirmation.
    </div>
<% } %>

<% if ("save".equals(errorStatus)) { %>
    <div class="appointment-message error-message">
        <i class="fa-solid fa-circle-exclamation"></i>
        Unable to submit your appointment. Please check your details and try again.
    </div>
<% } else if ("invalid".equals(errorStatus)) { %>
    <div class="appointment-message error-message">
        Please enter valid appointment details and select a future date.
    </div>
<% } %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String doctorId = request.getParameter("doctorId");

    if (doctorId == null || !doctorId.matches("\\d+")) {
        response.sendError(
            HttpServletResponse.SC_BAD_REQUEST,
            "Invalid doctor selection."
        );
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment | PetNest</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">

    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', sans-serif;
            background: #f4f8f5;
            color: #172333;
        }

        .page {
            width: min(760px, 100%);
            margin: auto;
            padding: 35px 20px 50px;
        }

        .back-link {
            display: inline-flex;
            gap: 9px;
            align-items: center;
            margin-bottom: 24px;
            color: #187746;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
        }

        .form-card {
            padding: 30px;
            background: #fff;
            border: 1px solid #e5ece7;
            border-radius: 20px;
            box-shadow: 0 8px 25px rgba(25, 70, 45, .05);
        }

        .form-icon {
            display: grid;
            place-items: center;
            width: 52px;
            height: 52px;
            margin-bottom: 20px;
            border-radius: 15px;
            background: #e8f5e9;
            color: #187746;
            font-size: 22px;
        }

        h1 {
            margin-bottom: 9px;
            font-size: 27px;
        }

        .subtitle {
            margin-bottom: 26px;
            color: #75818d;
            font-size: 13px;
            line-height: 1.7;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px;
        }

        .field {
            min-width: 0;
        }

        .field.full {
            grid-column: 1 / -1;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-size: 12px;
            font-weight: 700;
        }

        input, select, textarea {
            width: 100%;
            padding: 12px 13px;
            border: 1px solid #dce6df;
            border-radius: 10px;
            background: #fff;
            color: #172333;
            font: inherit;
            font-size: 13px;
            outline: none;
        }

        input:focus, select:focus, textarea:focus {
            border-color: #21834d;
            box-shadow: 0 0 0 3px rgba(33, 131, 77, .1);
        }

        textarea {
            min-height: 105px;
            resize: vertical;
        }

        .hint {
            margin-top: 7px;
            color: #78858e;
            font-size: 11px;
            line-height: 1.6;
        }

        .submit-btn {
            display: inline-flex;
            justify-content: center;
            align-items: center;
            gap: 9px;
            width: 100%;
            margin-top: 23px;
            padding: 14px;
            border: 0;
            border-radius: 11px;
            background: #167a43;
            color: white;
            font: inherit;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
        }
		```css
.appointment-message {
    padding: 14px 18px;
    margin: 0 0 20px;
    border-radius: 10px;
    font-size: 14px;
    line-height: 1.6;
}

.success-message {
    color: #176534;
    background: #e8f7ed;
    border: 1px solid #a8dfb8;
}

.error-message {
    color: #a12626;
    background: #fff0f0;
    border: 1px solid #f0b6b6;
}

        .submit-btn:hover { background: #106536; }

        @media (max-width: 550px) {
            .page { padding: 22px 14px; }
            .form-card { padding: 22px 17px; }
            .form-grid { grid-template-columns: 1fr; }
            .field.full { grid-column: auto; }
            h1 { font-size: 23px; }
        }
    </style>
</head>

<body>
<main class="page">

    <a class="back-link"
       href="<%= request.getContextPath() %>/MyPetsServlet">
        <i class="fa-solid fa-arrow-left"></i>
        Back to PetNest
    </a>

    <section class="form-card">
        <div class="form-icon">
            <i class="fa-solid fa-calendar-check"></i>
        </div>

        <h1>Book an Appointment</h1>
        <p class="subtitle">
            Submit your preferred date and time for a veterinary consultation.
            Your request will be sent for confirmation.
        </p>

        <form action="<%= request.getContextPath() %>/BookAppointmentServlet"
              method="post">

            <input type="hidden" name="doctorId"
                   value="<%= doctorId %>">

            <div class="form-grid">

                <div class="field">
                    <label for="petName">Pet Name *</label>
                    <input id="petName" name="petName"
                           type="text" maxlength="100"
                           required placeholder="Enter your pet's name">
                </div>

                <div class="field">
                    <label for="petType">Pet Type</label>
                    <select id="petType" name="petType">
                        <option value="">Select pet type</option>
                        <option value="Dog">Dog</option>
                        <option value="Cat">Cat</option>
                        <option value="Bird">Bird</option>
                        <option value="Rabbit">Rabbit</option>
                        <option value="Other">Other</option>
                    </select>
                </div>

                <div class="field">
                    <label for="appointmentDate">Preferred Date *</label>
                    <input id="appointmentDate" name="appointmentDate"
                           type="date" required>
                </div>

                <div class="field">
                    <label for="appointmentTime">Preferred Time *</label>
                    <input id="appointmentTime" name="appointmentTime"
                           type="time" required>
                </div>

                <div class="field full">
                    <label for="reason">Reason for Visit</label>
                    <textarea id="reason" name="reason"
                              maxlength="500"
                              placeholder="Describe your pet's symptoms or reason for the visit"></textarea>
                </div>

            </div>

            <p class="hint">
                Submitting this form requests an appointment; it does not
                guarantee a confirmed booking.
            </p>

            <button class="submit-btn" type="submit">
                <i class="fa-solid fa-calendar-check"></i>
                Submit Appointment Request
            </button>
        </form>
    </section>
</main>

<script>
    const dateInput = document.getElementById("appointmentDate");

    const now = new Date();
    const localDate = new Date(
        now.getTime() - now.getTimezoneOffset() * 60000
    ).toISOString().split("T")[0];

    dateInput.min = localDate;
</script>

</body>
</html>
