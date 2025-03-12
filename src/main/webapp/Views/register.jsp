<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mega City Cab | Register</title>

    <!-- Bootstrap & FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <!-- Custom Styles -->
    <style>
        /* Retro-inspired gradient background (same as login) */
        body {
            background: linear-gradient(135deg, #ffcc00 0%, #ff66cc 100%);
            background-repeat: no-repeat;
            background-attachment: fixed;
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
        }

        /* Full-height container to center content vertically (same pattern as login) */
        .register-wrapper {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center; /* Center horizontally */
        }

        /* Retro-styled container (same size as login) */
        .register-form-section {
            background-color: rgba(0, 0, 0, 0.5); /* Semi-transparent overlay */
            width: 100%;
            max-width: 400px; /* Same container width as login */
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.3);
            text-align: center;
            color: #fff;
        }

        /* Retro Heading */
        .retro-heading {
            font-family: 'Courier New', monospace;
            font-size: 2rem;
            text-shadow: 2px 2px #000;
            color: #ffef00; /* Bright yellow for retro vibe */
            margin-bottom: 0.5rem;
        }

        /* Sub-heading */
        .sub-heading {
            margin-bottom: 1rem;
            font-size: 1.5rem;
        }

        /* Tabs styled similarly to login’s color scheme */
        .nav-tabs {
            border-bottom: 1px solid #ffef00; /* Optional: subtle border for retro flair */
        }
        .nav-tabs .nav-link {
            color: #fff;
            background-color: transparent;
            border: 1px solid #fff;
            margin-right: 5px;
        }
        .nav-tabs .nav-link.active {
            background-color: #FFC107;
            color: #212529;
            border-color: #FFC107;
        }

        /* Form controls on dark background */
        .form-control {
            background-color: #fff;
        }

        /* Button matching login style */
        .btn-primary {
            background-color: #FFC107;
            border: none;
            color: #212529;
        }
        .btn-primary:hover {
            background-color: #ffca2c;
        }

        /* Space below the tabs */
        .tab-content {
            margin-top: 1rem;
        }

        /* Login link style */
        .login-links {
            margin-top: 1rem;
            display: flex;
            justify-content: center;
            gap: 0.5rem;
            font-size: 0.9rem;
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
    <div class="register-wrapper">
        <div class="register-form-section">
            <!-- Retro Heading -->
            <h1 class="retro-heading">MEGA CITY CAB</h1>
            <h2 class="sub-heading">Register</h2>
            
            <!-- Nav Tabs -->
            <ul class="nav nav-tabs justify-content-center" id="registerTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="customer-tab" data-bs-toggle="tab" data-bs-target="#customer" type="button" role="tab">
                        Customer
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="driver-tab" data-bs-toggle="tab" data-bs-target="#driver" type="button" role="tab">
                        Driver
                    </button>
                </li>
            </ul>

            <!-- Tab Contents -->
            <div class="tab-content" id="registerTabsContent">
                <!-- Customer Registration Form -->
                <div class="tab-pane fade show active" id="customer" role="tabpanel">
                    <form action="${pageContext.request.contextPath}/RegisterController" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="role" value="Customer">
                        <div class="mb-3">
                            <input type="text" class="form-control" name="name" placeholder="Full Name" required>
                        </div>
                        <div class="mb-3">
                            <input type="email" class="form-control" name="email" placeholder="Email Address" required>
                        </div>
                        <div class="mb-3">
                            <input type="text" class="form-control" name="phone" placeholder="Phone Number" required>
                        </div>
                        <div class="mb-3">
                            <textarea class="form-control" name="address" placeholder="Address" required></textarea>
                        </div>
                        <div class="mb-3">
                            <input type="password" class="form-control" name="password" placeholder="Password" required>
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Register</button>
                        
                        <div class="login-links">
                            <span>Already have an account?</span>
                            <a href="login.jsp">Login Here</a>
                        </div>
                    </form>
                </div>

                <!-- Driver Registration Form -->
                <div class="tab-pane fade" id="driver" role="tabpanel">
                    <form action="${pageContext.request.contextPath}/RegisterController" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="role" value="Driver">
                        <div class="mb-3">
                            <input type="text" class="form-control" name="name" placeholder="Full Name" required>
                        </div>
                        <div class="mb-3">
                            <input type="email" class="form-control" name="email" placeholder="Email Address" required>
                        </div>
                        <div class="mb-3">
                            <input type="text" class="form-control" name="phone" placeholder="Phone Number" required>
                        </div>
                        <div class="mb-3">
                            <textarea class="form-control" name="address" placeholder="Address" required></textarea>
                        </div>
                        <div class="mb-3">
                            <input type="password" class="form-control" name="password" placeholder="Password" required>
                        </div>
                        <div class="mb-3">
                            <input type="file" class="form-control" name="profilePicture" accept="image/*">
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Register</button>
                        
                        <div class="login-links">
                            <span>Already have an account?</span>
                            <a href="login.jsp">Login Here</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
