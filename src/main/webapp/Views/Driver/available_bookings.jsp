<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.megacitycab.models.Booking" %>
<%@ page import="com.megacitycab.models.Driver" %> <!-- Add this line -->

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
    List<Booking> availableRides = (List<Booking>) request.getAttribute("availableRides");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Available Bookings | Mega City Cab</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <style>
        body { background-color: #f8f9fa; font-family: 'Arial', sans-serif; }
        .sidebar {
            width: 260px;
            height: 100vh;
            position: fixed;
            background-color: #212529;
            padding-top: 20px;
            color: white;
        }
        .sidebar h4 { text-align: center; color: #FFC107; font-weight: bold; }
        .sidebar a { color: white; padding: 12px; display: block; text-decoration: none; font-size: 16px; transition: 0.3s; }
        .sidebar a:hover { background-color: #343a40; padding-left: 18px; }
        .main-content { margin-left: 260px; padding: 20px; }
        .heading-container { background-color: #ffc107; padding: 15px; border-radius: 8px; 
                            text-align: center; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); }
        .card-custom { border-radius: 10px; background-color: #f0f0f0; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); 
                      border: none; color: #212529; }
        .table thead { background-color: #FFC107; color: #212529; }
        .btn-success { background-color: #28A745; border: none; }
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

<!-- Main Content -->
<div class="main-content">
    <div class="heading-container mb-4">
        <h2 class="mb-0"><i class="fas fa-list-ol"></i> Available Bookings</h2>
    </div>

    <%-- Display messages --%>
    <% String error = request.getParameter("error");
       String success = request.getParameter("success");
       if (error != null) { %>
        <div class="alert alert-danger"><%= error %></div>
    <% } else if (success != null) { %>
        <div class="alert alert-success"><%= success %></div>
    <% } %>

    <div class="card card-custom p-4">
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Booking ID</th>
                    <th>Pickup Location</th>
                    <th>Drop-off Location</th>
                    <th>Distance (km)</th>
                    <th>Fare</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% if (availableRides == null || availableRides.isEmpty()) { %>
                    <tr>
                        <td colspan="6" class="text-center text-danger">No available bookings found</td>
                    </tr>
                <% } else { 
                    for (Booking ride : availableRides) { %>
                    <tr>
                        <td><%= ride.getBookingID() %></td>
                        <td><%= ride.getPickupLat() + ", " + ride.getPickupLng() %></td>
                        <td><%= ride.getDropoffLat() + ", " + ride.getDropoffLng() %></td>
                        <td><%= ride.getDistance() %></td>
                        <td>$<%= ride.getFare() %></td>
                        <td>
                            <form action="${pageContext.request.contextPath}/DriverController" method="post">
                                <input type="hidden" name="action" value="acceptRide">
                                <input type="hidden" name="bookingID" value="<%= ride.getBookingID() %>">
                                <button type="submit" class="btn btn-success btn-sm">
                                    <i class="fas fa-check"></i> Accept Ride
                                </button>
                            </form>
                        </td>
                    </tr>
                <% } 
                } %>
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>