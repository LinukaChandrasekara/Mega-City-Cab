<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="com.megacitycab.models.User" %>

<%
    User loggedUser = (User) session.getAttribute("user");

    if (loggedUser == null || !"Customer".equalsIgnoreCase(loggedUser.getRole())) {
        response.sendRedirect("${pageContext.request.contextPath}/Views/login.jsp?error=Unauthorized%20Access");
        return;
    }

    List<Map<String, String>> reviews = (List<Map<String, String>>) request.getAttribute("customerReviews");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reviews | Mega City Cab</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/customer.css">
</head>
<body>

<div class="container mt-4">
    <h2 class="text-warning">Customer Reviews</h2>

    <table class="table table-dark table-striped">
        <thead>
            <tr>
                <th>Driver</th>
                <th>Rating</th>
                <th>Comments</th>
                <th>Date</th>
            </tr>
        </thead>
        <tbody>
            <% for (Map<String, String> review : reviews) { %>
                <tr>
                    <td><%= review.get("DriverName") %></td>
                    <td>⭐ <%= review.get("Rating") %>/5</td>
                    <td><%= review.get("Comments") %></td>
                    <td><%= review.get("ReviewDate") %></td>
                </tr>
            <% } %>
        </tbody>
    </table>

    <h3 class="mt-4">Submit a Review</h3>
    <form action="${pageContext.request.contextPath}/ReviewController" method="post">
        <input type="hidden" name="action" value="addReview">
        <div class="mb-3">
            <label>Driver ID</label>
            <input type="number" class="form-control" name="driverID" required>
        </div>
        <div class="mb-3">
            <label>Rating (1-5)</label>
            <input type="number" class="form-control" name="rating" min="1" max="5" required>
        </div>
        <div class="mb-3">
            <label>Comments</label>
            <textarea class="form-control" name="comments" required></textarea>
        </div>
        <button type="submit" class="btn btn-primary">Submit Review</button>
    </form>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
