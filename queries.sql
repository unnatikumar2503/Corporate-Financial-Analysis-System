-- Step 1: Create the Companies Table
CREATE TABLE Companies (
    CompanyID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Industry VARCHAR(50),
    Country VARCHAR(50),
    StockSymbol VARCHAR(10) UNIQUE
);

-- Step 2: Create the Financials Table
CREATE TABLE Financials (
    RecordID INT PRIMARY KEY AUTO_INCREMENT,
    CompanyID INT,
    Year INT,
    Revenue DECIMAL(15,2),
    Expenses DECIMAL(15,2),
    NetProfit DECIMAL(15,2) GENERATED ALWAYS AS (Revenue - Expenses) STORED,
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);

-- Step 3: Create the Stock Prices Table
CREATE TABLE StockPrices (
    PriceID INT PRIMARY KEY AUTO_INCREMENT,
    CompanyID INT,
    Date DATE,
    OpenPrice DECIMAL(10,2),
    ClosePrice DECIMAL(10,2),
    Volume BIGINT,
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);

-- Step 4: Create the Transactions Table (M&A, Investments, etc.)
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY AUTO_INCREMENT,
    CompanyID INT,
    TransactionType ENUM('M&A', 'Investment', 'Divestment'),
    Amount DECIMAL(15,2),
    Date DATE,
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);

-- Step 5: Insert Sample Data
INSERT INTO Companies (Name, Industry, Country, StockSymbol) VALUES
('Tesla Inc.', 'Automobile', 'USA', 'TSLA'),
('Reliance Industries', 'Conglomerate', 'India', 'RELIANCE'),
('Amazon', 'E-commerce', 'USA', 'AMZN');

INSERT INTO Financials (CompanyID, Year, Revenue, Expenses) VALUES
(1, 2024, 1000000, 600000),
(2, 2024, 500000, 200000),
(3, 2024, 2000000, 1500000);

INSERT INTO StockPrices (CompanyID, Date, OpenPrice, ClosePrice, Volume) VALUES
(1, '2024-03-20', 950.00, 980.50, 500000),
(2, '2024-03-20', 2800.00, 2850.50, 300000),
(3, '2024-03-20', 3300.00, 3400.00, 400000);

INSERT INTO Transactions (CompanyID, TransactionType, Amount, Date) VALUES
(1, 'Investment', 5000000, '2024-03-10'),
(2, 'M&A', 12000000, '2024-02-25'),
(3, 'Investment', 8000000, '2024-01-15');

-- Step 6: Sample Queries

-- Get the top 3 most profitable companies
SELECT c.Name, f.NetProfit 
FROM Financials f 
JOIN Companies c ON f.CompanyID = c.CompanyID 
ORDER BY f.NetProfit DESC 
LIMIT 3;

-- Retrieve the stock performance of Tesla for the last 30 days
SELECT Date, OpenPrice, ClosePrice, Volume 
FROM StockPrices 
WHERE CompanyID = (SELECT CompanyID FROM Companies WHERE StockSymbol = 'TSLA') 
ORDER BY Date DESC 
LIMIT 30;

-- Total investment made by companies in 2024
SELECT SUM(Amount) AS TotalInvestment 
FROM Transactions 
WHERE TransactionType = 'Investment' AND YEAR(Date) = 2024;
