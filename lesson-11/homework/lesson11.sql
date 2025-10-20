-- ============================================
-- LESSON 11: SUBQUERIES AND EXISTS (SQL SERVER)
-- ============================================

DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;

-- ==========================
-- CREATE TABLES
-- ==========================

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(50)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name NVARCHAR(50),
    DepartmentID INT,
    Salary DECIMAL(10,2)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Country NVARCHAR(50)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2)
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    OrderID INT,
    Amount DECIMAL(10,2),
    PaymentDate DATE
);

-- ==========================
-- INSERT DATA
-- ==========================

INSERT INTO Departments VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'Sales'),
(4, 'IT');

INSERT INTO Employees VALUES
(1, 'Alice', 1, 2000),
(2, 'Bob', 2, 2500),
(3, 'Charlie', 3, 3000),
(4, 'Diana', 3, 1500),
(5, 'Edward', 4, 4000);

INSERT INTO Customers VALUES
(1, 'John', 'Doe', 'USA'),
(2, 'Jane', 'Smith', 'UK'),
(3, 'Ali', 'Khan', 'UAE'),
(4, 'Maria', 'Lopez', 'USA');

INSERT INTO Products VALUES
(1, 'Laptop', 800, 15),
(2, 'Phone', 600, 30),
(3, 'Tablet', 400, 20),
(4, 'Headphones', 100, 50);

INSERT INTO Orders VALUES
(1, 1, 1, 1, '2023-01-10', 800),
(2, 2, 2, 2, '2023-02-12', 1200),
(3, 3, 3, 3, '2024-03-15', 1200),
(4, 4, 4, 4, '2025-04-20', 400),
(5, 1, 2, 1, '2025-05-10', 600);

INSERT INTO Payments VALUES
(1, 1, 800, '2023-01-11'),
(2, 2, 1200, '2023-02-13'),
(3, 3, 1000, '2024-03-17'),
(4, 4, 400, '2025-04-22');

-- ============================================
-- EASY LEVEL (1–7)
-- ============================================

SELECT Name, Salary
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);

SELECT ProductName, Price
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);

SELECT FirstName + ' ' + LastName AS CustomerName
FROM Customers
WHERE CustomerID IN (SELECT DISTINCT CustomerID FROM Orders);

SELECT ProductName
FROM Products
WHERE ProductID NOT IN (SELECT DISTINCT ProductID FROM Orders);

SELECT Name
FROM Employees
WHERE DepartmentID = (SELECT DepartmentID FROM Departments WHERE DepartmentName = 'Sales');

SELECT FirstName, LastName
FROM Customers
WHERE Country = (SELECT Country FROM Customers WHERE FirstName = 'John');

SELECT ProductName, Price
FROM Products
WHERE Price = (SELECT MAX(Price) FROM Products);

-- ============================================
-- MEDIUM LEVEL (8–14)
-- ============================================

SELECT FirstName + ' ' + LastName AS CustomerName, TotalAmount
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
WHERE TotalAmount > (SELECT AVG(TotalAmount) FROM Orders);

SELECT Name, Salary
FROM Employees E
WHERE Salary > ALL (SELECT Salary FROM Employees WHERE DepartmentID = 2);

SELECT ProductName, Price
FROM Products
WHERE EXISTS (
    SELECT 1 FROM Orders O
    WHERE O.ProductID = Products.ProductID
    AND O.Quantity > 2
);

SELECT FirstName + ' ' + LastName AS CustomerName
FROM Customers C
WHERE EXISTS (
    SELECT 1 FROM Orders O
    WHERE O.CustomerID = C.CustomerID
    AND YEAR(O.OrderDate) = 2025
);

SELECT DepartmentName
FROM Departments D
WHERE EXISTS (
    SELECT 1 FROM Employees E
    WHERE E.DepartmentID = D.DepartmentID
    AND E.Salary > 2500
);

SELECT ProductName
FROM Products
WHERE Price < ANY (SELECT Price FROM Products WHERE Stock > 20);

-- ============================================
-- HARD LEVEL (15–21)
-- ============================================

SELECT FirstName + ' ' + LastName AS CustomerName
FROM Customers C
WHERE NOT EXISTS (
    SELECT 1 FROM Orders O
    WHERE O.CustomerID = C.CustomerID
);

SELECT DepartmentName
FROM Departments D
WHERE DepartmentID IN (
    SELECT DepartmentID FROM Employees
    GROUP BY DepartmentID
    HAVING AVG(Salary) > 2500
);

SELECT Name, Salary
FROM Employees
WHERE Salary > (
    SELECT MAX(Salary) FROM Employees WHERE DepartmentID = 1
);

SELECT FirstName + ' ' + LastName AS CustomerName
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID FROM Orders
    WHERE TotalAmount > (
        SELECT AVG(TotalAmount) FROM Orders
    )
);

SELECT ProductName
FROM Products P
WHERE NOT EXISTS (
    SELECT 1 FROM Orders O
    WHERE O.ProductID = P.ProductID
    AND O.Quantity > 1
);

SELECT Name, DepartmentID
FROM Employees
WHERE EXISTS (
    SELECT 1 FROM Departments D
    WHERE D.DepartmentID = Employees.DepartmentID
    AND D.DepartmentName IN ('Sales', 'IT')
);

SELECT DepartmentName
FROM Departments
WHERE DepartmentID IN (
    SELECT DepartmentID
    FROM Employees
    WHERE Salary = (SELECT MAX(Salary) FROM Employees)
);
