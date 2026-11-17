
document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("sellerRegisterForm");
    const password = document.getElementById("password");
    const confirmPassword = document.getElementById("confirmPassword");
    const submitBtn = document.getElementById("submitBtn");

    if (!form) return;

    function checkPasswords() {
        confirmPassword.setCustomValidity(
            password.value === confirmPassword.value
                ? ""
                : "Passwords do not match."
        );
    }

    password.addEventListener("input", checkPasswords);
    confirmPassword.addEventListener("input", checkPasswords);

    form.addEventListener("submit", (event) => {
        checkPasswords();

        if (!form.checkValidity()) {
            event.preventDefault();
            form.reportValidity();
            return;
        }

        const files = [
            document.getElementById("idProof").files[0],
            document.getElementById("shopProof").files[0]
        ];

        const maxSize = 5 * 1024 * 1024;
        const allowedTypes = [
            "application/pdf",
            "image/jpeg",
            "image/png"
        ];

        for (const file of files) {
            if (!file) {
                event.preventDefault();
                alert("Please upload both required documents.");
                return;
            }

            if (file.size > maxSize) {
                event.preventDefault();
                alert("Each document must be 5 MB or smaller.");
                return;
            }

            if (!allowedTypes.includes(file.type)) {
                event.preventDefault();
                alert("Only PDF, JPG and PNG documents are accepted.");
                return;
            }
        }

        submitBtn.disabled = true;
        submitBtn.textContent = "Submitting...";
    });
});




document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("sellerLoginForm");
    const password = document.getElementById("password");
    const toggle = document.getElementById("togglePassword");
    const loginBtn = document.getElementById("loginBtn");

    toggle.addEventListener("click", () => {
        const showPassword = password.type === "password";

        password.type = showPassword ? "text" : "password";
        toggle.textContent = showPassword ? "Hide" : "Show";
    });

    form.addEventListener("submit", (event) => {
        if (!form.checkValidity()) {
            event.preventDefault();
            form.reportValidity();
            return;
        }

        loginBtn.disabled = true;
        loginBtn.textContent = "Signing in...";
    });
});
