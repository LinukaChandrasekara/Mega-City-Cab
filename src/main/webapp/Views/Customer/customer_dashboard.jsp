<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="com.megacitycab.models.*" %>

<%
    User loggedUser = (User) session.getAttribute("user");

    if (loggedUser == null || !"Customer".equalsIgnoreCase(loggedUser.getRole())) {
        response.sendRedirect("../login.jsp?error=Unauthorized Access!");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Dashboard | Mega City Cab</title>

    <!-- Bootstrap & Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <!-- Custom Styles -->
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
        .profile-img {
            width: 130px;
            height: 130px;
            object-fit: cover;
            border-radius: 50%;
            border: 3px solid #FFC107;
            margin-top: 10px;
        }
        .card-custom {
            border-radius: 10px;
            background-color: #ffffff;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border: none;
        }
        .quick-action-card {
            text-align: center;
            padding: 15px;
            border-radius: 10px;
            font-size: 18px;
            color: white;
            font-weight: bold;
        }
        .table thead {
            background-color: #FFC107;
            color: #212529;
        }
        .btn-primary {
            background-color: #007BFF;
            border: none;
        }
        .btn-warning {
            background-color: #FFC107;
            border: none;
            color: #212529;
        }
        .btn-danger {
            background-color: #DC3545;
        }
    </style>
</head>
<body>


<!-- Sidebar -->
<div class="sidebar">
    <h4>Mega City Cab</h4>
            <a href="${pageContext.request.contextPath}/BookingController?action=dashboard"><i class="fas fa-home"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/Views/Customer/manage_profile.jsp" class="nav-link text-white"><i class="fas fa-user"></i> Manage Profile</a>
            <a href="${pageContext.request.contextPath}/Views/Customer/book_ride.jsp?" class="nav-link text-white"><i class="fas fa-taxi"></i> Book a Ride</a>
            <a href="${pageContext.request.contextPath}/Views/Customer/booking_history.jsp" class="nav-link text-white"><i class="fas fa-history"></i> Booking History</a>
            <a href="${pageContext.request.contextPath}/Views/Customer/customer_reviews.jsp" class="nav-link text-white"><i class="fas fa-star"></i> Reviews</a>
            <a href="${pageContext.request.contextPath}/Views/login.jsp?" class="nav-link text-danger"><i class="fas fa-sign-out-alt"></i> Logout</a>
</div>

<!-- Main Content -->
<div class="main-content">
    <!-- Dashboard Header -->
    <div class="dashboard-header">
        Customer Dashboard
    </div>

    <!-- Profile Section -->
    <div class="card card-custom p-3 my-4">
        <div class="row align-items-center">
            <div class="col-md-3 text-center">
                <img src="<%= loggedUser.getProfilePicture() != null ? "data:image/png;base64," + new String(java.util.Base64.getEncoder().encode(loggedUser.getProfilePicture())) : "${pageContext.request.contextPath}/Images/default_customer.png" %>" class="profile-img">
            </div>
            <div class="col-md-9">
                <h4 class="mb-1">Hi, <%= loggedUser.getName() %>!</h4>
                <p><i class="fas fa-envelope"></i> Email: <%= loggedUser.getEmail() %></p>
                <p><i class="fas fa-phone"></i> Phone: <%= loggedUser.getPhone() %></p>
                <a href="${pageContext.request.contextPath}/Views/Customer/manage_profile.jsp" class="btn btn-warning btn-sm">Edit Profile</a>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="row">
        <div class="col-md-6">
            <div class="quick-action-card bg-primary">
                <h5><i class="fas fa-taxi"></i> Book a Ride</h5>
                <a href="${pageContext.request.contextPath}/Views/Customer/book_ride.jsp?" class="btn btn-light btn-sm">Start Booking</a>
            </div>
        </div>
        <div class="col-md-6">
            <div class="quick-action-card bg-success">
                <h5><i class="fas fa-history"></i> View Booking History</h5>
                <a href="${pageContext.request.contextPath}/Views/Customer/booking_history.jsp" class="btn btn-light btn-sm">View History</a>
            </div>
        </div>
    </div>

    <!-- Recent Bookings -->
    <div class="card card-custom p-3 mt-4">
        <h5><i class="fas fa-clock"></i> Recent Bookings</h5>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Booking ID</th>
                    <th>Pickup</th>
                    <th>Drop-off</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <% List<Booking> recentBookings = (List<Booking>) request.getAttribute("recentBookings"); %>
                <% for (Booking booking : recentBookings) { %>
                    <tr>
                        <td><%= booking.getBookingID() %></td>
                        <td><%= booking.getPickupLat() + ", " + booking.getPickupLng() %></td>
                        <td><%= booking.getDropoffLat() + ", " + booking.getDropoffLng() %></td>
                        <td><%= booking.getStatus() %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
        <a href="${pageContext.request.contextPath}/Views/Customer/booking_history.jsp" class="btn btn-warning btn-sm">See All</a>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

</body>
</html>
