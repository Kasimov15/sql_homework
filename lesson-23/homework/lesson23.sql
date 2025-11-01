/* ================================
   LESSON 23 – SQL PUZZLE QUESTIONS
   ================================ */

-----------------------------------
-- Puzzle 1: Extract Month (with zero)
-----------------------------------
CREATE TABLE Dates (
    Id INT,
    Dt DATETIME
);
INSERT INTO Dates VALUES
(1,'2018-04-06 11:06:43.020'),
(2,'2017-12-06 11:06:43.020'),
(3,'2016-01-06 11:06:43.020'),
(4,'2015-11-06 11:06:43.020'),
(5,'2014-10-06 11:06:43.020');

SELECT 
    Id,
    Dt,
    RIGHT('0' + CAST(MONTH(Dt) AS VARCHAR(2)), 2) AS MonthPrefixedWithZero
FROM Dates;

-----------------------------------
-- Puzzle 2: SUM of Max(Vals) per Id/rID
-----------------------------------
CREATE TABLE MyTabel (
    Id INT,
    rID INT,
    Vals INT
);
INSERT INTO MyTabel VALUES
(121, 9, 1), (121, 9, 8),
(122, 9, 14), (122, 9, 0), (122, 9, 1),
(123, 9, 1), (123, 9, 2), (123, 9, 10);

SELECT 
    COUNT(DISTINCT Id) AS Distinct_Ids,
    rID,
    SUM(MaxVals) AS TotalOfMaxVals
FROM (
    SELECT Id, rID, MAX(Vals) AS MaxVals
    FROM MyTabel
    GROUP BY Id, rID
) AS X
GROUP BY rID;

-----------------------------------
-- Puzzle 3: String Length Filter (6–10 chars)
-----------------------------------
CREATE TABLE TestFixLengths (
    Id INT,
    Vals VARCHAR(100)
);
INSERT INTO TestFixLengths VALUES
(1,'11111111'), (2,'123456'), (2,'1234567'), 
(2,'1234567890'), (5,''), (6,NULL), 
(7,'123456789012345');

SELECT *
FROM TestFixLengths
WHERE LEN(Vals) BETWEEN 6 AND 10;

-----------------------------------
-- Puzzle 4: Max Value and Item per Id
-----------------------------------
CREATE TABLE TestMaximum (
    ID INT,
    Item VARCHAR(20),
    Vals INT
);
INSERT INTO TestMaximum VALUES
(1, 'a1',15), (1, 'a2',20), (1, 'a3',90),
(2, 'q1',10), (2, 'q2',40), (2, 'q3',60), (2, 'q4',30),
(3, 'q5',20);

SELECT t.ID, t.Item, t.Vals
FROM TestMaximum t
JOIN (
    SELECT ID, MAX(Vals) AS MaxVal
    FROM TestMaximum
    GROUP BY ID
) m ON t.ID = m.ID AND t.Vals = m.MaxVal;

-----------------------------------
-- Puzzle 5: Sum of Max per DetailedNumber
-----------------------------------
CREATE TABLE SumOfMax (
    DetailedNumber INT,
    Vals INT,
    Id INT
);
INSERT INTO SumOfMax VALUES
(1,5,101), (1,4,101), (2,6,101), (2,3,101),
(3,3,102), (4,2,102), (4,3,102);

SELECT Id, SUM(MaxVals) AS SumOfMax
FROM (
    SELECT Id, DetailedNumber, MAX(Vals) AS MaxVals
    FROM SumOfMax
    GROUP BY Id, DetailedNumber
) AS X
GROUP BY Id;

-----------------------------------
-- Puzzle 6: Difference a - b (replace zero with blank)
-----------------------------------
CREATE TABLE TheZeroPuzzle (
    Id INT,
    a INT,
    b INT
);
INSERT INTO TheZeroPuzzle VALUES
(1,10,4), (2,10,10), (3,1,10000000), (4,15,15);

SELECT 
    Id, a, b,
    CASE 
        WHEN a - b = 0 THEN ''
        ELSE CAST(a - b AS VARCHAR(20))
    END AS OUTPUT
FROM TheZeroPuzzle;

-----------------------------------
-- CUSTOMERS TABLE
-----------------------------------
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Region VARCHAR(50),
    JoinDate DATE
);

INSERT INTO Customers (CustomerName, Region, JoinDate)
VALUES
('John Doe', 'North', '2022-03-01'),
('Jane Smith', 'West', '2023-06-15'),
('Emily Davis', 'East', '2021-11-20'),
('Michael Brown', 'South', '2023-01-10'),
('Sarah Wilson', 'North', '2022-07-25'),
('David Martinez', 'East', '2023-04-30'),
('Laura Johnson', 'West', '2022-09-14'),
('Kevin Anderson', 'South', '2021-12-05'),
('Sophia Moore', 'North', '2023-02-17'),
('Daniel Garcia', 'East', '2022-08-22');

-----------------------------------
-- SALES TABLE
-----------------------------------
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    Product VARCHAR(50),
    Category VARCHAR(50),
    QuantitySold INT,
    UnitPrice DECIMAL(10,2),
    SaleDate DATE,
    Region VARCHAR(50),
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Sales (Product, Category, QuantitySold, UnitPrice, SaleDate, Region, CustomerID)
VALUES
('Laptop', 'Electronics', 10, 800.00, '2024-01-01', 'North', 1),
('Smartphone', 'Electronics', 15, 500.00, '2024-01-02', 'North', 2),
('Tablet', 'Electronics', 8, 300.00, '2024-01-03', 'East', 3),
('Headphones', 'Electronics', 25, 100.00, '2024-01-04', 'West', 4),
('TV', 'Electronics', 5, 1200.00, '2024-01-05', 'South', 5),
('Refrigerator', 'Appliances', 3, 1500.00, '2024-01-06', 'South', 6),
('Microwave', 'Appliances', 7, 200.00, '2024-01-07', 'East', 7),
('Washing Machine', 'Appliances', 4, 1000.00, '2024-01-08', 'North', 8),
('Oven', 'Appliances', 6, 700.00, '2024-01-09', 'West', 9),
('Smartwatch', 'Electronics', 12, 250.00, '2024-01-10', 'East', 10),
('Vacuum Cleaner', 'Appliances', 5, 400.00, '2024-01-11', 'South', 1),
('Gaming Console', 'Electronics', 9, 450.00, '2024-01-12', 'North', 2),
('Monitor', 'Electronics', 14, 300.00, '2024-01-13', 'West', 3),
('Keyboard', 'Electronics', 20, 50.00, '2024-01-14', 'South', 4),
('Mouse', 'Electronics', 30, 25.00, '2024-01-15', 'East', 5),
('Blender', 'Appliances', 10, 150.00, '2024-01-16', 'North', 6),
('Fan', 'Appliances', 12, 75.00, '2024-01-17', 'South', 7),
('Heater', 'Appliances', 8, 120.00, '2024-01-18', 'East', 8),
('Air Conditioner', 'Appliances', 2, 2000.00, '2024-01-19', 'West', 9),
('Camera', 'Electronics', 7, 900.00, '2024-01-20', 'North', 10);

-----------------------------------
-- SALES QUERIES
-----------------------------------
-- 1. Total revenue
SELECT SUM(QuantitySold * UnitPrice) AS TotalRevenue FROM Sales;

-- 2. Average unit price
SELECT AVG(UnitPrice) AS AverageUnitPrice FROM Sales;

-- 3. Count sales transactions
SELECT COUNT(*) AS TotalTransactions FROM Sales;

-- 4. Highest units sold
SELECT MAX(QuantitySold) AS HighestUnitsSold FROM Sales;

-- 5. Products sold per category
SELECT Category, COUNT(*) AS ProductsSold
FROM Sales
GROUP BY Category;

-- 6. Total revenue per region
SELECT Region, SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY Region;

-- 7. Product with highest total revenue
SELECT TOP 1 Product, SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY Product
ORDER BY TotalRevenue DESC;

-- 8. Running total of revenue by SaleDate
SELECT 
    SaleDate,
    SUM(QuantitySold * UnitPrice) AS DailyRevenue,
    SUM(SUM(QuantitySold * UnitPrice)) OVER (ORDER BY SaleDate) AS RunningTotal
FROM Sales
GROUP BY SaleDate
ORDER BY SaleDate;

-- 9. Category contribution to total sales
SELECT 
    Category,
    SUM(QuantitySold * UnitPrice) AS CategoryRevenue,
    ROUND(100.0 * SUM(QuantitySold * UnitPrice) / SUM(SUM(QuantitySold * UnitPrice)) OVER(), 2) AS PercentContribution
FROM Sales
GROUP BY Category;

-----------------------------------
-- CUSTOMER QUERIES
-----------------------------------
-- 1. Show all sales with customer names
SELECT s.SaleID, s.Product, s.QuantitySold, s.UnitPrice, c.CustomerName
FROM Sales s
JOIN Customers c ON s.CustomerID = c.CustomerID;

-- 2. Customers with no purchases
SELECT c.CustomerName
FROM Customers c
LEFT JOIN Sales s ON c.CustomerID = s.CustomerID
WHERE s.CustomerID IS NULL;

-- 3. Total revenue per customer
SELECT c.CustomerName, SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM Sales s
JOIN Customers c ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerName;

-- 4. Customer with highest revenue
SELECT TOP 1 c.CustomerName, SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM Sales s
JOIN Customers c ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerName
ORDER BY TotalRevenue DESC;

-- 5. Total sales per customer
SELECT c.CustomerName, COUNT(s.SaleID) AS TotalSales
FROM Customers c
LEFT JOIN Sales s ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerName;

-----------------------------------
-- PRODUCTS TABLE
-----------------------------------
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(50),
    Category VARCHAR(50),
    CostPrice DECIMAL(10,2),
    SellingPrice DECIMAL(10,2)
);

INSERT INTO Products (ProductName, Category, CostPrice, SellingPrice)
VALUES
('Laptop', 'Electronics', 600.00, 800.00),
('Smartphone', 'Electronics', 350.00, 500.00),
('Tablet', 'Electronics', 200.00, 300.00),
('Headphones', 'Electronics', 50.00, 100.00),
('TV', 'Electronics', 900.00, 1200.00),
('Refrigerator', 'Appliances', 1100.00, 1500.00),
('Microwave', 'Appliances', 120.00, 200.00),
('Washing Machine', 'Appliances', 700.00, 1000.00),
('Oven', 'Appliances', 500.00, 700.00),
('Gaming Console', 'Electronics', 320.00, 450.00);

-----------------------------------
-- PRODUCT QUERIES
-----------------------------------
-- 1. Products sold at least once
SELECT DISTINCT p.ProductName
FROM Products p
JOIN Sales s ON p.ProductName = s.Product;

-- 2. Most expensive product
SELECT TOP 1 ProductName, SellingPrice
FROM Products
ORDER BY SellingPrice DESC;

-- 3. Products above average selling price per category
SELECT *
FROM Products p
WHERE SellingPrice > (
    SELECT AVG(SellingPrice)
    FROM Products
    WHERE Category = p.Category
);
