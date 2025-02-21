<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.megacitycab.dao.DBUtil" %>
<%
    String username = (String) session.getAttribute("username");

    if (username == null || !username.equals("admin")) {
        response.sendRedirect("login.jsp");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Panel - Mega City Cab</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-black">
        <div class="container">
            <a class="navbar-brand text-warning" href="#">🚖 Admin Panel</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link text-white" href="admin.jsp">Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="manage_bookings.jsp">Bookings</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="manage_users.jsp">Users</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="manage_drivers.jsp">Drivers</a></li>
                    <li class="nav-item"><a class="nav-link text-danger" href="logout">Logout</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <h2 class="text-warning">Welcome, Admin</h2>
        <p>Use the navigation bar to manage the system.</p>
    </div>
</body>
</html>
