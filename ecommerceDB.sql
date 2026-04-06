-- Create Database
CREATE DATABASE EcommerceDB;
USE EcommerceDB;

-- =========================
-- 1. Customers Table
-- =========================
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    
    BirthYear YEAR,  -- Stores only year (1901–2155)

    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    -- Auto-stores account creation time (UTC based)
);

-- =========================
-- 2. Products Table
-- =========================
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(150) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Stock INT DEFAULT 0,

    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
    -- Stored as-is (no timezone conversion)
);

-- =========================
-- 3. Orders Table
-- =========================
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,

    OrderDate DATE,        -- Only date (YYYY-MM-DD)
    OrderTime TIME,        -- Only time (HH:MM:SS)
    OrderPlaced DATETIME,  -- Exact date + time

    LastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
    ON UPDATE CURRENT_TIMESTAMP,
    -- Auto-updates on every row modification

    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- =========================
-- 4. Order Items Table
-- =========================
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    ProductID INT,

    Quantity INT NOT NULL,
    PriceAtPurchase DECIMAL(10,2) NOT NULL,

    AddedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- =========================
-- Sample Inserts
-- =========================

-- Insert Customers
INSERT INTO Customers (Name, Email, BirthYear)
VALUES 
('Aryaman Kumar', 'aryaman@example.com', 2002),
('Rahul Sharma', 'rahul@example.com', 1998);

-- Insert Products
INSERT INTO Products (ProductName, Price, Stock)
VALUES 
('Laptop', 75000.00, 10),
('Headphones', 2000.00, 50);

-- Insert Orders
INSERT INTO Orders (CustomerID, OrderDate, OrderTime, OrderPlaced)
VALUES 
(1, '2026-04-02', '14:30:00', '2026-04-02 14:30:00'),
(2, '2026-04-01', '10:15:00', '2026-04-01 10:15:00');

-- Insert Order Items
INSERT INTO OrderItems (OrderID, ProductID, Quantity, PriceAtPurchase)
VALUES 
(1, 1, 1, 75000.00),
(1, 2, 2, 2000.00),
(2, 2, 1, 2000.00);

-- =========================


SELECT * 
FROM Orders
WHERE OrderDate >= CURDATE() - INTERVAL 30 DAY;

-- Latest updated orders
SELECT * 
FROM Orders
ORDER BY LastUpdated DESC;

-- Total order value
SELECT O.OrderID, SUM(OI.Quantity * OI.PriceAtPurchase) AS TotalAmount
FROM Orders O
JOIN OrderItems OI ON O.OrderID = OI.OrderID
GROUP BY O.OrderID;