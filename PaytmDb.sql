
-- PAYTM FINTECH DATABASE (FULL SCRIPT)
-- =====================================

-- Create Database
CREATE DATABASE IF NOT EXISTS PaytmDB;
USE PaytmDB;

-- =====================================
-- 1. TRANSACTION LEDGER TABLE
-- =====================================
CREATE TABLE IF NOT EXISTS PAYTM_TXN_LEDGER (
    TxnID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID VARCHAR(10) NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    TxnType CHAR(2),
    TxnDate DATE NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CHECK (TxnType IN ('CR', 'DR'))
);

-- =====================================
-- 2. INVOICES TABLE
-- =====================================
CREATE TABLE IF NOT EXISTS PAYTM_INVOICES (
    InvoiceID INT PRIMARY KEY AUTO_INCREMENT,
    VendorID VARCHAR(10) NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    Status VARCHAR(10),
    InvoiceDate DATE,
    
    CHECK (Status IN ('Paid', 'Unpaid'))
);

-- =====================================
-- 3. INSERT SAMPLE DATA
-- =====================================

-- Transactions
INSERT INTO PAYTM_TXN_LEDGER (CustomerID, Amount, TxnType, TxnDate)
VALUES
('C001', 100, 'DR', CURDATE() - INTERVAL 1 DAY),
('C001', 1200, 'CR', CURDATE() - INTERVAL 3 DAY),
('C001', 8500, 'DR', CURDATE() - INTERVAL 7 DAY),
('C001', 60000, 'DR', CURDATE() - INTERVAL 2 DAY),
('C002', 300, 'CR', CURDATE());

-- Invoices
INSERT INTO PAYTM_INVOICES (VendorID, Amount, Status, InvoiceDate)
VALUES
('V001', 15000, 'Paid', CURDATE() - INTERVAL 10 DAY),
('V001', 7000, 'Unpaid', CURDATE() - INTERVAL 5 DAY),
('V001', 9000, 'Unpaid', CURDATE() - INTERVAL 2 DAY),
('V002', 20000, 'Paid', CURDATE() - INTERVAL 6 DAY);

-- =====================================
-- 4. CASE WHEN QUERY (TRANSACTION ANALYSIS)
-- =====================================
SELECT
  TxnID,
  Amount,

  CASE
    WHEN Amount < 500 THEN 'Micro Transaction'
    WHEN Amount BETWEEN 500 AND 4999 THEN 'Small Transaction'
    WHEN Amount BETWEEN 5000 AND 49999 THEN 'Medium Transaction'
    WHEN Amount >= 50000 THEN 'Large Transaction - Flag for Review'
    ELSE 'Unknown'
  END AS TransactionCategory,

  CASE TxnType
    WHEN 'CR' THEN 'Money Received'
    WHEN 'DR' THEN 'Money Sent'
    ELSE 'Pending'
  END AS TxnDescription

FROM PAYTM_TXN_LEDGER
WHERE CustomerID = 'C001'
  AND TxnDate >= CURDATE() - INTERVAL 30 DAY;

-- =====================================
-- 5. CASE WHEN WITH AGGREGATE (INVOICE ANALYSIS)
-- =====================================
SELECT
  VendorID,

  COUNT(*) AS TotalInvoices,

  COUNT(CASE WHEN Status = 'Paid' THEN 1 END) AS PaidCount,

  COUNT(CASE WHEN Status = 'Unpaid' THEN 1 END) AS UnpaidCount,

  SUM(
    CASE 
      WHEN Status = 'Unpaid' THEN Amount 
      ELSE 0 
    END
  ) AS OutstandingAmount

FROM PAYTM_INVOICES
GROUP BY VendorID;