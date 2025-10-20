-- Lesson-16: CTEs and Derived Tables

CREATE TABLE Numbers1(Number INT)
INSERT INTO Numbers1 VALUES (5),(9),(8),(6),(7)

CREATE TABLE FindSameCharacters
(
     Id INT,
     Vals VARCHAR(10)
)
INSERT INTO FindSameCharacters VALUES
(1,'aa'),
(2,'cccc'),
(3,'abc'),
(4,'aabc'),
(5,NULL),
(6,'a'),
(7,'zzz'),
(8,'abc')

CREATE TABLE RemoveDuplicateIntsFromNames
(
      PawanName INT,
      Pawan_slug_name VARCHAR(1000)
)
INSERT INTO RemoveDuplicateIntsFromNames VALUES
(1,'PawanA-111'),
(2,'PawanB-123'),
(3,'PawanB-32'),
(4,'PawanC-4444'),
(5,'PawanD-3')

CREATE TABLE Example
(
Id INTEGER IDENTITY(1,1) PRIMARY KEY,
String VARCHAR(30) NOT NULL
)
INSERT INTO Example VALUES('123456789'),('abcdefghi')

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    DepartmentID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Salary DECIMAL(10, 2)
)
INSERT INTO Employees VALUES
(1,1,'John','Doe',60000.00),
(2,1,'Jane','Smith',65000.00),
(3,2,'James','Brown',70000.00),
(4,3,'Mary','Johnson',75000.00),
(5,4,'Linda','Williams',80000.00),
(6,2,'Michael','Jones',85000.00),
(7,1,'Robert','Miller',55000.00),
(8,3,'Patricia','Davis',72000.00),
(9,4,'Jennifer','García',77000.00),
(10,1,'William','Martínez',69000.00)

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
)
INSERT INTO Departments VALUES
(1,'HR'),
(2,'Sales'),
(3,'Marketing'),
(4,'Finance'),
(5,'IT'),
(6,'Operations'),
(7,'Customer Service'),
(8,'R&D'),
(9,'Legal'),
(10,'Logistics')

CREATE TABLE Sales (
    SalesID INT PRIMARY KEY,
    EmployeeID INT,
    ProductID INT,
    SalesAmount DECIMAL(10,2),
    SaleDate DATE
)
INSERT INTO Sales VALUES
(1,1,1,1550.00,'2025-01-02'),
(2,2,2,2050.00,'2025-01-04'),
(3,3,3,1250.00,'2025-01-06'),
(4,4,4,1850.00,'2025-01-08'),
(5,5,5,2250.00,'2025-01-10'),
(6,6,6,1450.00,'2025-01-12'),
(7,7,1,2550.00,'2025-01-14'),
(8,8,2,1750.00,'2025-01-16'),
(9,9,3,1650.00,'2025-01-18'),
(10,10,4,1950.00,'2025-01-20')

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    CategoryID INT,
    ProductName VARCHAR(100),
    Price DECIMAL(10,2)
)
INSERT INTO Products VALUES
(1,1,'Laptop',1000.00),
(2,1,'Smartphone',800.00),
(3,2,'Tablet',500.00),
(4,2,'Monitor',300.00),
(5,3,'Headphones',150.00),
(6,3,'Mouse',25.00),
(7,4,'Keyboard',50.00),
(8,4,'Speaker',200.00),
(9,5,'Smartwatch',250.00),
(10,5,'Camera',700.00)

-- Easy 1
WITH NumbersCTE AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n+1 FROM NumbersCTE WHERE n<1000
)
SELECT * FROM NumbersCTE

-- Easy 2
SELECT E.EmployeeID, E.FirstName, SUM(S.SalesAmount) AS TotalSales
FROM Employees E
JOIN Sales S ON E.EmployeeID = S.EmployeeID
GROUP BY E.EmployeeID, E.FirstName

-- Easy 3
WITH AvgSalary AS (
    SELECT AVG(Salary) AS AvgSal FROM Employees
)
SELECT * FROM AvgSalary

-- Easy 4
SELECT P.ProductID, P.ProductName, MAX(S.SalesAmount) AS MaxSale
FROM Products P
JOIN Sales S ON P.ProductID = S.ProductID
GROUP BY P.ProductID, P.ProductName

-- Easy 5
WITH DoubleCTE AS (
    SELECT 1 AS Num
    UNION ALL
    SELECT Num*2 FROM DoubleCTE WHERE Num*2<1000000
)
SELECT * FROM DoubleCTE

-- Easy 6
WITH SalesCount AS (
    SELECT EmployeeID, COUNT(*) AS SalesCount FROM Sales GROUP BY EmployeeID
)
SELECT E.FirstName, S.SalesCount
FROM Employees E
JOIN SalesCount S ON E.EmployeeID = S.EmployeeID
WHERE S.SalesCount>5

-- Easy 7
WITH ProductSales AS (
    SELECT P.ProductName, SUM(S.SalesAmount) AS TotalSales
    FROM Products P
    JOIN Sales S ON P.ProductID = S.ProductID
    GROUP BY P.ProductName
)
SELECT * FROM ProductSales WHERE TotalSales>500

-- Easy 8
WITH AvgCTE AS (SELECT AVG(Salary) AS AvgSal FROM Employees)
SELECT E.FirstName, E.LastName, E.Salary
FROM Employees E, AvgCTE
WHERE E.Salary>AvgCTE.AvgSal

-- Medium 1
SELECT TOP 5 E.FirstName, COUNT(S.SalesID) AS OrdersCount
FROM Employees E
JOIN Sales S ON E.EmployeeID = S.EmployeeID
GROUP BY E.FirstName
ORDER BY OrdersCount DESC

-- Medium 2
SELECT P.CategoryID, SUM(S.SalesAmount) AS TotalSales
FROM Products P
JOIN Sales S ON P.ProductID = S.ProductID
GROUP BY P.CategoryID

-- Medium 3
WITH FactorialCTE AS (
    SELECT Number, CAST(1 AS BIGINT) AS Factorial FROM Numbers1
    UNION ALL
    SELECT N.Number, F.Factorial*N.Number FROM Numbers1 N
    JOIN FactorialCTE F ON N.Number>F.Number
)
SELECT DISTINCT Number, MAX(Factorial) OVER(PARTITION BY Number) AS Factorial FROM FactorialCTE

-- Medium 4
WITH SplitCTE AS (
    SELECT Id, LEFT(String,1) AS Ch, RIGHT(String,LEN(String)-1) AS Rest FROM Example
    UNION ALL
    SELECT Id, LEFT(Rest,1), RIGHT(Rest,LEN(Rest)-1) FROM SplitCTE WHERE LEN(Rest)>0
)
SELECT * FROM SplitCTE

-- Medium 5
WITH MonthlySales AS (
    SELECT YEAR(SaleDate) AS Y, MONTH(SaleDate) AS M, SUM(SalesAmount) AS TotalSales
    FROM Sales GROUP BY YEAR(SaleDate), MONTH(SaleDate)
)
SELECT Y, M, TotalSales - LAG(TotalSales) OVER(ORDER BY Y,M) AS Diff
FROM MonthlySales

-- Medium 6
SELECT E.FirstName, SUM(S.SalesAmount) AS QuarterSales
FROM Employees E
JOIN Sales S ON E.EmployeeID = S.EmployeeID
GROUP BY E.FirstName, DATEPART(QUARTER, S.SaleDate)
HAVING SUM(S.SalesAmount)>45000

-- Difficult 1
WITH Fib (n, a, b) AS (
    SELECT 1, 0, 1
    UNION ALL
    SELECT n+1, b, a+b FROM Fib WHERE n<15
)
SELECT a AS Fibonacci FROM Fib

-- Difficult 2
SELECT * FROM FindSameCharacters
WHERE LEN(Vals)>1 AND LEN(Vals)=LEN(REPLACE(Vals,LEFT(Vals,1),''))+1

-- Difficult 3
WITH NumSeq AS (
    SELECT 1 AS n, CAST('1' AS VARCHAR(10)) AS Seq
    UNION ALL
    SELECT n+1, Seq + CAST(n+1 AS VARCHAR(10)) FROM NumSeq WHERE n<5
)
SELECT * FROM NumSeq

-- Difficult 4
WITH Last6Months AS (
    SELECT * FROM Sales WHERE DATEDIFF(MONTH,SaleDate,GETDATE())<=6
),
EmployeeSales AS (
    SELECT EmployeeID, SUM(SalesAmount) AS TotalSales FROM Last6Months GROUP BY EmployeeID
)
SELECT TOP 1 E.FirstName, ES.TotalSales
FROM Employees E
JOIN EmployeeSales ES ON E.EmployeeID = ES.EmployeeID
ORDER BY ES.TotalSales DESC

-- Difficult 5
SELECT DISTINCT
Pawan_slug_name,
(SELECT STRING_AGG(DISTINCT value,'')
 FROM STRING_SPLIT(Pawan_slug_name,'')
 WHERE value NOT LIKE '%[0-9]%') AS CleanString
FROM RemoveDuplicateIntsFromNames
