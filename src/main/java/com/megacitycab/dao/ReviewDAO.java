package com.megacitycab.dao;

import com.megacitycab.models.Review;
import com.megacitycab.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    // ✅ Add a new review
    public static boolean addReview(int customerID, int driverID, int rating, String comments) {
        String sql = "INSERT INTO Reviews (CustomerID, DriverID, Rating, Comments) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, customerID);
            stmt.setInt(2, driverID);
            stmt.setInt(3, rating);
            stmt.setString(4, comments);

            return stmt.executeUpdate() > 0; // Return true if insertion was successful
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Fetch all reviews (Admin View)
    public static List<Review> getAllReviews() {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u1.Name AS CustomerName, u2.Name AS DriverName FROM Reviews r " +
                     "JOIN Users u1 ON r.CustomerID = u1.UserID " +
                     "JOIN Users u2 ON r.DriverID = u2.UserID " +
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

    // ✅ Fetch reviews by a specific customer
    public static List<Review> getReviewsByCustomer(int customerID) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.Name AS DriverName FROM Reviews r " +
                     "JOIN Users u ON r.DriverID = u.UserID " +
                     "WHERE r.CustomerID = ? " +
                     "ORDER BY r.ReviewDate DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, customerID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                reviews.add(new Review(
                        rs.getInt("ReviewID"),
                        rs.getInt("CustomerID"),
                        null,  // Customer Name not needed here
                        rs.getInt("DriverID"),
                        rs.getString("DriverName"),
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

    // ✅ Fetch reviews for a specific driver
    public static List<Review> getReviewsByDriver(int driverID) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.Name AS CustomerName FROM Reviews r " +
                     "JOIN Users u ON r.CustomerID = u.UserID " +
                     "WHERE r.DriverID = ? " +
                     "ORDER BY r.ReviewDate DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, driverID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                reviews.add(new Review(
                        rs.getInt("ReviewID"),
                        rs.getInt("CustomerID"),
                        rs.getString("CustomerName"),
                        rs.getInt("DriverID"),
                        null,  // Driver Name not needed here
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

    // ✅ Fetch a single review by ID (for editing)
    public static Review getReviewById(int reviewID) {
        String sql = "SELECT r.*, u1.Name AS CustomerName, u2.Name AS DriverName FROM Reviews r " +
                     "JOIN Users u1 ON r.CustomerID = u1.UserID " +
                     "JOIN Users u2 ON r.DriverID = u2.UserID " +
                     "WHERE r.ReviewID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reviewID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new Review(
                        rs.getInt("ReviewID"),
                        rs.getInt("CustomerID"),
                        rs.getString("CustomerName"),
                        rs.getInt("DriverID"),
                        rs.getString("DriverName"),
                        rs.getInt("Rating"),
                        rs.getString("Comments"),
                        rs.getTimestamp("ReviewDate")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // No review found
    }

    // ✅ Update an existing review
    public static boolean updateReview(int reviewID, int rating, String comments) {
        String sql = "UPDATE Reviews SET Rating = ?, Comments = ?, ReviewDate = CURRENT_TIMESTAMP WHERE ReviewID = ?";

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

    // ✅ Delete a review (by customer or admin)
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
}
