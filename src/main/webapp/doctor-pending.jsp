
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Petora | Application Submitted</title>

    <link rel="stylesheet" href="CSS/doctor-register.css">

    <style>
        .pending-page {
            min-height: calc(100vh - 82px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 35px 18px;
        }

        .pending-card {
            width: 100%;
            max-width: 600px;
            padding: 45px 38px;
            background: #fff;
            border: 1px solid #e5ece5;
            border-radius: 24px;
            box-shadow: 0 15px 50px rgba(35, 62, 44, .07);
            text-align: center;
        }

        .pending-icon {
            width: 90px;
            height: 90px;
            margin: 0 auto 25px;
            display: grid;
            place-items: center;
            border-radius: 50%;
            background: #fff3dc;
            color: #b7791f;
            font-size: 38px;
        }

        .pending-label {
            color: #b7791f;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 2px;
        }

        .pending-card h1 {
            margin: 15px 0;
            color: #192a22;
            font-size: clamp(27px, 5vw, 35px);
            line-height: 1.3;
        }

        .pending-card h1 span {
            color: #176b46;
        }

        .pending-description {
            max-width: 460px;
            margin: 0 auto;
            color: #718078;
            font-size: 14px;
            line-height: 1.9;
        }

        .status-box {
            margin-top: 28px;
            padding: 18px;
            display: flex;
            align-items: center;
            gap: 14px;
            border: 1px solid #f0dfb9;
            border-radius: 14px;
            background: #fffaf0;
            text-align: left;
        }

        .status-symbol {
            width: 42px;
            height: 42px;
            flex-shrink: 0;
            display: grid;
            place-items: center;
            border-radius: 12px;
            background: #ffedc9;
            font-size: 21px;
        }

        .status-box strong {
            display: block;
            color: #815718;
            font-size: 13px;
        }

        .status-box p {
            margin: 5px 0 0;
            color: #8a795b;
            font-size: 12px;
            line-height: 1.7;
        }

        .pending-steps {
            margin: 28px 0;
            padding: 0;
            display: grid;
            gap: 14px;
            list-style: none;
            text-align: left;
        }

        .pending-steps li {
            display: flex;
            align-items: center;
            gap: 12px;
            color: #56645b;
            font-size: 13px;
        }

        .step-check {
            width: 27px;
            height: 27px;
            flex-shrink: 0;
            display: grid;
            place-items: center;
            border-radius: 50%;
            background: #e5f4e8;
            color: #176b46;
        }

        .pending-home {
            min-height: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            border-radius: 12px;
            background: #176b46;
            color: #fff;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            transition: .2s;
        }

        .pending-home:hover {
            background: #124d35;
        }

        .pending-footer {
            margin: 20px 0 0;
            color: #89948c;
            font-size: 11px;
            line-height: 1.8;
        }

        @media (max-width: 520px) {
            .pending-card {
                padding: 32px 20px;
            }
        }
    </style>
</head>

<body>

<header class="register-header">
    <a href="Doclogin.jsp" class="brand">
        <span class="brand-icon">🐾</span>
        <span>
            <strong>Petora</strong>
            <small>Veterinary Network</small>
        </span>
    </a>
</header>

<main class="pending-page">
    <section class="pending-card">

        <div class="pending-icon">⏳</div>

        <span class="pending-label">APPLICATION RECEIVED</span>

        <h1>Thank you for joining <span>Petora!</span></h1>

        <p class="pending-description">
            Your veterinarian registration has been submitted successfully.
            Our admin team will review your professional information and
            verification documents before activating your account.
        </p>

        <div class="status-box">
            <div class="status-symbol">🕒</div>
            <div>
                <strong>Status: Pending Admin Approval</strong>
                <p>
                    You cannot access the doctor dashboard until your
                    application has been approved.
                </p>
            </div>
        </div>

        <ul class="pending-steps">
            <li>
                <span class="step-check">✓</span>
                Registration details submitted
            </li>
            <li>
                <span class="step-check">✓</span>
                Application stored for review
            </li>
            <li>
                <span class="step-check">◷</span>
                Waiting for admin verification
            </li>
        </ul>

        <a href="Doclogin.jsp" class="pending-home">
            Return to Doctor Login <span>→</span>
        </a>

        <p class="pending-footer">
            Once approved, you will be able to sign in and access the
            Petora doctor dashboard.
        </p>

    </section>
</main>

</body>
</html>
