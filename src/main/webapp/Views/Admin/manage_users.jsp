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
    if (users == null) {
        users = List.of(); 
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Users | Mega City Cab</title>

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
        .profile-img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }
    </style>
</head>
<body>

<div class="container mt-4">
    <h2><i class="fas fa-users"></i> Manage Users</h2>

    <!-- Search & Filter -->
    <div class="row mb-3">
        <div class="col-md-6">
            <input type="text" id="searchInput" class="form-control" placeholder="Search by Name, Email, Phone">
        </div>
        <div class="col-md-3">
            <select id="filterRole" class="form-control">
                <option value="">All Roles</option>
                <option value="Customer">Customer</option>
                <option value="Driver">Driver</option>
            </select>
        </div>
        <div class="col-md-3">
            <button class="btn btn-primary btn-custom" data-bs-toggle="modal" data-bs-target="#addUserModal">
                <i class="fas fa-user-plus"></i> Add User
            </button>
        </div>
    </div>

    <!-- Users Table -->
    <table class="table table-striped">
        <thead>
            <tr>
                <th>User ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Role</th>
                <th>Profile</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody id="userTable">
            <% if (users.isEmpty()) { %>
                <tr>
                    <td colspan="7" class="text-center text-danger">No users found.</td>
                </tr>
            <% } else { %>
                <% for (User user : users) { %>
                    <tr>
                        <td><%= user.getUserID() %></td>
                        <td><%= user.getName() %></td>
                        <td><%= user.getEmail() %></td>
                        <td><%= user.getPhone() %></td>
                        <td><%= user.getRole() %></td>
                        <td>
                            <% if (user.getProfilePicture() != null) { %>
                                <img src="${pageContext.request.contextPath}/GetProfilePicture?userID=<%= user.getUserID() %>" 
                                     alt="Profile Picture" class="profile-img">
                            <% } else { %>
                                <img src="default-profile.png" alt="No Profile" class="profile-img">
                            <% } %>
                        </td>
                        <td>
                            <button class="btn btn-warning btn-sm btn-custom editBtn" data-id="<%= user.getUserID() %>">
                                <i class="fas fa-edit"></i> Edit
                            </button>
                            <button class="btn btn-danger btn-sm btn-custom deleteBtn" data-id="<%= user.getUserID() %>">
                                <i class="fas fa-trash-alt"></i> Delete
                            </button>
                        </td>
                    </tr>
                <% } %>
            <% } %>
        </tbody>
    </table>
</div>

<!-- Bootstrap JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

<script>
    document.querySelectorAll('.editBtn').forEach(button => {
        button.addEventListener('click', function() {
            document.getElementById('editUserID').value = this.getAttribute('data-id');
            document.getElementById('editName').value = this.getAttribute('data-name');
            document.getElementById('editEmail').value = this.getAttribute('data-email');
            document.getElementById('editPhone').value = this.getAttribute('data-phone');
            document.getElementById('editRole').value = this.getAttribute('data-role');
            new bootstrap.Modal(document.getElementById('editUserModal')).show();
        });
    });

    document.querySelectorAll('.deleteBtn').forEach(button => {
        button.addEventListener('click', function() {
            if (confirm("Are you sure you want to delete this user?")) {
                window.location.href = "UserController?action=delete&userID=" + this.getAttribute('data-id');
            }
        });
    });
</script>

</body>
</html>
