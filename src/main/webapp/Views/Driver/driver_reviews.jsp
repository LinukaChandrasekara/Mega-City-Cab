<%@ page import="java.util.List" %>
<%@ page import="com.megacitycab.models.*" %>
<%@ page import="com.megacitycab.dao.ReviewDAO" %>

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
    User user = (User) userSession.getAttribute("user");
    List<Review> reviews = ReviewDAO.getReviewsByDriver(user.getUserID());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>My Reviews | Mega City Cab</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <style>
body {
    background-color: #f8f9fa;
    font-family: 'Arial', sans-serif;
}

/* Sidebar */
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

/* Main Content */
		.main-content {
		    margin-left: 260px;
		    padding: 20px;
		}
		
		/* Heading Background */
		.heading-container {
		    background-color: #ffc107;
		    padding: 15px;
		    border-radius: 8px;
		    text-align: center;
		    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
		}
		
		/* Cards */
		.card-custom {
		    border-radius: 10px;
		    background-color: #f0f0f0; /* Light Grey */
		    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
		    border: none;
		    color: #212529; /* Dark Grey for visibility */
		}
		
		/* Profile Image */
		.profile-img {
		    width: 130px;
		    height: 130px;
		    object-fit: cover;
		    border-radius: 50%;
		    border: 4px solid #FFC107;
		    margin-top: 10px;
		}
		
		/* Table Headers */
		.table thead {
		    background-color: #FFC107;
		    color: #212529;
		}
		
		/* Dropdown Select */
		.dropdown-select {
		    width: 150px;
		}
        .btn-primary {
            background-color: #007BFF;
            border: none;
        }
        .btn-success {
            background-color: #28A745;
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
    <a href="${pageContext.request.contextPath}/DriverController"><i class="fas fa-home"></i> Dashboard</a>
    <a href="${pageContext.request.contextPath}/Views/Driver/manage_profile.jsp"><i class="fas fa-user"></i> Manage Profile</a>
    <a href="${pageContext.request.contextPath}/Views/Driver/manage_vehicle.jsp"><i class="fas fa-car"></i> Manage Vehicle</a>
    <a href="${pageContext.request.contextPath}/Views/Driver/available_bookings.jsp"><i class="fas fa-list"></i> Available Bookings</a>
    <a href="${pageContext.request.contextPath}/Views/Driver/driver_reviews.jsp"><i class="fas fa-star"></i> Reviews</a>
    <a href="${pageContext.request.contextPath}/Views/Driver/earnings_dashboard.jsp"><i class="fas fa-dollar-sign"></i> Earnings</a>
    <a href="${pageContext.request.contextPath}/Views/login.jsp?" class="text-danger"><i class="fas fa-sign-out-alt"></i> Logout</a>
</div>

<div class="container mt-4">
    <h2>Reviews About Me</h2>

    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Customer</th>
                <th>Rating</th>
                <th>Comments</th>
                <th>Date</th>
            </tr>
        </thead>
        <tbody>
            <% for (Review review : reviews) { %>
                <tr>
                    <td><%= review.getCustomerName() %></td>
                    <td><%= review.getRating() %>/5</td>
                    <td><%= review.getComments() %></td>
                    <td><%= review.getReviewDate() %></td>
                </tr>
            <% } %>
        </tbody>
    </table>
</div>
</body>
</html>
