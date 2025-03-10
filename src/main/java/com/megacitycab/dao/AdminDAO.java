package com.megacitycab.dao;

import com.megacitycab.utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AdminDAO {

    public static int getTotalBookings() {
        String query = "SELECT COUNT(*) AS total FROM Bookings";
        return getCount(query);
    }

    public static int getTotalCustomers() {
        String query = "SELECT COUNT(*) AS total FROM Users WHERE Role='Customer'";
        return getCount(query);
    }

    public static int getTotalDrivers() {
        String query = "SELECT COUNT(*) AS total FROM Users WHERE Role='Driver'";
        return getCount(query);
    }

    public static double getTotalRevenue() {
        String query = "SELECT SUM(PaidAmount) AS revenue FROM Payments WHERE PaymentStatus='Completed'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble("revenue");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    private static int getCount(String query) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
