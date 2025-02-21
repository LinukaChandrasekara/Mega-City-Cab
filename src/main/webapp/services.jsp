<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Our Services - Mega City Cab</title>
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
                    <li class="nav-item"><a class="nav-link text-warning" href="services.jsp">Services</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="contact.jsp">Contact</a></li>
                    
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

    <!-- Services Section -->
    <div class="container mt-5">
        <h2 class="text-center text-warning">Our Services</h2>
        <div class="row">
            <div class="col-md-4">
                <div class="card">
                    <img src="images/taxi1.jpg" class="card-img-top" alt="City Ride">
                    <div class="card-body">
                        <h5 class="card-title">City Rides</h5>
                        <p class="card-text">Safe and comfortable rides within Colombo.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card">
                    <img src="images/airport.jpg" class="card-img-top" alt="Airport Taxi">
                    <div class="card-body">
                        <h5 class="card-title">Airport Transfers</h5>
                        <p class="card-text">Hassle-free airport pickup and drop-off.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card">
                    <img src="images/luxury.jpg" class="card-img-top" alt="Luxury Ride">
                    <div class="card-body">
                        <h5 class="card-title">Luxury Rides</h5>
                        <p class="card-text">Travel in style with our premium cars.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-black text-white text-center py-3 mt-5">
        <p>© 2025 Mega City Cab. All rights reserved.</p>
    </footer>
</body>
</html>
