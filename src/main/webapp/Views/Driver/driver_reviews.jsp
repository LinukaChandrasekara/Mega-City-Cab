<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.megacitycab.models.*" %>
<%@ page import="com.megacitycab.dao.ReviewDAO" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"Driver".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    List<Review> reviews = ReviewDAO.getReviewsByDriver(user.getUserID());
    double avgRating = ReviewDAO.getAverageRating(user.getUserID());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Driver Reviews | Mega City Cab</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
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
        .sidebar a:hover {
            background-color: #343a40;
            padding-left: 18px;
        }
        .main-content {
            margin-left: 260px;
            padding: 20px;
        }
        .card-custom {
            border-radius: 10px;
            background-color: #ffffff;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border: none;
        }
        .rating-card {
            background-color: #FFC107;
            color: #212529;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .table thead {
            background-color: #FFC107;
            color: #212529;
        }
        .star-rating {
            color: #FFC107;
            font-size: 1.2rem;
        }
        .profile-img-sm {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #FFC107;
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <h4>Mega City Cab</h4>
    <a href="${pageContext.request.contextPath}/DriverController"><i class="fas fa-home"></i> Dashboard</a>
    <a href="${pageContext.request.contextPath}/Views/Driver/manage_profile.jsp"><i class="fas fa-user"></i> Manage Profile</a>
    <a href="${pageContext.request.contextPath}/Views/Driver/manage_vehicle.jsp"><i class="fas fa-car"></i> Manage Vehicle</a>
    <a href="${pageContext.request.contextPath}/Views/Driver/available_bookings.jsp"><i class="fas fa-list"></i> Available Bookings</a>
    <a href="${pageContext.request.contextPath}/Views/Driver/driver_reviews.jsp" style="background-color: #343a40; padding-left: 18px;">
        <i class="fas fa-star"></i> Reviews
    </a>
    <a href="${pageContext.request.contextPath}/Views/Driver/earnings_dashboard.jsp"><i class="fas fa-dollar-sign"></i> Earnings</a>
    <a href="${pageContext.request.contextPath}/Views/login.jsp" class="text-danger"><i class="fas fa-sign-out-alt"></i> Logout</a>
</div>

<!-- Main Content -->
<div class="main-content">
    <div class="card card-custom p-4">
        <div class="rating-card">
            <h3 class="mb-0">
                <i class="fas fa-star"></i> 
                Driver Rating: <%= String.format("%.1f", avgRating) %>/5
                <small class="text-muted">(Based on <%= reviews.size() %> reviews)</small>
            </h3>
        </div>

        <% if (request.getAttribute("message") != null) { %>
            <div class="alert alert-info alert-dismissible fade show mt-3">
                <%= request.getAttribute("message") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="table-responsive">
            <table class="table table-striped align-middle">
                <thead>
                    <tr>
                        <th>Customer</th>
                        <th>Rating</th>
                        <th>Comments</th>
                        <th>Date</th>
                        <th>Booking ID</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Review review : reviews) { %>
                    <tr>
                        <td>
                            <div class="d-flex align-items-center">
                                <img src="${pageContext.request.contextPath}/GetProfilePicture?userID=<%= review.getCustomerID() %>" 
                                     class="profile-img-sm me-2" 
                                     alt="Customer image">
                                <%= review.getCustomerName() %>
                            </div>
                        </td>
                        <td>
                            <div class="star-rating">
                                <% for(int i=0; i<review.getRating(); i++) { %>
                                    <i class="fas fa-star"></i>
                                <% } %>
                                <% for(int i=review.getRating(); i<5; i++) { %>
                                    <i class="far fa-star"></i>
                                <% } %>
                            </div>
                        </td>
                        <td><%= review.getComments() %></td>
                        <td><%= review.getReviewDate().toString().split(" ")[0] %></td>
                        <td>#<%= review.getBookingID() %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <% if (reviews.isEmpty()) { %>
            <div class="alert alert-warning mt-3">
                No reviews found yet. Complete more rides to get reviews!
            </div>
        <% } %>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>