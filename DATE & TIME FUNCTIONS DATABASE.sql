-- =====================================
-- DATE & TIME FUNCTIONS DATABASE
-- =====================================

CREATE DATABASE IF NOT EXISTS DateTimeDB;
USE DateTimeDB;

-- =====================================
-- 1. TRANSACTIONS TABLE (Navi example)
-- =====================================
CREATE TABLE IF NOT EXISTS TRANSACTIONS (
    TxnID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    Amount DECIMAL(10,2),
    TxnDate DATETIME
);

INSERT INTO TRANSACTIONS (CustomerID, Amount, TxnDate) VALUES
(1, 500, NOW() - INTERVAL 5 DAY),
(2, 1200, NOW() - INTERVAL 20 DAY),
(3, 7000, NOW() - INTERVAL 40 DAY);

-- =====================================
-- 2. ORDERS TABLE (Zomato example)
-- =====================================
CREATE TABLE IF NOT EXISTS ORDERS (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    OrderDate DATETIME
);

INSERT INTO ORDERS (CustomerID, OrderDate) VALUES
(1, '2024-04-02 12:00:00'),
(2, '2024-05-15 18:30:00'),
(3, '2024-06-29 20:00:00'),
(4, NOW()),
(5, NOW() - INTERVAL 1 DAY);

-- =====================================
-- 3. CUSTOMER TABLE
-- =====================================
CREATE TABLE IF NOT EXISTS CUSTOMER (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Phone VARCHAR(15),
    Email VARCHAR(100),
    DateOfBirth DATE
);

INSERT INTO CUSTOMER (Name, Phone, Email, DateOfBirth) VALUES
('Aryaman', '9999999999', 'aryaman@email.com', '2002-04-02'),
('Rahul', '8888888888', 'rahul@email.com', '1998-08-15'),
('Sneha', '7777777777', 'sneha@email.com', '2000-04-02');

-- =====================================
-- 4. LOANS TABLE
-- =====================================
CREATE TABLE IF NOT EXISTS LOANS (
    LoanID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    MaturityDate DATE,
    EMIAmount DECIMAL(10,2),
    
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
);

INSERT INTO LOANS (CustomerID, MaturityDate, EMIAmount) VALUES
(1, CURDATE() + INTERVAL 30 DAY, 5000),
(2, CURDATE() + INTERVAL 100 DAY, 7000),
(3, CURDATE() + INTERVAL 60 DAY, 6000);

-- =====================================
-- 5. CURRENT DATE/TIME FUNCTIONS
-- =====================================
SELECT CURDATE() AS CurrentDate;
SELECT NOW() AS CurrentDateTime;
SELECT YEAR(NOW()) AS CurrentYear;
SELECT MONTH(NOW()) AS CurrentMonth;
SELECT DAYOFWEEK(NOW()) AS DayOfWeek;

-- =====================================
-- 6. LAST 30 DAYS TRANSACTIONS
-- =====================================
SELECT * 
FROM TRANSACTIONS
WHERE TxnDate >= NOW() - INTERVAL 30 DAY;

-- =====================================
-- 7. ORDERS IN Q3 FY2024 (APR–JUNE)
-- =====================================
SELECT * 
FROM ORDERS
WHERE OrderDate BETWEEN '2024-04-01' AND '2024-06-30';

-- =====================================
-- 8. TODAY'S BIRTHDAYS
-- =====================================
SELECT Name, Phone, Email 
FROM CUSTOMER
WHERE MONTH(DateOfBirth) = MONTH(CURDATE())
  AND DAY(DateOfBirth) = DAY(CURDATE());

-- =====================================
-- 9. LOANS MATURING IN NEXT 90 DAYS
-- =====================================
SELECT 
    L.LoanID, 
    C.Name AS CustomerName, 
    L.MaturityDate, 
    L.EMIAmount
FROM LOANS L
JOIN CUSTOMER C ON L.CustomerID = C.CustomerID
WHERE MaturityDate BETWEEN CURDATE() AND CURDATE() + INTERVAL 90 DAY
ORDER BY MaturityDate ASC;


-- 10. WEEKEND ORDERS ANALYSIS

SELECT 
    COUNT(*) AS TotalOrders, 
    DAYNAME(OrderDate) AS DayName
FROM ORDERS
GROUP BY DAYNAME(OrderDate)
HAVING DayName IN ('Saturday', 'Sunday');