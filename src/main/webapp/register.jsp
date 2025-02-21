<!DOCTYPE html>
<html>
<head>
    <title>Register - Mega City Cab</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="text-center">
    <div class="container mt-5">
        <h2 class="text-warning">Mega City Cab - Register</h2>

        <% if(request.getAttribute("message") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("message") %></div>
        <% } %>

        <form action="register" method="post">
            <div class="mb-3">
                <label class="form-label">Username</label>
                <input type="text" class="form-control" name="username" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Password</label>
                <input type="password" class="form-control" name="password" required>
            </div>
            <button type="submit" class="btn btn-warning w-100">Sign Up</button>
        </form>
        <p class="mt-3">Already have an account? <a href="login.jsp">Login</a></p>
    </div>
</body>
</html>
