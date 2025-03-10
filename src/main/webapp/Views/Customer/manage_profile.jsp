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
        /* General Styles */
        body {
            background-color: #f8f9fa;
            font-family: 'Poppins', sans-serif;
        }

        .container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            max-width: 600px;
        }

        /* Heading */
        .heading-container {
            background: #ffc107;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            color: #212529;
            font-weight: bold;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        /* Profile Image */
        .profile-img {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 50%;
            border: 4px solid #ffc107;
            margin-top: 10px;
        }

        /* Buttons */
        .btn-primary {
            background-color: #007BFF;
            border: none;
            transition: 0.3s ease-in-out;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            transform: scale(1.05);
        }

        /* Alerts */
        .alert {
            border-radius: 5px;
        }

        /* Form Fields */
        .form-control {
            border-radius: 5px;
            box-shadow: none;
        }
    </style>
</head>
<body>

<div class="container mt-4">
    
    <!-- Page Heading -->
    <div class="heading-container mb-4">
        <h2><i class="fas fa-user-edit"></i> Manage Profile</h2>
    </div>

    <% if (request.getParameter("success") != null) { %>
        <div class="alert alert-success"><i class="fas fa-check-circle"></i> <%= request.getParameter("success") %></div>
    <% } %>
    <% if (request.getParameter("error") != null) { %>
        <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> <%= request.getParameter("error") %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/CustomerController" method="post" enctype="multipart/form-data">
        <input type="hidden" name="action" value="updateProfile">

        <!-- Profile Picture -->
        <div class="text-center mb-3">
            <% if (loggedUser.getProfilePicture() != null) { %>
                <img src="${pageContext.request.contextPath}/GetProfilePicture?userID=<%= loggedUser.getUserID() %>" class="profile-img">
            <% } else { %>
                <img src="${pageContext.request.contextPath}/Images/default_profile.png" class="profile-img">
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
        <button type="submit" class="btn btn-primary w-100"><i class="fas fa-save"></i> Update Profile</button>
    </form>
</div>

<!-- Bootstrap JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
