package com.megacitycab.models;

public class Vehicle {
    private int vehicleID;
    private int driverID;
    private String type;
    private String model;
    private String licensePlate;
    private String status;

    public Vehicle(int vehicleID, int driverID, String type, String model, String licensePlate, String status) {
        this.vehicleID = vehicleID;
        this.driverID = driverID;
        this.type = type;
        this.model = model;
        this.licensePlate = licensePlate;
        this.status = status;
    }

    // Getters and Setters
    public int getVehicleID() { return vehicleID; }
    public void setVehicleID(int vehicleID) { this.vehicleID = vehicleID; }

    public int getDriverID() { return driverID; }
    public void setDriverID(int driverID) { this.driverID = driverID; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }

    public String getLicensePlate() { return licensePlate; }
    public void setLicensePlate(String licensePlate) { this.licensePlate = licensePlate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
