
document.addEventListener("DOMContentLoaded", function () {
    const sections = document.querySelectorAll(".content-section");
    const navItems = document.querySelectorAll(".nav-item");
    const sectionButtons = document.querySelectorAll("[data-section]");
    const sidebar = document.getElementById("sidebar");
    const mobileMenu = document.getElementById("mobileMenu");
    const overlay = document.getElementById("mobileOverlay");
    const globalSearch = document.getElementById("globalSearch");

    function showSection(sectionId) {
        const target = document.getElementById(sectionId);

        if (!target || !target.classList.contains("content-section")) return;

        sections.forEach(section => section.classList.remove("active"));
        target.classList.add("active");

        navItems.forEach(item => {
            item.classList.toggle("active", item.dataset.section === sectionId);
        });

        closeMobileMenu();
        window.scrollTo({ top: 0, behavior: "smooth" });
    }


	sectionButtons.forEach(button => {
	    button.addEventListener("click", function () {
	        const sectionId = this.dataset.section;

	        showSection(sectionId);

	        if (sectionId === "doctors") {
	            loadDoctorApplications();
	        }
			if (sectionId === "sellers") {
			            loadSellerApplications();
			        }
	    });
	});

    function openMobileMenu() {
        sidebar.classList.add("open");
        overlay.classList.add("visible");
    }

    function closeMobileMenu() {
        sidebar.classList.remove("open");
        overlay.classList.remove("visible");
    }

    mobileMenu.addEventListener("click", function () {
        if (sidebar.classList.contains("open")) {
            closeMobileMenu();
        } else {
            openMobileMenu();
        }
    });

    overlay.addEventListener("click", closeMobileMenu);

    document.addEventListener("keydown", function (event) {
        if (event.key === "Escape") closeMobileMenu();
    });

    // Switch between doctor and seller preview lists.
    const approvalTabs = document.querySelectorAll(".approval-tab");
    const approvalLists = document.querySelectorAll(".approval-list");

    approvalTabs.forEach(tab => {
        tab.addEventListener("click", function () {
            approvalTabs.forEach(item => item.classList.remove("active"));
            this.classList.add("active");

            approvalLists.forEach(list => list.classList.add("hidden"));

            const targetList = document.getElementById(this.dataset.approval);
            if (targetList) targetList.classList.remove("hidden");
        });
    });

    // Search demo activity and approval records.
    globalSearch.addEventListener("input", function () {
        const query = this.value.trim().toLowerCase();

        document.querySelectorAll(".activity-row").forEach(row => {
            row.style.display = row.textContent.toLowerCase().includes(query)
                ? ""
                : "none";
        });

        document.querySelectorAll(".approval-row").forEach(row => {
            row.style.display = row.textContent.toLowerCase().includes(query)
                ? ""
                : "none";
        });
    });

    // Demo profile menu interaction.
    const profileButton = document.getElementById("profileButton");
    profileButton.addEventListener("click", function () {
        alert("Administrator profile settings will be connected later.");
    });
});




async function loadDoctorApplications() {
    const section = document.getElementById("doctors");
    const count = document.getElementById("doctorPendingCount");

    if (!section) return;

    section.innerHTML = `
        <span class="eyebrow">VERIFICATION CENTER</span>
        <h1>Doctor Approvals</h1>
        <p>Loading pending doctor applications...</p>
    `;

    try {
        const response = await fetch(
            window.location.pathname.substring(
                0,
                window.location.pathname.lastIndexOf("/")
            ) + "/DoctorApplicationsServlet?format=json",
            {
                credentials: "same-origin",
                headers: { "Accept": "application/json" }
            }
        );

        if (response.status === 401 || response.redirected) {
            throw new Error("Your admin session may have expired. Please log in again.");
        }

        if (!response.ok) {
            throw new Error("Server returned HTTP " + response.status);
        }

        const data = await response.json();

        if (!Array.isArray(data)) {
            throw new Error("Unexpected response from the server.");
        }

        const escapeHTML = value =>
            String(value ?? "").replace(/[&<>"']/g, char => ({
                "&": "&amp;",
                "<": "&lt;",
                ">": "&gt;",
                '"': "&quot;",
                "'": "&#39;"
            })[char]);

        section.innerHTML = `
            <span class="eyebrow">VERIFICATION CENTER</span>
            <h1>Doctor Approvals</h1>
            <p>Review veterinarian applications and credentials.</p>
            <div class="placeholder-card">
                <h2>Doctor Applications</h2>
                <p><strong>Pending applications: ${data.length}</strong></p>
                ${
                    data.length === 0
                        ? "<p>No pending doctor applications found.</p>"

						: data.map(doctor => `
						    <div class="doctor-application-card">

						        <div class="doctor-card-header">
						            <div>
						                <span class="eyebrow">DOCTOR APPLICATION #${doctor.id}</span>
						                <h3>${escapeHTML(doctor.fullName)}</h3>
						                <p>${escapeHTML(doctor.specialization)}</p>
						            </div>
						            <span class="pending-status">${escapeHTML(doctor.status)}</span>
						        </div>

						        <div class="doctor-details-grid">
						            <div class="doctor-detail">
						                <span>EMAIL ADDRESS</span>
						                <p>${escapeHTML(doctor.email)}</p>
						            </div>

						            <div class="doctor-detail">
						                <span>PHONE NUMBER</span>
						                <p>${escapeHTML(doctor.phone)}</p>
						            </div>

						            <div class="doctor-detail">
						                <span>QUALIFICATION</span>
						                <p>${escapeHTML(doctor.qualification)}</p>
						            </div>

						            <div class="doctor-detail">
						                <span>REGISTRATION NUMBER</span>
						                <p>${escapeHTML(doctor.registrationNumber)}</p>
						            </div>

						            <div class="doctor-detail">
						                <span>EXPERIENCE</span>
						                <p>${escapeHTML(doctor.experienceYears)} years</p>
						            </div>

						            <div class="doctor-detail">
						                <span>CLINIC NAME</span>
						                <p>${escapeHTML(doctor.clinicName || "Not provided")}</p>
						            </div>

						            <div class="doctor-detail">
						                <span>CITY / STATE</span>
						                <p>${escapeHTML(doctor.city)}, ${escapeHTML(doctor.state)}</p>
						            </div>

						            <div class="doctor-detail">
						                <span>SUBMITTED</span>
						                <p>${escapeHTML(doctor.submittedAt)}</p>
						            </div>
						        </div>

						        <div class="doctor-card-actions">
						            <button type="button" class="doctor-view-btn"
						                onclick="viewDoctorApplication(${doctor.id})">
						                <i class="fa-solid fa-file-lines"></i> View Certificates
						            </button>

						            <button type="button" class="doctor-approve-btn"
						                onclick="reviewDoctorApplication(${doctor.id}, 'APPROVED')">
						                <i class="fa-solid fa-check"></i> Approve
						            </button>

						            <button type="button" class="doctor-reject-btn"
						                onclick="reviewDoctorApplication(${doctor.id}, 'REJECTED')">
						                <i class="fa-solid fa-xmark"></i> Reject
						            </button>
						        </div>

						    </div>
						`).join("")

                }
            </div>
        `;

        if (count) {
            count.textContent = data.length;
        }

    } catch (error) {
        console.error("Unable to load doctor applications:", error);

        section.innerHTML = `
            <span class="eyebrow">VERIFICATION CENTER</span>
            <h1>Doctor Approvals</h1>
            <p>Could not load applications: ${String(error.message).replace(/[&<>"']/g, "")}</p>
            <button type="button" onclick="loadDoctorApplications()">Try Again</button>
        `;
    }
}




function viewDoctorApplication(doctorId) {
    const basePath = window.location.pathname.substring(
        0,
        window.location.pathname.lastIndexOf("/")
    );

    const registrationUrl =
        basePath + "/DoctorCertificateServlet?id=" +
        encodeURIComponent(doctorId) + "&type=registration";

    const degreeUrl =
        basePath + "/DoctorCertificateServlet?id=" +
        encodeURIComponent(doctorId) + "&type=degree";

    const choice = confirm(
        "OK = View Registration Certificate\n" +
        "Cancel = View Degree Certificate"
    );

    const url = choice ? registrationUrl : degreeUrl;

    window.open(url, "_blank", "noopener,noreferrer");
}


async function reviewDoctorApplication(doctorId, decision) {
    const action = decision === "APPROVED" ? "approve" : "reject";

    if (!confirm(`Are you sure you want to ${action} this doctor application?`)) {
        return;
    }

    let adminNote = "";

    if (decision === "REJECTED") {
        adminNote = prompt("Enter a reason for rejection (optional):") || "";
    }

    if (adminNote.length > 500) {
        alert("The rejection note must be 500 characters or fewer.");
        return;
    }

    const basePath = window.location.pathname.substring(
        0,
        window.location.pathname.lastIndexOf("/")
    );

    try {
        const response = await fetch(basePath + "/DoctorReviewServlet", {
            method: "POST",
            credentials: "same-origin",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
            },
            body: new URLSearchParams({
                id: String(doctorId),
                decision: decision,
                adminNote: adminNote
            })
        });

        if (!response.ok) {
            if (response.status === 401) {
                throw new Error("Your admin session has expired. Please log in again.");
            }

            if (response.status === 409) {
                throw new Error("This application has already been reviewed.");
            }

            throw new Error("The server could not update this application.");
        }

        const result = await response.json();

        if (!result.success) {
            throw new Error("The application update was unsuccessful.");
        }

        alert(
            decision === "APPROVED"
                ? "Doctor application approved successfully!"
                : "Doctor application rejected successfully."
        );

        // Refresh the existing Doctor Approvals section.
        await loadDoctorApplications();

    } catch (error) {
        console.error("Doctor review failed:", error);
        alert(error.message || "Something went wrong. Please try again.");
    }
}







async function loadSellerApplications() {
    const tbody = document.getElementById("sellerApplicationsBody");
    const message = document.getElementById("sellerMessage");

    if (!tbody) {
        console.error("ERROR: sellerApplicationsBody not found in admin.jsp");
        return;
    }

    tbody.innerHTML = `
        <tr>
            <td colspan="8">Loading seller applications...</td>
        </tr>
    `;

    if (message) {
        message.textContent = "";
    }

    // Get the current web application's context path
    const appPath = window.location.pathname.substring(
        0,
        window.location.pathname.lastIndexOf("/")
    );

    const apiUrl = appPath + "/ApproveSellerServlet?action=list";

    console.log("Loading seller applications from:", apiUrl);

    try {
        const response = await fetch(apiUrl, {
            method: "GET",
            credentials: "same-origin",
            headers: {
                "Accept": "application/json"
            }
        });

        const responseText = await response.text();

        console.log("Seller API status:", response.status);
        console.log("Seller API response:", responseText);

        if (!response.ok) {
            throw new Error(
                "HTTP " + response.status + ": " + responseText
            );
        }

        let applications;

        try {
            applications = JSON.parse(responseText);
        } catch (error) {
            throw new Error("The servlet response is not valid JSON.");
        }

        if (!Array.isArray(applications)) {
            throw new Error(
                applications.message || "Expected a list of seller applications."
            );
        }

        // Update dashboard statistics
        updateSellerStats(applications);

        if (applications.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="8">No seller applications found.</td>
                </tr>
            `;
            return;
        }

        // Escape database values before inserting them into HTML
        const safe = value =>
            escapeSellerHtml(value == null ? "" : value);

        tbody.innerHTML = applications.map(seller => {
            const id = Number(seller.id);

            const status = String(
                seller.applicationStatus || "PENDING"
            ).toUpperCase();

            const sellerType =
                seller.sellerType === "PET_SELLER"
                    ? "Pet Seller"
                    : seller.sellerType === "PRODUCT_SELLER"
                        ? "Product Seller"
                        : seller.sellerType || "Unknown";

            const appliedOn = seller.createdAt
                ? String(seller.createdAt).replace("T", " ")
                : "—";

            let actions = "Reviewed";

            if (status === "PENDING") {
                actions = `
                    <button
                        type="button"
                        class="seller-action-btn approve-btn"
                        data-seller-action="approve"
                        data-seller-id="${id}">
                        Approve
                    </button>

                    <button
                        type="button"
                        class="seller-action-btn reject-btn"
                        data-seller-action="reject"
                        data-seller-id="${id}">
                        Reject
                    </button>
                `;
            }

            return `
                <tr>
                    <td>${id}</td>

                    <td>
                        <strong>${safe(seller.fullName)}</strong>
                        <br>
                        <small>${safe(seller.email)}</small>
                    </td>

                    <td>${safe(seller.businessName || "—")}</td>

                    <td>${safe(sellerType)}</td>

                    <td>${safe(seller.phone)}</td>

                    <td>${safe(appliedOn)}</td>

                    <td>
                        <span class="seller-status status-${status.toLowerCase()}">
                            ${safe(status)}
                        </span>
                    </td>

                    <td>${actions}</td>
                </tr>
            `;
        }).join("");

        console.log(
            "Seller applications loaded successfully:",
            applications.length
        );

    } catch (error) {
        console.error("SELLER LOADING ERROR:", error);

        tbody.innerHTML = `
            <tr>
                <td colspan="8">
                    Unable to load seller applications.
                    <br>
                    ${escapeSellerHtml(error.message)}
                </td>
            </tr>
        `;
    }
}

/* =========================================
   SELLER DASHBOARD STATISTICS
========================================= */

function updateSellerStats(applications) {
    const total = applications.length;

    const pending = applications.filter(
        seller => seller.applicationStatus === "PENDING"
    ).length;

    const approved = applications.filter(
        seller => seller.applicationStatus === "APPROVED"
    ).length;

    const rejected = applications.filter(
        seller => seller.applicationStatus === "REJECTED"
    ).length;

    const totalElement = document.getElementById("sellerTotal");
    const pendingElement = document.getElementById("sellerPending");
    const approvedElement = document.getElementById("sellerApproved");
    const rejectedElement = document.getElementById("sellerRejected");

    if (totalElement) totalElement.textContent = total;
    if (pendingElement) pendingElement.textContent = pending;
    if (approvedElement) approvedElement.textContent = approved;
    if (rejectedElement) rejectedElement.textContent = rejected;
}


/* =========================================
   SAFE HTML TEXT
========================================= */

function escapeSellerHtml(value) {
    return String(value ?? "").replace(/[&<>"']/g, function (character) {
        return {
            "&": "&amp;",
            "<": "&lt;",
            ">": "&gt;",
            '"': "&quot;",
            "'": "&#39;"
        }[character];
    });
}


/* =========================================
   SELLER APPROVE / REJECT BUTTONS
========================================= */

document.addEventListener("click", async function (event) {
    const button = event.target.closest("[data-seller-action]");

    if (!button) return;

    const sellerId = button.dataset.sellerId;
    const action = button.dataset.sellerAction;

    if (!sellerId || !["approve", "reject"].includes(action)) {
        console.error("Invalid seller ID or action.");
        return;
    }

    if (!confirm("Are you sure you want to " + action + " this seller?")) {
        return;
    }

    button.disabled = true;

    const appPath = window.location.pathname.substring(
        0,
        window.location.pathname.lastIndexOf("/")
    );

    try {
        const response = await fetch(
            appPath + "/ApproveSellerServlet",
            {
                method: "POST",
                credentials: "same-origin",
                headers: {
                    "Content-Type":
                        "application/x-www-form-urlencoded;charset=UTF-8",
                    "Accept": "application/json"
                },
                body: new URLSearchParams({
                    sellerId: sellerId,
                    action: action
                })
            }
        );

        const result = await response.json();

        if (!response.ok || !result.success) {
            throw new Error(
                result.message || "Could not update seller application."
            );
        }

        alert(result.message);

        await loadSellerApplications();

    } catch (error) {
        console.error("Seller review error:", error);
        alert(error.message || "Something went wrong.");
        button.disabled = false;
    }
});
