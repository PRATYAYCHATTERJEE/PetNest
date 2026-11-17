package com.petcare.servlet;

import com.petcare.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/MarketplaceListingsServlet")
public class MarketplaceListingsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store");

        String sql =
            "SELECT sl.id, sl.seller_id, sl.listing_type, " +
            "sl.title, sl.description, sl.category, " +
            "sl.animal_type, sl.breed, sl.age, sl.gender, " +
            "sl.weight, sl.size, sl.location, sl.is_food_item, " +
            "sl.food_animal_type, sl.quantity, sl.price, sl.image " +
            "FROM seller_listings sl " +
            "INNER JOIN seller_applications sa " +
            "ON sa.id = sl.seller_id " +
            "WHERE UPPER(sa.application_status) = 'APPROVED' " +
            "ORDER BY sl.id DESC";

        StringBuilder pets = new StringBuilder();
        StringBuilder products = new StringBuilder();

        pets.append("[");
        products.append("[");

        boolean firstPet = true;
        boolean firstProduct = true;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                String type = rs.getString("listing_type");

                StringBuilder target;
                boolean isFirst;

                if ("PET".equalsIgnoreCase(type)) {
                    target = pets;
                    isFirst = firstPet;
                    firstPet = false;
                } else if ("PRODUCT".equalsIgnoreCase(type)) {
                    target = products;
                    isFirst = firstProduct;
                    firstProduct = false;
                } else {
                    continue;
                }

                if (!isFirst) {
                    target.append(",");
                }

                String image = rs.getString("image");
                String imageUrl = "";

                if (image != null && !image.trim().isEmpty()) {
                    imageUrl = request.getContextPath()
                            + "/uploads/seller-listings/"
                            + image;
                }

                target.append("{");

                addField(target, "id",
                        String.valueOf(rs.getInt("id")), false, true);

                addField(target, "sellerId",
                        String.valueOf(rs.getInt("seller_id")), true, true);

                addField(target, "listingType",
                        rs.getString("listing_type"), true, false);

                addField(target, "title",
                        rs.getString("title"), true, false);

                addField(target, "description",
                        rs.getString("description"), true, false);

                addField(target, "category",
                        rs.getString("category"), true, false);

                addField(target, "animalType",
                        rs.getString("animal_type"), true, false);

                addField(target, "breed",
                        rs.getString("breed"), true, false);

                addField(target, "age",
                        rs.getString("age"), true, false);

                addField(target, "gender",
                        rs.getString("gender"), true, false);

                addField(target, "weight",
                        rs.getString("weight"), true, false);

                addField(target, "size",
                        rs.getString("size"), true, false);

                addField(target, "location",
                        rs.getString("location"), true, false);

                addField(target, "isFoodItem",
                        rs.getBoolean("is_food_item") ? "true" : "false",
                        true, true);

                addField(target, "foodAnimalType",
                        rs.getString("food_animal_type"), true, false);

                addField(target, "quantity",
                        String.valueOf(rs.getInt("quantity")), true, true);

                addField(target, "price",
                        String.valueOf(rs.getBigDecimal("price")), true, true);

                addField(target, "imageUrl",
                        imageUrl, true, false);

                target.append("}");
            }

            pets.append("]");
            products.append("]");

            try (PrintWriter out = response.getWriter()) {
                out.print("{\"success\":true,\"pets\":");
                out.print(pets);
                out.print(",\"products\":");
                out.print(products);
                out.print("}");
            }

        } catch (Exception e) {
            e.printStackTrace();

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

            try (PrintWriter out = response.getWriter()) {
                out.print(
                    "{\"success\":false," +
                    "\"message\":\"Unable to load marketplace listings.\"}"
                );
            }
        }
    }

    private void addField(StringBuilder json,
                          String key,
                          String value,
                          boolean addComma,
                          boolean rawValue) {

        if (addComma) {
            json.append(",");
        }

        json.append("\"")
            .append(escapeJson(key))
            .append("\":");

        if (rawValue) {
            json.append(value == null ? "null" : value);
        } else {
            json.append("\"")
                .append(escapeJson(value))
                .append("\"");
        }
    }

    private String escapeJson(String value) {

        if (value == null) {
            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}