-----------------------HOMEWORK---LESSON 3------------------------------------------------------------------------------------
USE Lesson2
-- EASY-LEVEL TASKS

-- 1. Define and explain the purpose of BULK INSERT in SQL Server.
-- BULK INSERT is used to quickly import large amounts of data from a file (such as CSV or TXT) into a SQL Server table. It is more efficient than using individual INSERT statements for each row.

-- 2. List four file formats that can be imported into SQL Server.
-- The four common file formats that can be imported into SQL Server are:
-- - CSV (Comma-Separated Values)
-- - TXT (Plain Text)
-- - XML (Extensible Markup Language)
-- - Excel (.xls, .xlsx)

-- 3. Create a table Products with columns: ProductID (INT, PRIMARY KEY), ProductName (VARCHAR(50)), Price (DECIMAL(10,2)).
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10, 2)
);

-- 4. Insert three records into the Products table using INSERT INTO.
INSERT INTO Products (ProductID, ProductName, Price)
VALUES 
    (1, 'Laptop', 799.99),
    (2, 'Smartphone', 499.99),
    (3, 'Headphones', 149.99);

-- 5. Explain the difference between NULL and NOT NULL.
-- NULL means that a value is missing, unknown, or not provided.
-- NOT NULL means that a value must be provided and the field cannot be empty.

-- 6. Add a UNIQUE constraint to the ProductName column in the Products table.
ALTER TABLE Products
ADD CONSTRAINT UC_ProductName UNIQUE (ProductName);

-- 7. Write a comment in a SQL query explaining its purpose.
-- This query selects all the records from the Products table
SELECT * FROM Products;  -- Selecting all products from the Products table

-- 8. Add CategoryID column to the Products table.
ALTER TABLE Products
ADD CategoryID INT;

-- 9. Create a table Categories with a CategoryID as PRIMARY KEY and a CategoryName as UNIQUE.
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) UNIQUE
);

-- 10. Explain the purpose of the IDENTITY column in SQL Server.
-- The IDENTITY column automatically generates unique sequential numbers for each row, typically used for primary key columns to ensure uniqueness.

-- MEDIUM-LEVEL TASKS



-- 12. Create a FOREIGN KEY in the Products table that references the Categories table.
ALTER TABLE Products
ADD CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID);

-- 13. Explain the differences between PRIMARY KEY and UNIQUE KEY.
-- PRIMARY KEY: Uniquely identifies each row in a table. A table can only have one PRIMARY KEY, and it cannot accept NULL values.
-- UNIQUE KEY: Ensures all values in the column are unique, but it can accept NULL values (a column can have multiple UNIQUE keys).

-- 14. Add a CHECK constraint to the Products table ensuring Price > 0.
ALTER TABLE Products
ADD CONSTRAINT CK_Price CHECK (Price > 0);

-- 15. Modify the Products table to add a column Stock (INT, NOT NULL).
ALTER TABLE Products
ADD Stock INT NOT NULL;

-- 16. Use the ISNULL function to replace NULL values in Price column with 0.
SELECT ProductName, ISNULL(Price, 0) AS Price FROM Products;

-- 17. Describe the purpose and usage of FOREIGN KEY constraints in SQL Server.
-- FOREIGN KEY constraints are used to ensure referential integrity between tables. They ensure that values in the child table match values in the parent table.

-- HARD-LEVEL TASKS

-- 18. Write a script to create a Customers table with a CHECK constraint ensuring Age >= 18.
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT CHECK (Age >= 18)
);


-- 20.
Write a query to create a composite PRIMARY KEY in a new table OrderDetails.
CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    PRIMARY KEY (OrderID, ProductID)
);


-- 22. Create a table Employees with both PRIMARY KEY on EmpID and UNIQUE KEY on Email.
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100) UNIQUE
);
