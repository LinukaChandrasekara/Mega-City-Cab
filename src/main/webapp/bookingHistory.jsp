<%@ page session="true" %>
<%@ page import="java.sql.*, com.megacitycab.dao.DBUtil" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null) {
        response.sendRedirect("login.jsp?message=Please login to view booking history.");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Booking History - Mega City Cab</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-warning text-center">📅 Booking History</h2>
        <table class="table table-bordered mt-4">
            <thead class="table-dark">
                <tr>
                    <th>#</th>
                    <th>Customer Name</th>
                    <th>Phone</th>
                    <th>Pickup</th>
                    <th>Drop-off</th>
                    <th>Vehicle Type</th>
                    <th>Distance (km)</th>
                    <th>Fare ($)</th>
                    <th>Booking Date</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try (Connection con = DBUtil.getConnection()) {
                        PreparedStatement ps;
                        if ("admin".equals(role)) {
                            ps = con.prepareStatement("SELECT * FROM bookings ORDER BY booking_date DESC");
                        } else if ("driver".equals(role)) {
                            ps = con.prepareStatement("SELECT * FROM bookings WHERE driver_username = ? ORDER BY booking_date DESC");
                            ps.setString(1, username);
                        } else {
                            ps = con.prepareStatement("SELECT * FROM bookings WHERE customer_name = ? ORDER BY booking_date DESC");
                            ps.setString(1, username);
                        }

                        ResultSet rs = ps.executeQuery();
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
                        <td><%= rs.getTimestamp("booking_date") %></td>
                        <td>
    <% if ("admin".equals(role) && rs.getInt("driver_id") == 0) { %>
        <a href="assignDriver.jsp?bookingId=<%= rs.getInt("booking_id") %>" class="btn btn-sm btn-primary">Assign Driver</a>
    <% } else { %>
        Assigned
    <% } %>
</td>
                        
                    </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                %>
                    <tr>
                        <td colspan="9" class="text-center text-danger">⚠️ Unable to fetch booking history.</td>
                    </tr>
                <%
                    }
                %>
            </tbody>
        </table>
        <a href="index.jsp" class="btn btn-secondary">Back to Home</a>
    </div>
</body>
</html>
