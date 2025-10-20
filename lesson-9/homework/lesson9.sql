-- ============================================
-- LESSON 9: JOINS (SQL SERVER)
-- ============================================

-- Drop old tables if exist
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Suppliers;
DROP TABLE IF EXISTS Customers;

-- ==========================
-- CREATE TABLES
-- ==========================

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    SupplierName NVARCHAR(50),
    City NVARCHAR(50)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(50),
    SupplierID INT,
    Price DECIMAL(10,2),
    StockQuantity INT
);

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
    City NVARCHAR(50)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    TotalAmount DECIMAL(10,2)
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    OrderID INT,
    Amount DECIMAL(10,2),
    PaymentDate DATE
);

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name NVARCHAR(50)
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName NVARCHAR(50)
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT
);

-- ==========================
-- INSERT SAMPLE DATA
-- ==========================

INSERT INTO Suppliers VALUES
(1, 'Fresh Foods', 'Tashkent'),
(2, 'Global Goods', 'Samarkand'),
(3, 'Nature''s Best', 'Bukhara');

INSERT INTO Products VALUES
(1, 'Apples', 1, 50, 100),
(2, 'Oranges', 1, 60, 80),
(3, 'Bananas', 2, 40, 150),
(4, 'Grapes', 3, 120, 60),
(5, 'Mangoes', 2, 200, 30);

INSERT INTO Departments VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'IT');

INSERT INTO Employees VALUES
(1, 'Alice', 1, 2000),
(2, 'Bob', 2, 2500),
(3, 'Charlie', 3, 3000),
(4, 'Diana', 1, 1800);

INSERT INTO Customers VALUES
(1, 'John', 'Doe', 'Tashkent'),
(2, 'Jane', 'Smith', 'Samarkand'),
(3, 'Mike', 'Brown', 'Bukhara');

INSERT INTO Orders VALUES
(1, 1, 1, 5, 250),
(2, 2, 3, 10, 400),
(3, 3, 4, 2, 240),
(4, 1, 5, 1, 200);

INSERT INTO Payments VALUES
(1, 1, 250, '2025-01-10'),
(2, 2, 400, '2025-01-11'),
(3, 3, 240, '2025-01-12');

INSERT INTO Students VALUES
(1, 'Tom'),
(2, 'Jerry'),
(3, 'Anna');

INSERT INTO Courses VALUES
(1, 'Math'),
(2, 'English'),
(3, 'Science');

INSERT INTO Enrollments VALUES
(1, 1, 1),
(2, 1, 3),
(3, 2, 2),
(4, 3, 1);

-- ============================================
-- EASY LEVEL (1–10)
-- ============================================

SELECT P.ProductName, S.SupplierName
FROM Products P
CROSS JOIN Suppliers S;

SELECT D.DepartmentName, E.Name AS EmployeeName
FROM Departments D
CROSS JOIN Employees E;

SELECT S.SupplierName, P.ProductName
FROM Products P
INNER JOIN Suppliers S ON P.SupplierID = S.SupplierID;

SELECT C.FirstName + ' ' + C.LastName AS CustomerName, O.OrderID
FROM Orders O
INNER JOIN Customers C ON O.CustomerID = C.CustomerID;

SELECT S.Name AS StudentName, C.CourseName
FROM Students S
CROSS JOIN Courses C;

SELECT P.ProductName, O.OrderID, O.Quantity, O.TotalAmount
FROM Orders O
INNER JOIN Products P ON O.ProductID = P.ProductID;

SELECT E.Name AS EmployeeName, D.DepartmentName
FROM Employees E
INNER JOIN Departments D ON E.DepartmentID = D.DepartmentID;

SELECT S.Name AS StudentName, E.CourseID
FROM Enrollments E
INNER JOIN Students S ON E.StudentID = S.StudentID;

SELECT O.OrderID, P.PaymentID, P.Amount, P.PaymentDate
FROM Payments P
INNER JOIN Orders O ON P.OrderID = O.OrderID;

SELECT O.OrderID, P.ProductName, P.Price, O.Quantity, O.TotalAmount
FROM Orders O
INNER JOIN Products P ON O.ProductID = P.ProductID
WHERE P.Price > 100;

-- ============================================
-- MEDIUM LEVEL (11–20)
-- ============================================

SELECT E.Name AS EmployeeName, D.DepartmentName, 
       E.DepartmentID AS EmployeeDept, D.DepartmentID AS DepartmentID
FROM Employees E
CROSS JOIN Departments D
WHERE E.DepartmentID <> D.DepartmentID;

SELECT O.OrderID, P.ProductName, O.Quantity, P.StockQuantity
FROM Orders O
INNER JOIN Products P ON O.ProductID = P.ProductID
WHERE O.Quantity > P.StockQuantity;

SELECT C.FirstName + ' ' + C.LastName AS CustomerName, P.ProductName
FROM Customers C
CROSS JOIN Products P;

SELECT E.Name, D.DepartmentName, E.Salary
FROM Employees E
INNER JOIN Departments D ON E.DepartmentID = D.DepartmentID
WHERE E.Salary > 2000;

SELECT O.OrderID, C.FirstName + ' ' + C.LastName AS CustomerName, 
       S.SupplierName, C.City
FROM Orders O
INNER JOIN Customers C ON O.CustomerID = C.CustomerID
INNER JOIN Products P ON O.ProductID = P.ProductID
INNER JOIN Suppliers S ON P.SupplierID = S.SupplierID
WHERE C.City = S.City;

SELECT C.CourseName, S.Name AS StudentName
FROM Enrollments E
INNER JOIN Students S ON E.StudentID = S.StudentID
INNER JOIN Courses C ON E.CourseID = C.CourseID;

SELECT O.OrderID, O.TotalAmount, P.Amount AS PaidAmount
FROM Orders O
INNER JOIN Payments P ON O.OrderID = P.OrderID
WHERE O.TotalAmount <> P.Amount;

SELECT E.Name, D.DepartmentName
FROM Employees E
INNER JOIN Departments D ON E.DepartmentID = D.DepartmentID
WHERE E.DepartmentID = (
    SELECT DepartmentID FROM Employees WHERE Name = 'Alice'
);

SELECT DISTINCT C.FirstName + ' ' + C.LastName AS CustomerName
FROM Orders O
INNER JOIN Customers C ON O.CustomerID = C.CustomerID
INNER JOIN Products P ON O.ProductID = P.ProductID
WHERE P.ProductName = 'Mangoes';

SELECT P.ProductName, S.SupplierName
FROM Products P
INNER JOIN Suppliers S ON P.SupplierID = S.SupplierID
WHERE S.SupplierName = 'Global Goods';

-- ============================================
-- HARD LEVEL (21–30)
-- ============================================

-- 21. Departments without employees
SELECT D.DepartmentName
FROM Departments D
LEFT JOIN Employees E ON D.DepartmentID = E.DepartmentID
WHERE E.EmployeeID IS NULL;

-- 22. Products that have never been ordered
SELECT P.ProductName
FROM Products P
LEFT JOIN Orders O ON P.ProductID = O.ProductID
WHERE O.ProductID IS NULL;

-- 23. Customers who never made an order
SELECT C.FirstName + ' ' + C.LastName AS CustomerName
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE O.CustomerID IS NULL;

-- 24. Employees with salary higher than the average
SELECT E.Name, E.Salary
FROM Employees E
WHERE E.Salary > (SELECT AVG(Salary) FROM Employees);

-- 25. Students not enrolled in any course
SELECT S.Name
FROM Students S
LEFT JOIN Enrollments E ON S.StudentID = E.StudentID
WHERE E.StudentID IS NULL;

-- 26. List all suppliers and how many products they supply
SELECT S.SupplierName, COUNT(P.ProductID) AS ProductCount
FROM Suppliers S
LEFT JOIN Products P ON S.SupplierID = P.SupplierID
GROUP BY S.SupplierName;

-- 27. Customers with total order amount over 300
SELECT C.FirstName + ' ' + C.LastName AS CustomerName, SUM(O.TotalAmount) AS TotalSpent
FROM Customers C
INNER JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.FirstName, C.LastName
HAVING SUM(O.TotalAmount) > 300;

-- 28. List each department and total salary of its employees
SELECT D.DepartmentName, SUM(E.Salary) AS TotalDeptSalary
FROM Departments D
LEFT JOIN Employees E ON D.DepartmentID = E.DepartmentID
GROUP BY D.DepartmentName;

-- 29. Show students enrolled in more than one course
SELECT S.Name, COUNT(E.CourseID) AS CourseCount
FROM Students S
INNER JOIN Enrollments E ON S.StudentID = E.StudentID
GROUP BY S.Name
HAVING COUNT(E.CourseID) > 1;

-- 30. List all products with supplier name and total order quantity
SELECT P.ProductName, S.SupplierName, 
       ISNULL(SUM(O.Quantity), 0) AS TotalOrdered
FROM Products P
LEFT JOIN Suppliers S ON P.SupplierID = S.SupplierID
LEFT JOIN Orders O ON P.ProductID = O.ProductID
GROUP BY P.ProductName, S.SupplierName;
