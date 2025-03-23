<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.megacitycab.models.*" %>

<%
    HttpSession userSession = request.getSession(false);
    User user = (User) userSession.getAttribute("user");
    if (user == null || !"Admin".equals(user.getRole())) {
        response.sendRedirect("../login.jsp?error=Unauthorized%20Access");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Bookings | Mega City Cab</title>
    
    <!-- Bootstrap & Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <style>
        /* Consistent with admin dashboard styling */
        body {
            background-color: #f8f9fa;
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
        }

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
            margin-bottom: 20px;
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

        .sidebar a i {
            margin-right: 10px;
        }

        .main-content {
            margin-left: 260px;
            padding: 20px;
        }

        .dashboard-header {
            background-color: #ffc107;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }

        .card-custom {
            border-radius: 10px;
            background-color: #ffffff;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 30px;
        }

        .table thead {
            background-color: #FFC107;
            color: #212529;
        }

        .btn-warning {
            background-color: #ffc107;
            border: none;
        }

        .btn-primary {
            background-color: #007bff;
            border: none;
        }

        .alert {
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body>

<!-- Consistent Sidebar -->
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
    <a href="${pageContext.request.contextPath}/DriverController">
        <i class="fas fa-id-card"></i> Manage Drivers
    </a>
    <a href="${pageContext.request.contextPath}/Views/Admin/reports.jsp">
        <i class="fas fa-chart-bar"></i> Reports
    </a>
    <a href="${pageContext.request.contextPath}/Views/Admin/admin_reviews.jsp">
        <i class="fas fa-star"></i> Reviews
    </a>
    <a href="${pageContext.request.contextPath}/Views/Admin/settings.jsp">
        <i class="fas fa-cogs"></i> Settings
    </a>
    <a href="${pageContext.request.contextPath}/Views/login.jsp?" class="text-danger">
        <i class="fas fa-sign-out-alt"></i> Logout
    </a>
</div>

<!-- Main Content -->
<div class="main-content">
    <!-- Dashboard Header -->
    <div class="dashboard-header">
        <h2 class="mb-0"><i class="fas fa-car"></i> Manage Bookings</h2>
    </div>

    <!-- Alerts -->
    <% 
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    %>
    
    <% if (successMessage != null) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fas fa-check-circle me-2"></i><%= successMessage %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% session.removeAttribute("successMessage"); %>
    <% } %>
    
    <% if (errorMessage != null) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="fas fa-exclamation-circle me-2"></i><%= errorMessage %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% session.removeAttribute("errorMessage"); %>
    <% } %>

    <!-- Bookings Table -->
    <div class="card-custom">
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Booking ID</th>
                    <th>Customer</th>
                    <th>Driver</th>
                    <th>Pickup Location</th>
                    <th>Drop-off Location</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% 
                List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
                if (bookings != null) {
                    for (Booking booking : bookings) { 
                %>
                <tr>
                    <td><%= booking.getBookingID() %></td>
                    <td><%= booking.getCustomerName() %></td>
                    <td><%= booking.getDriverName() != null ? booking.getDriverName() : "Not Assigned" %></td>
                    <td><%= String.format("%.6f, %.6f", booking.getPickupLat(), booking.getPickupLng()) %></td>
                    <td><%= String.format("%.6f, %.6f", booking.getDropoffLat(), booking.getDropoffLng()) %></td>
                    <td><%= booking.getBookingDate() != null ? booking.getBookingDate().toString() : "N/A" %></td>
                    <td>
                        <span class="badge 
                            <% switch(booking.getStatus()) {
                                case "Pending": %>bg-warning text-dark<%
                                    break;
                                case "Confirmed": %>bg-primary<%
                                    break;
                                case "Ongoing": %>bg-success<%
                                    break;
                                case "Completed": %>bg-secondary<%
                                    break;
                                case "Cancelled": %>bg-danger<%
                                    break;
                            } %>">
                            <%= booking.getStatus() %>
                        </span>
                    </td>
                    <td>
                        <button class="btn btn-warning btn-sm updateBtn" 
                                data-id="<%= booking.getBookingID() %>">
                            <i class="fas fa-edit"></i> Update
                        </button>
                    </td>
                </tr>
                <% } 
                } else { %>
                <tr>
                    <td colspan="8" class="text-center">No bookings found</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Update Modal -->
<div class="modal fade" id="updateBookingModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-edit"></i> Update Booking Status</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form action="BookingController" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="bookingID" id="updateBookingID">
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Status</label>
                        <select class="form-select" name="status" required>
                            <option value="Pending">Pending</option>
                            <option value="Confirmed">Confirmed</option>
                            <option value="Ongoing">Ongoing</option>
                            <option value="Completed">Completed</option>
                            <option value="Cancelled">Cancelled</option>
                        </select>
                    </div>
                    
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-save me-2"></i>Update Status
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
<script>
    // Activate update buttons
    document.querySelectorAll('.updateBtn').forEach(btn => {
        btn.addEventListener('click', () => {
            document.getElementById('updateBookingID').value = btn.dataset.id;
            new bootstrap.Modal(document.getElementById('updateBookingModal')).show();
        });
    });

    // Auto-hide alerts after 5 seconds
    setTimeout(() => {
        document.querySelectorAll('.alert').forEach(alert => {
            new bootstrap.Alert(alert).close();
        });
    }, 5000);
</script>

</body>
</html>