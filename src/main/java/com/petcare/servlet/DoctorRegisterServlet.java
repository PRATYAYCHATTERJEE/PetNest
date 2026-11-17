
package com.petcare.servlet;

import com.petcare.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.security.SecureRandom;
import java.security.spec.KeySpec;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Date;
import java.util.Locale;
import java.util.UUID;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

@WebServlet("/DoctorRegisterServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 11 * 1024 * 1024
)
public class DoctorRegisterServlet extends HttpServlet {

    private static final int ITERATIONS = 210000;
    private static final int KEY_LENGTH = 256;

    private Path uploadDirectory;

    @Override
    public void init() throws ServletException {
        String configuredPath = System.getProperty("petcare.upload.dir");

        if (configuredPath == null || configuredPath.trim().isEmpty()) {
            throw new ServletException(
                "Configure the JVM property petcare.upload.dir " +
                "to a private directory outside the web application."
            );
        }

        uploadDirectory = Paths.get(configuredPath)
                               .toAbsolutePath()
                               .normalize();

        try {
            Files.createDirectories(uploadDirectory);
        } catch (IOException e) {
            throw new ServletException(
                "Unable to initialize document storage.", e
            );
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()
                || password == null || confirmPassword == null) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Email and password are required."
            );
            return;
        }

        if (password.length() < 8 || password.length() > 72) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Password must contain between 8 and 72 characters."
            );
            return;
        }

        if (!password.equals(confirmPassword)) {
            response.sendRedirect(
                request.getContextPath() +
                "/doctor-register.jsp?error=password"
            );
            return;
        }

        Part registrationPart;
        Part degreePart;

        try {
            registrationPart = request.getPart("registrationCertificate");
            degreePart = request.getPart("degreeCertificate");
        } catch (IllegalStateException e) {
            response.sendError(
                HttpServletResponse.SC_REQUEST_ENTITY_TOO_LARGE,
                "The uploaded files exceed the allowed size."
            );
            return;
        }

        validateDocument(registrationPart);
        validateDocument(degreePart);

        String registrationPath = null;
        String degreePath = null;

        try {
            registrationPath = saveDocument(registrationPart);
            degreePath = saveDocument(degreePart);

            String sql =
                "INSERT INTO doctor_applications (" +
                "full_name, email, phone, date_of_birth, gender, " +
                "qualification, specialization, registration_number, " +
                "experience_years, clinic_name, clinic_address, city, " +
                "state, pin_code, registration_certificate, " +
                "degree_certificate, password_hash, status" +
                ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'PENDING')";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                     sql, Statement.RETURN_GENERATED_KEYS)) {

                ps.setString(1, required(request, "fullName"));
                ps.setString(2, email.trim().toLowerCase(Locale.ROOT));
                ps.setString(3, required(request, "phone"));
                ps.setDate(4, java.sql.Date.valueOf(
                    required(request, "dateOfBirth")
                ));

                setOptional(ps, 5, request.getParameter("gender"));
                ps.setString(6, required(request, "qualification"));
                ps.setString(7, required(request, "specialization"));
                ps.setString(8, required(request, "registrationNumber"));
                ps.setString(9, required(request, "experienceYears"));
                setOptional(ps, 10, request.getParameter("clinicName"));
                ps.setString(11, required(request, "clinicAddress"));
                ps.setString(12, required(request, "city"));
                ps.setString(13, required(request, "state"));
                ps.setString(14, required(request, "pinCode"));
                ps.setString(15, registrationPath);
                ps.setString(16, degreePath);
                ps.setString(17, hashPassword(password));

                ps.executeUpdate();
            }

            response.sendRedirect(
                request.getContextPath() +
                "/doctor-pending.jsp"
            );

        } catch (SQLException e) {
            deleteSavedFile(registrationPath);
            deleteSavedFile(degreePath);

            if ("23000".equals(e.getSQLState())) {
                response.sendRedirect(
                    request.getContextPath() +
                    "/doctor-register.jsp?error=email"
                );
                return;
            }

            throw new ServletException(
                "Unable to save the doctor application.", e
            );

        } catch (IllegalArgumentException e) {
            deleteSavedFile(registrationPath);
            deleteSavedFile(degreePath);

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Please check the submitted form details."
            );
        }
    }

    private String required(HttpServletRequest request, String name)
            throws ServletException {

        String value = request.getParameter(name);

        if (value == null || value.trim().isEmpty()) {
            throw new ServletException("Missing required field: " + name);
        }

        return value.trim();
    }

    private void setOptional(PreparedStatement ps, int index, String value)
            throws SQLException {

        if (value == null || value.trim().isEmpty()) {
            ps.setNull(index, Types.VARCHAR);
        } else {
            ps.setString(index, value.trim());
        }
    }

    private void validateDocument(Part part) throws ServletException {
        if (part == null || part.getSize() == 0
                || part.getSize() > 5L * 1024 * 1024) {
            throw new ServletException(
                "Both verification documents are required and must be under 5 MB."
            );
        }

        String submittedName = part.getSubmittedFileName();

        if (submittedName == null || submittedName.trim().isEmpty()) {
            throw new ServletException("Invalid uploaded document.");
        }

        String name = Paths.get(submittedName)
                           .getFileName()
                           .toString()
                           .toLowerCase(Locale.ROOT);

        if (!(name.endsWith(".pdf") || name.endsWith(".jpg")
                || name.endsWith(".jpeg") || name.endsWith(".png"))) {
            throw new ServletException(
                "Only PDF, JPG, JPEG and PNG documents are accepted."
            );
        }

        String contentType = part.getContentType();

        if (contentType == null ||
                !(contentType.equalsIgnoreCase("application/pdf")
                  || contentType.equalsIgnoreCase("image/jpeg")
                  || contentType.equalsIgnoreCase("image/png")
                  || contentType.equalsIgnoreCase("application/octet-stream"))) {
            throw new ServletException("Unsupported document type.");
        }
    }

    private String saveDocument(Part part) throws IOException {
        String original = Paths.get(part.getSubmittedFileName())
                               .getFileName()
                               .toString()
                               .toLowerCase(Locale.ROOT);

        String extension = original.substring(original.lastIndexOf('.'));
        String filename = UUID.randomUUID().toString() + extension;

        Path destination = uploadDirectory.resolve(filename).normalize();

        if (!destination.getParent().equals(uploadDirectory)) {
            throw new IOException("Invalid upload path.");
        }

        try (InputStream input = part.getInputStream()) {
            Files.copy(input, destination, StandardCopyOption.REPLACE_EXISTING);
        }

        return filename;
    }

    private String hashPassword(String password) throws ServletException {
        byte[] salt = new byte[16];
        new SecureRandom().nextBytes(salt);

        PBEKeySpec spec = new PBEKeySpec(
            password.toCharArray(), salt, ITERATIONS, KEY_LENGTH
        );

        try {
            byte[] hash = SecretKeyFactory
                .getInstance("PBKDF2WithHmacSHA256")
                .generateSecret(spec)
                .getEncoded();

            Base64.Encoder encoder = Base64.getEncoder();

            return "pbkdf2_sha256$" + ITERATIONS + "$"
                + encoder.encodeToString(salt) + "$"
                + encoder.encodeToString(hash);

        } catch (Exception e) {
            throw new ServletException("Unable to secure the password.", e);
        } finally {
            spec.clearPassword();
        }
    }

    private void deleteSavedFile(String filename) {
        if (filename == null || uploadDirectory == null) {
            return;
        }

        try {
            Path file = uploadDirectory.resolve(filename).normalize();

            if (file.getParent().equals(uploadDirectory)) {
                Files.deleteIfExists(file);
            }
        } catch (IOException ignored) {
            // Log cleanup failures in production.
        }
    }
}
