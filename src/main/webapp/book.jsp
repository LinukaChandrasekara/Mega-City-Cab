<!DOCTYPE html>
<html>
<head>
    <title>Book a Ride</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-warning text-center">Book Your Ride</h2>
        <form action="book" method="post">
            <div class="mb-3">
                <label class="form-label">Full Name</label>
                <input type="text" class="form-control" name="customer_name" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Phone Number</label>
                <input type="tel" class="form-control" name="phone" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Pickup Location</label>
                <input type="text" class="form-control" name="pickup_location" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Drop-off Location</label>
                <input type="text" class="form-control" name="dropoff_location" required>
            </div>
            <button type="submit" class="btn btn-warning w-100">Confirm Booking</button>
        </form>
    </div>
</body>
</html>
