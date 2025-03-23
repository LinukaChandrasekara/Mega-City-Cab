package com.megacitycab.dao;

import com.megacitycab.models.Review;
import com.megacitycab.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {
    
	public static boolean addReview(int customerID, int bookingID, int rating, String comments) {
	    String sql = "INSERT INTO Reviews (CustomerID, DriverID, BookingID, Rating, Comments) " +
	                "SELECT ?, b.DriverID, ?, ?, ? " +
	                "FROM Bookings b " +
	                "WHERE b.BookingID = ?";
	    
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(sql)) {
	        
	        stmt.setInt(1, customerID);
	        stmt.setInt(2, bookingID);
	        stmt.setInt(3, rating);
	        stmt.setString(4, comments);
	        stmt.setInt(5, bookingID);
	        
	        return stmt.executeUpdate() > 0;
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false;
	    }
	}

    // Get all reviews (Admin)
    public static List<Review> getAllReviews() {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, c.Name AS CustomerName, d.Name AS DriverName " +
                     "FROM Reviews r " +
                     "JOIN Users c ON r.CustomerID = c.UserID " +
                     "JOIN Users d ON r.DriverID = d.UserID " +
                     "ORDER BY r.ReviewDate DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                reviews.add(new Review(
                    rs.getInt("ReviewID"),
                    rs.getInt("CustomerID"),
                    rs.getString("CustomerName"),
                    rs.getInt("DriverID"),
                    rs.getString("DriverName"),
                    rs.getInt("BookingID"),
                    rs.getInt("Rating"),
                    rs.getString("Comments"),
                    rs.getTimestamp("ReviewDate")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }

    // Get reviews by customer
    public static List<Review> getReviewsByCustomer(int customerID) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, d.Name AS DriverName " +
                     "FROM Reviews r " +
                     "JOIN Users d ON r.DriverID = d.UserID " +
                     "WHERE r.CustomerID = ? " +
                     "ORDER BY r.ReviewDate DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, customerID);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reviews.add(new Review(
                        rs.getInt("ReviewID"),
                        customerID,
                        null,
                        rs.getInt("DriverID"),
                        rs.getString("DriverName"),
                        rs.getInt("BookingID"),
                        rs.getInt("Rating"),
                        rs.getString("Comments"),
                        rs.getTimestamp("ReviewDate")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }

    // Get reviews by driver
    public static List<Review> getReviewsByDriver(int driverID) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, c.Name AS CustomerName " +
                     "FROM Reviews r " +
                     "JOIN Users c ON r.CustomerID = c.UserID " +
                     "WHERE r.DriverID = ? " +
                     "ORDER BY r.ReviewDate DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, driverID);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reviews.add(new Review(
                        rs.getInt("ReviewID"),
                        rs.getInt("CustomerID"),
                        rs.getString("CustomerName"),
                        driverID,
                        null,
                        rs.getInt("BookingID"),
                        rs.getInt("Rating"),
                        rs.getString("Comments"),
                        rs.getTimestamp("ReviewDate")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }

    public static Review getReviewByBookingId(int bookingID) {
        String sql = "SELECT * FROM Reviews WHERE BookingID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookingID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Review(
                    rs.getInt("ReviewID"),
                    rs.getInt("CustomerID"),
                    null,
                    rs.getInt("DriverID"),
                    null,
                    bookingID,
                    rs.getInt("Rating"),
                    rs.getString("Comments"),
                    rs.getTimestamp("ReviewDate")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update review
    public static boolean updateReview(int reviewID, int rating, String comments) {
        String sql = "UPDATE Reviews SET Rating = ?, Comments = ? WHERE ReviewID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, rating);
            stmt.setString(2, comments);
            stmt.setInt(3, reviewID);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete review
    public static boolean deleteReview(int reviewID) {
        String sql = "DELETE FROM Reviews WHERE ReviewID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, reviewID);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get average rating for driver
    public static double getAverageRating(int driverID) {
        String sql = "SELECT AVG(Rating) AS avgRating FROM Reviews WHERE DriverID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, driverID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("avgRating");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
}