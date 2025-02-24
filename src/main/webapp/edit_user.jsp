<%@ page session="true" %>
<%@ page import="java.sql.*, com.megacitycab.dao.DBUtil" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp?message=Admin access required.");
        return;
    }

    int userId = Integer.parseInt(request.getParameter("userId"));
    String username = "", userRole = "", fullName = "", address = "", nic = "", phone = "";

    try (Connection con = DBUtil.getConnection()) {
        PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE user_id=?");
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            username = rs.getString("username");
            userRole = rs.getString("role");
            fullName = rs.getString("full_name");
            address = rs.getString("address");
            nic = rs.getString("nic");
            phone = rs.getString("phone");
        } else {
            response.sendRedirect("manage_users.jsp?message=User not found.");
            return;
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("manage_users.jsp?message=Error fetching user data.");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit User - Admin Panel</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-warning text-center">✏️ Edit User</h2>
        <form action="EditUserServlet" method="post">
            <input type="hidden" name="user_id" value="<%= userId %>">

            <div class="mb-3">
                <label class="form-label">Username</label>
                <input type="text" class="form-control" name="username" value="<%= username %>" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Role</label>
                <select class="form-select" name="role" required>
                    <option value="customer" <%= "customer".equals(userRole) ? "selected" : "" %>>Customer</option>
                    <option value="driver" <%= "driver".equals(userRole) ? "selected" : "" %>>Driver</option>
                    <option value="admin" <%= "admin".equals(userRole) ? "selected" : "" %>>Admin</option>
                </select>
            </div>
            <div class="mb-3">
                <label class="form-label">Full Name</label>
                <input type="text" class="form-control" name="full_name" value="<%= fullName %>" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Address</label>
                <textarea class="form-control" name="address" required><%= address %></textarea>
            </div>
            <div class="mb-3">
                <label class="form-label">NIC</label>
                <input type="text" class="form-control" name="nic" value="<%= nic %>" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Phone Number</label>
                <input type="tel" class="form-control" name="phone" value="<%= phone %>" required>
            </div>
            <button type="submit" class="btn btn-primary w-100">Update User</button>
        </form>
        <a href="manage_users.jsp" class="btn btn-secondary mt-3">Back to Manage Users</a>
    </div>
</body>
</html>
