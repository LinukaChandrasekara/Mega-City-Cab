<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Keep your cookie logic
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

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Mega City Cab | Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <!-- Bootstrap & FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <!-- Custom Styles -->
    <style>
        /* Body & Background */
        body {
            /* Retro-inspired gradient background */
            background: linear-gradient(135deg, #ffcc00 0%, #ff66cc 100%);
            background-repeat: no-repeat;
            background-attachment: fixed;
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            color: #fff; /* Default text color */
        }
        
        /* Full-height container to center content vertically */
        .login-wrapper {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center; /* Center form horizontally */
        }
        
        /* Single-column form container with retro styling */
        .login-form-section {
            background-color: rgba(0, 0, 0, 0.5); /* Semi-transparent black overlay */
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 450px;
        }
        
        /* Retro Heading */
        .retro-heading {
            font-family: 'Courier New', monospace;
            font-size: 2rem;
            color: #ffef00; /* Bright yellow for retro vibe */
            text-shadow: 2px 2px #000;
            margin-bottom: 0.5rem;
        }
        
        /* Logo Image */
        .logo-img {
            width: 80px;
            height: auto;
            display: block;
            margin: 0 auto 1rem auto;
        }
        
        /* Social Icons Container */
        .social-icons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 1rem;
        }
        .social-icons a {
            color: #fff;
            font-size: 1.2rem;
            transition: transform 0.3s;
        }
        .social-icons a:hover {
            transform: scale(1.2);
        }
        
        /* Alerts */
        .alert {
            margin-bottom: 1rem;
        }
        
        /* Input Groups */
        .input-group-text {
            background-color: #ffc107;
            border: none;
            color: #212529;
        }
        .form-control:focus {
            box-shadow: none;
            border-color: #ffc107;
        }
        
        /* Buttons */
        .btn-primary {
            background-color: #FFC107;
            border: none;
            color: #212529;
        }
        .btn-primary:hover {
            background-color: #ffca2c;
        }
        
        .form-check-label {
            margin-left: 5px;
        }
        
        /* Links */
        .login-links {
            margin-top: 1rem;
            display: flex;
            justify-content: center;
            gap: 0.5rem;
        }
        .login-links a {
            color: #fff;
            text-decoration: none;
            font-weight: 500;
        }
        .login-links a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <!-- Display success message if any -->
    <% if (request.getParameter("success") != null) { %>
        <div class="alert alert-success text-center m-0">
            <%= request.getParameter("success") %>
        </div>
    <% } %>
    
    <div class="login-wrapper">
        <!-- Single-column login form -->
        <div class="login-form-section">
            
            <!-- Logo (Optional) -->
            <img src="../Logo.png" class="logo-img">
            
            <!-- Retro Heading -->
            <h1 class="retro-heading text-center">MEGA CITY CAB</h1>
            
            <!-- Social Icons -->
            <div class="social-icons">
                <a href="#"><i class="fab fa-facebook"></i></a>
                <a href="#"><i class="fab fa-google"></i></a>
                <a href="#"><i class="fab fa-x-twitter"></i></a>
                <a href="#"><i class="fab fa-instagram"></i></a>
            </div>
            
            <h2 class="text-center">Login to Your Account</h2>

            <!-- Display error message if any -->
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger text-center">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <!-- Login Form -->
            <form action="${pageContext.request.contextPath}/AuthController" method="post">
                <div class="input-group mb-3">
                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                    <input 
                        type="text" 
                        class="form-control" 
                        name="identifier" 
                        placeholder="Email or Username" 
                        value="<%= savedIdentifier %>" 
                        required
                    >
                </div>

                <div class="input-group mb-3">
                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                    <input 
                        type="password" 
                        class="form-control" 
                        name="password" 
                        placeholder="Password" 
                        required
                    >
                </div>

                <div class="form-check mb-3 text-start">
                    <input type="checkbox" class="form-check-input" id="rememberMe" name="rememberMe">
                    <label class="form-check-label" for="rememberMe">Remember Me</label>
                </div>

                <button type="submit" class="btn btn-primary w-100">
                    <i class="fas fa-sign-in-alt"></i> Login
                </button>

                <div class="login-links">
                    <a href="forgotPassword.jsp">Forgot Password?</a>
                    <span>|</span>
                    <a href="register.jsp">Register Here</a>
                </div>
            </form>
            <!-- End of Login Form -->
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
