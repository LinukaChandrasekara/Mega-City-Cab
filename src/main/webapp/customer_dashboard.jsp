<%@ page session="true" %>
<%@ page import="java.sql.*, com.megacitycab.dao.DBUtil" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp?message=Please login first.");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-black">
    <div class="container">
        <a class="navbar-brand text-warning"><b>Customer Dashboard</b></a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link text-white" href="index.jsp">Home</a></li>
                <li class="nav-item"><a class="nav-link text-white" href="book.jsp">Book a Ride</a></li>
                <li class="nav-item"><a class="nav-link text-danger" href="logout">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<!-- Dashboard Tabs -->
<div class="container mt-5">
    <ul class="nav nav-tabs" id="dashboardTabs">
        <li class="nav-item">
            <a class="nav-link active" data-bs-toggle="tab" href="#profile">Profile</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" data-bs-toggle="tab" href="#bookings">Booking History</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" data-bs-toggle="tab" href="#feedback">Feedback</a>
        </li>
    </ul>

    <div class="tab-content mt-4">

        <!-- Profile Section -->
        <div id="profile" class="tab-pane fade show active">
            <h3>My Profile</h3>
            <%
                try (Connection con = DBUtil.getConnection();
                     PreparedStatement ps = con.prepareStatement("SELECT full_name, nic, address, phone_number FROM Users WHERE username = ?")) {
                    
                    ps.setString(1, username);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
            %>
            <form action="UpdateProfileServlet" method="post">
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
                    <label>Address:</label>
                    <input type="text" class="form-control" name="address" value="<%= rs.getString("address") %>" required>
                </div>
                <div class="mb-3">
                    <label>Phone Number:</label>
                    <input type="text" class="form-control" name="phone_number" value="<%= rs.getString("phone_number") %>" required>
                </div>
                <button type="submit" class="btn btn-primary">Update Profile</button>
            </form>
            <%
                        } else {
            %>
                <p class="text-danger">Profile not found.</p>
            <%
                        }
                    }
                } catch (SQLException e) {
                    out.println("<p class='text-danger'>Error loading profile.</p>");
                    e.printStackTrace();
                }
            %>
        </div>

        <!-- Booking History Section -->
        <div id="bookings" class="tab-pane fade">
            <h3>Booking History</h3>
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Pickup</th>
                        <th>Drop-off</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try (Connection con = DBUtil.getConnection();
                             PreparedStatement ps = con.prepareStatement("SELECT booking_id, pickup_location, dropoff_location, booking_date, status FROM bookings WHERE customer_name = ?")) {
                            
                            ps.setString(1, username);
                            try (ResultSet rs = ps.executeQuery()) {
                                while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("booking_id") %></td>
                        <td><%= rs.getString("pickup_location") %></td>
                        <td><%= rs.getString("dropoff_location") %></td>
                        <td><%= rs.getDate("booking_date") %></td>
                        <td><%= rs.getString("status") %></td>
                        <td>
                            <% if ("Upcoming".equals(rs.getString("status"))) { %>
                                <a href="CancelBookingServlet?bookingId=<%= rs.getInt("booking_id") %>" class="btn btn-sm btn-danger">Cancel</a>
                            <% } else { %>
                                <span class="text-muted">N/A</span>
                            <% } %>
                        </td>
                    </tr>
                    <%
                                }
                            }
                        } catch (SQLException e) {
                            out.println("<tr><td colspan='6' class='text-danger'>Error loading booking history.</td></tr>");
                            e.printStackTrace();
                        }
                    %>
                </tbody>
            </table>
        </div>

        <!-- Feedback Section -->
        <div id="feedback" class="tab-pane fade">
            <h3>Submit Feedback</h3>
            <form action="SubmitFeedbackServlet" method="post">
                <div class="mb-3">
                    <label>Booking ID:</label>
                    <input type="number" class="form-control" name="booking_id" required>
                </div>
                <div class="mb-3">
                    <label>Feedback:</label>
                    <textarea class="form-control" name="feedback_text" rows="3" required></textarea>
                </div>
                <button type="submit" class="btn btn-success">Submit</button>
            </form>

            <h3 class="mt-4">My Feedback</h3>
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Feedback</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try (Connection con = DBUtil.getConnection();
                             PreparedStatement ps = con.prepareStatement("SELECT booking_id, feedback_text, submitted_at FROM feedback WHERE customer_name = ?")) {
                            
                            ps.setString(1, username);
                            try (ResultSet rs = ps.executeQuery()) {
                                while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("booking_id") %></td>
                        <td><%= rs.getString("feedback_text") %></td>
                        <td><%= rs.getDate("submitted_at") %></td>
                    </tr>
                    <%
                                }
                            }
                        } catch (SQLException e) {
                            out.println("<tr><td colspan='3' class='text-danger'>Error loading feedback.</td></tr>");
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
