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
    <link rel="stylesheet" href="style.css">
    <style>
        body {
            background-color: #FFD700;
            font-family: 'Poppins', sans-serif;
        }
        .register-container {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .register-box {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
            text-align: center;
            width: 400px;
        }
        .nav-tabs .nav-link {
            color: black;
        }
        .nav-tabs .nav-link.active {
            background-color: black;
            color: white;
        }
        .btn-primary {
            background-color: black;
            border: none;
        }
        .btn-primary:hover {
            background-color: #333;
        }
    </style>
</head>
<body>

<div class="register-container">
    <div class="register-box">
        <h2>Register</h2>
        
        <ul class="nav nav-tabs" id="registerTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="customer-tab" data-bs-toggle="tab" data-bs-target="#customer" type="button" role="tab">Customer</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="driver-tab" data-bs-toggle="tab" data-bs-target="#driver" type="button" role="tab">Driver</button>
            </li>
        </ul>

        <div class="tab-content mt-3" id="registerTabsContent">
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
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

</body>
</html>
