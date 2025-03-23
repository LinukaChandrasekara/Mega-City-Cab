<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.megacitycab.models.Driver" %>

<%-- Session validation --%>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("user") == null) {
        response.sendRedirect("../login.jsp?error=Session%20Error");
        return;
    }

    Object userObj = userSession.getAttribute("user");
    if (!(userObj instanceof Driver)) {
        response.sendRedirect("../login.jsp?error=Unauthorized%20Access");
        return;
    }

    Driver loggedUser = (Driver) userObj;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Profile | Mega City Cab</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <style>
        /* Consistent with dashboard styling */
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

        .heading-container {
            background-color: #ffc107;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .card-custom {
            border-radius: 10px;
            background-color: #ffffff;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 30px;
            max-width: 600px;
            margin: 20px auto;
        }

        .profile-img {
            width: 130px;
            height: 130px;
            object-fit: cover;
            border-radius: 50%;
            border: 4px solid #FFC107;
            margin: 0 auto 20px;
            display: block;
        }

        .btn-primary {
            background-color: #007BFF;
            border: none;
            padding: 10px 20px;
        }

        .btn-primary:hover {
            background-color: #0056b3;
        }

        .form-control:focus {
            border-color: #FFC107;
            box-shadow: 0 0 0 0.25rem rgba(255, 193, 7, 0.25);
        }
    </style>
</head>
<body>

<!-- Consistent Sidebar -->
<div class="sidebar">
    <h4>Mega City Cab</h4>
    <a href="${pageContext.request.contextPath}/DriverController"><i class="fas fa-home"></i> Dashboard</a>
    <a href="${pageContext.request.contextPath}/Views/Driver/manage_profile.jsp"><i class="fas fa-user"></i> Manage Profile</a>
    <a href="${pageContext.request.contextPath}/Views/Driver/manage_vehicle.jsp"><i class="fas fa-car"></i> Manage Vehicle</a>
    <a href="${pageContext.request.contextPath}/Views/Driver/available_bookings.jsp"><i class="fas fa-list"></i> Available Bookings</a>
    <a href="${pageContext.request.contextPath}/Views/Driver/driver_reviews.jsp"><i class="fas fa-star"></i> Reviews</a>
    <a href="${pageContext.request.contextPath}/Views/Driver/earnings_dashboard.jsp"><i class="fas fa-dollar-sign"></i> Earnings</a>
    <a href="${pageContext.request.contextPath}/Views/login.jsp?" class="text-danger"><i class="fas fa-sign-out-alt"></i> Logout</a>
</div>

<!-- Main Content -->
<div class="main-content">
    <!-- Matching Heading Container -->
    <div class="heading-container mb-4">
        <h2 class="mb-0"><i class="fas fa-user"></i> Manage Profile</h2>
    </div>

    <!-- Profile Card -->
    <div class="card-custom">
        <%-- Status Messages --%>
        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success"><%= request.getParameter("success") %></div>
        <% } %>
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger"><%= request.getParameter("error") %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/DriverController" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="updateProfile">

            <!-- Profile Image -->
            <div class="text-center mb-4">
                <% if (loggedUser.getProfilePicture() != null) { %>
                    <img src="${pageContext.request.contextPath}/GetProfilePicture?userID=<%= loggedUser.getUserID() %>" 
                         class="profile-img" alt="Profile Picture">
                <% } else { %>
                    <img src="${pageContext.request.contextPath}/images/default-profile.jpg" 
                         class="profile-img" alt="Default Profile">
                <% } %>
            </div>

            <!-- Form Fields -->
            <div class="mb-3">
                <label class="form-label fw-bold">Full Name</label>
                <input type="text" class="form-control" name="name" 
                       value="<%= loggedUser.getName() %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Phone Number</label>
                <input type="tel" class="form-control" name="phone" 
                       value="<%= loggedUser.getPhone() %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Address</label>
                <textarea class="form-control" name="address" rows="3" required><%= loggedUser.getAddress() %></textarea>
            </div>

            <div class="mb-4">
                <label class="form-label fw-bold">Update Profile Picture</label>
                <input type="file" class="form-control" name="profilePicture" accept="image/*">
            </div>

            <button type="submit" class="btn btn-primary w-100">
                <i class="fas fa-save me-2"></i>Update Profile
            </button>
        </form>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>