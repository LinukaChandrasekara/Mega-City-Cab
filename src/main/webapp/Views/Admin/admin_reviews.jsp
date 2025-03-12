<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.megacitycab.models.*" %>
<%@ page import="com.megacitycab.dao.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    // Ensure only Admin users can access
    HttpSession userSession = request.getSession(false);
    if (userSession == null 
        || userSession.getAttribute("userRole") == null 
        || !"Admin".equals(userSession.getAttribute("userRole"))) {
        
        response.sendRedirect("../login.jsp?error=Unauthorized Access!");
        return;
    }

    // Retrieve all reviews
    List<Review> reviews = ReviewDAO.getAllReviews();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>All Reviews | Mega City Cab</title>

    <!-- Bootstrap & Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <!-- Custom Styles (matching other admin pages) -->
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
        }
        .sidebar h4 {
            text-align: center;
            color: #FFC107;
            font-weight: bold;
        }
        .sidebar a {
            color: white;
            padding: 12px;
            display: flex;
            align-items: center;
            text-decoration: none;
            font-size: 16px;
            transition: 0.3s;
        }
        .sidebar a i {
            margin-right: 10px;
        }
        .sidebar a:hover {
            background-color: #343a40;
            padding-left: 18px;
        }
        .main-content {
            margin-left: 260px; /* Leave space for sidebar */
            padding: 20px;
        }
        .dashboard-header {
            background-color: #FFC107;
            padding: 15px;
            text-align: center;
            border-radius: 5px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
        }
        .dashboard-header h2 {
            margin: 0;
            font-weight: bold;
        }
        .card-custom {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border: none;
        }
        .table-dark thead {
            background-color: #FFC107;
            color: #212529;
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <h4>Mega City Cab</h4>
    <a href="${pageContext.request.contextPath}/AdminController?action=dashboard">
        <i class="fas fa-home"></i> Dashboard
    </a>
    <a href="${pageContext.request.contextPath}/UserController">
        <i class="fas fa-users"></i> Manage Users
    </a>
    <!-- IMPORTANT: For "Manage Bookings," link a servlet that sets bookings -->
    <a href="${pageContext.request.contextPath}/BookingController?action=manage">
        <i class="fas fa-car"></i> Manage Bookings
    </a>
    <a href="${pageContext.request.contextPath}/DriverController">
        <i class="fas fa-id-card"></i> Manage Drivers
    </a>
    <a href="${pageContext.request.contextPath}/Views/Admin/reports.jsp">
        <i class="fas fa-chart-bar"></i> Reports
    </a>
    <!-- Current Page: Reviews -->
    <a href="${pageContext.request.contextPath}/Views/Admin/admin_reviews.jsp" 
       style="background-color: #343a40; padding-left: 18px;">
        <i class="fas fa-comments"></i> Reviews
    </a>
    <a href="${pageContext.request.contextPath}/Views/Admin/settings.jsp">
        <i class="fas fa-cogs"></i> Settings
    </a>
    <a href="${pageContext.request.contextPath}/Views/login.jsp?" class="text-danger">
        <i class="fas fa-sign-out-alt"></i> Logout
    </a>
</div>

<!-- Main Content -->
<div class="main-content">
    <!-- Optional header if you want a similar look as your other admin pages -->
    <div class="dashboard-header mb-4">
        <h2>All Customer Reviews</h2>
    </div>

    <!-- Reviews Table -->
    <div class="container">
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Customer</th>
                    <th>Driver</th>
                    <th>Rating</th>
                    <th>Comments</th>
                    <th>Date</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% for (Review review : reviews) { %>
                    <tr>
                        <td><%= review.getCustomerName() %></td>
                        <td><%= review.getDriverName() %></td>
                        <td><%= review.getRating() %>/5</td>
                        <td><%= review.getComments() %></td>
                        <td><%= review.getReviewDate() %></td>
                        <td>
                            <a href="<%= request.getContextPath() %>/ReviewController?action=delete&reviewID=<%= review.getReviewID() %>"
                               class="btn btn-danger btn-sm">
                                Delete
                            </a>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Bootstrap JS (Optional for table styling, modals, etc.) -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

</body>
</html>
