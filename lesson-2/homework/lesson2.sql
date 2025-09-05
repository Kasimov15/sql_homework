-------------------HOMEWORK-------LESSON 2---------------------------------------
USE Lesson2


-------------------------------------------------
-- BASIC LEVEL TASKS (10)
-------------------------------------------------

-- 1. Create Employees table
CREATE TABLE Employees (EmpID INT, Name VARCHAR(50), Salary DECIMAL(10,2))

-- 2. Insert three records (different approaches)
-- Single-row inserts
INSERT INTO Employees (EmpID, Name, Salary)
VALUES (1, 'Michael', 5000.00);

INSERT INTO Employees (EmpID, Name, Salary)
VALUES (2, 'Isagi', 4000.00);

-- Multi-row insert
INSERT INTO Employees (EmpID, Name, Salary)
VALUES 
    (3, 'Tobi', 6000.00),
    (4, 'Itama', 8000.00);

-- 3. Update Salary where EmpID = 1
UPDATE Employees
SET Salary = 7000
WHERE EmpID = 1;

-- 4. Delete record where EmpID = 2
DELETE FROM Employees
WHERE EmpID = 2;

-- 5. Demonstrate DELETE / TRUNCATE / DROP
CREATE TABLE TestTable (
    ID INT,
    Name VARCHAR(50)
);

INSERT INTO TestTable VALUES (1, 'Alice'), (2, 'Bob'), (3, 'Charlie');

-- DELETE → removes specific row(s)
DELETE FROM TestTable WHERE ID = 2;
SELECT * FROM TestTable;

-- TRUNCATE → removes all rows (structure remains)
TRUNCATE TABLE TestTable;
SELECT * FROM TestTable;

-- DROP → removes the table completely
DROP TABLE TestTable;

-- 5(b). Definitions:
-- DELETE   = removes rows (can use WHERE), structure stays
-- TRUNCATE = removes ALL rows, resets identity, no WHERE
-- DROP     = removes table structure + data completely

-- 6. Modify Name column to VARCHAR(100)
ALTER TABLE Employees
ALTER COLUMN Name VARCHAR(100);

-- 7. Add Department column
ALTER TABLE Employees
ADD Department VARCHAR(50);

-- 8. Change Salary column to FLOAT
ALTER TABLE Employees
ALTER COLUMN Salary FLOAT;

-------------------------------------------------
-- INTERMEDIATE LEVEL TASKS (6)
-------------------------------------------------

-- 11. Insert five records into Departments using INSERT INTO SELECT
IF OBJECT_ID('Departments', 'U') IS NOT NULL
    DROP TABLE Departments;

CREATE TABLE Departments (
    DeptID INT,
    DeptName VARCHAR(50)
);

INSERT INTO Departments (DeptID, DeptName)
SELECT 1, 'HR' UNION
SELECT 2, 'Finance' UNION
SELECT 3, 'IT' UNION
SELECT 4, 'Marketing' UNION
SELECT 5, 'Management';

-- 12. Update Department where Salary > 5000
UPDATE Employees
SET Department = 'Management'
WHERE Salary > 5000;

-- 13. Remove all employees but keep structure
DELETE FROM Employees;

-- 14. Drop Department column
ALTER TABLE Employees
DROP COLUMN Department;

-------------------------------------------------
-- ADVANCED LEVEL TASKS
-------------------------------------------------

-- Create Products table for demo
IF OBJECT_ID('Products', 'U') IS NOT NULL
    DROP TABLE Products;

CREATE TABLE Products (
    ProductID INT,
    ProductName VARCHAR(50),
    Price DECIMAL(10,2)
);

INSERT INTO Products VALUES
(1, 'Book', 10.99),
(2, 'Pen', 1.25),
(3, 'Laptop', 950.50);

-- 22. Use SELECT INTO to create backup table
SELECT *
INTO Products_Backup
FROM Products;

-- 23. Rename Products to Inventory
EXEC sp_rename 'Lesson2.dbo.Employees.Products', 'Inventory';

-- 24. Alter Inventory.Price to FLOAT
ALTER TABLE Inventory
ALTER COLUMN Price FLOAT;

-- 25. Add IDENTITY column ProductCode (1000, +5)
ALTER TABLE Inventory
ADD ProductCode INT IDENTITY(1000,5);
