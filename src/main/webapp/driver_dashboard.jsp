<%@ page session="true" %>
<%@ page import="java.sql.*, com.megacitycab.dao.DBUtil" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || !"driver".equals(role)) {
        response.sendRedirect("login.jsp?message=Driver access required.");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Driver Dashboard - Mega City Cab</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-black">
    <div class="container">
        <a class="navbar-brand text-warning"><b>Driver Dashboard</b></a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link text-white" href="index.jsp">Home</a></li>
                <li class="nav-item"><a class="nav-link text-white" href="assigned_rides.jsp">Assigned Rides</a></li>
                <li class="nav-item"><a class="nav-link text-danger" href="logout">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<!-- Tabs -->
<div class="container mt-5">
    <ul class="nav nav-tabs" id="driverTabs">
        <li class="nav-item">
            <a class="nav-link active" data-bs-toggle="tab" href="#profile">Profile</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" data-bs-toggle="tab" href="#vehicle">My Vehicle</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" data-bs-toggle="tab" href="#rides">Assigned Rides</a>
        </li>
    </ul>

    <div class="tab-content mt-4">

        <!-- Profile Section -->
        <div id="profile" class="tab-pane fade show active">
            <h3>My Profile</h3>
            <%
                try (Connection con = DBUtil.getConnection()) {
                    PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE username = ?");
                    ps.setString(1, username);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
            %>
            <form action="UpdateDriverProfileServlet" method="post">
                <input type="hidden" name="username" value="<%= username %>">
                <div class="mb-3">
                    <label>Full Name:</label>
                    <input type="text" class="form-control" name="full_name" value="<%= rs.getString("full_name") %>" required>
                </div>
                <div class="mb-3">
                    <label>NIC:</label>
                    <input type="text" class="form-control" name="nic" value="<%= rs.getString("nic") %>" required>
                </div>
                <div class="mb-3">
                    <label>Phone Number:</label>
                    <input type="text" class="form-control" name="phone_number" value="<%= rs.getString("phone_number") %>" required>
                </div>
                <button type="submit" class="btn btn-primary">Update Profile</button>
            </form>
            <%
                    } else {
                        out.println("<p class='text-danger'>Profile not found.</p>");
                    }
                } catch (SQLException e) {
                    out.println("<p class='text-danger'>Error loading profile.</p>");
                    e.printStackTrace();
                }
            %>
        </div>

        <!-- Vehicle Management Section -->
        <div id="vehicle" class="tab-pane fade">
            <h3>My Vehicle</h3>
            <%
                try (Connection con = DBUtil.getConnection()) {
                    PreparedStatement ps = con.prepareStatement(
                        "SELECT v.* FROM vehicles v JOIN drivers d ON v.vehicle_id = d.assigned_vehicle_id JOIN users u ON d.driver_id = u.user_id WHERE u.username = ?"
                    );
                    ps.setString(1, username);
                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {
            %>
            <form action="ManageVehicleServlet" method="post">
                <input type="hidden" name="vehicle_id" value="<%= rs.getInt("vehicle_id") %>">
                <div class="mb-3">
                    <label>Vehicle Type:</label>
                    <select class="form-select" name="vehicle_type" required>
                        <option value="bike" <%= "bike".equals(rs.getString("vehicle_type")) ? "selected" : "" %>>Bike</option>
                        <option value="cab" <%= "cab".equals(rs.getString("vehicle_type")) ? "selected" : "" %>>Cab</option>
                        <option value="car" <%= "car".equals(rs.getString("vehicle_type")) ? "selected" : "" %>>Car</option>
                        <option value="van" <%= "van".equals(rs.getString("vehicle_type")) ? "selected" : "" %>>Van</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label>Model:</label>
                    <input type="text" class="form-control" name="model" value="<%= rs.getString("model") %>" required>
                </div>
                <div class="mb-3">
                    <label>License Plate:</label>
                    <input type="text" class="form-control" name="license_plate" value="<%= rs.getString("license_plate") %>" required>
                </div>
                <button type="submit" class="btn btn-success">Update Vehicle</button>
            </form>
            <%
                    } else {
            %>
            <p>No vehicle assigned. You can register a new one below:</p>
            <form action="ManageVehicleServlet" method="post">
                <div class="mb-3">
                    <label>Vehicle Type:</label>
                    <select class="form-select" name="vehicle_type" required>
                        <option value="bike">Bike</option>
                        <option value="cab">Cab</option>
                        <option value="car">Car</option>
                        <option value="van">Van</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label>Model:</label>
                    <input type="text" class="form-control" name="model" required>
                </div>
                <div class="mb-3">
                    <label>License Plate:</label>
                    <input type="text" class="form-control" name="license_plate" required>
                </div>
                <button type="submit" class="btn btn-primary">Register Vehicle</button>
            </form>
            <%
                    }
                } catch (SQLException e) {
                    out.println("<p class='text-danger'>Error loading vehicle information.</p>");
                    e.printStackTrace();
                }
            %>
        </div>

        <!-- Assigned Rides Section -->
        <div id="rides" class="tab-pane fade">
            <h3>Assigned Rides</h3>
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Customer</th>
                        <th>Pickup</th>
                        <th>Drop-off</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try (Connection con = DBUtil.getConnection()) {
                            PreparedStatement ps = con.prepareStatement(
                                "SELECT b.* FROM bookings b JOIN users u ON b.driver_id = u.user_id WHERE u.username = ?"
                            );
                            ps.setString(1, username);
                            ResultSet rs = ps.executeQuery();

                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("booking_id") %></td>
                        <td><%= rs.getString("customer_name") %></td>
                        <td><%= rs.getString("pickup_location") %></td>
                        <td><%= rs.getString("dropoff_location") %></td>
                        <td><%= rs.getDate("date") %></td>
                        <td><%= rs.getString("status") %></td>
                        <td>
                            <% if (!"Completed".equals(rs.getString("status"))) { %>
                                <a href="UpdateRideStatusServlet?bookingId=<%= rs.getInt("booking_id") %>&status=Completed" class="btn btn-sm btn-success">Mark as Completed</a>
                            <% } else { %>
                                <span class="badge bg-success">Completed</span>
                            <% } %>
                        </td>
                    </tr>
                    <%
                            }
                        } catch (SQLException e) {
                            out.println("<tr><td colspan='7' class='text-danger'>Error loading rides.</td></tr>");
                            e.printStackTrace();
                        }
                    %>
                </tbody>
            </table>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
