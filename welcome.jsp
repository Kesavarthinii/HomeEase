<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>HomeEase - Welcome</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #fdfdfd, #f2f2f2);
            margin: 0;
            padding: 0;
        }
        .header {
            background: #ffffff;
            padding: 20px 40px;
            display: flex;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            justify-content: space-between;
        }
        .logo-text {
            font-size: 28px;
            font-weight: bold;
            color: #2C3E50;
        }
        .logo-img {
            height: 60px;
        }
        .main-content {
            text-align: center;
            padding: 40px 20px;
        }
        h1 {
            font-size: 32px;
            background: linear-gradient(to right, #e67e22, #e74c3c);
            -webkit-background-clip: text;
            color: transparent;
        }
        .tagline {
            font-size: 20px;
            margin-top: 10px;
            color: #555;
        }
        .search-box {
            background: white;
            margin-top: 30px;
            display: inline-block;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.07);
        }
        .tabs {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }
        .tab {
            padding: 12px 24px;
            margin: 0 6px;
            border-radius: 25px;
            background: #ecf0f1;
            color: #333;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .tab.active {
            background: #e74c3c;
            color: #fff;
        }
        .form-row {
            margin: 15px 0;
        }
        select, input[type="text"] {
            padding: 10px;
            width: 260px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 15px;
        }
        .search-button {
            background: linear-gradient(to right, #e74c3c, #e67e22);
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 25px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s;
        }
        .search-button:hover {
            background: linear-gradient(to right, #c0392b, #d35400);
        }
        .footer {
            margin-top: 60px;
            text-align: center;
        }
        .footer h3 {
            font-weight: normal;
            color: #666;
        }
        .post-btn {
            background-color: #009688;
            color: white;
            border: none;
            padding: 12px 30px;
            font-size: 16px;
            border-radius: 25px;
            cursor: pointer;
            margin-top: 10px;
            transition: background 0.3s ease;
        }
        .post-btn:hover {
            background-color: #00796b;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo-text">HomeEase</div>
        <div>
            <img src="images/logo.png" alt="Housyy Logo" class="logo-img">
        </div>
    </div>

    <div class="main-content">
        <h1>World's Easiest Home Finding Platform</h1>
        <div class="tagline">Find Homes That Feel Right!</div>

        <div class="search-box">
            <div class="tabs">
                <div class="tab active" id="buyTab">Buy</div>
                <div class="tab" id="rentTab">Rent</div>
            </div>

            <form action="SearchServlet" method="get">
                <input type="hidden" name="listingType" id="listingType" value="Buy">

                <div class="form-row">
                    <label for="location">City:</label><br>
                    <select name="location" id="location">
                        <option value="Bangalore">Bangalore</option>
                        <option value="Chennai" selected>Chennai</option>
                        <option value="Hyderabad">Hyderabad</option>
                        <option value="Mumbai">Mumbai</option>
                    </select>
                </div>

                <div class="form-row">
                    <label for="bhkType">BHK Type:</label><br>
                    <select name="bhkType" id="bhkType">
                        <option value="">Any</option>
                        <option>1 BHK</option>
                        <option>2 BHK</option>
                        <option>3 BHK</option>
                        <option>4 BHK</option>
                    </select>
                </div>

                <div class="form-row" style="text-align: center;">
                    <button class="search-button" type="submit">Search</button>
                </div>
            </form>
        </div>

        <div class="footer">
            <h3>Are you a Property Owner?</h3>
            <form action="login.jsp" method="get">
                <input type="hidden" name="action" value="post">
                <button class="post-btn">Login to Post Property</button>
            </form>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const buyTab = document.getElementById('buyTab');
            const rentTab = document.getElementById('rentTab');
            const listingType = document.getElementById('listingType');

            buyTab.addEventListener('click', function() {
                buyTab.classList.add('active');
                rentTab.classList.remove('active');
                listingType.value = 'Buy';
            });

            rentTab.addEventListener('click', function() {
                rentTab.classList.add('active');
                buyTab.classList.remove('active');
                listingType.value = 'Rent';
            });
        });
    </script>
</body>
</html>