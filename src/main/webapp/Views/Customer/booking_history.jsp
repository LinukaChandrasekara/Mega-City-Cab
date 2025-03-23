<%@ page import="java.util.List, com.megacitycab.models.Booking, com.megacitycab.dao.*" %>
<%@ page import="com.megacitycab.models.User, com.megacitycab.models.Review" %> <!-- Added Review import -->

<%
    User loggedUser = (User) session.getAttribute("user");
    if (loggedUser == null || !"Customer".equalsIgnoreCase(loggedUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/Views/login.jsp?error=Unauthorized%20Access");
        return;
    }
    
    List<Booking> bookingHistory = BookingDAO.getBookingsByCustomer(loggedUser.getUserID());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Booking History | Mega City Cab</title>
    <!-- Bootstrap & Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
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
        
        /* General Styles */
        body {
            background-color: #f8f9fa;
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
        }
        /* Adjust container to avoid overlapping the sidebar */
        .content {
            margin-left: 260px;
            padding: 20px;
        }
        .container-custom {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
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
            margin-bottom: 20px;
        }
        
        /* Table */
        .table-custom {
            border-radius: 10px;
            overflow: hidden;
        }
        .table-custom thead {
            background-color: #ffc107;
            color: #212529;
        }
        
        /* Icons */
        .icon {
            font-size: 18px;
            margin-right: 5px;
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <h4>Mega City Cab</h4>
        <a href="${pageContext.request.contextPath}/BookingController?action=dashboard"><i class="fas fa-home"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/Views/Customer/manage_profile.jsp" class="nav-link text-white">
            <i class="fas fa-user"></i> Manage Profile
        </a>
        <a href="${pageContext.request.contextPath}/Views/Customer/book_ride.jsp" class="nav-link text-white">
            <i class="fas fa-taxi"></i> Book a Ride
        </a>
        <a href="${pageContext.request.contextPath}/Views/Customer/booking_history.jsp" class="nav-link text-white">
            <i class="fas fa-history"></i> Booking History
        </a>
        <a href="${pageContext.request.contextPath}/Views/Customer/customer_reviews.jsp" class="nav-link text-white">
            <i class="fas fa-star"></i> Reviews
        </a>
        <a href="${pageContext.request.contextPath}/Views/login.jsp" class="nav-link text-danger">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </div>

    <!-- Main Content -->
    <div class="content">
        <div class="container-custom">
            <!-- Page Heading -->
            <div class="heading-container">
                <h2><i class="fas fa-history"></i> Booking History</h2>
            </div>

            <!-- Booking History Table -->
            <table class="table table-striped table-custom">
				<thead>
				    <tr>
				        <th>Booking ID</th>
				        <th>Pickup</th>
				        <th>Dropoff</th>
				        <th>Vehicle</th>
				        <th>Fare</th>
				        <th>Status</th>
				        <th>Invoice</th>
				        <th>Review</th>
				    </tr>
				</thead>
                <tbody>
						<%
						    for (Booking booking : bookingHistory) { // Changed "bookings" to "bookingHistory"
						        Review existingReview = ReviewDAO.getReviewByBookingId(booking.getBookingID());
						%>
						<tr>
						    <td><%= booking.getBookingID() %></td>
						    <td><%= booking.getPickupLat() %>, <%= booking.getPickupLng() %></td>
						    <td><%= booking.getDropoffLat() %>, <%= booking.getDropoffLng() %></td>
						    <td><%= booking.getVehicleType() %></td>
						    <td>$<%= booking.getTotalAmount() %></td>
						    <td><%= booking.getStatus() %></td>
						    <td>
						        <% if ("Completed".equals(booking.getStatus())) { %>
						            <a href="${pageContext.request.contextPath}/BookingController?action=generateInvoice&bookingID=<%= booking.getBookingID() %>" 
						               class="btn btn-primary btn-sm">
						                <i class="fas fa-download"></i> Invoice
						            </a>
						        <% } else { %>
						            <span class="text-muted">N/A</span>
						        <% } %>
						    </td>
								<td>
								    <% if ("Completed".equals(booking.getStatus())) { 
								        if (existingReview == null) { %>
								            <a href="${pageContext.request.contextPath}/ReviewController?action=add&bookingID=<%= booking.getBookingID() %>" 
								                class="btn btn-success btn-sm">
								                <i class="fas fa-star"></i> Review
								            </a>
								    <% } else { %>
								        <span class="text-success">Reviewed</span>
								    <% } %>
								<% } %>
								</td>
						</tr>
						<% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
