<%@ page contentType="text/html;charset=UTF-8" language="java" %> 
<%@ page import="com.megacitycab.models.Driver" %>

<%
    HttpSession userSession = request.getSession(false);
    
    // Ensure session exists
    if (userSession == null || userSession.getAttribute("user") == null) {
        response.sendRedirect("../login.jsp?error=Session%20Error");
        return;
    }

    // Get user object
    Object userObj = userSession.getAttribute("user");

    // Ensure the user is a Driver
    if (!(userObj instanceof Driver)) {
        response.sendRedirect("../login.jsp?error=Unauthorized%20Access");
        return;
    }

    // Cast to Driver
    Driver loggedUser = (Driver) userObj;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Profile | Mega City Cab</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/customer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
        }
        /* Sidebar Styles */
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
        /* Main Content Adjustment */
        .content {
            margin-left: 260px;
            padding: 20px;
        }
        /* Dashboard Heading Background */
        .heading-container {
            background-color: #ffc107;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        /* Profile Container */
        .container-custom {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
            max-width: 600px;
            margin-top: 20px;
        }
        /* Profile Image */
        .profile-img {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 50%;
            border: 3px solid #ffc107;
            display: block;
            margin: 0 auto 15px;
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
        <a href="${pageContext.request.contextPath}/Views/Driver/customer_reviews.jsp"><i class="fas fa-star"></i> Reviews</a>
        <a href="${pageContext.request.contextPath}/Views/Driver/earnings_dashboard.jsp"><i class="fas fa-dollar-sign"></i> Earnings</a>
        <a href="${pageContext.request.contextPath}/Views/login.jsp?" class="text-danger"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <!-- Main Content -->
    <div class="content">
        <div class="container-custom mt-4">
            <!-- Dashboard Heading with Background -->
            <div class="heading-container mb-4">
                <h2 class="fw-bold mb-0"><i class="fas fa-user"></i> Manage Profile</h2>
            </div>

            <% if (request.getParameter("success") != null) { %>
                <div class="alert alert-success"><%= request.getParameter("success") %></div>
            <% } %>
            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-danger"><%= request.getParameter("error") %></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/UserController" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="updateDriverProfile">

                <div class="text-center mb-3">
                    <% if (loggedUser.getProfilePicture() != null) { %>
                        <img src="${pageContext.request.contextPath}/GetProfilePicture?userID=<%= loggedUser.getUserID() %>" class="profile-img">
                    <% } else { %>
                        <img src="${pageContext.request.contextPath}/Images/default_profile.png" class="profile-img">
                    <% } %>
                </div>

                <div class="mb-3">
                    <label class="fw-bold">Name</label>
                    <input type="text" class="form-control" name="name" value="<%= loggedUser.getName() %>" required>
                </div>

                <div class="mb-3">
                    <label class="fw-bold">Phone</label>
                    <input type="text" class="form-control" name="phone" value="<%= loggedUser.getPhone() %>" required>
                </div>

                <div class="mb-3">
                    <label class="fw-bold">Address</label>
                    <textarea class="form-control" name="address" required><%= loggedUser.getAddress() %></textarea>
                </div>

                <div class="mb-3">
                    <label class="fw-bold">Profile Picture</label>
                    <input type="file" class="form-control" name="profilePicture" accept="image/*">
                </div>

                <button type="submit" class="btn btn-primary w-100">Update Profile</button>
            </form>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
