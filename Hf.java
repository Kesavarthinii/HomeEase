package hf;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import jakarta.servlet.http.HttpSession;

import java.io.*;
import java.nio.file.*;
import java.sql.*;

@WebServlet("/Hf")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,  // 1MB
    maxFileSize = 1024 * 1024 * 10,   // 10MB
    maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class Hf extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/java";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "arul@14";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        // Check if owner is logged in
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendError(req, resp, "You must be logged in to post a property");
            return;
        }

        try {
            // Get image part
            Part filePart = req.getPart("image");
            if (filePart == null || filePart.getSize() == 0) {
                throw new ServletException("No image uploaded");
            }

            // Generate unique file name
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;

            // Save to /images/ directory in web app
            String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            Path filePath = Paths.get(uploadDir.getAbsolutePath(), uniqueFileName);
            try (InputStream fileContent = filePart.getInputStream()) {
                Files.copy(fileContent, filePath, StandardCopyOption.REPLACE_EXISTING);
            }

            // Parse optional numbers safely
            Double rentAmount = parseDoubleSafe(req.getParameter("rentAmount"));
            Integer squareFeet = parseIntSafe(req.getParameter("squareFeet"));
            Double totalAmount = parseDoubleSafe(req.getParameter("totalAmount"));
            Double emi = parseDoubleSafe(req.getParameter("emi"));

            // Load JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                String sql = "INSERT INTO property_listing (property_name, image_path, location, listing_type, "
                        + "rent_amount, square_feet, total_amount, emi, bhk_type, parking_type, "
                        + "owner_name, owner_phone, owner_email, description) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, req.getParameter("propertyName"));
                    ps.setString(2, "images/" + uniqueFileName);
                    ps.setString(3, req.getParameter("location"));
                    ps.setString(4, req.getParameter("listingType"));
                    setDoubleOrNull(ps, 5, rentAmount);
                    setIntOrNull(ps, 6, squareFeet);
                    setDoubleOrNull(ps, 7, totalAmount);
                    setDoubleOrNull(ps, 8, emi);
                    ps.setString(9, req.getParameter("bhkType"));
                    ps.setString(10, req.getParameter("parkingType"));
                    ps.setString(11, req.getParameter("ownerName"));
                    ps.setString(12, req.getParameter("ownerPhone"));
                    ps.setString(13, req.getParameter("ownerEmail"));
                    ps.setString(14, req.getParameter("description"));

                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        resp.sendRedirect("ownerDashboard.jsp");
                    } else {
                        sendError(req, resp, "Failed to save property. Please try again.");
                    }
                }
            }
        } catch (ClassNotFoundException e) {
            sendError(req, resp, "MySQL JDBC Driver not found: " + e.getMessage());
        } catch (SQLException e) {
            sendError(req, resp, "Database error: " + e.getMessage());
        } catch (Exception e) {
            sendError(req, resp, "Error: " + e.getMessage());
        }
    }

    // Utility Methods
    private Double parseDoubleSafe(String value) {
        try {
            return (value != null && !value.trim().isEmpty()) ? Double.parseDouble(value) : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private Integer parseIntSafe(String value) {
        try {
            return (value != null && !value.trim().isEmpty()) ? Integer.parseInt(value) : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private void setDoubleOrNull(PreparedStatement ps, int index, Double value) throws SQLException {
        if (value != null) ps.setDouble(index, value);
        else ps.setNull(index, Types.DOUBLE);
    }

    private void setIntOrNull(PreparedStatement ps, int index, Integer value) throws SQLException {
        if (value != null) ps.setInt(index, value);
        else ps.setNull(index, Types.INTEGER);
    }

    private void sendError(HttpServletRequest req, HttpServletResponse resp, String message)
            throws ServletException, IOException {
        req.setAttribute("errorMessage", message);
        RequestDispatcher dispatcher = req.getRequestDispatcher("post.jsp");
        dispatcher.forward(req, resp);
    }
}