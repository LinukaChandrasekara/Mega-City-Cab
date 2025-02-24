<%@ page session="true" %>
<%@ page import="java.sql.*, com.megacitycab.dao.DBUtil" %>
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
    <title>Manage Bookings - Admin Panel</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-warning text-center">📅 Manage Bookings</h2>
        <table class="table table-bordered mt-4">
            <thead class="table-dark">
                <tr>
                    <th>#</th>
                    <th>Customer</th>
                    <th>Phone</th>
                    <th>Pickup</th>
                    <th>Drop-off</th>
                    <th>Vehicle</th>
                    <th>Distance (km)</th>
                    <th>Fare ($)</th>
                    <th>Driver</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try (Connection con = DBUtil.getConnection()) {
                        Statement stmt = con.createStatement();
                        ResultSet rs = stmt.executeQuery(
                            "SELECT b.*, d.driver_name FROM bookings b LEFT JOIN drivers d ON b.driver_id = d.driver_id ORDER BY b.booking_date DESC"
                        );
                        int count = 1;
                        while (rs.next()) {
                %>
                <tr>
                    <td><%= count++ %></td>
                    <td><%= rs.getString("customer_name") %></td>
                    <td><%= rs.getString("phone") %></td>
                    <td><%= rs.getString("pickup_location") %></td>
                    <td><%= rs.getString("dropoff_location") %></td>
                    <td><%= rs.getString("vehicle_type") %></td>
                    <td><%= rs.getDouble("distance") %></td>
                    <td>$<%= rs.getDouble("fare") %></td>
                    <td><%= rs.getString("driver_name") != null ? rs.getString("driver_name") : "Not Assigned" %></td>
                    <td>
                        <a href="edit_booking.jsp?bookingId=<%= rs.getInt("booking_id") %>" class="btn btn-sm btn-primary">Edit</a>
                        <a href="BookingServlet?action=delete&bookingId=<%= rs.getInt("booking_id") %>" class="btn btn-sm btn-danger" onclick="return confirm('Delete this booking?');">Delete</a>
                        <% if (rs.getString("driver_name") == null) { %>
                            <a href="assignDriver.jsp?bookingId=<%= rs.getInt("booking_id") %>" class="btn btn-sm btn-warning">Assign Driver</a>
                        <% } %>
                    </td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                %>
                <tr><td colspan="10" class="text-center text-danger">⚠️ Error loading bookings.</td></tr>
                <%
                    }
                %>
            </tbody>
        </table>
        <a href="admin.jsp" class="btn btn-secondary mt-3">Back to Dashboard</a>
    </div>
</body>
</html>
