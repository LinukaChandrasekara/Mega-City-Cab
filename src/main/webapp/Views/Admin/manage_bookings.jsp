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
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Bookings | Mega City Cab</title>

    <!-- Bootstrap & Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <!-- Custom Styles -->
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Arial', sans-serif;
        }
        .container {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        h2 {
            background: #ffc107;
            padding: 12px;
            border-radius: 5px;
            text-align: center;
            font-weight: bold;
            color: #212529;
        }
        .table {
            border-radius: 10px;
            overflow: hidden;
        }
        .table thead {
            background-color: #ffc107;
            color: #212529;
        }
        .btn-custom {
            transition: 0.3s ease-in-out;
        }
        .btn-custom:hover {
            transform: scale(1.05);
        }
        .modal-content {
            border-radius: 10px;
        }
        .modal-header {
            background-color: #ffc107;
            color: #212529;
        }
    </style>
</head>
<body>

<div class="container mt-4">
    <h2><i class="fas fa-tasks"></i> Manage Bookings</h2>

    <!-- Search & Filter -->
    <div class="row mb-3">
        <div class="col-md-3">
            <select id="filterStatus" class="form-control">
                <option value="">All Statuses</option>
                <option value="Pending">Pending</option>
                <option value="Ongoing">Ongoing</option>
                <option value="Completed">Completed</option>
                <option value="Cancelled">Cancelled</option>
            </select>
        </div>
        <div class="col-md-3">
            <input type="date" id="filterDate" class="form-control">
        </div>
        <div class="col-md-3">
            <input type="text" id="filterCustomer" class="form-control" placeholder="Search by Customer">
        </div>
        <div class="col-md-3">
            <input type="text" id="filterDriver" class="form-control" placeholder="Search by Driver">
        </div>
    </div>

    <!-- Bookings Table -->
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
        <tbody id="bookingTable">
            <%
                Object bookingsObj = request.getAttribute("bookings");
                List<Booking> bookings = new ArrayList<>();
                if (bookingsObj instanceof List<?>) { 
                    bookings = (List<Booking>) bookingsObj; // ✅ Safe casting
                }
            %>
            <% for (Booking booking : bookings) { %>
                <tr>
                    <td><%= booking.getBookingID() %></td>
                    <td><%= booking.getCustomerID() %></td>
                    <td><%= booking.getDriverID() != 0 ? booking.getDriverID() : "Not Assigned" %></td>
                    <td><%= booking.getPickupLat() + ", " + booking.getPickupLng() %></td>
                    <td><%= booking.getDropoffLat() + ", " + booking.getDropoffLng() %></td>
                    <td><%= booking.getBookingDate() %></td>
                    <td><%= booking.getStatus() %></td>
                    <td>
                        <button class="btn btn-warning btn-sm btn-custom updateBtn" data-id="<%= booking.getBookingID() %>"><i class="fas fa-edit"></i> Update</button>
                        <button class="btn btn-danger btn-sm btn-custom cancelBtn" data-id="<%= booking.getBookingID() %>"><i class="fas fa-ban"></i> Cancel</button>
                    </td>
                </tr>
            <% } %>
        </tbody>
    </table>
</div>

<!-- Update Booking Modal -->
<div class="modal fade" id="updateBookingModal" tabindex="-1" aria-labelledby="updateBookingModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="updateBookingModalLabel"><i class="fas fa-edit"></i> Update Booking Status</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="updateBookingForm" action="BookingController" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="bookingID" id="updateBookingID">
                    <div class="mb-3">
                        <label><strong>Status</strong></label>
                        <select class="form-control" name="status" id="updateStatus">
                            <option value="Pending">Pending</option>
                            <option value="Ongoing">Ongoing</option>
                            <option value="Completed">Completed</option>
                            <option value="Cancelled">Cancelled</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Update Booking</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- JavaScript for Modals & Actions -->
<script>
    document.querySelectorAll('.updateBtn').forEach(button => {
        button.addEventListener('click', function() {
            document.getElementById('updateBookingID').value = this.getAttribute('data-id');
            new bootstrap.Modal(document.getElementById('updateBookingModal')).show();
        });
    });

    document.querySelectorAll('.cancelBtn').forEach(button => {
        button.addEventListener('click', function() {
            if (confirm("Are you sure you want to cancel this booking?")) {
                window.location.href = "BookingController?action=cancel&bookingID=" + this.getAttribute('data-id');
            }
        });
    });
</script>

<!-- Bootstrap JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

</body>
</html>
