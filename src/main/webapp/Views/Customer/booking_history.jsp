<%@ page import="java.util.List, com.megacitycab.models.Booking, com.megacitycab.dao.BookingDAO" %>
<%@ page import="com.megacitycab.models.User" %>

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
        /* General Styles */
        body {
            background-color: #f8f9fa;
            font-family: 'Poppins', sans-serif;
        }

        .container {
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
        }

        /* Table */
        .table {
            border-radius: 10px;
            overflow: hidden;
        }

        .table thead {
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

<div class="container mt-4">
    
    <!-- Page Heading -->
    <div class="heading-container mb-4">
        <h2><i class="fas fa-history"></i> Booking History</h2>
    </div>

    <!-- Booking History Table -->
    <table class="table table-striped">
        <thead>
            <tr>
                <th><i class="fas fa-receipt icon"></i> Booking ID</th>
                <th><i class="fas fa-map-marker-alt icon"></i> Pickup</th>
                <th><i class="fas fa-map-pin icon"></i> Drop-off</th>
                <th><i class="fas fa-info-circle icon"></i> Status</th>
                <th><i class="fas fa-dollar-sign icon"></i> Fare</th>
            </tr>
        </thead>
        <tbody>
            <% if (bookingHistory.isEmpty()) { %>
                <tr>
                    <td colspan="5" class="text-center text-danger">No bookings found.</td>
                </tr>
            <% } else { %>
                <% for (Booking booking : bookingHistory) { %>
                    <tr>
                        <td><%= booking.getBookingID() %></td>
                        <td><%= booking.getPickupLat() %>, <%= booking.getPickupLng() %></td>
                        <td><%= booking.getDropoffLat() %>, <%= booking.getDropoffLng() %></td>
                        <td><%= booking.getStatus() %></td>
                        <td>$<%= booking.getFare() %></td>
                    </tr>
                <% } %>
            <% } %>
        </tbody>
    </table>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
