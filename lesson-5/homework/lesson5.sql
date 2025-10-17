------------------------------------------------------------
-- LESSON 5: Aliases, UNION, Conditional Columns, IF, WHILE
------------------------------------------------------------

-- 1. CREATE TABLES
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
(5, 'Keyboard', 50.00, 'Accessories', 100);

CREATE TABLE Products_Discounted (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2),
    Category VARCHAR(50),
    StockQuantity INT
);

INSERT INTO Products_Discounted VALUES
(1, 'Gaming Laptop', 950.00, 'Electronics', 25),
(2, 'Smartphone', 750.00, 'Electronics', 45),
(3, 'Convertible Tablet', 350.00, 'Electronics', 35),
(4, 'Ultra-Wide Monitor', 220.00, 'Electronics', 55),
(5, 'Mechanical Keyboard', 45.00, 'Accessories', 90);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Country VARCHAR(50)
);

INSERT INTO Customers VALUES
(1, 'John', 'Doe', 'USA'),
(2, 'Alice', 'Brown', 'Canada'),
(3, 'Tom', 'Lee', 'Japan'),
(4, 'Liam', 'Smith', 'UK'),
(5, 'Sara', 'White', 'Australia');

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    CustomerID INT,
    SaleAmount DECIMAL(10, 2)
);

INSERT INTO Sales VALUES
(1, 1, 550.00),
(2, 2, 300.00),
(3, 3, 120.00),
(4, 4, 700.00),
(5, 5, 200.00);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    Quantity INT
);

INSERT INTO Orders VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 4),
(4, 4, 2),
(5, 5, 5);


------------------------------------------------------------
-- EASY LEVEL TASKS
------------------------------------------------------------

-- 1. Rename ProductName as Name
SELECT ProductName AS Name FROM Products;

-- 2. Alias Customers as Client
SELECT * FROM Customers AS Client;

-- 3. UNION: ProductName from both tables
SELECT ProductName FROM Products
UNION
SELECT ProductName FROM Products_Discounted;

-- 4. INTERSECT: common products in both tables
SELECT ProductName FROM Products
INTERSECT
SELECT ProductName FROM Products_Discounted;

-- 5. DISTINCT: customer names + country
SELECT DISTINCT FirstName, Country FROM Customers;

-- 6. CASE: High if Price > 1000, Low otherwise
SELECT ProductName,
       Price,
       CASE 
           WHEN Price > 1000 THEN 'High'
           ELSE 'Low'
       END AS PriceLevel
FROM Products;

-- 7. IIF: Yes if StockQuantity > 100, No otherwise
SELECT ProductName,
       StockQuantity,
       IIF(StockQuantity > 100, 'Yes', 'No') AS InStock
FROM Products_Discounted;


------------------------------------------------------------
-- MEDIUM LEVEL TASKS
------------------------------------------------------------

-- 8. UNION: again for practice
SELECT ProductName FROM Products
UNION
SELECT ProductName FROM Products_Discounted;

-- 9. EXCEPT: products that are not discounted
SELECT ProductName FROM Products
EXCEPT
SELECT ProductName FROM Products_Discounted;

-- 10. IIF: Expensive or Affordable
SELECT ProductName,
       Price,
       IIF(Price > 1000, 'Expensive', 'Affordable') AS PriceCategory
FROM Products;

-- 11. Example filter: price < 400 or price > 600
SELECT ProductName, Price
FROM Products
WHERE Price < 400 OR Price > 600;

-- 12. CASE: Category based on price
SELECT ProductName,
       Price,
       CASE
           WHEN Price < 300 THEN 'Low'
           WHEN Price BETWEEN 300 AND 1000 THEN 'Medium'
           ELSE 'High'
       END AS PriceGroup
FROM Products;


------------------------------------------------------------
-- HARD LEVEL TASKS (IF / WHILE examples)
------------------------------------------------------------

-- 13. IF: Simple conditional block
DECLARE @TotalProducts INT;
SELECT @TotalProducts = COUNT(*) FROM Products;

IF @TotalProducts > 3
    PRINT 'There are more than 3 products';
ELSE
    PRINT 'There are 3 or fewer products';

-- 14. IF with variable and calculation
DECLARE @AvgPrice DECIMAL(10,2);
SELECT @AvgPrice = AVG(Price) FROM Products;

IF @AvgPrice > 500
    PRINT 'Average price is above 500';
ELSE
    PRINT 'Average price is 500 or below';

-- 15. WHILE loop: simple counter
DECLARE @Counter INT = 1;

WHILE @Counter <= 5
BEGIN
    PRINT CONCAT('Iteration number: ', @Counter);
    SET @Counter = @Counter + 1;
END;
