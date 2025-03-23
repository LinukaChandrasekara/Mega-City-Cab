package com.megacitycab.models;

import java.sql.Timestamp;

/**
 * Represents a review submitted by a customer for a completed ride
 */
public class Review {
    private int reviewID;
    private int customerID;
    private String customerName;  // Transient field for display
    private int driverID;
    private String driverName;    // Transient field for display
    private int bookingID;        // Associated booking
    private int rating;           // 1-5 scale
    private String comments;
    private Timestamp reviewDate;

    // Full constructor
    public Review(int reviewID, int customerID, String customerName, 
                 int driverID, String driverName, int bookingID, 
                 int rating, String comments, Timestamp reviewDate) {
        this.reviewID = reviewID;
        this.customerID = customerID;
        this.customerName = customerName;
        this.driverID = driverID;
        this.driverName = driverName;
        this.bookingID = bookingID;
        this.rating = rating;
        this.comments = comments;
        this.reviewDate = reviewDate;
    }

    // Getters and Setters
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

    public int getBookingID() { return bookingID; }
    public void setBookingID(int bookingID) { this.bookingID = bookingID; }

    public int getRating() { return rating; }
    public void setRating(int rating) { 
        if(rating < 1 || rating > 5) {
            throw new IllegalArgumentException("Rating must be between 1-5");
        }
        this.rating = rating; 
    }

    public String getComments() { return comments; }
    public void setComments(String comments) { 
        if(comments == null || comments.trim().isEmpty()) {
            throw new IllegalArgumentException("Comments cannot be empty");
        }
        this.comments = comments; 
    }

    public Timestamp getReviewDate() { return reviewDate; }
    public void setReviewDate(Timestamp reviewDate) { this.reviewDate = reviewDate; }

    @Override
    public String toString() {
        return "Review{" +
                "reviewID=" + reviewID +
                ", customerID=" + customerID +
                ", customerName='" + customerName + '\'' +
                ", driverID=" + driverID +
                ", driverName='" + driverName + '\'' +
                ", bookingID=" + bookingID +
                ", rating=" + rating +
                ", comments='" + comments + '\'' +
                ", reviewDate=" + reviewDate +
                '}';
    }
}