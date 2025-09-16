-- ==============================
-- Lesson-8 Practice Full Script
-- ==============================

-- DROP old tables if rerun
DROP TABLE IF EXISTS Sales, Orders, Invoices, Products_Discounted, Customers, Products, city_population;

-- =====================
-- CREATE TABLES + DATA
-- =====================

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2),
    Category VARCHAR(50),
    StockQuantity INT
);

INSERT INTO Products VALUES
(1, 'Laptop', 1200.00, 'Electronics', 30),
(2, 'Smartphone', 800.00, 'Electronics', 50),
(3, 'Tablet', 400.00, 'Electronics', 40),
(4, 'Monitor', 250.00, 'Electronics', 60),
(5, 'Keyboard', 50.00, 'Accessories', 100),
(6, 'Mouse', 30.00, 'Accessories', 120),
(7, 'Chair', 150.00, 'Furniture', 80),
(8, 'Desk', 200.00, 'Furniture', 75),
(9, 'Pen', 5.00, 'Stationery', 300),
(10, 'Notebook', 10.00, 'Stationery', 500),
(11, 'Printer', 180.00, 'Electronics', 25),
(12, 'Camera', 500.00, 'Electronics', 40),
(13, 'Flashlight', 25.00, 'Tools', 200),
(14, 'Shirt', 30.00, 'Clothing', 150),
(15, 'Jeans', 45.00, 'Clothing', 120),
(16, 'Jacket', 80.00, 'Clothing', 70),
(17, 'Shoes', 60.00, 'Clothing', 100),
(18, 'Hat', 20.00, 'Accessories', 50),
(19, 'Socks', 10.00, 'Clothing', 200),
(20, 'T-Shirt', 25.00, 'Clothing', 150),
(21, 'Lamp', 60.00, 'Furniture', 40),
(22, 'Coffee Table', 100.00, 'Furniture', 35),
(23, 'Book', 15.00, 'Stationery', 250),
(24, 'Rug', 90.00, 'Furniture', 60),
(25, 'Cup', 5.00, 'Accessories', 500),
(26, 'Bag', 25.00, 'Accessories', 300),
(27, 'Couch', 450.00, 'Furniture', 15),
(28, 'Fridge', 600.00, 'Electronics', 20),
(29, 'Stove', 500.00, 'Electronics', 15),
(30, 'Microwave', 120.00, 'Electronics', 25),
(31, 'Air Conditioner', 350.00, 'Electronics', 10),
(32, 'Washing Machine', 450.00, 'Electronics', 15),
(33, 'Dryer', 400.00, 'Electronics', 10),
(34, 'Hair Dryer', 30.00, 'Accessories', 100),
(35, 'Iron', 40.00, 'Electronics', 50),
(36, 'Coffee Maker', 50.00, 'Electronics', 60),
(37, 'Blender', 35.00, 'Electronics', 40),
(38, 'Juicer', 55.00, 'Electronics', 30),
(39, 'Toaster', 40.00, 'Electronics', 70),
(40, 'Dishwasher', 500.00, 'Electronics', 20);

-- (Customers, Products_Discounted, Sales, Orders, Invoices, city_population inserts go here — omitted for brevity since you already pasted full data.)

-- =====================
-- EASY LEVEL QUERIES
-- =====================

-- 1. Total products in each category
SELECT Category, COUNT(*) AS TotalProducts
FROM Products
GROUP BY Category;

-- 2. Avg price in Electronics
SELECT AVG(Price) AS AvgPriceElectronics
FROM Products
WHERE Category = 'Electronics';

-- 3. Customers from cities starting with 'L'
SELECT *
FROM Customers
WHERE City LIKE 'L%';

-- 4. Product names ending with 'er'
SELECT ProductName
FROM Products
WHERE ProductName LIKE '%er';

-- 5. Customers from countries ending with 'A'
SELECT *
FROM Customers
WHERE Country LIKE '%A';

-- 6. Highest price among all products
SELECT MAX(Price) AS HighestPrice
FROM Products;

-- 7. Label stock
SELECT ProductName,
       CASE WHEN StockQuantity < 30 THEN 'Low Stock'
            ELSE 'Sufficient' END AS StockStatus
FROM Products;

-- 8. Total customers in each country
SELECT Country, COUNT(*) AS TotalCustomers
FROM Customers
GROUP BY Country;

-- 9. Min and Max order quantity
SELECT MIN(Quantity) AS MinQty, MAX(Quantity) AS MaxQty
FROM Orders;

-- =====================
-- MEDIUM LEVEL QUERIES
-- =====================

-- 10. Customers with orders in Jan 2023 but no invoices
SELECT DISTINCT o.CustomerID
FROM Orders o
WHERE YEAR(o.OrderDate) = 2023 AND MONTH(o.OrderDate) = 1
AND o.CustomerID NOT IN (
    SELECT CustomerID FROM Invoices
    WHERE YEAR(InvoiceDate) = 2023 AND MONTH(InvoiceDate) = 1
);

-- 11. Union all product names (with duplicates)
SELECT ProductName FROM Products
UNION ALL
SELECT ProductName FROM Products_Discounted;

-- 12. Union product names (no duplicates)
SELECT ProductName FROM Products
UNION
SELECT ProductName FROM Products_Discounted;

-- 13. Avg order amount by year
SELECT YEAR(OrderDate) AS OrderYear, AVG(TotalAmount) AS AvgAmount
FROM Orders
GROUP BY YEAR(OrderDate);

-- 14. Group products by price
SELECT ProductName,
       CASE WHEN Price < 100 THEN 'Low'
            WHEN Price BETWEEN 100 AND 500 THEN 'Mid'
            ELSE 'High' END AS PriceGroup
FROM Products;

-- 15. Pivot years -> new table
SELECT district_name, [2012], [2013]
INTO Population_Each_Year
FROM (SELECT district_name, population, year FROM city_population) src
PIVOT (SUM(population) FOR year IN ([2012],[2013])) p;

-- 16. Total sales per product
SELECT ProductID, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY ProductID;

-- 17. Products containing 'oo'
SELECT ProductName
FROM Products
WHERE ProductName LIKE '%oo%';

-- 18. Pivot cities -> new table
SELECT year, [Bektemir], [Chilonzor], [Yakkasaroy]
INTO Population_Each_City
FROM (SELECT year, district_name, population FROM city_population) src
PIVOT (SUM(population) FOR district_name IN ([Bektemir],[Chilonzor],[Yakkasaroy])) p;

-- =====================
-- HARD LEVEL QUERIES
-- =====================

-- 19. Top 3 customers by invoice amount
SELECT TOP 3 CustomerID, SUM(TotalAmount) AS TotalSpent
FROM Invoices
GROUP BY CustomerID
ORDER BY TotalSpent DESC;

-- 20. Transform Population_Each_Year back
SELECT district_name, '2012' AS Year, [2012] AS Population FROM Population_Each_Year
UNION ALL
SELECT district_name, '2013', [2013] FROM Population_Each_Year;

-- 21. Product names + times sold
SELECT p.ProductName, COUNT(s.SaleID) AS TimesSold
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductName;

-- 22. Transform Population_Each_City back
SELECT 'Bektemir' AS City, year, [Bektemir] AS Population FROM Population_Each_City
UNION ALL
SELECT 'Chilonzor', year, [Chilonzor] FROM Population_Each_City
UNION ALL
SELECT 'Yakkasaroy', year, [Yakkasaroy] FROM Population_Each_City;
