<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.megacitycab.dao.DBUtil" %>
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
    <title>Manage Drivers - Admin Panel</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-warning text-center">🚘 Manage Drivers</h2>

        <a href="add_driver.jsp" class="btn btn-success mb-3">➕ Add Driver</a>

        <table class="table table-bordered">
            <thead class="table-dark">
                <tr>
                    <th>#</th>
                    <th>Name</th>
                    <th>Phone</th>
                    <th>Vehicle</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try (Connection con = DBUtil.getConnection()) {
                        ResultSet rs = con.createStatement().executeQuery("SELECT * FROM drivers ORDER BY status DESC, name");
                        int count = 1;
                        while (rs.next()) {
                %>
                <tr>
                    <td><%= count++ %></td>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getString("phone") %></td>
                    <td><%= rs.getString("vehicle") %></td>
                    <td>
                        <% String status = rs.getString("status"); %>
                        <span class="badge bg-<%= "available".equals(status) ? "success" : "secondary" %>">
                            <%= status.substring(0, 1).toUpperCase() + status.substring(1) %>
                        </span>
                    </td>
                    <td>
                        <a href="edit_driver.jsp?driverId=<%= rs.getInt("driver_id") %>" class="btn btn-sm btn-primary">✏️ Edit</a>
                        <a href="DeleteDriverServlet?driverId=<%= rs.getInt("driver_id") %>" 
                           class="btn btn-sm btn-danger" 
                           onclick="return confirm('Delete this driver?');">🗑️ Delete</a>
                    </td>
                </tr>
                <%  
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                %>
                <tr><td colspan="6" class="text-center text-danger">⚠️ Error loading drivers.</td></tr>
                <% } %>
            </tbody>
        </table>
        <a href="admin.jsp" class="btn btn-secondary mt-3">⬅️ Back to Dashboard</a>
    </div>
</body>
</html>

