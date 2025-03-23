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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
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
        /* Main Content Adjustment */
        .content {
            margin-left: 260px;
            padding: 20px;
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <div class="sidebar">
        <h4>Mega City Cab</h4>
        <a href="${pageContext.request.contextPath}/BookingController?action=dashboard"><i class="fas fa-home"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/Views/Customer/manage_profile.jsp" class="nav-link text-white"><i class="fas fa-user"></i> Manage Profile</a>
        <a href="${pageContext.request.contextPath}/Views/Customer/book_ride.jsp" class="nav-link text-white"><i class="fas fa-taxi"></i> Book a Ride</a>
        <a href="${pageContext.request.contextPath}/Views/Customer/booking_history.jsp" class="nav-link text-white"><i class="fas fa-history"></i> Booking History</a>
        <a href="${pageContext.request.contextPath}/Views/Customer/reviews.jsp" class="nav-link text-white"><i class="fas fa-star"></i> Reviews</a>
        <a href="${pageContext.request.contextPath}/Views/login.jsp" class="nav-link text-danger"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <!-- Main Content -->
    <div class="content">
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
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
