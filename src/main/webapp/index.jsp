<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Mega City Cab - Home</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    
<style>
	body {
    font-family: 'Bitter', serif;
	}

	h1, h2, h3 {
    font-family: 'Merriweather', serif;
	}
	

    .feature-box {
        height: 300px; /* Set a fixed height */
        width: 100%;   /* Make it responsive to the container */
        max-width: 350px; /* Set a max width to make it consistent */
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        text-align: center;
        margin: 0 auto; /* Center the boxes horizontally */
        padding: 20px;
        border-radius: 10px;
    }
    .feature-box i {
        font-size: 3rem; /* Increase the icon size */
    }

    /* Styling for the hover effect */
    .testimonial-card {
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .testimonial-card:hover {
        transform: translateY(-10px); /* Moves the card up slightly */
        box-shadow: 0px 10px 30px rgba(0, 0, 0, 0.15); /* Adds a stronger shadow for depth */
    }

    /* Optional: Add some subtle hover scale for images */
    .testimonial-card img {
        transition: transform 0.3s ease;
    }

    .testimonial-card:hover img {
        transform: scale(1.05); /* Slightly zooms the image on hover */
    }

    /* Adding padding and spacing */
    .testimonial-card .card-body {
        padding: 2rem;
    }

    /* Adding a little more space between the rows of cards */
    .row {
        margin-left: -15px;
        margin-right: -15px;
    }

    .col-md-4 {
        padding-left: 15px;
        padding-right: 15px;
    }
/* Hover effect to scale up the feature box */
	.feature-box:hover {
    	transform: scale(1.05);
    	background-color: #ffd700; /* Lighter shade for hover */
    	transition: all 0.3s ease-in-out;
	}

/* Add animation to icons */
	.feature-box i {
    	font-size: 3rem;
    	transition: transform 0.3s ease-in-out;
	}

	.feature-box:hover i {
    	transform: scale(1.2); /* Slightly enlarges the icon */
	}

/* Add a smoother transition to text and icon */
	.feature-box h4, .feature-box p {
    	opacity: 0;
    	transition: opacity 0.5s ease-out;
	}

	.feature-box:hover h4, .feature-box:hover p {
    	opacity: 1;
	}
</style>
</head>
<body>
    <!-- 🌐 Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-black">
        <div class="container">
            <a class="navbar-brand text-warning" href="index.jsp" style="font-size: 1.5rem;"><b>Mega City Cab</b></a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link text-white" href="index.jsp">Home</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="book.jsp">Book a Ride</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="services.jsp">Services</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="contact.jsp">Contact</a></li>

                    <% String username = (String) session.getAttribute("username");
                       String role = (String) session.getAttribute("role");
                       if (username != null) { %>
                        <li class="nav-item">
                            <a class="nav-link text-warning">Welcome, <%= username %>!</a>
                        </li>

                        <%-- 🎯 Conditional Dashboard Links --%>
                        <% if ("customer".equals(role)) { %>
                            <li class="nav-item"><a class="nav-link text-info" href="customer_dashboard.jsp">Dashboard</a></li>
                        <% } else if ("driver".equals(role)) { %>
                            <li class="nav-item"><a class="nav-link text-info" href="driver_dashboard.jsp">Dashboard</a></li>
                        <% } else if ("admin".equals(role)) { %>
                            <li class="nav-item"><a class="nav-link text-info" href="admin.jsp">Admin Panel</a></li>
                        <% } %>

                        <li class="nav-item"><a class="nav-link text-danger" href="logout">Logout</a></li>
                    <% } else { %>
                        <li class="nav-item"><a class="nav-link text-white" href="login.jsp">Login</a></li>
                        <li class="nav-item"><a class="nav-link text-white" href="register.jsp">Register</a></li>
                    <% } %>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <header class="hero text-center text-white" style="background: url('images/background.jpg') center/cover no-repeat; padding: 160px 0;">
        <div class="container">
            <h1 class="display-3">Fast & Reliable Cab Booking in Colombo</h1>
            <p class="lead">Book your ride in seconds and travel safely with Mega City Cab.</p>
            <a href="book.jsp" class="btn btn-warning btn-lg">Book Now</a>
        </div>
    </header>
<!-- Introduction Section -->
<section class="py-5 bg-light text-center">
    <div class="container">
        <h2 class="display-4 mb-4">Why Choose Mega City Cab?</h2>
        
        <img src="images/Taxi.png" alt="Why Choose Us" class="img-fluid mt-4" style="height: 150px; width: 250px;">
        <p class="lead">We provide the most reliable and fastest taxi service in Colombo. With Mega City Cab, you are guaranteed comfort, safety, and punctuality. Our team is always ready to serve you, 24/7.</p>
        
        <!-- Image with fixed height of 80px -->


    </div>
</section>


<section class="py-5 text-center bg-white">
    <div class="container">
        <h2 class="display-4 mb-4">Our Features</h2>
        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="feature-box p-4 bg-warning rounded">
                    <i class="bi bi-car-front"></i>
                    <h4 class="mt-3">Quick & Convenient</h4>
                    <p>Our user-friendly app makes booking a ride quick and easy. Get a cab within minutes.</p>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="feature-box p-4 bg-warning rounded">
                    <i class="bi bi-shield-lock"></i>
                    <h4 class="mt-3">Safe & Secure</h4>
                    <p>We prioritize safety with vetted drivers, real-time tracking, and secure payment methods.</p>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="feature-box p-4 bg-warning rounded">
                    <i class="bi bi-bell"></i>
                    <h4 class="mt-3">24/7 Availability</h4>
                    <p>Need a ride at any time? We’re available round the clock to ensure you can travel whenever you need.</p>
                </div>
            </div>
        </div>
    </div>
</section>


<!-- Testimonials Section -->
<section class="py-5 bg-light text-center">
    <div class="container">
        <h2 class="display-4 mb-4">What Our Customers Say</h2>
        <div class="row">
            <!-- Testimonial 1 -->
            <div class="col-md-4 mb-4">
                <div class="card shadow-sm border-light rounded testimonial-card">
                    <!-- Card body -->
                    <div class="card-body text-center">
                        <!-- Add rounded image with object-fit -->
                        <img src="images/emil.jpg" alt="Customer 1" class="rounded-circle mb-3" style="width: 150px; height: 150px; object-fit: cover;">
                        <p class="mb-0">"Mega City Cab made my journey smooth and quick. The driver was courteous, and the ride was extremely comfortable."</p>
                        <footer class="blockquote-footer mt-3">Emil Oshada, <cite title="Source Title">Frequent Traveler</cite></footer>
                    </div>
                </div>
            </div>

            <!-- Testimonial 2 -->
            <div class="col-md-4 mb-4">
                <div class="card shadow-sm border-light rounded testimonial-card">
                    <!-- Card body -->
                    <div class="card-body text-center">
                        <!-- Add rounded image with object-fit -->
                        <img src="images/ushan.jpg" alt="Customer 2" class="rounded-circle mb-3" style="width: 150px; height: 150px; object-fit: cover;">
                        <p class="mb-0">"Great service! I love the convenience of booking through the app, and the prices are very affordable. Satisfied!"</p>
                        <footer class="blockquote-footer mt-3">Ushan Madheera, <cite title="Source Title">Regular Rider</cite></footer>
                    </div>
                </div>
            </div>

            <!-- Testimonial 3 -->
            <div class="col-md-4 mb-4">
                <div class="card shadow-sm border-light rounded testimonial-card">
                    <!-- Card body -->
                    <div class="card-body text-center">
                        <!-- Add rounded image with object-fit -->
                        <img src="images/ayya.jpg" alt="Customer 3" class="rounded-circle mb-3" style="width: 150px; height: 150px; object-fit: cover;">
                        <p class="mb-0">"I had a fantastic experience with Mega City Cab! The booking process was smooth, and the driver was very friendly."</p>
                        <footer class="blockquote-footer mt-3">Thinura Chandrasekara, <cite title="Source Title">First-Time Rider</cite></footer>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>





    <!-- Call-to-Action Section -->
    <section class="py-5 bg-warning text-center">
        <div class="container">
            <h2 class="display-4 mb-4 text-white">Ready to Book Your Ride?</h2>
            <p class="lead text-white">Get to your destination in style and comfort. Book a ride with Mega City Cab now!</p>
            <a href="book.jsp" class="btn btn-dark btn-lg">Book Now</a>
        </div>
    </section>

    <!-- Contact Info Section -->
    <section class="py-5 text-center bg-white">
        <div class="container">
            <h2 class="display-4 mb-4">Contact Us</h2>
            <p class="lead">Have any questions? Feel free to reach out to us!</p>
            <p><strong>Email:</strong> support@megacitycab.com</p>
            <p><strong>Phone:</strong> +94 123 456 789</p>
            <a href="contact.jsp" class="btn btn-warning btn-lg">Contact Us</a>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-black text-white text-center py-3">
        <p>© 2025 Mega City Cab. All rights reserved.</p>
    </footer>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
