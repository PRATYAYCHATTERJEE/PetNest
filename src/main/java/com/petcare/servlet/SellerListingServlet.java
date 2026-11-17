
package com.petcare.servlet;

import com.petcare.util.DBConnection;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.util.UUID;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/SellerListingServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 7 * 1024 * 1024
)
public class SellerListingServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final long MAX_IMAGE_SIZE = 5L * 1024 * 1024;

    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        return session != null
                && Boolean.TRUE.equals(session.getAttribute("sellerLoggedIn"))
                && session.getAttribute("sellerId") != null;
    }

    private int getSellerId(HttpServletRequest request) {
        return Integer.parseInt(
            String.valueOf(
                request.getSession(false).getAttribute("sellerId")
            )
        );
    }

    private String clean(String value) {
        return value == null ? "" : value.trim();
    }

    private void sendJson(HttpServletResponse response, String json)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
    }

    private String jsonEscape(String value) {
        if (value == null) {
            return "";
        }

        return value.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t");
    }

    private boolean isApprovedSeller(Connection con, int sellerId)
            throws SQLException {

        String sql =
            "SELECT id FROM seller_applications " +
            "WHERE id = ? AND application_status = 'APPROVED'";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, sellerId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    private void redirectError(
            HttpServletRequest request,
            HttpServletResponse response,
            String reason) throws IOException {

        response.sendRedirect(
            request.getContextPath()
            + "/seller-dashboard.jsp?uploadError=" + reason
        );
    }

    // =========================================================
    // GET: Load listings belonging to the logged-in seller
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        if (!isLoggedIn(request)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);

            sendJson(response,
                "{\"success\":false,\"message\":\"Please log in again.\"}");
            return;
        }

        int sellerId = getSellerId(request);

        String sql =
            "SELECT id, listing_type, title, description, category, " +
            "animal_type, breed, age, gender, weight, size, location, " +
            "food_animal_type, quantity, price, image " +
            "FROM seller_listings " +
            "WHERE seller_id = ? ORDER BY id DESC";

        StringBuilder json = new StringBuilder();
        json.append("{\"success\":true,\"listings\":[");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, sellerId);

            try (ResultSet rs = ps.executeQuery()) {
                boolean first = true;

                while (rs.next()) {
                    if (!first) {
                        json.append(",");
                    }

                    first = false;

                    json.append("{")
                        .append("\"id\":").append(rs.getInt("id")).append(",")
                        .append("\"listingType\":\"")
                        .append(jsonEscape(rs.getString("listing_type"))).append("\",")
                        .append("\"title\":\"")
                        .append(jsonEscape(rs.getString("title"))).append("\",")
                        .append("\"description\":\"")
                        .append(jsonEscape(rs.getString("description"))).append("\",")
                        .append("\"category\":\"")
                        .append(jsonEscape(rs.getString("category"))).append("\",")
                        .append("\"animalType\":\"")
                        .append(jsonEscape(rs.getString("animal_type"))).append("\",")
                        .append("\"breed\":\"")
                        .append(jsonEscape(rs.getString("breed"))).append("\",")
                        .append("\"age\":\"")
                        .append(jsonEscape(rs.getString("age"))).append("\",")
                        .append("\"gender\":\"")
                        .append(jsonEscape(rs.getString("gender"))).append("\",")
                        .append("\"weight\":\"")
                        .append(jsonEscape(rs.getString("weight"))).append("\",")
                        .append("\"size\":\"")
                        .append(jsonEscape(rs.getString("size"))).append("\",")
                        .append("\"location\":\"")
                        .append(jsonEscape(rs.getString("location"))).append("\",")
                        .append("\"foodAnimalType\":\"")
                        .append(jsonEscape(rs.getString("food_animal_type"))).append("\",")
                        .append("\"quantity\":").append(rs.getInt("quantity")).append(",")
                        .append("\"price\":")
                        .append(rs.getBigDecimal("price")).append(",")
                        .append("\"image\":\"")
                        .append(jsonEscape(rs.getString("image"))).append("\"")
                        .append("}");
                }
            }

            json.append("]}");
            sendJson(response, json.toString());

        } catch (SQLException e) {
            e.printStackTrace();

            response.setStatus(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            );

            sendJson(response,
                "{\"success\":false,\"message\":\"Unable to load listings.\"}");
        }
    }

    // =========================================================
    // POST: Upload a pet or product
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        if (!isLoggedIn(request)) {
            response.sendRedirect(
                request.getContextPath() + "/seller-login.jsp"
            );
            return;
        }

        int sellerId = getSellerId(request);

        String title = clean(request.getParameter("title"));
        String description = clean(request.getParameter("description"));
        String category = clean(request.getParameter("category"));

        String animalType = clean(request.getParameter("animalType"));
        String breed = clean(request.getParameter("breed"));
        String age = clean(request.getParameter("age"));
        String gender = clean(request.getParameter("gender"));
        String weight = clean(request.getParameter("weight"));
        String size = clean(request.getParameter("size"));
        String location = clean(request.getParameter("location"));

        String foodAnimalType =
            clean(request.getParameter("foodAnimalType"));

        String sellerType = clean(
            String.valueOf(
                request.getSession(false).getAttribute("sellerType")
            )
        );

        boolean petSeller = "PET_SELLER".equals(sellerType);

        if (!petSeller && !"PRODUCT_SELLER".equals(sellerType)) {
            redirectError(request, response, "sellerType");
            return;
        }

        String listingType = petSeller ? "PET" : "PRODUCT";

        // Validate title
        if (title.isEmpty() || title.length() > 150) {
            redirectError(request, response, "invalid");
            return;
        }

        // Validate product category and food animal
        if (!petSeller) {
            if (!category.equals("Pet Foods")
                    && !category.equals("Health Care")
                    && !category.equals("Dress & Accessories")) {

                redirectError(request, response, "category");
                return;
            }

            if (category.equals("Pet Foods")) {
                if (!foodAnimalType.equals("Dog")
                        && !foodAnimalType.equals("Cat")
                        && !foodAnimalType.equals("Bird")
                        && !foodAnimalType.equals("Fish")
                        && !foodAnimalType.equals("Rabbit")
                        && !foodAnimalType.equals("Other")) {

                    redirectError(request, response, "animal");
                    return;
                }
            } else {
                foodAnimalType = "";
            }
        }

        // Validate price
        BigDecimal price;

        try {
            price = new BigDecimal(
                clean(request.getParameter("price"))
            );

            if (price.compareTo(BigDecimal.ZERO) <= 0
                    || price.scale() > 2
                    || price.precision() > 10) {
                redirectError(request, response, "price");
                return;
            }

        } catch (NumberFormatException | NullPointerException e) {
            redirectError(request, response, "price");
            return;
        }

        // Validate product quantity
        int quantity = 1;

        if (!petSeller) {
            try {
                quantity = Integer.parseInt(
                    clean(request.getParameter("quantity"))
                );

                if (quantity < 1) {
                    redirectError(request, response, "quantity");
                    return;
                }

            } catch (NumberFormatException e) {
                redirectError(request, response, "quantity");
                return;
            }
        }

        // Read and validate image
        Part imagePart;

        try {
            imagePart = request.getPart("image");

        } catch (IllegalStateException e) {
            redirectError(request, response, "image");
            return;
        }

        if (imagePart == null
                || imagePart.getSize() <= 0
                || imagePart.getSize() > MAX_IMAGE_SIZE) {

            redirectError(request, response, "image");
            return;
        }

        String submittedName = imagePart.getSubmittedFileName();

        if (submittedName == null || submittedName.trim().isEmpty()) {
            redirectError(request, response, "image");
            return;
        }

        // Use only the extension; never use the original filename as a path.
        String extension = "";
        int dot = submittedName.lastIndexOf('.');

        if (dot >= 0) {
            extension = submittedName.substring(dot).toLowerCase();
        }

        if (!extension.equals(".jpg")
                && !extension.equals(".jpeg")
                && !extension.equals(".png")
                && !extension.equals(".webp")) {

            redirectError(request, response, "image");
            return;
        }

        String contentType = imagePart.getContentType();

        if (contentType == null
                || !(contentType.equalsIgnoreCase("image/jpeg")
                || contentType.equalsIgnoreCase("image/png")
                || contentType.equalsIgnoreCase("image/webp"))) {

            redirectError(request, response, "image");
            return;
        }

        // Resolve image upload directory
        String realPath =
            getServletContext().getRealPath("/uploads/seller-listings");

        if (realPath == null) {
            redirectError(request, response, "storage");
            return;
        }

        File uploadDir = new File(realPath);

        if (!uploadDir.exists() && !uploadDir.mkdirs()) {
            redirectError(request, response, "storage");
            return;
        }

        String fileName = UUID.randomUUID().toString() + extension;
        File savedFile = new File(uploadDir, fileName);

        if (!savedFile.getCanonicalPath().startsWith(
                uploadDir.getCanonicalPath() + File.separator)) {

            redirectError(request, response, "image");
            return;
        }

        String sql =
            "INSERT INTO seller_listings " +
            "(seller_id, listing_type, title, description, category, " +
            "animal_type, breed, age, gender, weight, size, location, " +
            "is_food_item, food_animal_type, quantity, price, image) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        boolean imageSaved = false;

        try (Connection con = DBConnection.getConnection()) {

            // Only approved sellers can upload listings.
            if (!isApprovedSeller(con, sellerId)) {
                redirectError(request, response, "approval");
                return;
            }

            // Save uploaded image
            try (java.io.InputStream input = imagePart.getInputStream()) {
                Files.copy(input, savedFile.toPath());
                imageSaved = true;
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, sellerId);
                ps.setString(2, listingType);
                ps.setString(3, title);
                ps.setString(4, description);

                ps.setString(5, petSeller ? null : category);

                ps.setString(6, petSeller ? animalType : null);
                ps.setString(7, petSeller ? breed : null);
                ps.setString(8, petSeller ? age : null);
                ps.setString(9, petSeller ? gender : null);
                ps.setString(10, petSeller ? weight : null);
                ps.setString(11, petSeller ? size : null);
                ps.setString(12, petSeller ? location : null);

                boolean foodItem =
                    !petSeller && "Pet Foods".equals(category);

                ps.setBoolean(13, foodItem);
                ps.setString(14, foodItem ? foodAnimalType : null);

                ps.setInt(15, quantity);
                ps.setBigDecimal(16, price);
                ps.setString(17, fileName);

                int rowsInserted = ps.executeUpdate();

                if (rowsInserted == 1) {
                    // Display the success page only after the insert succeeds.
                    response.sendRedirect(
                        request.getContextPath() + "/listing-success.jsp"
                    );
                    return;
                }

                throw new SQLException("Listing was not inserted.");

            } catch (SQLException e) {
                if (imageSaved) {
                    Files.deleteIfExists(savedFile.toPath());
                    imageSaved = false;
                }

                throw e;
            }

        } catch (SQLException e) {
            e.printStackTrace();

            if (imageSaved) {
                Files.deleteIfExists(savedFile.toPath());
            }

            redirectError(request, response, "save");
        }
    }
}
