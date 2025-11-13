package hf;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/java";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "arul@14";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            // Check if username or email already exists
            String checkSql = "SELECT id FROM users WHERE username = ? OR email = ?";
            try (PreparedStatement checkPs = con.prepareStatement(checkSql)) {
                checkPs.setString(1, username);
                checkPs.setString(2, email);
                
                try (ResultSet rs = checkPs.executeQuery()) {
                    if (rs.next()) {
                        request.setAttribute("error", "Username or email already exists");
                        request.getRequestDispatcher("signup.jsp").forward(request, response);
                        return;
                    }
                }
            }

            // Insert new owner
            String insertSql = "INSERT INTO users (username, password, email, phone) VALUES (?, ?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                ps.setString(1, username);
                ps.setString(2, password);
                ps.setString(3, email);
                ps.setString(4, phone); // Make sure phone is included
                
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    response.sendRedirect("login.jsp?signup=success");
                } else {
                    request.setAttribute("error", "Registration failed");
                    request.getRequestDispatcher("signup.jsp").forward(request, response);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        }
    }
}