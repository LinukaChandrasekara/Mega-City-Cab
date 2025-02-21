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
    <title>Manage Drivers</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-warning">Manage Drivers</h2>

        <!-- Form to Add New Driver -->
        <form action="add_driver" method="post">
            <div class="mb-3">
                <label class="form-label">Driver Name</label>
                <input type="text" class="form-control" name="name" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Phone Number</label>
                <input type="text" class="form-control" name="phone" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Vehicle</label>
                <input type="text" class="form-control" name="vehicle" required>
            </div>
            <button type="submit" class="btn btn-success">Add Driver</button>
        </form>

        <hr>

        <!-- Display Drivers -->
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Phone</th>
                    <th>Vehicle</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection con = DBUtil.getConnection();
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM drivers");

                    while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getString("phone") %></td>
                    <td><%= rs.getString("vehicle") %></td>
                    <td><%= rs.getString("status") %></td>
                    <td>
                        <a href="delete_driver?id=<%= rs.getInt("id") %>" class="btn btn-danger btn-sm">Delete</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>
