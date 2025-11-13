package hf;

import java.sql.*;
import java.util.*;

public class DbUtil {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/java";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "arul@14";

    public static List<Map<String, String>> getOwnerProperties(String ownerId) {
        List<Map<String, String>> properties = new ArrayList<>();
        
        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String sql = "SELECT p.*, COUNT(b.id) as bookings FROM property_listing p " +
                       "LEFT JOIN bookings b ON p.id = b.property_id " +
                       "WHERE p.owner_email = (SELECT email FROM users WHERE id = ?) " +
                       "GROUP BY p.id";
            
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, Integer.parseInt(ownerId));
                
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> property = new HashMap<>();
                        property.put("id", rs.getString("id"));
                        property.put("property_name", rs.getString("property_name"));
                        property.put("location", rs.getString("location"));
                        property.put("listing_type", rs.getString("listing_type"));
                        property.put("bhk_type", rs.getString("bhk_type"));
                        property.put("bookings", rs.getString("bookings"));
                        properties.add(property);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return properties;
    }

    public static List<Map<String, String>> getOwnerBookings(String ownerId) {
        List<Map<String, String>> bookings = new ArrayList<>();
        
        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String sql = "SELECT b.*, p.property_name FROM bookings b " +
                       "JOIN property_listing p ON b.property_id = p.id " +
                       "WHERE p.owner_email = (SELECT email FROM users WHERE id = ?) " +
                       "ORDER BY b.booking_date DESC";
            
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, Integer.parseInt(ownerId));
                
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> booking = new HashMap<>();
                        booking.put("property_name", rs.getString("property_name"));
                        booking.put("user_name", rs.getString("user_name"));
                        booking.put("user_email", rs.getString("user_email"));
                        booking.put("user_phone", rs.getString("user_phone"));
                        booking.put("booking_date", rs.getString("booking_date"));
                        bookings.add(booking);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return bookings;
    }

    public static boolean deleteProperty(String propertyId, String ownerId) {
        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            // Verify property belongs to owner
            String verifySql = "SELECT 1 FROM property_listing p " +
                            "JOIN users u ON p.owner_email = u.email " +
                            "WHERE p.id = ? AND u.id = ?";
            
            try (PreparedStatement verifyPs = con.prepareStatement(verifySql)) {
                verifyPs.setInt(1, Integer.parseInt(propertyId));
                verifyPs.setInt(2, Integer.parseInt(ownerId));
                
                try (ResultSet rs = verifyPs.executeQuery()) {
                    if (!rs.next()) {
                        return false; // Property doesn't belong to owner or doesn't exist
                    }
                }
            }

            // Delete bookings first to maintain referential integrity
            String deleteBookingsSql = "DELETE FROM bookings WHERE property_id = ?";
            try (PreparedStatement deleteBookingsPs = con.prepareStatement(deleteBookingsSql)) {
                deleteBookingsPs.setInt(1, Integer.parseInt(propertyId));
                deleteBookingsPs.executeUpdate();
            }

            // Delete the property
            String deletePropertySql = "DELETE FROM property_listing WHERE id = ?";
            try (PreparedStatement deletePropertyPs = con.prepareStatement(deletePropertySql)) {
                deletePropertyPs.setInt(1, Integer.parseInt(propertyId));
                return deletePropertyPs.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}