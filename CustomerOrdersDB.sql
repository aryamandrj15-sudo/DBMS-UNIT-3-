
CREATE DATABASE  CustomerOrdersDB;
USE CustomerOrdersDB;


-- 1. CUSTOMER TABLE

CREATE TABLE CUSTOMER (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Email VARCHAR(100)
);

INSERT INTO CUSTOMER (Name, Email) VALUES
('Aryaman', 'aryaman@email.com'),
('Rahul', 'rahul@email.com'),
('Sneha', 'sneha@email.com'),
('Amit', 'amit@email.com');

-- 2. ORDERS TABLE

CREATE TABLE  ORDERS (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NULL,  
    OrderDate DATE
);

INSERT INTO ORDERS (CustomerID, OrderDate) VALUES
(1, '2024-04-01'),
(1, '2024-04-05'),
(2, '2024-04-03'),
(NULL, '2024-04-07');  -- NULL row (important for NOT IN trap)

-- =====================================
-- 3. USING IN (SUBQUERY)
-- =====================================
-- Customers who have placed at least one order
SELECT Name, Email 
FROM CUSTOMER
WHERE CustomerID IN (
    SELECT DISTINCT CustomerID 
    FROM ORDERS
);

-- =====================================
-- 4. USING EXISTS (BETTER FOR LARGE DATA)
-- =====================================
SELECT Name, Email 
FROM CUSTOMER C
WHERE EXISTS (
    SELECT 1 
    FROM ORDERS O 
    WHERE O.CustomerID = C.CustomerID
);

-- =====================================
-- 5. WRONG: NOT IN (NULL TRAP)
-- =====================================
-- This may return EMPTY result if NULL exists in ORDERS
SELECT Name 
FROM CUSTOMER
WHERE CustomerID NOT IN (
    SELECT CustomerID FROM ORDERS
);

-- =====================================
-- 6. CORRECT: NOT EXISTS
-- =====================================
-- Customers who NEVER ordered
SELECT Name 
FROM CUSTOMER C
WHERE NOT EXISTS (
    SELECT 1 
    FROM ORDERS O 
    WHERE O.CustomerID = C.CustomerID
);