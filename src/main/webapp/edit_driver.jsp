<%@ page session="true" %>
<%@ page import="java.sql.*, com.megacitycab.dao.DBUtil" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp?message=Admin access required.");
        return;
    }

    int driverId = Integer.parseInt(request.getParameter("driverId"));
    String name = "", phone = "", vehicle = "", status = "";

    try (Connection con = DBUtil.getConnection()) {
        PreparedStatement ps = con.prepareStatement("SELECT * FROM drivers WHERE driver_id = ?");
        ps.setInt(1, driverId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            phone = rs.getString("phone");
            vehicle = rs.getString("vehicle");
            status = rs.getString("status");
        } else {
            response.sendRedirect("manage_drivers.jsp?message=Driver not found.");
            return;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Driver - Admin Panel</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-primary text-center">✏️ Edit Driver</h2>

        <form action="EditDriverServlet" method="post" class="mt-4">
            <input type="hidden" name="driver_id" value="<%= driverId %>">
            <div class="mb-3">
                <label class="form-label">Driver Name</label>
                <input type="text" class="form-control" name="name" value="<%= name %>" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Phone Number</label>
                <input type="tel" class="form-control" name="phone" value="<%= phone %>" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Vehicle</label>
                <input type="text" class="form-control" name="vehicle" value="<%= vehicle %>" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Status</label>
                <select class="form-select" name="status" required>
                    <option value="available" <%= "available".equals(status) ? "selected" : "" %>>Available</option>
                    <option value="unavailable" <%= "unavailable".equals(status) ? "selected" : "" %>>Unavailable</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary w-100">💾 Update Driver</button>
            <a href="manage_drivers.jsp" class="btn btn-secondary mt-3">⬅️ Cancel</a>
        </form>
    </div>
</body>
</html>
