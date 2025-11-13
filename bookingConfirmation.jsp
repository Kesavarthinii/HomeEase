<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Booking Confirmation</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #e0f7fa, #ffffff);
            margin: 0;
            padding: 50px 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .confirmation {
            background: #ffffff;
            padding: 40px 30px;
            border-radius: 16px;
            max-width: 600px;
            width: 100%;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            text-align: center;
            animation: fadeIn 0.6s ease-in-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        h1 {
            color: #28a745;
            font-size: 32px;
            margin-bottom: 20px;
        }
        p {
            color: #333;
            font-size: 16px;
            margin: 10px 0;
        }
        .btn {
            background: linear-gradient(to right, #007bff, #0056b3);
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            display: inline-block;
            margin-top: 25px;
            transition: background 0.3s ease;
        }
        .btn:hover {
            background: linear-gradient(to right, #0056b3, #004080);
        }
    </style>
</head>
<body>
    <div class="confirmation">
        <h1>Booking Confirmed!</h1>
        <p>Thank you for your booking. We've emailed you the details.</p>
        <p>Our representative will contact you soon.</p>
        <a href="welcome.jsp" class="btn">Back to Home</a>
    </div>
</body>
</html>