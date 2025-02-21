<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Contact Us - Mega City Cab</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">

    <style>
        html, body {
            height: 100%;
            font-family: 'Roboto', sans-serif;
            background: url('images/background.jpg') no-repeat center center fixed;
            background-size: cover;
            position: relative;
        }

        /* Background overlay for better readability */
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.6);
            z-index: -1;
        }

        .content-wrapper {
            min-height: calc(100vh - 80px); /* Adjusted for footer height */
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .contact-card {
            background-color: rgba(255, 255, 255, 0.95);
            padding: 2.5rem;
            border-radius: 15px;
            box-shadow: 0px 15px 30px rgba(0, 0, 0, 0.2);
            max-width: 600px;
            width: 100%;
            margin: 2rem auto;
            animation: fadeIn 0.8s ease-in-out;
        }

        .contact-icon {
            font-size: 4rem;
            color: #ffc107;
            margin-bottom: 10px;
        }

        h2 {
            font-weight: 600;
            margin-bottom: 1rem;
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

        footer {
            background-color: #000;
            color: #fff;
            text-align: center;
            padding: 1rem 0;
            width: 100%;
            position: relative;
            bottom: 0;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
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

    <!-- Main Content -->
    <div class="content-wrapper">
        <div class="contact-card text-center">
            <i class="bi bi-telephone-fill contact-icon"></i>
            <h2 class="text-warning">Contact Us</h2>
            <p class="mb-4">Have questions or feedback? Fill out the form below and we’ll get back to you shortly!</p>

            <form action="contact-form-handler.jsp" method="post">
                <div class="mb-3">
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-person-fill"></i></span>
                        <input type="text" class="form-control" name="name" placeholder="Your Name" required>
                    </div>
                </div>
                <div class="mb-3">
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-envelope-fill"></i></span>
                        <input type="email" class="form-control" name="email" placeholder="Your Email" required>
                    </div>
                </div>
                <div class="mb-3">
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-chat-dots-fill"></i></span>
                        <textarea class="form-control" name="message" rows="4" placeholder="Your Message" required></textarea>
                    </div>
                </div>
                <button type="submit" class="btn btn-warning w-100">Send Message</button>
            </form>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <p>© 2025 Mega City Cab. All rights reserved.</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
