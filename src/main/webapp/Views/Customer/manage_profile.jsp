<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.megacitycab.models.User" %>

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
    <title>Manage Profile | Mega City Cab</title>

    <!-- Bootstrap & Icons -->
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
        .dashboard-header {
            background-color: #FFC107;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            color: #212529;
            font-weight: bold;
            font-size: 22px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
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
            padding: 30px;
            max-width: 600px;
            margin: 0 auto;
        }
        .form-control {
            border-radius: 5px;
            box-shadow: none;
            border: 1px solid #ced4da;
        }
        .form-control:focus {
            border-color: #FFC107;
            box-shadow: 0 0 0 0.2rem rgba(255, 193, 7, 0.25);
        }
        .btn-warning {
            background-color: #FFC107;
            border: none;
            color: #212529;
            transition: 0.3s;
        }
        .btn-warning:hover {
            background-color: #e0a800;
            transform: translateY(-1px);
        }
        .alert {
            border-radius: 8px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<!-- Sidebar Navigation -->
<div class="sidebar">
    <h4>Mega City Cab</h4>
    <a href="${pageContext.request.contextPath}/BookingController?action=dashboard"><i class="fas fa-home"></i> Dashboard</a>
    <a href="${pageContext.request.contextPath}/Views/Customer/manage_profile.jsp" class="nav-link text-white">
        <i class="fas fa-user"></i> Manage Profile
    </a>
    <a href="${pageContext.request.contextPath}/Views/Customer/book_ride.jsp?" class="nav-link text-white">
        <i class="fas fa-taxi"></i> Book a Ride
    </a>
    <a href="${pageContext.request.contextPath}/Views/Customer/booking_history.jsp" class="nav-link text-white">
        <i class="fas fa-history"></i> Booking History
    </a>
    <a href="${pageContext.request.contextPath}/Views/Customer/customer_reviews.jsp" class="nav-link text-white">
        <i class="fas fa-star"></i> Reviews
    </a>
    <a href="${pageContext.request.contextPath}/Views/login.jsp?" class="nav-link text-danger">
        <i class="fas fa-sign-out-alt"></i> Logout
    </a>
</div>

<!-- Main Content -->
<div class="main-content">
    <div class="container mt-4">
        <!-- Page Heading -->
        <div class="heading-container mb-4">
            <h2><i class="fas fa-user-edit"></i> Manage Profile</h2>
        </div>

        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> <%= request.getParameter("success") %>
            </div>
        <% } %>
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i> <%= request.getParameter("error") %>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/CustomerController" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="updateProfile">

            <!-- Profile Picture -->
            <div class="text-center mb-3">
                <% if (loggedUser.getProfilePicture() != null) { %>
                    <img src="${pageContext.request.contextPath}/GetProfilePicture?userID=<%= loggedUser.getUserID() %>" 
                         class="profile-img" alt="Profile Picture">
                <% } else { %>
                    <img src="${pageContext.request.contextPath}/Images/default_profile.png" 
                         class="profile-img" alt="Default Profile">
                <% } %>
            </div>

            <!-- Name -->
            <div class="mb-3">
                <label><i class="fas fa-user"></i> Name</label>
                <input type="text" class="form-control" name="name" value="<%= loggedUser.getName() %>" required>
            </div>

            <!-- Phone -->
            <div class="mb-3">
                <label><i class="fas fa-phone"></i> Phone</label>
                <input type="text" class="form-control" name="phone" value="<%= loggedUser.getPhone() %>" required>
            </div>

            <!-- Address -->
            <div class="mb-3">
                <label><i class="fas fa-map-marker-alt"></i> Address</label>
                <textarea class="form-control" name="address" required><%= loggedUser.getAddress() %></textarea>
            </div>

            <!-- Profile Picture Upload -->
            <div class="mb-3">
                <label><i class="fas fa-image"></i> Profile Picture</label>
                <input type="file" class="form-control" name="profilePicture" accept="image/*">
            </div>

            <!-- Submit Button -->
            <button type="submit" class="btn btn-primary w-100">
                <i class="fas fa-save"></i> Update Profile
            </button>
        </form>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
