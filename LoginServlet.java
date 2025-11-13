package hf;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/java";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "arul@14";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, username);
                ps.setString(2, password);
                
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        Map<String, String> user = new HashMap<>();
                        user.put("id", rs.getString("id"));
                        user.put("username", rs.getString("username"));
                        user.put("email", rs.getString("email"));
                        user.put("phone", rs.getString("phone")); // Make sure phone is included
                        
                        HttpSession session = request.getSession();
                        session.setAttribute("user", user);
                        
                        // Redirect to owner dashboard
                        response.sendRedirect("ownerDashboard.jsp");
                    } else {
                        request.setAttribute("error", "Invalid username or password");
                        request.getRequestDispatcher("login.jsp").forward(request, response);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}