<%@ page import="com.megacitycab.dao.BookingDAO, com.megacitycab.models.Booking, com.megacitycab.models.User" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/Views/login.jsp?error=Session expired");
        return;
    }

    User customer = (User) userSession.getAttribute("user");
    String bookingIdParam = request.getParameter("bookingID");

    if (bookingIdParam == null || bookingIdParam.isEmpty()) {
        response.sendRedirect("booking_history.jsp?error=Invalid booking ID.");
        return;
    }

    int bookingID = Integer.parseInt(bookingIdParam);
    Booking booking = BookingDAO.getBookingById(bookingID);

    if (booking == null) {
        response.sendRedirect("booking_history.jsp?error=Booking not found.");
        return;
    }

    User driver = BookingDAO.getDriverById(booking.getDriverID());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ride Invoice | Mega City Cab</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body {
            background-color: #f4f4f4;
            font-family: 'Poppins', sans-serif;
        }

        .invoice-container {
            max-width: 650px;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            margin: 40px auto;
            box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.2);
        }

        .invoice-header {
            background: #ffc107;
            padding: 15px;
            text-align: center;
            border-radius: 8px 8px 0 0;
        }

        .invoice-header h2 {
            margin: 0;
            color: #212529;
            font-weight: bold;
        }

        .invoice-body {
            padding: 20px;
        }

        .details p {
            margin: 8px 0;
            font-size: 16px;
        }

        .details i {
            margin-right: 8px;
            color: #ffc107;
        }

        .fare-summary {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            font-weight: bold;
            box-shadow: 0px 3px 10px rgba(0, 0, 0, 0.1);
        }

        .btn-custom {
            width: 100%;
            margin-top: 10px;
            padding: 12px;
            font-size: 16px;
            font-weight: bold;
            transition: 0.3s;
        }

        .btn-custom i {
            margin-right: 6px;
        }

        .btn-custom:hover {
            transform: scale(1.05);
        }
    </style>
</head>
<body>

<div class="invoice-container">
    <!-- Header -->
    <div class="invoice-header">
        <h2><i class="fas fa-receipt"></i> Mega City Cab Invoice</h2>
    </div>

    <!-- Body -->
    <div class="invoice-body">
        <div class="details">
            <p><i class="fas fa-user"></i> <strong>Customer:</strong> <%= customer.getName() %></p>
            <p><i class="fas fa-id-badge"></i> <strong>Driver:</strong> <%= driver != null ? driver.getName() : "Not Assigned" %></p>
            <p><i class="fas fa-car"></i> <strong>Vehicle Type:</strong> <%= booking.getVehicleType() %></p>
            <p><i class="fas fa-map-marker-alt"></i> <strong>Pickup Location:</strong> Lat: <%= booking.getPickupLat() %>, Lng: <%= booking.getPickupLng() %></p>
            <p><i class="fas fa-map-pin"></i> <strong>Dropoff Location:</strong> Lat: <%= booking.getDropoffLat() %>, Lng: <%= booking.getDropoffLng() %></p>
            <p><i class="fas fa-road"></i> <strong>Distance:</strong> <%= booking.getDistance() %> km</p>
            <p><i class="fas fa-clock"></i> <strong>Estimated Time:</strong> <%= booking.getEstimatedTime() %> mins</p>
        </div>

        <!-- Fare Summary -->
        <div class="fare-summary">
            <p><i class="fas fa-money-bill-wave"></i> <strong>Fare:</strong> $<%= booking.getFare() %></p>
            <p><i class="fas fa-tag"></i> <strong>Discount:</strong> -$<%= booking.getDiscount() %></p>
            <h4><i class="fas fa-dollar-sign"></i> <strong>Total: $<%= booking.getTotalAmount() %></strong></h4>
        </div>

        <!-- Buttons -->
        <form action="BookingController" method="post">
            <input type="hidden" name="action" value="makePayment">
            <input type="hidden" name="bookingID" value="<%= booking.getBookingID() %>">
            <button type="submit" class="btn btn-success btn-custom">
                <i class="fas fa-credit-card"></i> Pay Now
            </button>
        </form>
        <a href="BookingController?action=generateInvoice&bookingID=<%= booking.getBookingID() %>" 
           class="btn btn-primary btn-custom">
            <i class="fas fa-download"></i> Download Invoice (PDF)
        </a>
    </div>
</div>

</body>
</html>
