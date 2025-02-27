<%@ page session="true" %>
<%@ page import="java.sql.*, com.megacitycab.dao.DBUtil" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    HttpSession currentSession = request.getSession(false);
    if (currentSession == null || !"admin".equals(currentSession.getAttribute("role"))) {
        response.sendRedirect("login.jsp?message=Admin access required.");
        return;
    }

    int totalBookings = 0, totalUsers = 0, totalDrivers = 0, availableDrivers = 0;
    try (Connection con = DBUtil.getConnection()) {
        Statement stmt = con.createStatement();

        ResultSet rsBookings = stmt.executeQuery("SELECT COUNT(*) FROM bookings");
        if (rsBookings.next()) totalBookings = rsBookings.getInt(1);

        ResultSet rsUsers = stmt.executeQuery("SELECT COUNT(*) FROM users;");
        if (rsUsers.next()) totalUsers = rsUsers.getInt(1);

        ResultSet rsDrivers = stmt.executeQuery("SELECT COUNT(*) FROM users WHERE role='driver';");
        if (rsDrivers.next()) totalDrivers = rsDrivers.getInt(1);

        ResultSet rsAvailableDrivers = stmt.executeQuery("SELECT COUNT(*) FROM drivers WHERE availability = TRUE");
        if (rsAvailableDrivers.next()) availableDrivers = rsAvailableDrivers.getInt(1);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Mega City Cab</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        .dashboard-card {
            transition: transform 0.3s ease;
        }
        .dashboard-card:hover {
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-black">
        <div class="container">
            <a class="navbar-brand text-warning" href="#">🚖 Admin Dashboard</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link text-white" href="admin.jsp">Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="manage_bookings.jsp">Manage Bookings</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="manage_users.jsp">Manage Users</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="manage_drivers.jsp">Manage Drivers</a></li>
                    <li class="nav-item"><a class="nav-link text-danger" href="logout">Logout</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Dashboard Content -->
    <div class="container mt-5">
        <h2 class="text-warning mb-4">👋 Welcome, <%= username %>!</h2>
        <div class="row g-4">
            <!-- Total Bookings -->
            <div class="col-md-3">
                <div class="card text-bg-primary dashboard-card">
                    <div class="card-body text-center">
                        <h5 class="card-title">Total Bookings</h5>
                        <p class="display-5"><%= totalBookings %></p>
                        <a href="manage_bookings.jsp" class="btn btn-light btn-sm">View Bookings</a>
                    </div>
                </div>
            </div>

            <!-- Total Users -->
            <div class="col-md-3">
                <div class="card text-bg-success dashboard-card">
                    <div class="card-body text-center">
                        <h5 class="card-title">Total Users</h5>
                        <p class="display-5"><%= totalUsers %></p>
                        <a href="manage_users.jsp" class="btn btn-light btn-sm">Manage Users</a>
                    </div>
                </div>
            </div>

            <!-- Total Drivers -->
            <div class="col-md-3">
                <div class="card text-bg-warning dashboard-card">
                    <div class="card-body text-center">
                        <h5 class="card-title">Total Drivers</h5>
                        <p class="display-5"><%= totalDrivers %></p>
                        <a href="manage_drivers.jsp" class="btn btn-light btn-sm">Manage Drivers</a>
                    </div>
                </div>
            </div>

            <!-- Available Drivers -->
            <div class="col-md-3">
                <div class="card text-bg-danger dashboard-card">
                    <div class="card-body text-center">
                        <h5 class="card-title">Available Drivers</h5>
                        <p class="display-5"><%= availableDrivers %></p>
                        <a href="manage_drivers.jsp" class="btn btn-light btn-sm">Assign Drivers</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <h4 class="mt-5">🔧 Quick Actions</h4>
        <div class="row g-3">
            <div class="col-md-4">
                <a href="manage_bookings.jsp" class="btn btn-outline-primary w-100">📅 Manage Bookings</a>
            </div>
            <div class="col-md-4">
                <a href="assignDriver.jsp" class="btn btn-outline-warning w-100">🚗 Assign Drivers</a>
            </div>
            <div class="col-md-4">
                <a href="manage_users.jsp" class="btn btn-outline-success w-100">👥 Manage Users</a>
            </div>
        </div>
    </div>
</body>
</html>
