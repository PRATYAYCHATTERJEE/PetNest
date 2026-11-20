
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PetNest | Veterinarian Registration</title>
    <link rel="stylesheet" href="CSS/doctor-register.css">
</head>
<body>

<header class="register-header">
    <a href="Doclogin.jsp" class="brand">
        <span class="brand-icon">🐾</span>
        <span>
            <strong>PetNest</strong>
            <small>Veterinary Network</small>
        </span>
    </a>
    <a href="Doclogin.jsp" class="back-link">← Back to Login</a>
</header>

<main class="register-container">

    <section class="register-intro">
        <div class="intro-icon">🩺</div>
        <span class="eyebrow">JOIN OUR PROFESSIONAL NETWORK</span>
        <h1>Care for pets.<br><span>Make a difference.</span></h1>
        <p>
            Create your veterinarian account to connect with pet parents,
            manage appointments, and provide better care through Petora.
        </p>

        <div class="benefit-list">
            <div><span>✓</span><div><strong>Professional profile</strong>
                <small>Showcase your qualifications and expertise.</small></div></div>
            <div><span>✓</span><div><strong>Trusted network</strong>
                <small>Join after your credentials are verified.</small></div></div>
            <div><span>✓</span><div><strong>Secure approval process</strong>
                <small>Your application is reviewed by our admin team.</small></div></div>
        </div>

        <div class="privacy-note">
            🔒 Your submitted professional information is used for verification.
        </div>
    </section>

    <section class="form-panel">
        <div class="form-heading">
            <span class="form-step">VETERINARIAN APPLICATION</span>
            <h2>Create your account</h2>
            <p>Complete all required fields to submit your application.</p>
        </div>

        <div class="pending-notice">
            <span class="notice-icon">ⓘ</span>
            <div>
                <strong>Admin verification required</strong>
                <p>Your account will remain pending until an administrator
                   reviews and approves your credentials.</p>
            </div>
        </div>

        <form action="DoctorRegisterServlet" method="post"
              enctype="multipart/form-data" id="doctorRegisterForm">

            <h3 class="group-title"><span>01</span> Personal information</h3>

            <div class="form-grid">
                <div class="field full-width">
                    <label for="fullName">Full name <b>*</b></label>
                    <input type="text" id="fullName" name="fullName"
                           placeholder="Enter your full legal name"
                           maxlength="100" autocomplete="name" required>
                </div>

                <div class="field">
                    <label for="email">Email address <b>*</b></label>
                    <input type="email" id="email" name="email"
                           placeholder="doctor@example.com"
                           maxlength="150" autocomplete="email" required>
                </div>

                <div class="field">
                    <label for="phone">Phone number <b>*</b></label>
                    <input type="tel" id="phone" name="phone"
                           placeholder="10-digit mobile number"
                           maxlength="15" autocomplete="tel"
                           pattern="[0-9+\-\s]{10,15}" required>
                </div>

                <div class="field">
                    <label for="dob">Date of birth <b>*</b></label>
                    <input type="date" id="dob" name="dateOfBirth"
                           required>
                </div>

                <div class="field">
                    <label for="gender">Gender</label>
                    <select id="gender" name="gender">
                        <option value="">Prefer not to say</option>
                        <option value="Female">Female</option>
                        <option value="Male">Male</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
            </div>

            <h3 class="group-title"><span>02</span> Professional credentials</h3>

            <div class="form-grid">
                <div class="field">
                    <label for="qualification">Highest qualification <b>*</b></label>
                    <select id="qualification" name="qualification" required>
                        <option value="">Select qualification</option>
                        <option value="BVSc">BVSc</option>
                        <option value="BVSc and AH">BVSc &amp; AH</option>
                        <option value="MVSc">MVSc</option>
                        <option value="PhD Veterinary Science">PhD Veterinary Science</option>
                        <option value="Other recognized qualification">Other recognized qualification</option>
                    </select>
                </div>

                <div class="field">
                    <label for="specialization">Specialization <b>*</b></label>
                    <select id="specialization" name="specialization" required>
                        <option value="">Select specialization</option>
                        <option value="General Veterinary Care">General Veterinary Care</option>
                        <option value="Surgery">Veterinary Surgery</option>
                        <option value="Dermatology">Dermatology</option>
                        <option value="Dentistry">Veterinary Dentistry</option>
                        <option value="Animal Nutrition">Animal Nutrition</option>
                        <option value="Emergency Care">Emergency Care</option>
                        <option value="Other">Other</option>
                    </select>
                </div>

                <div class="field">
                    <label for="registrationNumber">Veterinary registration number <b>*</b></label>
                    <input type="text" id="registrationNumber"
                           name="registrationNumber"
                           placeholder="Official registration number"
                           maxlength="100" required>
                    <small>Use the number issued by your relevant veterinary council.</small>
                </div>

                <div class="field">
                    <label for="experience">Years of experience <b>*</b></label>
                    <select id="experience" name="experienceYears" required>
                        <option value="">Select experience</option>
                        <option value="0">Newly qualified</option>
                        <option value="1">1 year</option>
                        <option value="2">2 years</option>
                        <option value="3">3 years</option>
                        <option value="4">4 years</option>
                        <option value="5">5 years</option>
                        <option value="6-10">6–10 years</option>
                        <option value="11+">11+ years</option>
                    </select>
                </div>
            </div>

            <h3 class="group-title"><span>03</span> Clinic and workplace</h3>

            <div class="form-grid">
                <div class="field full-width">
                    <label for="clinicName">Clinic / hospital name</label>
                    <input type="text" id="clinicName" name="clinicName"
                           placeholder="Enter your clinic or hospital name"
                           maxlength="150">
                </div>

                <div class="field full-width">
                    <label for="clinicAddress">Workplace address <b>*</b></label>
                    <textarea id="clinicAddress" name="clinicAddress"
                              rows="3" maxlength="500"
                              placeholder="Street, area, building or clinic address"
                              required></textarea>
                </div>

                <div class="field">
                    <label for="city">City <b>*</b></label>
                    <input type="text" id="city" name="city"
                           maxlength="100" placeholder="Your city" required>
                </div>

                <div class="field">
                    <label for="state">State <b>*</b></label>
                    <input type="text" id="state" name="state"
                           maxlength="100" placeholder="Your state" required>
                </div>

                <div class="field">
                    <label for="pinCode">PIN code <b>*</b></label>
                    <input type="text" id="pinCode" name="pinCode"
                           pattern="[0-9]{6}" maxlength="6"
                           inputmode="numeric" placeholder="6-digit PIN"
                           required>
                </div>
            </div>

            <h3 class="group-title"><span>04</span> Verification documents</h3>

            <p class="section-description">
                Upload clear copies of your documents. Accepted formats:
                PDF, JPG, JPEG or PNG. Maximum 5 MB per file.
            </p>

            <div class="upload-grid">
                <label class="upload-box" for="registrationCertificate">
                    <span class="upload-icon">📄</span>
                    <strong>Veterinary registration certificate <b>*</b></strong>
                    <small id="registrationFileName">Click to upload a document</small>
                    <input type="file" id="registrationCertificate"
                           name="registrationCertificate"
                           accept=".pdf,.jpg,.jpeg,.png"
                           data-name-target="registrationFileName"
                           required>
                </label>

                <label class="upload-box" for="degreeCertificate">
                    <span class="upload-icon">🎓</span>
                    <strong>Degree certificate <b>*</b></strong>
                    <small id="degreeFileName">Click to upload a document</small>
                    <input type="file" id="degreeCertificate"
                           name="degreeCertificate"
                           accept=".pdf,.jpg,.jpeg,.png"
                           data-name-target="degreeFileName"
                           required>
                </label>
            </div>

            <h3 class="group-title"><span>05</span> Secure your account</h3>

            <div class="form-grid">
                <div class="field">
                    <label for="password">Create password <b>*</b></label>
                    <input type="password" id="password" name="password"
                           minlength="8" maxlength="72"
                           autocomplete="new-password"
                           placeholder="At least 8 characters" required>
                </div>

                <div class="field">
                    <label for="confirmPassword">Confirm password <b>*</b></label>
                    <input type="password" id="confirmPassword"
                           name="confirmPassword" minlength="8" maxlength="72"
                           autocomplete="new-password"
                           placeholder="Enter password again" required>
                </div>
            </div>

            <label class="terms-check">
                <input type="checkbox" name="confirmAccuracy"
                       value="yes" required>
                <span>
                    I confirm that the information and documents submitted
                    are accurate and belong to me.
                </span>
            </label>

            <button type="submit" class="submit-btn">
                Submit for Verification <span>→</span>
            </button>

            <p class="login-prompt">
                Already registered?
                <a href="Doclogin.jsp">Login as a Doctor</a>
            </p>

            <p class="form-footnote">
                Submitting this form does not guarantee approval.
                Petora may verify your credentials before activating your account.
            </p>

        </form>
    </section>
</main>

<script>
    const dob = document.getElementById("dob");
    dob.max = new Date().toISOString().split("T")[0];

    document.querySelectorAll('input[type="file"]').forEach(function(input) {
        input.addEventListener("change", function() {
            const target = document.getElementById(input.dataset.nameTarget);
            if (!target) return;

            const file = input.files[0];

            if (!file) {
                target.textContent = "Click to upload a document";
                return;
            }

            const allowedTypes = [
                "application/pdf",
                "image/jpeg",
                "image/png"
            ];

            if (!allowedTypes.includes(file.type) || file.size > 5 * 1024 * 1024) {
                alert("Please select a PDF, JPG or PNG file up to 5 MB.");
                input.value = "";
                target.textContent = "Click to upload a document";
                return;
            }

            target.textContent = file.name;
        });
    });

    document.getElementById("doctorRegisterForm").addEventListener("submit", function(event) {
        const password = document.getElementById("password").value;
        const confirmPassword = document.getElementById("confirmPassword").value;

        if (password !== confirmPassword) {
            event.preventDefault();
            alert("Passwords do not match.");
            document.getElementById("confirmPassword").focus();
        }
    });
</script>

</body>
</html>
