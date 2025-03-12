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
        .alert {
            position: relative;
            padding: 10px;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>

<div class="container mt-4">
    <h2><i class="fas fa-tasks"></i> Manage Bookings</h2>

    <!-- ✅ Bootstrap Alerts for Success & Error Messages -->
    <% 
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");

    if (successMessage != null) { 
    %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fas fa-check-circle"></i> <%= successMessage %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% 
        session.removeAttribute("successMessage");
    }
    if (errorMessage != null) { 
    %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% 
        session.removeAttribute("errorMessage");
    }
    %>

    <!-- ✅ JavaScript to Auto-Hide Alerts After 5 Seconds -->
    <script>
        setTimeout(() => {
            let alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                alert.classList.remove('show');
                alert.classList.add('fade');
            });
        }, 5000);
    </script>

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
      bookings = (List<Booking>) bookingsObj;
  }
%>

            <% for (Booking booking : bookings) { %>
                <tr>
                    <td><%= booking.getBookingID() %></td>
                    <td><%= booking.getCustomerName() %></td>
                    <td><%= booking.getDriverName() != null ? booking.getDriverName() : "Not Assigned" %></td>
                    <td><%= booking.getPickupLat() + ", " + booking.getPickupLng() %></td>
                    <td><%= booking.getDropoffLat() + ", " + booking.getDropoffLng() %></td>
                    <td><%= booking.getBookingDate() %></td>
                    <td><%= booking.getStatus() %></td>
                    <td>
                        <button class="btn btn-warning btn-sm btn-custom updateBtn" data-id="<%= booking.getBookingID() %>"><i class="fas fa-edit"></i> Update</button>
                    </td>
                </tr>
            <% } %>
        </tbody>
    </table>
</div>

<!-- ✅ JavaScript to Set Booking ID in Modal -->
<script>
document.querySelectorAll('.updateBtn').forEach(button => {
    button.addEventListener('click', function () {
        let bookingID = this.getAttribute('data-id');
        document.getElementById('updateBookingID').value = bookingID;
        new bootstrap.Modal(document.getElementById('updateBookingModal')).show();
    });
});
</script>

<!-- ✅ Update Booking Modal -->
<div class="modal fade" id="updateBookingModal" tabindex="-1" aria-labelledby="updateBookingModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-edit"></i> Update Booking Status</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="updateBookingForm" action="BookingController" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="bookingID" id="updateBookingID">
                    <label><strong>Status</strong></label>
                    <select class="form-control" name="status">
                        <option value="Pending">Pending</option>
                        <option value="Ongoing">Ongoing</option>
                        <option value="Completed">Completed</option>
                        <option value="Cancelled">Cancelled</option>
                    </select>
                    <button type="submit" class="btn btn-primary w-100 mt-3">Update Booking</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

</body>
</html>
