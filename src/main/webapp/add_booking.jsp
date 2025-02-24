<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp?message=Admin access required.");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Booking</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-success text-center">➕ Add New Booking</h2>
        <form action="BookingServlet" method="post">
            <input type="hidden" name="action" value="add">
            <div class="mb-3">
                <label>Customer Name</label>
                <input type="text" name="customer_name" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Phone</label>
                <input type="tel" name="phone" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Pickup Location</label>
                <input type="text" name="pickup_location" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Drop-off Location</label>
                <input type="text" name="dropoff_location" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Vehicle Type</label>
                <select name="vehicle_type" class="form-select" required>
                    <option value="bike">Bike</option>
                    <option value="cab">Cab</option>
                    <option value="van">Van</option>
                </select>
            </div>
            <div class="mb-3">
                <label>Distance (km)</label>
                <input type="number" step="0.01" name="distance" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Fare ($)</label>
                <input type="number" step="0.01" name="fare" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-success w-100">Add Booking</button>
        </form>
        <a href="manage_bookings.jsp" class="btn btn-secondary mt-3">Back</a>
    </div>
</body>
</html>
