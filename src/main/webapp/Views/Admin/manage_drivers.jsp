<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.megacitycab.models.*" %>

<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("user") == null || !"Admin".equals(userSession.getAttribute("userRole"))) {
        response.sendRedirect(request.getContextPath() + "/Views/login.jsp?error=Unauthorized%20Access");
        return;
    }

    List<Driver> drivers = (List<Driver>) request.getAttribute("drivers");

    if (drivers == null) {
        System.out.println("❌ ERROR: Drivers list is NULL in JSP!");
        drivers = new ArrayList<>();
    } else {
        System.out.println("📌 JSP: Drivers Count = " + drivers.size());
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Drivers | Mega City Cab</title>

    <!-- Bootstrap & Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <!-- Custom Styles -->
    <style>
        /* Sidebar Styling */
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
            margin-bottom: 20px;
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
        
        /* Main Content Styling */
        .main-content {
            margin-left: 280px; /* Sidebar width + gap */
            padding: 20px;
        }
        body {
            background-color: #f8f9fa;
            font-family: 'Arial', sans-serif;
        }
        .container-custom {
            margin-top: 40px;
        }
        /* Header Background */
        .heading-container {
            background-color: #ffc107;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        /* Table Styling */
        .table thead {
            background-color: #ffc107;
            color: #212529;
        }
        /* Profile Image */
        .profile-img {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 50%;
            border: 2px solid #ffc107;
        }
        /* Status Badge */
        .badge {
            padding: 8px 12px;
            font-size: 14px;
            border-radius: 15px;
        }
        .badge-active {
            background-color: #28a745;
            color: white;
        }
        .badge-inactive {
            background-color: #dc3545;
            color: white;
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
        <a href="${pageContext.request.contextPath}/Views/login.jsp" class="text-danger"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="container-custom">
            <!-- Dashboard Heading with Background -->
            <div class="heading-container">
                <h2 class="fw-bold mb-0"><i class="fas fa-id-card"></i> View Drivers</h2>
            </div>
            
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Profile</th>
                        <th>Driver ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Vehicle</th>
                        <th>License Plate</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (drivers.isEmpty()) { %>
                        <tr>
                            <td colspan="8" class="text-center text-danger fw-bold">No drivers found.</td>
                        </tr>
                    <% } else { %>
                        <% for (Driver driver : drivers) { %>
                            <tr>
                                <!-- Profile Picture -->
                                <td class="text-center">
                                    <% if (driver.getProfilePicture() != null) { %>
                                        <img src="${pageContext.request.contextPath}/GetProfilePicture?userID=<%= driver.getUserID() %>" 
                                             alt="Profile" class="profile-img">
                                    <% } else { %>
                                        <img src="default-profile.png" alt="No Profile" class="profile-img">
                                    <% } %>
                                </td>
                                <td><%= driver.getUserID() %></td>
                                <td><%= driver.getName() %></td>
                                <td><%= driver.getEmail() %></td>
                                <td><%= driver.getPhone() %></td>
                                <!-- Vehicle Info -->
                                <td>
                                    <strong><%= driver.getVehicleType() != null ? driver.getVehicleType() : "N/A" %></strong>
                                    (<%= driver.getModel() != null ? driver.getModel() : "N/A" %>)
                                </td>
                                <td><%= driver.getLicensePlate() != null ? driver.getLicensePlate() : "N/A" %></td>
                                <!-- Status with Badge -->
                                <td>
                                    <% if ("Available".equalsIgnoreCase(driver.getStatus())) { %>
                                        <span class="badge badge-active">Active</span>
                                    <% } else { %>
                                        <span class="badge badge-inactive">Inactive</span>
                                    <% } %>
                                </td>
                            </tr>
                        <% } %>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
