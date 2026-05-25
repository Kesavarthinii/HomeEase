# HomeEase
HomeEase is a Java-based real estate web application built using JSP, Servlets, and MySQL. It allows users to search for properties, view listings, and make bookings. Property owners can post listings, and users can register/login to manage their bookings.

The project demonstrates a full-stack Java EE workflow with MVC architecture.

## ⚙️ Tech Stack
Frontend: JSP, HTML, CSS, JavaScript
Backend: Java Servlets (JDK 8+)
Database: MySQL (via MySQL Extension)
Server: Apache Tomcat 9+
Build Tool: Maven

## 🗄️ Database Schema
Using MySQL with the following tables:

### 1️⃣ bookings
id           INT AUTO_INCREMENT PRIMARY KEY
property_id  INT
user_name    VARCHAR(100) NOT NULL
user_email   VARCHAR(100) NOT NULL
user_phone   VARCHAR(20)  NOT NULL
booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP

### 2️⃣ property_listing
id            INT AUTO_INCREMENT PRIMARY KEY
property_name VARCHAR(255) NOT NULL
image_path    VARCHAR(255) NOT NULL
location      VARCHAR(255) NOT NULL
listing_type  VARCHAR(20)  NOT NULL
rent_amount   DOUBLE
square_feet   INT
total_amount  DOUBLE
emi           DOUBLE
bhk_type      VARCHAR(20)
parking_type  VARCHAR(20)
owner_name    VARCHAR(100) NOT NULL
owner_phone   VARCHAR(20)  NOT NULL
owner_email   VARCHAR(100) NOT NULL
description   TEXT

### 3️⃣ users
id         INT AUTO_INCREMENT PRIMARY KEY
username   VARCHAR(50)  UNIQUE NOT NULL
password   VARCHAR(255) NOT NULL
email      VARCHAR(100) UNIQUE NOT NULL
phone      VARCHAR(20)  NOT NULL
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

## 🚀 Features
User signup, login, and logout
Property search by location, type, and budget
Booking system with confirmation page
Owner dashboard to post new properties
Session handling with JSP + Servlets
Database connectivity via DbUtil.java

## 📖 Booking Flow
User searches properties → SearchServlet.java
Chooses a property → fills booking form (modal in JSP)
Form submits to BookingServlet.java
Booking stored in bookings table
Redirects to bookingConfirmation.jsp

## 🛠️ Troubleshooting
Ensure MySQL is running .
Check database credentials in DbUtil.java.
Verify MySQL connector JAR is in Referenced Libraries.
Clean & build Maven project if deployment fails.

## 📌 Future Enhancements
Role-based access (Admin, Owner, User)
Property filters (price range, BHK, location)
Image upload for property listings
Email notifications for bookings

