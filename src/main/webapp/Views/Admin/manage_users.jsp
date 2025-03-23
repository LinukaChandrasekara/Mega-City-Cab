<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.megacitycab.models.User" %>

<%
    User loggedUser = (User) session.getAttribute("user");
    if (loggedUser == null || !"Admin".equalsIgnoreCase(loggedUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/Views/login.jsp?error=Unauthorized%20Access");
        return;
    }

    List<User> users = (List<User>) request.getAttribute("users");
    if (users == null) users = List.of(); 
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Users | Mega City Cab</title>
    
    <!-- Bootstrap & Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <style>
        /* Consistent Dashboard Styling */
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
            background-color: #ffc107;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }

        .card-custom {
            border-radius: 10px;
            background-color: white;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }

        .table thead {
            background-color: #FFC107;
            color: #212529;
        }

        .btn-primary {
            background-color: #007bff;
            border: none;
            transition: transform 0.2s;
        }

        .btn-warning {
            background-color: #ffc107;
            border: none;
        }

        .btn-danger {
            background-color: #dc3545;
            border: none;
        }

        .btn-custom:hover {
            transform: scale(1.05);
        }

        .profile-img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #ffc107;
        }

        .modal-header {
            background-color: #ffc107;
            color: #212529;
        }

        .form-control:focus {
            border-color: #ffc107;
            box-shadow: 0 0 0 0.25rem rgba(255, 193, 7, 0.25);
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <h4>Mega City Cab</h4>
    <a href="${pageContext.request.contextPath}/AdminController"><i class="fas fa-home"></i> Dashboard</a>
    <a href="${pageContext.request.contextPath}/UserController"><i class="fas fa-users"></i> Manage Users</a>
    <a href="${pageContext.request.contextPath}/BookingController?action=manage"><i class="fas fa-car"></i> Manage Bookings</a>
    <a href="${pageContext.request.contextPath}/DriverController"><i class="fas fa-id-card"></i> Manage Drivers</a>
    <a href="${pageContext.request.contextPath}/Views/Admin/reports.jsp"><i class="fas fa-chart-bar"></i> Reports</a>
    <a href="${pageContext.request.contextPath}/Views/Admin/settings.jsp"><i class="fas fa-cogs"></i> Settings</a>
    <a href="${pageContext.request.contextPath}/Views/login.jsp" class="text-danger"><i class="fas fa-sign-out-alt"></i> Logout</a>
</div>

<!-- Main Content -->
<div class="main-content">
    <div class="dashboard-header">
        <h2 class="mb-0"><i class="fas fa-users"></i> Manage Users</h2>
    </div>

    <div class="card-custom">
        <!-- Search & Actions -->
        <div class="row mb-4">
            <div class="col-md-6">
                <input type="text" class="form-control" placeholder="Search users..." id="searchInput">
            </div>
            <div class="col-md-3">
                <select class="form-select" id="roleFilter">
                    <option value="">All Roles</option>
                    <option value="Customer">Customer</option>
                    <option value="Driver">Driver</option>
                    <option value="Admin">Admin</option>
                </select>
            </div>
            <div class="col-md-3">
                <button class="btn btn-primary w-100 btn-custom" data-bs-toggle="modal" data-bs-target="#addUserModal">
                    <i class="fas fa-user-plus"></i> Add User
                </button>
            </div>
        </div>

        <!-- Users Table -->
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Role</th>
                    <th>Profile</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (users.isEmpty()) { %>
                    <tr>
                        <td colspan="7" class="text-center text-danger">No users found</td>
                    </tr>
                <% } else { 
                    for (User user : users) { %>
                    <tr>
                        <td><%= user.getUserID() %></td>
                        <td><%= user.getName() %></td>
                        <td><%= user.getEmail() %></td>
                        <td><%= user.getPhone() %></td>
                        <td>
                            <span class="badge 
                                <% switch(user.getRole()) {
                                    case "Admin": %>bg-danger<%
                                        break;
                                    case "Driver": %>bg-primary<%
                                        break;
                                    default: %>bg-success<%
                                } %>">
                                <%= user.getRole() %>
                            </span>
                        </td>
                        <td>
                            <img src="${pageContext.request.contextPath}/GetProfilePicture?userID=<%= user.getUserID() %>" 
                                 class="profile-img" 
                                 onerror="this.src='${pageContext.request.contextPath}/images/default-profile.png'">
                        </td>
                        <td>
                            <button class="btn btn-warning btn-sm btn-custom edit-btn"
                                    data-bs-toggle="modal"
                                    data-bs-target="#editUserModal"
                                    data-id="<%= user.getUserID() %>"
                                    data-name="<%= user.getName() %>"
                                    data-email="<%= user.getEmail() %>"
                                    data-phone="<%= user.getPhone() %>"
                                    data-role="<%= user.getRole() %>">
                                <i class="fas fa-edit"></i> Edit
                            </button>
                            <button class="btn btn-danger btn-sm btn-custom delete-btn" 
                                    data-id="<%= user.getUserID() %>">
                                <i class="fas fa-trash"></i> Delete
                            </button>
                        </td>
                    </tr>
                <% }} %>
            </tbody>
        </table>
    </div>
</div>

<!-- Add User Modal -->
<div class="modal fade" id="addUserModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-user-plus"></i> Add New User</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="UserController" method="post" enctype="multipart/form-data">
                <div class="modal-body">
                    <input type="hidden" name="action" value="add">
                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" class="form-control" name="name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" name="email" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Phone</label>
                        <input type="tel" class="form-control" name="phone" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Role</label>
                        <select class="form-select" name="role" required>
                            <option value="Customer">Customer</option>
                            <option value="Driver">Driver</option>
                            <option value="Admin">Admin</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Profile Picture</label>
                        <input type="file" class="form-control" name="profilePicture" accept="image/*">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Add User</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit User Modal -->
<div class="modal fade" id="editUserModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-edit"></i> Edit User</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="UserController" method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="userID" id="editUserId">
                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" class="form-control" name="name" id="editName" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" name="email" id="editEmail" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Phone</label>
                        <input type="tel" class="form-control" name="phone" id="editPhone" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Role</label>
                        <select class="form-select" name="role" id="editRole" required>
                            <option value="Customer">Customer</option>
                            <option value="Driver">Driver</option>
                            <option value="Admin">Admin</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
<script>
    // Edit User Modal Handler
    document.querySelectorAll('.edit-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            document.getElementById('editUserId').value = btn.dataset.id;
            document.getElementById('editName').value = btn.dataset.name;
            document.getElementById('editEmail').value = btn.dataset.email;
            document.getElementById('editPhone').value = btn.dataset.phone;
            document.getElementById('editRole').value = btn.dataset.role;
        });
    });

    // Delete User Handler
    document.querySelectorAll('.delete-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            if (confirm('Are you sure you want to delete this user?')) {
                window.location.href = `UserController?action=delete&userID=${btn.dataset.id}`;
            }
        });
    });

    // Search Functionality
    document.getElementById('searchInput').addEventListener('input', function() {
        const filter = this.value.toLowerCase();
        document.querySelectorAll('tbody tr').forEach(row => {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(filter) ? '' : 'none';
        });
    });

    // Role Filter
    document.getElementById('roleFilter').addEventListener('change', function() {
        const filter = this.value;
        document.querySelectorAll('tbody tr').forEach(row => {
            const role = row.querySelector('td:nth-child(5)').textContent;
            row.style.display = (filter === '' || role === filter) ? '' : 'none';
        });
    });
</script>

</body>
</html>