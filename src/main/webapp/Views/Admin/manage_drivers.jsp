<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.megacitycab.models.*" %>

<%
    // Authorization Check
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("userRole") == null || !"Admin".equals(userSession.getAttribute("userRole"))) {
        response.sendRedirect("../login.jsp?error=Unauthorized Access!");
        return;
    }

    List<Driver> drivers = (List<Driver>) request.getAttribute("drivers");
    if (drivers == null) drivers = new ArrayList<>();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Drivers | Mega City Cab</title>
    
    <!-- Bootstrap & Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <!-- Custom Styles -->
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Arial', sans-serif;
        }
        .sidebar {
            width: 260px;
            height: 100vh;
            position: fixed;
            background-color: #212529;
            padding-top: 20px;
        }
        .sidebar h4 {
            text-align: center;
            color: #FFC107;
            font-weight: bold;
        }
        .sidebar a {
            color: white;
            padding: 12px;
            display: flex;
            align-items: center;
            text-decoration: none;
            font-size: 16px;
            transition: 0.3s;
        }
        .sidebar a i {
            margin-right: 10px;
        }
        .sidebar a:hover {
            background-color: #343a40;
            padding-left: 18px;
        }
        .main-content {
            margin-left: 260px;
            padding: 20px;
        }
        .dashboard-header {
            background-color: #FFC107;
            padding: 15px;
            text-align: center;
            border-radius: 5px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        .table-responsive {
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .table thead {
            background-color: #FFC107;
            color: #212529;
        }
        .status-badge {
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 500;
        }
        .badge-active {
            background-color: #28a745;
            color: white;
        }
        .badge-inactive {
            background-color: #dc3545;
            color: white;
        }
        .profile-img {
            width: 40px;
            height: 40px;
            object-fit: cover;
            border-radius: 50%;
            border: 2px solid #ffc107;
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <h4>Mega City Cab</h4>
    <a href="${pageContext.request.contextPath}/AdminController?action=dashboard">
        <i class="fas fa-home"></i> Dashboard
    </a>
    <a href="${pageContext.request.contextPath}/UserController">
        <i class="fas fa-users"></i> Manage Users
    </a>
    <a href="${pageContext.request.contextPath}/BookingController?action=manage">
        <i class="fas fa-car"></i> Manage Bookings
    </a>
    <a href="${pageContext.request.contextPath}/DriverController" class="active">
        <i class="fas fa-id-card"></i> Manage Drivers
    </a>
    <a href="${pageContext.request.contextPath}/Views/Admin/reports.jsp">
        <i class="fas fa-chart-bar"></i> Reports
    </a>
    <a href="${pageContext.request.contextPath}/Views/Admin/settings.jsp">
        <i class="fas fa-cogs"></i> Settings
    </a>
    <a href="${pageContext.request.contextPath}/Views/login.jsp" class="text-danger">
        <i class="fas fa-sign-out-alt"></i> Logout
    </a>
</div>

<!-- Main Content -->
<div class="main-content">
    <!-- Header -->
    <div class="dashboard-header">
        <h2 class="mb-0"><i class="fas fa-id-card"></i> Manage Drivers</h2>
    </div>

    <!-- Drivers Table -->
    <div class="table-responsive">
        <table class="table table-striped table-hover align-middle">
            <thead>
                <tr>
                    <th>Profile</th>
                    <th>Driver ID</th>
                    <th>Name</th>
                    <th>Contact</th>
                    <th>Vehicle Info</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (drivers.isEmpty()) { %>
                    <tr>
                        <td colspan="7" class="text-center text-muted py-4">No drivers found</td>
                    </tr>
                <% } else { 
                    for (Driver driver : drivers) { 
                %>
                    <tr>
                        <td>
                            <img src="${pageContext.request.contextPath}/GetProfilePicture?userID=<%= driver.getUserID() %>" 
                                 alt="Profile" class="profile-img">
                        </td>
                        <td><%= driver.getUserID() %></td>
                        <td><%= driver.getName() %></td>
                        <td>
                            <div><%= driver.getEmail() %></div>
                            <small class="text-muted"><%= driver.getPhone() %></small>
                        </td>
                        <td>
                            <div><strong><%= driver.getVehicleType() %></strong></div>
                            <small class="text-muted"><%= driver.getLicensePlate() %></small>
                        </td>
                        <td>
                            <% if ("Available".equalsIgnoreCase(driver.getStatus())) { %>
                                <span class="status-badge badge-active">Active</span>
                            <% } else { %>
                                <span class="status-badge badge-inactive">Inactive</span>
                            <% } %>
                        </td>
                        <td>
                            <button class="btn btn-sm btn-warning" title="Edit">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn btn-sm btn-danger ms-2" title="Delete">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                <% } 
                } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

</body>
</html>