package com.megacitycab.models;

public class Driver extends User {
    private String vehicleType;
    private String model;
    private String licensePlate;
    private String status;

    // ✅ Correct Constructor for `getAllDrivers()`
    public Driver(int userID, String name, String email, String phone, byte[] profilePicture,
                  String vehicleType, String model, String licensePlate, String status) {
        super(userID, name, email, phone, null, null, "Driver", profilePicture);
        this.vehicleType = vehicleType;
        this.model = model;
        this.licensePlate = licensePlate;
        this.status = status;
    }

    // ✅ Correct Constructor for `getDriverById()`
    public Driver(int userID, String name, String email, String phone, String address,
                  String password, String role, byte[] profilePicture) {
        super(userID, name, email, phone, address, password, role, profilePicture);
    }

    // ✅ Getters & Setters
    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }

    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }

    public String getLicensePlate() { return licensePlate; }
    public void setLicensePlate(String licensePlate) { this.licensePlate = licensePlate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
