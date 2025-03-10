<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="com.megacitycab.models.User" %>

<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("userRole") == null || !"Admin".equals(userSession.getAttribute("userRole"))) {
        response.sendRedirect("../login.jsp?error=Unauthorized Access!");
        return;
    }
%>

<%
    int totalBookings = request.getAttribute("totalBookings") != null ? (int) request.getAttribute("totalBookings") : 0;
    int totalCustomers = request.getAttribute("totalCustomers") != null ? (int) request.getAttribute("totalCustomers") : 0;
    int totalDrivers = request.getAttribute("totalDrivers") != null ? (int) request.getAttribute("totalDrivers") : 0;
    double totalRevenue = request.getAttribute("totalRevenue") != null ? (double) request.getAttribute("totalRevenue") : 0.0;

    Object liveRidesObj = request.getAttribute("liveRides");
    List<Map<String, String>> liveRides = liveRidesObj instanceof List ? (List<Map<String, String>>) liveRidesObj : List.of();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | Mega City Cab</title>

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
        }
        .dashboard-header h2 {
            margin: 0;
            font-weight: bold;
        }
        .card-custom {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border: none;
        }
        .table-dark thead {
            background-color: #FFC107;
            color: #212529;
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <h4>Mega City Cab</h4>
    <a href="${pageContext.request.contextPath}/AdminController"><i class="fas fa-home"></i> Dashboard</a>
    <a href="${pageContext.request.contextPath}/UserController"><i class="fas fa-users"></i> Manage Users</a>
    <a href="${pageContext.request.contextPath}/Views/Admin/manage_bookings.jsp"><i class="fas fa-car"></i> Manage Bookings</a>
    <a href="${pageContext.request.contextPath}/DriverController"><i class="fas fa-id-card"></i> Manage Drivers</a>
    <a href="${pageContext.request.contextPath}/Views/Admin/reports.jsp"><i class="fas fa-chart-bar"></i> Reports</a>
    <a href="${pageContext.request.contextPath}/Views/Admin/settings.jsp"><i class="fas fa-cogs"></i> Settings</a>
    <a href="${pageContext.request.contextPath}/Views/login.jsp?" class="text-danger"><i class="fas fa-sign-out-alt"></i> Logout</a>
</div>

<!-- Main Content -->
<div class="main-content">
    <!-- Dashboard Heading with Background -->
    <div class="dashboard-header mb-4">
        <h2>Admin Dashboard</h2>
    </div>

    <!-- Dashboard Stats -->
    <div class="row">
        <div class="col-md-3">
            <div class="card card-custom text-white bg-primary">
                <div class="card-body text-center">
                    <h5><i class="fas fa-file-alt"></i> Total Bookings</h5>
                    <h2><%= totalBookings %></h2>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card card-custom text-white bg-success">
                <div class="card-body text-center">
                    <h5><i class="fas fa-user"></i> Total Customers</h5>
                    <h2><%= totalCustomers %></h2>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card card-custom text-white bg-warning">
                <div class="card-body text-center">
                    <h5><i class="fas fa-id-card"></i> Total Drivers</h5>
                    <h2><%= totalDrivers %></h2>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card card-custom text-white bg-danger">
                <div class="card-body text-center">
                    <h5><i class="fas fa-dollar-sign"></i> Total Revenue</h5>
                    <h2>$<%= totalRevenue %></h2>
                </div>
            </div>
        </div>
    </div>

    <!-- Live Ride Status -->
    <div class="card card-custom mt-4">
        <div class="card-body">
            <h5><i class="fas fa-car"></i> Live Ride Status</h5>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Customer</th>
                        <th>Driver</th>
                        <th>Status</th>
                        <th>Fare</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, String> ride : liveRides) { %>
                        <tr>
                            <td><%= ride.get("BookingID") %></td>
                            <td><%= ride.get("CustomerID") %></td>
                            <td><%= ride.get("DriverID") %></td>
                            <td><%= ride.get("Status") %></td>
                            <td>$<%= ride.get("Fare") %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

</div>

<!-- Bootstrap JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

</body>
</html>
