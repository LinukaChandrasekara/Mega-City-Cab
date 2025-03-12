package com.megacitycab.models;

import java.sql.Timestamp;

public class Review {
    private int reviewID;
    private int customerID;
    private String customerName;  // Fetch customer name for display
    private int driverID;
    private String driverName;    // Fetch driver name for display
    private int rating;  // 1-5 star rating
    private String comments;
    private Timestamp reviewDate;

    // ✅ Constructor
    public Review(int reviewID, int customerID, String customerName, int driverID, String driverName, int rating, String comments, Timestamp reviewDate) {
        this.reviewID = reviewID;
        this.customerID = customerID;
        this.customerName = customerName;
        this.driverID = driverID;
        this.driverName = driverName;
        this.rating = rating;
        this.comments = comments;
        this.reviewDate = reviewDate;
    }

    // ✅ Getters & Setters
    public int getReviewID() { return reviewID; }
    public void setReviewID(int reviewID) { this.reviewID = reviewID; }

    public int getCustomerID() { return customerID; }
    public void setCustomerID(int customerID) { this.customerID = customerID; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public int getDriverID() { return driverID; }
    public void setDriverID(int driverID) { this.driverID = driverID; }

    public String getDriverName() { return driverName; }
    public void setDriverName(String driverName) { this.driverName = driverName; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getComments() { return comments; }
    public void setComments(String comments) { this.comments = comments; }

    public Timestamp getReviewDate() { return reviewDate; }
    public void setReviewDate(Timestamp reviewDate) { this.reviewDate = reviewDate; }
}
