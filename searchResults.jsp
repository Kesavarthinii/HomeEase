<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<html>
<head>
    <title>Search Results</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #e0f7fa, #ffffff);
            margin: 0;
            padding: 20px;
            color: #2c3e50;
        }

        .results-container {
            max-width: 1300px;
            margin: 0 auto;
            padding: 20px;
        }

        h2 {
            text-align: center;
            color: #34495e;
            margin-bottom: 30px;
            font-size: 32px;
            letter-spacing: 1px;
        }

        .card {
            border: none;
            padding: 15px;
            margin: 15px;
            width: 300px;
            display: inline-block;
            vertical-align: top;
            border-radius: 16px;
            background: #ffffff;
            box-shadow: 0 8px 16px rgba(0,0,0,0.1), 0 4px 8px rgba(0,0,0,0.06);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 20px rgba(0,0,0,0.15);
        }

        .card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 10px;
            background-color: #ecf0f1;
            cursor: pointer;
        }

        .card h3 {
            margin: 12px 0 6px;
            color: #2c3e50;
            font-size: 20px;
        }

        .card p {
            margin: 4px 0;
            color: #555;
            font-size: 14px;
        }

        .price {
            font-weight: bold;
            color: #e74c3c;
            font-size: 18px;
            margin-top: 6px;
        }

        .emi {
            font-weight: bold;
            color: #3498db;
            font-size: 16px;
            margin-top: 4px;
        }

        .book-btn {
            margin-top: 12px;
            padding: 10px 0;
            background: linear-gradient(to right, #3498db, #2980b9);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
            transition: background 0.3s;
        }

        .book-btn:hover {
            background: linear-gradient(to right, #2980b9, #2471a3);
        }

        .no-results {
            text-align: center;
            margin-top: 50px;
            font-size: 18px;
            color: #666;
        }

        .error-message {
            color: #d9534f;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            padding: 10px;
            border-radius: 6px;
            margin: 20px auto;
            max-width: 600px;
            text-align: center;
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(44, 62, 80, 0.7);
            animation: fadeIn 0.4s;
        }

        .modal-content {
            background-color: #fefefe;
            margin: 5% auto;
            padding: 25px;
            border: 1px solid #ccc;
            width: 90%;
            max-width: 500px;
            border-radius: 12px;
            animation: slideDown 0.5s ease;
        }

        @keyframes slideDown {
            from { transform: translateY(-50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        @keyframes fadeIn {
            from { background-color: rgba(0,0,0,0); }
            to { background-color: rgba(44, 62, 80, 0.7); }
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }

        .close:hover {
            color: black;
        }

        .modal h3 {
            margin-top: 0;
            text-align: center;
            color: #2c3e50;
        }

        .form-group {
            margin-bottom: 15px;
        }

        label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
            color: #333;
        }

        input {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ddd;
            border-radius: 6px;
            box-sizing: border-box;
        }

        .modal-submit-btn {
            background: linear-gradient(to right, #27ae60, #2ecc71);
            color: white;
            padding: 12px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
            transition: background 0.3s ease;
        }

        .modal-submit-btn:hover {
            background: linear-gradient(to right, #1e8449, #27ae60);
        }

        /* Image Modal Styles */
        #imageModal {
            display: none;
            position: fixed;
            z-index: 2000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.9);
        }

        #imageModal img {
            margin: auto;
            display: block;
            max-width: 90%;
            max-height: 90%;
            margin-top: 5%;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(255,255,255,0.3);
        }

        #imageModal .close-img {
            position: absolute;
            top: 20px;
            right: 40px;
            color: white;
            font-size: 40px;
            font-weight: bold;
            cursor: pointer;
        }
    </style>
</head>
<body>
<div class="results-container">
    <h2>Search Results</h2>

    <%
        String msg = (String) request.getAttribute("message");
        String error = (String) request.getAttribute("error");

        if (error != null && request.getAttribute("formPropertyId") == null) {
    %>
        <div class="error-message">
            <%= error %>
            <br>
            <a href="javascript:history.back()">Go back</a> or 
            <a href="welcome.jsp">Return to home</a>
        </div>
    <%
        } else if (msg != null) {
    %>
        <div class="no-results"><%= msg %></div>
    <%
        } else {
            List<Map<String, String>> props = (List<Map<String, String>>) request.getAttribute("properties");
            if (props != null && !props.isEmpty()) {
                for (Map<String, String> prop : props) {
                    String propertyId = prop.get("propertyId") != null ? prop.get("propertyId") : "";
                    boolean isBuy = "Buy".equalsIgnoreCase(prop.get("listingType"));
    %>
        <div class="card" data-property-id="<%= propertyId %>">
            <img src="<%= prop.get("imagePath") != null ? prop.get("imagePath") : "images/default-property.jpg" %>" 
                 alt="<%= prop.get("propertyName") != null ? prop.get("propertyName") : "Property" %>" />
            <h3><%= prop.get("propertyName") != null ? prop.get("propertyName") : "" %> 
                - <%= prop.get("bhkType") != null ? prop.get("bhkType") : "" %></h3>
            <p><b>Location:</b> <%= prop.get("location") != null ? prop.get("location") : "" %></p>
            <p><b>Parking:</b> <%= prop.get("parkingType") != null ? prop.get("parkingType") : "Not specified" %></p>
            <% if (isBuy) { %>
                <p class="price">₹<%= prop.get("price") != null ? prop.get("price") : "0" %></p>
                <p class="emi">EMI: ₹<%= prop.get("emi") != null ? prop.get("emi") : "0" %>/month</p>
            <% } else { %>
                <p class="price">₹<%= prop.get("rent") != null ? prop.get("rent") : "0" %>/month</p>
            <% } %>
            <button class="book-btn">Book Now</button>
        </div>
    <%
                }
            } else {
    %>
        <div class="no-results">No properties found matching your criteria.</div>
    <%
            }
        }
    %>
</div>

<!-- Booking Modal -->
<div id="bookingModal" class="modal">
    <div class="modal-content">
        <span class="close">&times;</span>
        <h3>Book Property</h3>
        
        <% if (request.getAttribute("error") != null && request.getAttribute("formPropertyId") != null) { %>
            <div class="error-message" style="margin-bottom: 15px;">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <form id="bookingForm" action="BookingServlet" method="post" onsubmit="return validateBookingForm()">
            <input type="hidden" id="propertyId" name="propertyId" 
                   value="<%= request.getAttribute("formPropertyId") != null ? 
                          request.getAttribute("formPropertyId") : "" %>">
            <div class="form-group">
                <label for="userName">Your Name</label>
                <input type="text" id="userName" name="userName" required minlength="2" maxlength="100"
                       value="<%= request.getAttribute("formUserName") != null ? 
                              request.getAttribute("formUserName") : "" %>">
            </div>
            <div class="form-group">
                <label for="userEmail">Email</label>
                <input type="email" id="userEmail" name="userEmail" required maxlength="100"
                       value="<%= request.getAttribute("formUserEmail") != null ? 
                              request.getAttribute("formUserEmail") : "" %>">
            </div>
            <div class="form-group">
                <label for="userPhone">Phone</label>
                <input type="tel" id="userPhone" name="userPhone" required 
                       pattern="[0-9]{10}" title="10 digit phone number" maxlength="20"
                       value="<%= request.getAttribute("formUserPhone") != null ? 
                              request.getAttribute("formUserPhone") : "" %>">
            </div>
            <button type="submit" class="modal-submit-btn">Confirm Booking</button>
        </form>
    </div>
</div>

<!-- Image Modal -->
<div id="imageModal">
    <span class="close-img">&times;</span>
    <img id="modalImage" src="" alt="Full View">
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const bookingModal = document.getElementById('bookingModal');
    const closeBtn = document.querySelector('.close');
    const propertyInput = document.getElementById('propertyId');

    document.querySelectorAll('.card .book-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const card = this.closest('.card');
            const propertyId = card.getAttribute('data-property-id');
            if (!propertyId) {
                alert('Error: Property ID is missing. Please try again.');
                return;
            }
            propertyInput.value = propertyId;
            bookingModal.style.display = 'block';
        });
    });

    closeBtn.onclick = function() {
        bookingModal.style.display = 'none';
    };

    window.onclick = function(event) {
        if (event.target === bookingModal) {
            bookingModal.style.display = 'none';
        }
    };

    // Full image view
    const imageModal = document.getElementById('imageModal');
    const modalImage = document.getElementById('modalImage');
    const closeImgBtn = document.querySelector('.close-img');

    document.querySelectorAll('.card img').forEach(img => {
        img.addEventListener('click', function() {
            modalImage.src = this.src;
            imageModal.style.display = 'block';
        });
    });

    closeImgBtn.onclick = function() {
        imageModal.style.display = 'none';
    };

    window.addEventListener('click', function(event) {
        if (event.target === imageModal) {
            imageModal.style.display = 'none';
        }
    });

    // Show modal if there's an error for this property
    <% if (request.getAttribute("error") != null && request.getAttribute("formPropertyId") != null) { %>
        document.getElementById('propertyId').value = '<%= request.getAttribute("formPropertyId") %>';
        document.getElementById('bookingModal').style.display = 'block';
    <% } %>
});

function validateBookingForm() {
    const propertyId = document.getElementById('propertyId').value;
    if (!propertyId) {
        alert('Please select a property to book');
        return false;
    }

    const phone = document.getElementById('userPhone').value;
    if (!/^\d{10}$/.test(phone)) {
        alert('Please enter a valid 10-digit phone number');
        return false;
    }

    return true;
}
</script>
</body>
</html>