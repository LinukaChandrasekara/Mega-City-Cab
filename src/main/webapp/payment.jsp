<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.megacitycab.dao.DBUtil" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Make Payment</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-warning">Your Pending Payments</h2>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Booking ID</th>
                    <th>Fare</th>
                    <th>Payment Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String username = (String) session.getAttribute("username");
                    Connection con = DBUtil.getConnection();
                    PreparedStatement ps = con.prepareStatement(
                        "SELECT b.id, b.fare, " +
                        "(SELECT payment_status FROM payments WHERE booking_id = b.id) AS payment_status " +
                        "FROM bookings b WHERE b.customer_name = ?"
                    );
                    ps.setString(1, username);
                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
                        String paymentStatus = rs.getString("payment_status") == null ? "Pending" : rs.getString("payment_status");
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getDouble("fare") %></td>
                    <td><%= paymentStatus %></td>
                    <td>
                        <% if (paymentStatus.equals("Pending")) { %>
                            <form action="make_payment" method="post">
                                <input type="hidden" name="booking_id" value="<%= rs.getInt("id") %>">
                                <select name="payment_method" class="form-select">
                                    <option value="Cash">Cash</option>
                                    <option value="Credit Card">Credit Card</option>
                                    <option value="Online Payment">Online Payment</option>
                                </select>
                                <button type="submit" class="btn btn-primary btn-sm mt-2">Pay Now</button>
                            </form>
                        <% } %>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>
