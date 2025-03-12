<%@ page session="true" %>
<%@ page import="com.megacitycab.models.User, com.megacitycab.models.Driver, com.megacitycab.models.Vehicle, com.megacitycab.dao.VehicleDAO, com.megacitycab.dao.DriverDAO" %>

<%
    HttpSession userSession = request.getSession(false);

    if (userSession == null || userSession.getAttribute("user") == null || !"Driver".equals(((User) userSession.getAttribute("user")).getRole())) {
        response.sendRedirect(request.getContextPath() + "/Views/login.jsp?error=Session%20Error!");
        return;
    }

    // ★ Get logged-in driver
    User user = (User) userSession.getAttribute("user");
    Driver driver = (user instanceof Driver) ? (Driver) user : null;

    if (driver == null) {
        driver = DriverDAO.getDriverById(user.getUserID());
        userSession.setAttribute("user", driver);
    }

    // ★ Fetch Vehicle details from database
    Vehicle vehicle = VehicleDAO.getVehicleByDriverId(driver.getUserID());

    // ★ Handle null case
    String vehicleType = (vehicle != null) ? vehicle.getType() : "Not Assigned";
    String model = (vehicle != null) ? vehicle.getModel() : "";
    String licensePlate = (vehicle != null) ? vehicle.getLicensePlate() : "";
    String availabilityStatus = (vehicle != null) ? vehicle.getStatus() : "Offline"; // Default to Offline
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Vehicle | Mega City Cab</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
        }
        
        /* Sidebar Styles */
        .sidebar {
            width: 260px;
            height: 100vh;
            position: fixed;
            background-color: #212529;
            padding-top: 20px;
            color: white;
        }
        .sidebar h4 {
            text-align: center;
            color: #FFC107;
            font-weight: bold;
        }
        .sidebar a {
            color: white;
            padding: 12px;
            display: block;
            text-decoration: none;
            font-size: 16px;
            transition: 0.3s;
        }
        .sidebar a:hover {
            background-color: #343a40;
            padding-left: 18px;
        }
        
        /* Main Content Adjustment */
        .content {
            margin-left: 260px;
            padding: 20px;
        }
        
        /* Dashboard Heading Background */
        .heading-container {
            background: #ffc107;
            padding: 12px;
            border-radius: 5px;
            text-align: center;
            font-weight: bold;
            color: #212529;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        /* Form Container */
        .container-custom {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            max-width: 600px;
            margin-top: 20px;
        }
        
        /* Button Hover Effects */
        .btn-custom {
            transition: 0.3s ease-in-out;
        }
        .btn-custom:hover {
            transform: scale(1.05);
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <div class="sidebar">
        <h4>Mega City Cab</h4>
        <a href="${pageContext.request.contextPath}/DriverController"><i class="fas fa-home"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/Views/Driver/manage_profile.jsp"><i class="fas fa-user"></i> Manage Profile</a>
        <a href="${pageContext.request.contextPath}/Views/Driver/manage_vehicle.jsp"><i class="fas fa-car"></i> Manage Vehicle</a>
        <a href="${pageContext.request.contextPath}/Views/Driver/available_bookings.jsp"><i class="fas fa-list"></i> Available Bookings</a>
        <a href="${pageContext.request.contextPath}/Views/Driver/customer_reviews.jsp"><i class="fas fa-star"></i> Reviews</a>
        <a href="${pageContext.request.contextPath}/Views/Driver/earnings_dashboard.jsp"><i class="fas fa-dollar-sign"></i> Earnings</a>
        <a href="${pageContext.request.contextPath}/Views/login.jsp?" class="text-danger"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <!-- Main Content -->
    <div class="content">
        <div class="container-custom">
            <!-- Dashboard Heading with Background -->
            <h2 class="heading-container"><i class="fas fa-car"></i> Manage Vehicle</h2>

            <%-- Success & Error Messages --%>
            <% String success = request.getParameter("success");
               String error = request.getParameter("error");
               if (success != null) { %>
                <div class="alert alert-success"><%= success %></div>
            <% } else if (error != null) { %>
                <div class="alert alert-danger"><%= error %></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/DriverController" method="post">
                <input type="hidden" name="action" value="updateVehicle">

                <div class="mb-3">
                    <label class="fw-bold">Vehicle Type</label>
                    <select class="form-select" name="vehicleType" required>
                        <option value="Bike" <%= "Bike".equals(vehicleType) ? "selected" : "" %>>Bike</option>
                        <option value="Car" <%= "Car".equals(vehicleType) ? "selected" : "" %>>Car</option>
                        <option value="Van" <%= "Van".equals(vehicleType) ? "selected" : "" %>>Van</option>
                    </select>
                </div>
                
                <div class="mb-3">
                    <label class="fw-bold">Model</label>
                    <input type="text" class="form-control" name="model" value="<%= model %>" required>
                </div>
                
                <div class="mb-3">
                    <label class="fw-bold">License Plate</label>
                    <input type="text" class="form-control" name="licensePlate" value="<%= licensePlate %>" required>
                </div>

                <div class="mb-3">
                    <label class="fw-bold">Availability Status</label>
                    <select class="form-select" name="availabilityStatus" required>
                        <option value="Available" <%= "Available".equals(availabilityStatus) ? "selected" : "" %>>Available</option>
                        <option value="Busy" <%= "Busy".equals(availabilityStatus) ? "selected" : "" %>>Busy</option>
                        <option value="Offline" <%= "Offline".equals(availabilityStatus) ? "selected" : "" %>>Offline</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-warning w-100 btn-custom"><i class="fas fa-save"></i> Update Vehicle</button>
            </form>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
