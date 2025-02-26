<%@ page session="true" %>
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
    <title>Add Driver - Admin Panel</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-success text-center">➕ Add New Driver</h2>

        <form action="AddDriverServlet" method="post" class="mt-4">
            <div class="mb-3">
                <label class="form-label">Full Name</label>
                <input type="text" class="form-control" name="name" placeholder="Enter driver's full name" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Username</label>
                <input type="text" class="form-control" name="username" placeholder="Enter username" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Password</label>
                <input type="password" class="form-control" name="password" placeholder="Enter password" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Phone Number</label>
                <input type="tel" class="form-control" name="phone" placeholder="Enter phone number" required>
            </div>
            <div class="mb-3">
                <label class="form-label">License Number</label>
                <input type="text" class="form-control" name="license_number" placeholder="Enter license number" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Vehicle</label>
                <input type="text" class="form-control" name="vehicle" placeholder="Enter vehicle type" required>
            </div>
            <div class="mb-3">
    			<label class="form-label">Experience Years</label>
    			<input type="number" class="form-control" name="experience_years" placeholder="Enter years of experience" required>
		</div>
			<div class="mb-3">
    			<label class="form-label">Assigned Vehicle ID (Optional)</label>
    			<input type="number" class="form-control" name="assigned_vehicle_id" placeholder="Enter vehicle ID">
		</div>
            <div class="mb-3">
                <label class="form-label">Status</label>
                <select class="form-select" name="status" required>
                    <option value="available" selected>Available</option>
                    <option value="unavailable">Unavailable</option>
                </select>
            </div>
            <button type="submit" class="btn btn-success w-100">✅ Add Driver</button>
            <a href="manage_drivers.jsp" class="btn btn-secondary mt-3">⬅️ Cancel</a>
        </form>
    </div>
</body>
</html>
