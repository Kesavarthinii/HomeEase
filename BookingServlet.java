package hf;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.logging.Logger;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/java";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "arul@14";
    private static final Logger logger = Logger.getLogger(BookingServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String propertyId = req.getParameter("propertyId");
        String userName = req.getParameter("userName");
        String userEmail = req.getParameter("userEmail");
        String userPhone = req.getParameter("userPhone");

        // Validate all required fields
        if (propertyId == null || propertyId.isEmpty()) {
            handleError(req, resp, "Property ID is required");
            return;
        }

        try {
            int propId = Integer.parseInt(propertyId);
            
            // Verify property exists before booking
            if (!propertyExists(propId)) {
                handleError(req, resp, "Selected property does not exist");
                return;
            }

            // Check if this user already booked this property
            if (bookingExists(propId, userEmail)) {
                handleError(req, resp, "You have already booked this property");
                return;
            }

            // Process the booking
            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                String sql = "INSERT INTO bookings (property_id, user_name, user_email, user_phone) VALUES (?, ?, ?, ?)";
                
                try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, propId);
                    ps.setString(2, userName);
                    ps.setString(3, userEmail);
                    ps.setString(4, userPhone);
                    
                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        try (ResultSet rs = ps.getGeneratedKeys()) {
                            if (rs.next()) {
                                int bookingId = rs.getInt(1);
                                logger.info("Booking created with ID: " + bookingId);
                            }
                        }
                        resp.sendRedirect("bookingConfirmation.jsp");
                    } else {
                        handleError(req, resp, "Booking failed. Please try again.");
                    }
                }
            }
        } catch (SQLIntegrityConstraintViolationException e) {
            handleError(req, resp, "You have already booked this property");
        } catch (NumberFormatException e) {
            handleError(req, resp, "Invalid property ID format");
        } catch (SQLException e) {
            logger.severe("Database error: " + e.getMessage());
            handleError(req, resp, "Database error occurred. Please try again later.");
        } catch (Exception e) {
            logger.severe("Unexpected error: " + e.getMessage());
            handleError(req, resp, "An unexpected error occurred.");
        }
    }

    private boolean propertyExists(int propertyId) throws SQLException {
        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String sql = "SELECT id FROM property_listing WHERE id = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, propertyId);
                try (ResultSet rs = ps.executeQuery()) {
                    return rs.next();
                }
            }
        }
    }

    private boolean bookingExists(int propertyId, String userEmail) throws SQLException {
        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String sql = "SELECT id FROM bookings WHERE property_id = ? AND user_email = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, propertyId);
                ps.setString(2, userEmail);
                try (ResultSet rs = ps.executeQuery()) {
                    return rs.next();
                }
            }
        }
    }

    private void handleError(HttpServletRequest req, HttpServletResponse resp, String message) 
            throws ServletException, IOException {
        req.setAttribute("error", message);
        RequestDispatcher dispatcher = req.getRequestDispatcher("searchResults.jsp");
        dispatcher.forward(req, resp);
    }

    @Override
    public void init() throws ServletException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ServletException("MySQL JDBC Driver not found", e);
        }
    }
}