
package com.petcare.servlet;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.nio.file.InvalidPathException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.petcare.util.DBConnection;

@WebServlet("/DoctorCertificateServlet")
public class DoctorCertificateServlet extends HttpServlet {

    private Path uploadDirectory;

    @Override
    public void init() throws ServletException {
        String directory = System.getProperty("petcare.upload.dir");

        if (directory == null || directory.trim().isEmpty()) {
            throw new ServletException(
                "Missing petcare.upload.dir configuration."
            );
        }

        try {
            uploadDirectory = Paths.get(directory)
                                  .toAbsolutePath()
                                  .normalize();
        } catch (InvalidPathException e) {
            throw new ServletException("Invalid upload directory.", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            !Boolean.TRUE.equals(session.getAttribute("isAdmin"))) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String idText = request.getParameter("id");
        String type = request.getParameter("type");

        if (idText == null ||
            !idText.matches("\\d+") ||
            !("registration".equals(type) || "degree".equals(type))) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int doctorId;

        try {
            doctorId = Integer.parseInt(idText);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String column = "registration".equals(type)
            ? "registration_certificate"
            : "degree_certificate";

        String filename = null;

        String sql = "SELECT " + column +
                     " FROM doctor_applications WHERE id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                 connection.prepareStatement(sql)) {

            statement.setInt(1, doctorId);

            try (ResultSet result = statement.executeQuery()) {
                if (result.next()) {
                    filename = result.getString(1);
                }
            }

        } catch (Exception e) {
            throw new ServletException(
                "Unable to retrieve doctor certificate.", e
            );
        }

        if (filename == null || filename.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Only allow generated UUID-style filenames and known extensions.
        if (!filename.matches(
                "[a-fA-F0-9-]{36}\\.(pdf|jpg|jpeg|png)")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        Path file = uploadDirectory.resolve(filename).normalize();

        if (!file.startsWith(uploadDirectory) ||
            !Files.isRegularFile(file) ||
            !Files.isReadable(file)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String contentType = Files.probeContentType(file);

        if (contentType == null ||
            !(contentType.equals("application/pdf") ||
              contentType.equals("image/jpeg") ||
              contentType.equals("image/png"))) {
            response.sendError(HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE);
            return;
        }

        response.setContentType(contentType);
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader("Content-Security-Policy", "default-src 'none'; sandbox");
        response.setHeader("Content-Disposition",
                           "inline; filename=\"doctor-certificate\"");
        response.setContentLengthLong(Files.size(file));

        try (InputStream input = Files.newInputStream(file);
             java.io.OutputStream output = response.getOutputStream()) {

            byte[] buffer = new byte[8192];
            int length;

            while ((length = input.read(buffer)) != -1) {
                output.write(buffer, 0, length);
            }
        }
    }
}
