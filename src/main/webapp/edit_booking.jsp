<%@ page session="true" %>
<%@ page import="java.sql.*, com.megacitycab.dao.DBUtil" %>
<%
    String bookingId = request.getParameter("bookingId");
    if (bookingId == null) {
        response.sendRedirect("manage_bookings.jsp?message=Invalid booking ID.");
        return;
    }

    Connection con = DBUtil.getConnection();
    PreparedStatement ps = con.prepareStatement("SELECT * FROM bookings WHERE booking_id = ?");
    ps.setInt(1, Integer.parseInt(bookingId));
    ResultSet rs = ps.executeQuery();

    if (!rs.next()) {
        response.sendRedirect("manage_bookings.jsp?message=Booking not found.");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Booking</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-warning text-center">✏️ Edit Booking</h2>
        <form action="BookingServlet" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="booking_id" value="<%= rs.getInt("booking_id") %>">
            <div class="mb-3">
                <label>Customer Name</label>
                <input type="text" name="customer_name" value="<%= rs.getString("customer_name") %>" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Phone</label>
                <input type="tel" name="phone" value="<%= rs.getString("phone") %>" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Pickup Location</label>
                <input type="text" name="pickup_location" value="<%= rs.getString("pickup_location") %>" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Drop-off Location</label>
                <input type="text" name="dropoff_location" value="<%= rs.getString("dropoff_location") %>" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Vehicle Type</label>
                <select name="vehicle_type" class="form-select" required>
                    <option value="bike" <%= rs.getString("vehicle_type").equals("bike") ? "selected" : "" %>>Bike</option>
                    <option value="cab" <%= rs.getString("vehicle_type").equals("cab") ? "selected" : "" %>>Cab</option>
                    <option value="van" <%= rs.getString("vehicle_type").equals("van") ? "selected" : "" %>>Van</option>
                </select>
            </div>
            <div class="mb-3">
                <label>Distance (km)</label>
                <input type="number" step="0.01" name="distance" value="<%= rs.getDouble("distance") %>" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Fare ($)</label>
                <input type="number" step="0.01" name="fare" value="<%= rs.getDouble("fare") %>" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-warning w-100">Update Booking</button>
        </form>
        <a href="manage_bookings.jsp" class="btn btn-secondary mt-3">Back</a>
    </div>
</body>
</html>
