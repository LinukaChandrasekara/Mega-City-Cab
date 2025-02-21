<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.megacitycab.utils.DBUtil" %>
<%
    if (session.getAttribute("username") == null || !session.getAttribute("username").equals("admin")) {
        response.sendRedirect("login.jsp");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Bookings</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-warning">Bookings</h2>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Customer</th>
                    <th>Pickup</th>
                    <th>Dropoff</th>
                    <th>Fare</th>
                    <th>Status</th>
                    <th>Payment Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection con = DBUtil.getConnection();
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery(
                        "SELECT b.id, b.customer_name, b.pickup_location, b.dropoff_location, b.fare, b.status, " +
                        "(SELECT payment_status FROM payments WHERE booking_id = b.id) AS payment_status " +
                        "FROM bookings b"
                    );

                    while (rs.next()) {
                        String paymentStatus = rs.getString("payment_status") == null ? "Pending" : rs.getString("payment_status");
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("customer_name") %></td>
                    <td><%= rs.getString("pickup_location") %></td>
                    <td><%= rs.getString("dropoff_location") %></td>
                    <td><%= rs.getDouble("fare") %></td>
                    <td><%= rs.getString("status") %></td>
                    <td><%= paymentStatus %></td>
                    <td>
                        <a href="update_booking?id=<%= rs.getInt("id") %>&status=Completed" class="btn btn-success btn-sm">Mark Completed</a>
                        <a href="delete_booking?id=<%= rs.getInt("id") %>" class="btn btn-danger btn-sm">Delete</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>
