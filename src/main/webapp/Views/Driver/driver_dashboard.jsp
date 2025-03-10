<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="com.megacitycab.models.*" %>

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
    <title>Driver Dashboard | Mega City Cab</title>

    <!-- Bootstrap & Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <!-- Custom Styles -->
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
    <a href="${pageContext.request.contextPath}/Views/Driver/customer_reviews.jsp"><i class="fas fa-star"></i> Reviews</a>
    <a href="${pageContext.request.contextPath}/Views/Driver/earnings_dashboard.jsp"><i class="fas fa-dollar-sign"></i> Earnings</a>
    <a href="${pageContext.request.contextPath}/Views/login.jsp?" class="text-danger"><i class="fas fa-sign-out-alt"></i> Logout</a>
</div>

<!-- Main Content -->
<!-- Main Content -->
<div class="main-content">
    <!-- Dashboard Heading with Background -->
    <div class="p-3 mb-4 text-center text-dark bg-warning rounded shadow-sm">
        <h2 class="fw-bold mb-0">Driver Dashboard</h2>
    </div>
    <!-- Profile Card -->
    <div class="card card-custom p-3 mb-4">
        <div class="row align-items-center">
            <div class="col-md-3 text-center">
                <img src="${pageContext.request.contextPath}/GetProfilePicture?userID=<%= loggedUser.getUserID() %>" class="profile-img">
            </div>
            <div class="col-md-9">
                <h4 class="mb-1">Hi, <%= loggedUser.getName() %>!</h4>
                <p><i class="fas fa-car"></i> Vehicle: 
                    <strong><%= request.getAttribute("vehicleType") != null ? request.getAttribute("vehicleType") : "Not Assigned" %></strong>
                    (<%= request.getAttribute("vehicleModel") != null ? request.getAttribute("vehicleModel") : "N/A" %>) | 
                    Plate: <%= request.getAttribute("licensePlate") != null ? request.getAttribute("licensePlate") : "N/A" %>
                </p>
                <a href="manage_profile.jsp" class="btn btn-warning btn-sm">Edit Profile</a>
            </div>
        </div>
    </div>

    <!-- Available Rides -->
    <div class="card card-custom p-3 mb-4">
        <h5><i class="fas fa-list-ul"></i> Available Rides</h5>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Booking ID</th>
                    <th>Pickup</th>
                    <th>Drop-off</th>
                    <th>Action</th>
                </tr>
            </thead>
				<%
				    Object availableRidesObj = request.getAttribute("availableRides");
				    List<Booking> availableRides = availableRidesObj instanceof List ? (List<Booking>) availableRidesObj : List.of();
				%>
				
				<tbody>
				    <% if (availableRides.isEmpty()) { %>
				        <tr>
				            <td colspan="4" class="text-center text-danger">No available rides found.</td>
				        </tr>
				    <% } else { %>
				        <% for (Booking ride : availableRides) { %>
				            <tr>
				                <td><%= ride.getBookingID() %></td>
				                <td><%= ride.getPickupLat() + ", " + ride.getPickupLng() %></td>
				                <td><%= ride.getDropoffLat() + ", " + ride.getDropoffLng() %></td>
				                <td>
				                    <form action="${pageContext.request.contextPath}/DriverController" method="post">
				                        <input type="hidden" name="action" value="acceptRide">
				                        <input type="hidden" name="bookingID" value="<%= ride.getBookingID() %>">
				                        <button type="submit" class="btn btn-success btn-sm">Accept</button>
				                    </form>
				                </td>
				            </tr>
				        <% } %>
				    <% } %>
				</tbody>
        </table>
    </div>

    <!-- Assigned Rides -->
<!-- Assigned Rides -->
<div class="card card-custom p-3 mb-4">
    <h5><i class="fas fa-tasks"></i> My Assigned Rides</h5>
    <table class="table table-striped">
        <thead>
            <tr>
                <th>Booking ID</th>
                <th>Pickup</th>
                <th>Drop-off</th>
                <th>Status</th>
            </tr>
        </thead>
        
        <%
            Object assignedRidesObj = request.getAttribute("assignedRides");
            List<Booking> assignedRides = assignedRidesObj instanceof List ? (List<Booking>) assignedRidesObj : List.of();
        %>

        <tbody>
            <% if (assignedRides.isEmpty()) { %>
                <tr>
                    <td colspan="5" class="text-center text-danger">No assigned rides found.</td>
                </tr>
            <% } else { %>
                <% for (Booking ride : assignedRides) { %>
                    <tr>
                        <td><%= ride.getBookingID() %></td>
                        <td><%= ride.getPickupLat() + ", " + ride.getPickupLng() %></td>
                        <td><%= ride.getDropoffLat() + ", " + ride.getDropoffLng() %></td>
                        <td>
                            <form action="${pageContext.request.contextPath}/DriverController" method="post">
                                <input type="hidden" name="action" value="updateRideStatus">
                                <input type="hidden" name="bookingID" value="<%= ride.getBookingID() %>">
                                <select name="status" class="form-select d-inline w-auto">
                                    <option value="Confirmed" <%= "Confirmed".equals(ride.getStatus()) ? "selected" : "" %>>Confirmed</option>
                                    <option value="Ongoing" <%= "Ongoing".equals(ride.getStatus()) ? "selected" : "" %>>Ongoing</option>
                                    <option value="Completed" <%= "Completed".equals(ride.getStatus()) ? "selected" : "" %>>Completed</option>
                                    <option value="Cancelled" <%= "Cancelled".equals(ride.getStatus()) ? "selected" : "" %>>Cancelled</option>
                                </select><button type="submit" class="btn btn-primary btn-sm">Update</button>
                            </form>
                        </td>
                    </tr>
                <% } %>
            <% } %>
        </tbody>
    </table>
</div>

</div>
<!-- Bootstrap JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
