<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Purchased Pets - Test</title>
</head>
<body>

<h1>My Purchased Pets</h1>

<%
    List<Map<String, Object>> myPets =
        (List<Map<String, Object>>) request.getAttribute("myPets");

    if (myPets != null && !myPets.isEmpty()) {
        for (Map<String, Object> pet : myPets) {
%>

    <div style="border:1px solid #ccc; padding:15px; margin:10px 0;">

        <h2><%= pet.get("name") %></h2>

        <p>Breed: <%= pet.get("breed") %></p>

        <p>Animal: <%= pet.get("animalType") %></p>

        <p>Age: <%= pet.get("age") %></p>

        <p>Gender: <%= pet.get("gender") %></p>

        <p>Price: ₹<%= pet.get("price") %></p>

        <p>Location: <%= pet.get("location") %></p>

        <p>Status: <%= pet.get("status") %></p>

    </div>

<%
        }
    } else {
%>

    <p>You haven't purchased any pets yet.</p>

<%
    }
%>

</body>
</html>