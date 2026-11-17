/* =========================================
   PETORA AUTHENTICATION JAVASCRIPT
========================================= */


/* =========================================
   PASSWORD VISIBILITY
========================================= */

function togglePassword(inputId, button) {

    const input = document.getElementById(inputId);

    if (!input) {
        return;
    }


    if (input.type === "password") {

        input.type = "text";

        button.textContent = "🙈";

    } else {

        input.type = "password";

        button.textContent = "👁";

    }

}



/* =========================================
   LOGIN FORM
========================================= */

const loginForm = document.getElementById("loginForm");


if (loginForm) {

    loginForm.addEventListener("submit", function (event) {

        const email =
            document.getElementById("email").value.trim();

        const password =
            document.getElementById("password").value;


        if (email === "" || password === "") {

            event.preventDefault();

            alert("Please enter your email and password.");

            return;

        }


        if (!isValidEmail(email)) {

            event.preventDefault();

            alert("Please enter a valid email address.");

            return;

        }

    });

}



/* =========================================
   REGISTER FORM
========================================= */

const registerForm =
    document.getElementById("registerForm");


if (registerForm) {

    registerForm.addEventListener("submit", function (event) {

        const name =
            document.getElementById("name").value.trim();

        const email =
            document.getElementById("registerEmail").value.trim();

        const phone =
            document.getElementById("phone").value.trim();

        const password =
            document.getElementById("registerPassword").value;

        const confirmPassword =
            document.getElementById("confirmPassword").value;

        const terms =
            document.getElementById("terms").checked;



        /* Name */

        if (name.length < 3) {

            event.preventDefault();

            alert("Please enter your full name.");

            return;

        }



        /* Email */

        if (!isValidEmail(email)) {

            event.preventDefault();

            alert("Please enter a valid email address.");

            return;

        }



        /* Phone */

        if (!/^[0-9]{10}$/.test(phone)) {

            event.preventDefault();

            alert("Please enter a valid 10-digit phone number.");

            return;

        }



        /* Password */

        if (password.length < 6) {

            event.preventDefault();

            alert(
                "Password must contain at least 6 characters."
            );

            return;

        }



        /* Confirm password */

        if (password !== confirmPassword) {

            event.preventDefault();

            alert("Passwords do not match.");

            return;

        }



        /* Terms */

        if (!terms) {

            event.preventDefault();

            alert(
                "Please accept the Terms & Conditions."
            );

            return;

        }

    });

}



/* =========================================
   EMAIL VALIDATION
========================================= */

function isValidEmail(email) {

    const emailPattern =
        /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    return emailPattern.test(email);

}