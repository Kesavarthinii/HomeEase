package hf;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/java";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "arul@14";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String listingType = req.getParameter("listingType");
        String location = req.getParameter("location");
        String bhkType = req.getParameter("bhkType");

        List<Map<String, String>> properties = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {

                // Updated SQL to include parking_type, total_amount, and emi
                StringBuilder sql = new StringBuilder("SELECT id, property_name, image_path, location, listing_type, " +
                        "rent_amount, total_amount, emi, bhk_type, parking_type FROM property_listing WHERE location LIKE ?");
                List<String> parameters = new ArrayList<>();
                parameters.add("%" + location + "%");

                if (listingType != null && !"ANY".equalsIgnoreCase(listingType)) {
                    sql.append(" AND listing_type=?");
                    parameters.add(listingType);
                }

                if (bhkType != null && !bhkType.isEmpty()) {
                    sql.append(" AND bhk_type=?");
                    parameters.add(bhkType);
                }

                try (PreparedStatement ps = con.prepareStatement(sql.toString())) {
                    for (int i = 0; i < parameters.size(); i++) {
                        ps.setString(i + 1, parameters.get(i));
                    }

                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
                        Map<String, String> row = new HashMap<>();
                        row.put("propertyId", rs.getString("id"));
                        row.put("propertyName", rs.getString("property_name"));
                        row.put("imagePath", rs.getString("image_path"));
                        row.put("location", rs.getString("location"));
                        row.put("listingType", rs.getString("listing_type"));
                        row.put("rent", rs.getString("rent_amount"));
                        row.put("price", rs.getString("total_amount"));
                        row.put("emi", rs.getString("emi"));
                        row.put("bhkType", rs.getString("bhk_type"));
                        row.put("parkingType", rs.getString("parking_type"));
                        properties.add(row);
                    }
                }
            }

            if (properties.isEmpty()) {
                req.setAttribute("message", "No properties found matching your criteria.");
            } else {
                req.setAttribute("properties", properties);
            }

            RequestDispatcher dispatcher = req.getRequestDispatcher("searchResults.jsp");
            dispatcher.forward(req, resp);

        } catch (Exception e) {
            req.setAttribute("message", "Error: " + e.getMessage());
            RequestDispatcher dispatcher = req.getRequestDispatcher("searchResults.jsp");
            dispatcher.forward(req, resp);
        }
    }
}