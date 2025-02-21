<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - Mega City Cab</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: url('images/background.jpg') no-repeat center center fixed;
            background-size: cover;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
        }

        /* Background overlay for better contrast */
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5); /* Dark overlay */
            z-index: -1;
        }

        .login-card {
            background-color: rgba(255, 255, 255, 0.95);
            padding: 2.5rem;
            border-radius: 15px;
            box-shadow: 0px 15px 30px rgba(0, 0, 0, 0.2);
            max-width: 400px;
            width: 100%;
            animation: fadeIn 0.7s ease-in-out;
        }

        .profile-icon {
            font-size: 5rem;
            color: #ffc107;
            margin-bottom: 10px;
        }

        h2 {
            font-weight: 500;
        }

        .input-group-text {
            background-color: #ffc107;
            border: none;
            color: #fff;
            border-top-left-radius: 10px;
            border-bottom-left-radius: 10px;
        }

        .form-control {
            border-top-right-radius: 10px;
            border-bottom-right-radius: 10px;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            box-shadow: 0 0 10px rgba(255, 193, 7, 0.6);
            border-color: #ffc107;
        }

        .btn-warning {
            border-radius: 10px;
            font-weight: bold;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .btn-warning:hover {
            background-color: #e0a800;
            transform: scale(1.05);
        }

        .alert {
            border-radius: 10px;
        }

        .register-link a {
            color: #ffc107;
            font-weight: 500;
            text-decoration: none;
        }

        .register-link a:hover {
            text-decoration: underline;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="login-card text-center">
        <i class="bi bi-person-circle profile-icon"></i>
        <h2 class="text-warning mb-4">Mega City Cab - Login</h2>
                <%-- Display login message if redirected --%>
        <% if(request.getParameter("message") != null) { %>
            <div class="alert alert-info"><%= request.getParameter("message") %></div>
        <% } %>

        <% if(request.getAttribute("error") != null) { %>
            <div class="alert alert-danger text-center"><%= request.getAttribute("error") %></div>
        <% } %>

        <form action="login" method="post">
            <div class="mb-3">
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-person-fill"></i></span>
                    <input type="text" class="form-control" name="username" placeholder="Enter your username" required>
                </div>
            </div>
            <div class="mb-3">
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                    <input type="password" class="form-control" name="password" placeholder="Enter your password" required>
                </div>
            </div>
            <button type="submit" class="btn btn-warning w-100">Login</button>
        </form>

        <p class="mt-3 register-link">
            New user? <a href="register.jsp">Register here</a>
        </p>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
