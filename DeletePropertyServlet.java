package hf;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.Map;

@WebServlet("/DeletePropertyServlet")
public class DeletePropertyServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Map<String, String> user = (Map<String, String>) session.getAttribute("user");
        String propertyId = request.getParameter("propertyId");
        String ownerId = user.get("id");

        if (propertyId == null || propertyId.isEmpty()) {
            request.setAttribute("error", "Invalid property ID");
            request.getRequestDispatcher("ownerDashboard.jsp").forward(request, response);
            return;
        }

        boolean success = DbUtil.deleteProperty(propertyId, ownerId);
        if (success) {
            response.sendRedirect("ownerDashboard.jsp?delete=success");
        } else {
            request.setAttribute("error", "Failed to delete property. It may not exist or you don't have permission.");
            request.getRequestDispatcher("ownerDashboard.jsp").forward(request, response);
        }
    }
}