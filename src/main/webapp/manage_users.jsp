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
    <title>Manage Users - Admin Panel</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-warning text-center">👥 Manage Users</h2>
        <a href="add_user.jsp" class="btn btn-success mb-3">➕ Add User</a>
        <table class="table table-bordered">
            <thead class="table-dark">
                <tr>
                    <th>#</th>
                    <th>Username</th>
                    <th>Role</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try (Connection con = DBUtil.getConnection()) {
                        ResultSet rs = con.createStatement().executeQuery("SELECT * FROM users ORDER BY role");
                        int count = 1;
                        while (rs.next()) {
                %>
                <tr>
                    <td><%= count++ %></td>
                    <td><%= rs.getString("username") %></td>
                    <td><%= rs.getString("role") %></td>
                    <td>
                        <a href="edit_user.jsp?userId=<%= rs.getInt("user_id") %>" class="btn btn-sm btn-primary">Edit</a>
                        <a href="UserServlet?action=delete&userId=<%= rs.getInt("user_id") %>" class="btn btn-sm btn-danger" onclick="return confirm('Delete this user?');">Delete</a>
                    </td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                %>
                <tr><td colspan="4" class="text-center text-danger">⚠️ Error loading users.</td></tr>
                <%
                    }
                %>
            </tbody>
        </table>
        <a href="admin.jsp" class="btn btn-secondary mt-3">Back to Dashboard</a>
    </div>
</body>
</html>
