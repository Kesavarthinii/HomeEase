<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map, hf.DbUtil" %>
<%
    // Check if owner is logged in
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Map<String, String> user = (Map<String, String>) session.getAttribute("user");
    List<Map<String, String>> properties = DbUtil.getOwnerProperties(user.get("id"));
    List<Map<String, String>> bookings = DbUtil.getOwnerBookings(user.get("id"));
    
    String deleteSuccess = request.getParameter("delete");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Owner Dashboard - HomeEase</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f7fa;
        }
        .header {
            background: #2c3e50;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .logo {
            font-size: 24px;
            font-weight: bold;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .logout-btn {
            background: #e74c3c;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
        }
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .dashboard-nav {
            display: flex;
            margin-bottom: 30px;
            border-bottom: 1px solid #ddd;
        }
        .nav-item {
            padding: 10px 20px;
            cursor: pointer;
            border-bottom: 3px solid transparent;
        }
        .nav-item.active {
            border-bottom-color: #3498db;
            font-weight: bold;
        }
        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
        }
        .card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        .card h3 {
            margin-top: 0;
            color: #2c3e50;
        }
        .btn {
            background: #3498db;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            text-decoration: none;
            display: inline-block;
            margin-top: 10px;
            cursor: pointer;
        }
        .btn-danger {
            background: #e74c3c;
        }
        .btn-success {
            background: #2ecc71;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
        }
        .no-data {
            text-align: center;
            padding: 20px;
            color: #666;
        }
        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }
        .actions-cell {
            display: flex;
            gap: 5px;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">HomeEase</div>
        <div class="user-info">
            <span>Welcome, <%= user.get("username") %></span>
            <form action="LogoutServlet" method="post">
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        </div>
    </div>

    <div class="container">
        <% if (deleteSuccess != null && deleteSuccess.equals("success")) { %>
            <div class="success-message">
                Property deleted successfully!
            </div>
        <% } %>
        
        <% if (error != null) { %>
            <div class="error-message">
                <%= error %>
            </div>
        <% } %>

        <div class="dashboard-nav">
            <div class="nav-item active" onclick="showTab('properties')">My Properties</div>
            <div class="nav-item" onclick="showTab('bookings')">Bookings</div>
            <div class="nav-item" onclick="showTab('post')">Post New Property</div>
        </div>

        <div id="properties" class="tab-content active">
            <h2>My Properties</h2>
            <% if (properties.isEmpty()) { %>
                <div class="no-data">You haven't posted any properties yet.</div>
            <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>Property Name</th>
                            <th>Location</th>
                            <th>Type</th>
                            <th>BHK</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Map<String, String> property : properties) { %>
                        <tr>
                            <td><%= property.get("property_name") %></td>
                            <td><%= property.get("location") %></td>
                            <td><%= property.get("listing_type") %></td>
                            <td><%= property.get("bhk_type") %></td>
                            <td>
                                <% if (property.get("bookings") != null && Integer.parseInt(property.get("bookings")) > 0) { %>
                                    <%= property.get("bookings") %> Bookings
                                <% } else { %>
                                    Available
                                <% } %>
                            </td>
                            <td class="actions-cell">
                                <form action="DeletePropertyServlet" method="post" style="margin: 0;">
                                    <input type="hidden" name="propertyId" value="<%= property.get("id") %>">
                                    <button type="submit" class="btn btn-danger" 
                                            onclick="return confirm('Are you sure you want to delete this property? This action cannot be undone.')">
                                        Delete
                                    </button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>

        <div id="bookings" class="tab-content">
            <h2>Property Bookings</h2>
            <% if (bookings.isEmpty()) { %>
                <div class="no-data">No bookings yet.</div>
            <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>Property</th>
                            <th>Booked By</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Map<String, String> booking : bookings) { %>
                        <tr>
                            <td><%= booking.get("property_name") %></td>
                            <td><%= booking.get("user_name") %></td>
                            <td><%= booking.get("user_email") %></td>
                            <td><%= booking.get("user_phone") %></td>
                            <td><%= booking.get("booking_date") %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>

        <div id="post" class="tab-content">
            <div class="card">
                <h3>Post New Property</h3>
                <a href="post.jsp" class="btn btn-success">Post Property</a>
            </div>
        </div>
    </div>

    <script>
        function showTab(tabId) {
            // Hide all tabs
            document.querySelectorAll('.tab-content').forEach(tab => {
                tab.classList.remove('active');
            });
            
            // Deactivate all nav items
            document.querySelectorAll('.nav-item').forEach(item => {
                item.classList.remove('active');
            });
            
            // Show selected tab
            document.getElementById(tabId).classList.add('active');
            
            // Activate clicked nav item
            event.currentTarget.classList.add('active');
        }
    </script>
</body>
</html>