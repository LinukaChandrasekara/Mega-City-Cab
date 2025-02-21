<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Contact Us - Mega City Cab</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-black">
        <div class="container">
            <a class="navbar-brand text-warning" href="#">🚖 Mega City Cab</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link text-white" href="index.jsp">Home</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="book.jsp">Book a Ride</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="services.jsp">Services</a></li>
                    <li class="nav-item"><a class="nav-link text-warning" href="contact.jsp">Contact</a></li>
                    
                    <% if (session.getAttribute("username") != null) { %>
                        <li class="nav-item">
                            <a class="nav-link text-warning">Welcome, <%= session.getAttribute("username") %>!</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-danger" href="logout">Logout</a>
                        </li>
                    <% } else { %>
                        <li class="nav-item"><a class="nav-link text-white" href="login.jsp">Login</a></li>
                        <li class="nav-item"><a class="nav-link text-white" href="register.jsp">Register</a></li>
                    <% } %>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Contact Form -->
    <div class="container mt-5">
        <h2 class="text-center text-warning">Contact Us</h2>
        <form action="contact-form-handler.jsp" method="post">
            <div class="mb-3">
                <label class="form-label">Your Name</label>
                <input type="text" class="form-control" name="name" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Your Email</label>
                <input type="email" class="form-control" name="email" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Message</label>
                <textarea class="form-control" name="message" rows="4" required></textarea>
            </div>
            <button type="submit" class="btn btn-warning w-100">Send Message</button>
        </form>
    </div>

    <!-- Footer -->
    <footer class="bg-black text-white text-center py-3 mt-5">
        <p>© 2025 Mega City Cab. All rights reserved.</p>
    </footer>
</body>
</html>
