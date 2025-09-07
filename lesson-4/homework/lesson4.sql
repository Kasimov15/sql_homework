-------------------------------------------------------
-- LESSON 4: Filtering and Ordering Data
-------------------------------------------------------

DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Products_Discounted;
DROP TABLE IF EXISTS Employees;

-------------------------------------------------------

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50) NULL,
    LastName VARCHAR(50) NULL,
    DepartmentName VARCHAR(50),
    Salary DECIMAL(10, 2),
    HireDate DATE,
    Age INT,
    Email VARCHAR(100) NULL,
    Country VARCHAR(50)
);

INSERT INTO Employees VALUES
(1, 'John', 'Doe', 'IT', 55000.00, '2020-01-01', 30, 'johndoe@example.com', 'USA'),
(2, 'Jane', 'Smith', 'HR', 65000.00, '2019-03-15', 28, 'janesmith@example.com', 'USA'),
(3, NULL, 'Johnson', 'Finance', 45000.00, '2021-05-10', 25, NULL, 'Canada'),
(4, 'James', 'Brown', 'Marketing', 60000.00, '2018-07-22', 35, 'jamesbrown@example.com', 'UK'),
(5, 'Patricia', NULL, 'HR', 70000.00, '2017-08-30', 40, NULL, 'USA'),
(6, 'Michael', 'Miller', 'IT', 75000.00, '2020-12-12', 27, 'michaelm@example.com', 'Germany'),
(7, 'Linda', NULL, 'Finance', 48000.00, '2016-11-02', 42, NULL, 'Canada'),
(8, 'David', 'Moore', 'Marketing', 85000.00, '2021-09-01', 29, 'davidm@example.com', 'UK'),
(9, 'Elizabeth', 'Taylor', 'HR', 60000.00, '2019-05-18', 31, 'elizabetht@example.com', 'USA'),
(10, 'William', NULL, 'IT', 64000.00, '2020-04-10', 26, NULL, 'Germany');


-------------------------------------------------------
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

-------------------------------------------------------
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(50),
    Address VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(100),
    PostalCode VARCHAR(20),
    Country VARCHAR(100)
);

INSERT INTO Customers VALUES
(1, 'John', 'Doe', 'johndoe@gmail.com', '555-1234', '123 Elm St', 'New York', 'NY', '10001', 'USA'),
(2, 'Jane', 'Smith', 'janesmith@yahoo.com', '555-2345', '456 Oak St', 'Los Angeles', 'CA', '90001', 'USA'),
(3, 'Alice', 'Johnson', 'alicej@outlook.com', '555-3456', '789 Pine St', 'Toronto', 'ON', 'M4B1B3', 'Canada');

-------------------------------------------------------
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    OrderDate DATE,
    Quantity INT,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Orders VALUES
(1, 1, 2, '2023-05-14', 1, 800.00),
(2, 2, 3, '2024-09-07', 2, 800.00),
(3, 3, 4, '2022-11-22', 1, 250.00);

-------------------------------------------------------
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    CustomerID INT,
    SaleDate DATE,
    SaleAmount DECIMAL(10, 2)
);

INSERT INTO Sales VALUES
(1, 1, 1, '2023-01-01', 150.00),
(2, 2, 2, '2023-01-02', 200.00),
(3, 3, 3, '2023-01-03', 250.00);

-------------------------------------------------------

--EASY----------------------------------------------------
--1----------------------------------------------------
SELECT TOP 5 * FROM Employees;
--2----------------------------------------------------
SELECT DISTINCT Category FROM Products;
--3----------------------------------------------------
SELECT * FROM Products WHERE Price > 100;
--4----------------------------------------------------
SELECT * FROM Customers WHERE FirstName LIKE 'A%';
--5----------------------------------------------------
SELECT * FROM Products ORDER BY Price ASC;
--6----------------------------------------------------
SELECT * FROM Employees WHERE Salary >= 60000 AND DepartmentName = 'HR';
--7----------------------------------------------------
SELECT EmployeeID, ISNULL(Email,'noemail@example.com') AS Email FROM Employees;
--8----------------------------------------------------
SELECT * FROM Products WHERE Price BETWEEN 50 AND 100;
--9----------------------------------------------------
SELECT DISTINCT Category, ProductName FROM Products;
--10----------------------------------------------------
SELECT DISTINCT Category, ProductName FROM Products ORDER BY ProductName DESC;

--MEDIUM----------------------------------------------------
--11----------------------------------------------------
SELECT TOP 10 * FROM Products ORDER BY Price DESC;
--12----------------------------------------------------
SELECT COALESCE(FirstName, LastName) AS Name FROM Employees;
--13----------------------------------------------------
SELECT DISTINCT Category, Price FROM Products;
--14----------------------------------------------------
SELECT * FROM Employees WHERE (Age BETWEEN 30 AND 40) OR DepartmentName = 'Marketing';
--15----------------------------------------------------
SELECT * FROM Employees ORDER BY Salary DESC OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;
--16----------------------------------------------------
SELECT * FROM Products WHERE Price <= 1000 AND StockQuantity > 50 ORDER BY StockQuantity ASC;
--17----------------------------------------------------
SELECT * FROM Products WHERE ProductName LIKE '%e%';
--18----------------------------------------------------
SELECT * FROM Employees WHERE DepartmentName IN ('HR','IT','Finance');
--19----------------------------------------------------
SELECT * FROM Customers ORDER BY City ASC, PostalCode DESC;

--HARD----------------------------------------------------
--20----------------------------------------------------
SELECT TOP 5 ProductID, SUM(SaleAmount) AS TotalSales
FROM Sales GROUP BY ProductID ORDER BY TotalSales DESC;
--21----------------------------------------------------
SELECT FirstName + ' ' + LastName AS FullName FROM Employees;
--22----------------------------------------------------
SELECT DISTINCT Category, ProductName, Price FROM Products WHERE Price > 50;
--23----------------------------------------------------
SELECT * FROM Products WHERE Price < 0.1 * (SELECT AVG(Price) FROM Products);
--24----------------------------------------------------
SELECT * FROM Employees WHERE Age < 30 AND DepartmentName IN ('HR','IT');
--25----------------------------------------------------
SELECT * FROM Customers WHERE Email LIKE '%@gmail.com%';
--26----------------------------------------------------
SELECT * FROM Employees WHERE Salary > ALL (SELECT Salary FROM Employees WHERE DepartmentName = 'Sales');
--27----------------------------------------------------
SELECT * FROM Orders
WHERE OrderDate BETWEEN DATEADD(DAY,-180,GETDATE()) AND GETDATE();
----------------------------------------------------END----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
