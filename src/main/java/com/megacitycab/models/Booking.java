package com.megacitycab.models;

import java.sql.Timestamp;

public class Booking {
    private int bookingID;
    private int customerID;
    private int driverID;
    private double pickupLat;
    private double pickupLng;
    private double dropoffLat;
    private double dropoffLng;
    private double distance;
    private int estimatedTime;
    private String vehicleType;
    private double fare;
    private double discount;
    private double totalAmount;
    private String status;
    private Timestamp bookingDate;
	private String customerName;
	private String driverName;

    // ✅ Constructor
    public Booking(int bookingID, int customerID, int driverID, double pickupLat, double pickupLng,
                   double dropoffLat, double dropoffLng, double distance, int estimatedTime, 
                   String vehicleType, double fare, double discount, double totalAmount, 
                   String status, Timestamp bookingDate) {
        this.bookingID = bookingID;
        this.customerID = customerID;
        this.driverID = driverID;
        this.pickupLat = pickupLat;
        this.pickupLng = pickupLng;
        this.dropoffLat = dropoffLat;
        this.dropoffLng = dropoffLng;
        this.distance = distance;
        this.estimatedTime = estimatedTime;
        this.vehicleType = vehicleType;
        this.fare = fare;
        this.discount = discount;
        this.totalAmount = totalAmount;
        this.status = status;
        this.bookingDate = bookingDate;
    }

    public Booking(int bookingID, int customerID, String customerName, int driverID, String driverName, 
            double pickupLat, double pickupLng, double dropoffLat, double dropoffLng, 
            double distance, int estimatedTime, String vehicleType, double fare, 
            double discount, double totalAmount, String status, Timestamp bookingDate) {
 this.bookingID = bookingID;
 this.customerID = customerID;
 this.setCustomerName(customerName);
 this.driverID = driverID;
 this.setDriverName(driverName);
 this.pickupLat = pickupLat;
 this.pickupLng = pickupLng;
 this.dropoffLat = dropoffLat;
 this.dropoffLng = dropoffLng;
 this.distance = distance;
 this.estimatedTime = estimatedTime;
 this.vehicleType = vehicleType;
 this.fare = fare;
 this.discount = discount;
 this.totalAmount = totalAmount;
 this.status = status;
 this.bookingDate = bookingDate;
}

	// ✅ Getters & Setters
    public int getBookingID() { return bookingID; }
    public void setBookingID(int bookingID) { this.bookingID = bookingID; }

    public int getCustomerID() { return customerID; }
    public void setCustomerID(int customerID) { this.customerID = customerID; }

    public int getDriverID() { return driverID; }
    public void setDriverID(int driverID) { this.driverID = driverID; }

    public double getPickupLat() { return pickupLat; }
    public void setPickupLat(double pickupLat) { this.pickupLat = pickupLat; }

    public double getPickupLng() { return pickupLng; }
    public void setPickupLng(double pickupLng) { this.pickupLng = pickupLng; }

    public double getDropoffLat() { return dropoffLat; }
    public void setDropoffLat(double dropoffLat) { this.dropoffLat = dropoffLat; }

    public double getDropoffLng() { return dropoffLng; }
    public void setDropoffLng(double dropoffLng) { this.dropoffLng = dropoffLng; }

    public double getDistance() { return distance; }
    public void setDistance(double distance) { this.distance = distance; }

    public int getEstimatedTime() { return estimatedTime; }
    public void setEstimatedTime(int estimatedTime) { this.estimatedTime = estimatedTime; }

    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }

    public double getFare() { return fare; }
    public void setFare(double fare) { this.fare = fare; }

    public double getDiscount() { return discount; }
    public void setDiscount(double discount) { this.discount = discount; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getBookingDate() { return bookingDate; }
    public void setBookingDate(Timestamp bookingDate) { this.bookingDate = bookingDate; }

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getDriverName() {
		return driverName;
	}

	public void setDriverName(String driverName) {
		this.driverName = driverName;
	}
}
