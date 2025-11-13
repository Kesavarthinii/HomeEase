<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%
    // Check if owner is logged in
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp?redirect=post");
        return;
    }
    
    Map<String, String> user = (Map<String, String>) session.getAttribute("user");
    String action = request.getParameter("action");
    if (action == null) action = "buy";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Post Property - HomeEase</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #fdfdfd, #f3f3f3);
            padding: 40px 20px;
        }
        h2 {
            color: #2C3E50;
            text-align: center;
            font-size: 30px;
            margin-bottom: 25px;
        }
        .form-container {
            background: #fff;
            max-width: 700px;
            margin: auto;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 12px 25px rgba(0, 0, 0, 0.08);
            transition: transform 0.3s ease;
        }
        .form-container:hover {
            transform: translateY(-3px);
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 6px;
            color: #2c3e50;
            font-weight: 600;
        }
        input[type="text"], input[type="email"], input[type="number"], textarea, select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 15px;
            box-shadow: inset 0 1px 3px rgba(0,0,0,0.05);
            transition: border 0.3s, box-shadow 0.3s;
        }
        input:focus, select:focus, textarea:focus {
            border-color: #e67e22;
            box-shadow: 0 0 0 3px rgba(230, 126, 34, 0.2);
            outline: none;
        }
        textarea {
            resize: vertical;
        }
        .form-radio-group {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin-bottom: 25px;
        }
        .form-radio-group label {
            font-weight: bold;
            color: #34495e;
            font-size: 16px;
            cursor: pointer;
        }
        .form-radio-group input[type="radio"] {
            margin-right: 8px;
        }
        .submit-btn {
            background: linear-gradient(to right, #e74c3c, #e67e22);
            color: white;
            border: none;
            padding: 14px;
            font-size: 18px;
            border-radius: 8px;
            cursor: pointer;
            width: 100%;
            box-shadow: 0 6px 15px rgba(0,0,0,0.1);
            transition: background 0.3s ease;
        }
        .submit-btn:hover {
            background: linear-gradient(to right, #c0392b, #d35400);
        }
        .error-message {
            background-color: #fbeaea;
            color: #c0392b;
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 6px;
            border: 1px solid #f5c6cb;
            font-weight: 500;
            text-align: center;
        }
        ::placeholder {
            color: #aaa;
            font-style: italic;
        }
        @media screen and (max-width: 768px) {
            .form-container {
                padding: 25px;
            }
            h2 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Post Your <%= action.equalsIgnoreCase("rent") ? "Rental" : "Sale" %> Property</h2>

        <% String errorMessage = (String) request.getAttribute("errorMessage");
           if (errorMessage != null) { %>
           <div class="error-message"><%= errorMessage %></div>
        <% } %>

        <form action="Hf" method="post" enctype="multipart/form-data">
            <div class="form-radio-group">
                <label><input type="radio" name="listingType" value="buy" <%= action.equals("buy") ? "checked" : "" %>> Buy</label>
                <label><input type="radio" name="listingType" value="rent" <%= action.equals("rent") ? "checked" : "" %>> Rent</label>
            </div>

            <div class="form-group">
                <label for="propertyName">Property Name</label>
                <input type="text" name="propertyName" id="propertyName" required placeholder="E.g., Green Villa" style="text-transform: capitalize;">
            </div>

            <div class="form-group">
                <label for="image">Property Image</label>
                <input type="file" name="image" id="image" accept="image/*" required>
            </div>

            <div class="form-group">
                <label for="location">Location</label>
                <input type="text" name="location" id="location" required placeholder="Enter city or locality">
            </div>

            <!-- Rent Fields -->
            <div id="rentFields" style="display: <%= action.equals("rent") ? "block" : "none" %>;">
                <div class="form-group">
                    <label for="rentAmount">Rent Amount (₹)</label>
                    <input type="number" name="rentAmount" id="rentAmount" placeholder="Monthly Rent">
                </div>
            </div>

            <!-- Buy Fields -->
            <div id="buyFields" style="display: <%= action.equals("buy") ? "block" : "none" %>;">
                <div class="form-group">
                    <label for="squareFeet">Square Feet</label>
                    <input type="number" name="squareFeet" id="squareFeet" placeholder="E.g., 1200">
                </div>
                <div class="form-group">
                    <label for="totalAmount">Total Amount (₹)</label>
                    <input type="number" name="totalAmount" id="totalAmount" placeholder="E.g., 5000000">
                </div>
                <div class="form-group">
                    <label for="emi">Estimated EMI (₹)</label>
                    <input type="number" name="emi" id="emi" placeholder="E.g., 30000">
                </div>
            </div>

            <div class="form-group">
                <label for="bhkType">BHK Type</label>
                <select name="bhkType" id="bhkType" required>
                    <option value="" disabled selected>Select BHK</option>
                    <option value="1 BHK">1 BHK</option>
                    <option value="2 BHK">2 BHK</option>
                    <option value="3 BHK">3 BHK</option>
                    <option value="4 BHK">4 BHK</option>
                </select>
            </div>

            <div class="form-group">
                <label for="parkingType">Parking Type</label>
                <select name="parkingType" id="parkingType" required>
                    <option value="" disabled selected>Select Parking</option>
                    <option value="1 Four Wheeler">1 Four Wheeler</option>
                    <option value="2 Four Wheeler">2 Four Wheeler</option>
                    <option value="Bike Only">Bike Only</option>
                    <option value="No Parking">No Parking</option>
                </select>
            </div>

            <div class="form-group">
                <label for="ownerName">Owner Name</label>
                <input type="text" name="ownerName" id="ownerName" 
                       value="<%= user.get("username") != null ? user.get("username") : "" %>" 
                       readonly style="background-color: #f5f5f5;">
            </div>

            <div class="form-group">
                <label for="ownerPhone">Owner Phone</label>
                <% if (user.get("phone") != null && !user.get("phone").isEmpty()) { %>
                    <input type="text" name="ownerPhone" id="ownerPhone" 
                           value="<%= user.get("phone") %>" 
                           readonly style="background-color: #f5f5f5;">
                <% } else { %>
                    <input type="text" name="ownerPhone" id="ownerPhone" 
                           required pattern="[0-9]{10}" title="10 digit phone number"
                           placeholder="Enter your phone number">
                <% } %>
            </div>

            <div class="form-group">
                <label for="ownerEmail">Owner Email</label>
                <input type="email" name="ownerEmail" id="ownerEmail" 
                       value="<%= user.get("email") != null ? user.get("email") : "" %>" 
                       readonly style="background-color: #f5f5f5;">
            </div>

            <div class="form-group">
                <label for="description">Property Description</label>
                <textarea name="description" id="description" rows="4" placeholder="Additional details..."></textarea>
            </div>

            <button type="submit" class="submit-btn">Submit Property</button>
        </form>
    </div>

    <script>
        function toggleFields() {
            const selected = document.querySelector('input[name="listingType"]:checked').value;
            document.getElementById('rentFields').style.display = selected === 'rent' ? 'block' : 'none';
            document.getElementById('buyFields').style.display = selected === 'buy' ? 'block' : 'none';
        }

        document.querySelectorAll('input[name="listingType"]').forEach(r => {
            r.addEventListener('change', toggleFields);
        });

        window.onload = toggleFields;
    </script>
</body>
</html>