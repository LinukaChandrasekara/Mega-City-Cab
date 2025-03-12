<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.megacitycab.models.*" %>
<%@ page import="com.megacitycab.dao.ReviewDAO" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    User loggedUser = (User) session.getAttribute("user");
    if (loggedUser == null || !"Customer".equalsIgnoreCase(loggedUser.getRole())) {
        response.sendRedirect("../login.jsp?error=Unauthorized Access!");
        return;
    }

    List<Review> reviews = ReviewDAO.getReviewsByCustomer(loggedUser.getUserID());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Reviews | Mega City Cab</title>

    <!-- Bootstrap & Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <!-- Custom Styles (matching other pages) -->
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Arial', sans-serif;
        }
        .sidebar {
            width: 260px;
            height: 100vh;
            position: fixed;
            background-color: #212529;
            padding-top: 20px;
            color: white;
        }
        .sidebar h4 {
            text-align: center;
            color: #FFC107;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .sidebar a {
            color: white;
            padding: 12px;
            display: block;
            text-decoration: none;
            font-size: 16px;
            transition: 0.3s;
        }
        .sidebar a i {
            margin-right: 8px;
        }
        .sidebar a:hover {
            background-color: #343a40;
            padding-left: 18px;
        }
        .main-content {
            margin-left: 260px; /* leaves space for sidebar */
            padding: 20px;
        }
        .dashboard-header {
            background-color: #FFC107;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            color: #212529;
            font-weight: bold;
            font-size: 22px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .table thead {
            background-color: #FFC107;
            color: #212529;
        }
        .btn-warning {
            background-color: #FFC107;
            border: none;
            color: #212529;
        }
        .btn-danger {
            background-color: #DC3545;
            border: none;
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <h4>Mega City Cab</h4>
    <a href="${pageContext.request.contextPath}/BookingController">
        <i class="fas fa-home"></i> Dashboard
    </a>
    <a href="${pageContext.request.contextPath}/Views/Customer/manage_profile.jsp">
        <i class="fas fa-user"></i> Manage Profile
    </a>
    <a href="${pageContext.request.contextPath}/Views/Customer/book_ride.jsp">
        <i class="fas fa-taxi"></i> Book a Ride
    </a>
    <a href="${pageContext.request.contextPath}/Views/Customer/booking_history.jsp">
        <i class="fas fa-history"></i> Booking History
    </a>
    <!-- Current page: Reviews -->
    <a href="${pageContext.request.contextPath}/Views/Customer/customer_reviews.jsp" style="background-color: #343a40; padding-left: 18px;">
        <i class="fas fa-star"></i> Reviews
    </a>
    <a href="${pageContext.request.contextPath}/Views/login.jsp" class="text-danger">
        <i class="fas fa-sign-out-alt"></i> Logout
    </a>
</div>

<!-- Main Content -->
<div class="main-content">

    <!-- Optional header to match style -->
    <div class="dashboard-header mb-4">
        My Reviews
    </div>

    <!-- Original Table & Content -->
    <div class="container mt-4">
        <h2>My Reviews</h2>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Driver</th>
                    <th>Rating</th>
                    <th>Comments</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% for (Review review : reviews) { %>
                    <tr>
                        <td><%= review.getDriverName() %></td>
                        <td><%= review.getRating() %>/5</td>
                        <td><%= review.getComments() %></td>
                        <td>
                            <a href="edit_review.jsp?reviewID=<%= review.getReviewID() %>"
                               class="btn btn-warning btn-sm">Edit</a>
                            <a href="ReviewController?action=delete&reviewID=<%= review.getReviewID() %>"
                               class="btn btn-danger btn-sm">Delete</a>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Bootstrap JS (optional) -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
