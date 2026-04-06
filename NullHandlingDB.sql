-- =====================================
-- NULL HANDLING DATABASE
-- =====================================

CREATE DATABASE IF NOT EXISTS NullHandlingDB;
USE NullHandlingDB;

-- =====================================
-- 1. EMPLOYEE TABLE (Manager hierarchy)
-- =====================================
CREATE TABLE IF NOT EXISTS EMPLOYEE (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    ManagerID INT NULL
);

INSERT INTO EMPLOYEE (Name, ManagerID) VALUES
('Aryaman', NULL),
('Rahul', 1),
('Sneha', 1),
('Amit', 2);

-- =====================================
-- 2. PATIENT TABLE (Apollo Hospital example)
-- =====================================
CREATE TABLE IF NOT EXISTS PATIENT (
    PatientID INT PRIMARY KEY AUTO_INCREMENT,
    PatientName VARCHAR(100),
    Phone VARCHAR(15),
    AlternatePhone VARCHAR(15)
);

INSERT INTO PATIENT (PatientName, Phone, AlternatePhone) VALUES
('Riya', NULL, '9876543210'),
('Karan', '9123456780', NULL),
('Meera', NULL, NULL);

-- =====================================
-- 3. PRODUCT TABLE
-- =====================================
CREATE TABLE IF NOT EXISTS PRODUCT (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100),
    ListPrice DECIMAL(10,2),
    DiscountedPrice DECIMAL(10,2)
);

INSERT INTO PRODUCT (ProductName, ListPrice, DiscountedPrice) VALUES
('Laptop', 70000, 65000),
('Headphones', 2000, NULL),
('Keyboard', 1500, NULL);

-- =====================================
-- 4. CUSTOMER SUMMARY (MakeMyTrip example)
-- =====================================
CREATE TABLE IF NOT EXISTS CUSTOMER_SUMMARY (
    CustomerID INT PRIMARY KEY,
    TotalRevenue DECIMAL(10,2),
    BookingCount INT
);

INSERT INTO CUSTOMER_SUMMARY VALUES
(1, 50000, 5),
(2, 20000, 0),
(3, 30000, 3);

-- =====================================
-- 5. NULL BEHAVIOR DEMO
-- =====================================
SELECT 100 + NULL AS Result1;      -- NULL
SELECT NULL = NULL AS Result2;     -- NULL
SELECT NULL <> NULL AS Result3;    -- NULL

-- =====================================
-- 6. CORRECT NULL CHECKING
-- =====================================
SELECT * FROM EMPLOYEE WHERE ManagerID IS NULL;
SELECT * FROM EMPLOYEE WHERE ManagerID IS NOT NULL;

-- =====================================
-- 7. COALESCE (First non-NULL value)
-- =====================================
SELECT 
    PatientName,
    COALESCE(Phone, AlternatePhone, 'Not Provided') AS ContactNumber
FROM PATIENT;

-- 8. IFNULL (MySQL-specific)

SELECT 
    ProductName,
    IFNULL(DiscountedPrice, ListPrice) AS EffectivePrice
FROM PRODUCT;


-- 9. NULLIF (Avoid division by zero)

SELECT 
    CustomerID,
    TotalRevenue / NULLIF(BookingCount, 0) AS AvgBookingValue
FROM CUSTOMER_SUMMARY;