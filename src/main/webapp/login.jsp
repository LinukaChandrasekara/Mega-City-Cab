<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Mega City Cab</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="text-center">
    <div class="container mt-5">
        <h2 class="text-warning">Mega City Cab - Login</h2>

        <% if(request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
        <% } %>

        <form action="login" method="post">
            <div class="mb-3">
                <label class="form-label">Username</label>
                <input type="text" class="form-control" name="username" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Password</label>
                <input type="password" class="form-control" name="password" required>
            </div>
            <button type="submit" class="btn btn-warning w-100">Login</button>
        </form>
        <p class="mt-3">New user? <a href="register.jsp">Register</a></p>
    </div>
</body>
</html>
