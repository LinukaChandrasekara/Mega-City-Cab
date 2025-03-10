<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<% 
    String savedIdentifier = "";
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if (cookie.getName().equals("userIdentifier")) {
                savedIdentifier = cookie.getValue();
                break;
            }
        }
    }
%>
<% if (request.getParameter("success") != null) { %>
    <div class="alert alert-success text-center">
        <%= request.getParameter("success") %>
    </div>
<% } %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mega City Cab | Login</title>

    <!-- Bootstrap & FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <!-- Custom Styles -->
    <link rel="stylesheet" href="style.css">
    <style>
        body {
            background-color: #FFD700;
            font-family: 'Poppins', sans-serif;
        }
        .login-container {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .login-box {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
            text-align: center;
        }
        .logo img {
            width: 80px;
            margin-bottom: 15px;
        }
        .btn-primary {
            background-color: black;
            border: none;
        }
        .btn-primary:hover {
            background-color: #333;
        }
        .login-links a {
            color: black;
            text-decoration: none;
            font-weight: 500;
        }
        .login-links a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="login-container">
    <div class="login-box">
        <div class="logo">
            <img src="/images/logo.png" alt="Mega City Cab">
        </div>
        <h2>Welcome Back!</h2>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger text-center">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/AuthController" method="post">

                <div class="input-group mb-3">
        <span class="input-group-text"><i class="fas fa-user"></i></span>
        <input type="text" class="form-control" name="identifier" placeholder="Email or Username" value="<%= savedIdentifier %>" required>
    </div>
    <div class="input-group mb-3">
        <span class="input-group-text"><i class="fas fa-lock"></i></span>
        <input type="password" class="form-control" name="password" placeholder="Password" required>
    </div>
    <div class="form-check mb-3">
        <input type="checkbox" class="form-check-input" id="rememberMe" name="rememberMe">
        <label class="form-check-label" for="rememberMe">Remember Me</label>
    </div>
    <button type="submit" class="btn btn-primary w-100">Login</button>

            <div class="login-links mt-3">
                <a href="forgotPassword.jsp">Forgot Password?</a>
                <span>|</span>
                <a href="register.jsp">Register Now</a>
            </div>
        </form>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

</body>
</html>