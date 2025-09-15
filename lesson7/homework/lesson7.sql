-- Easy-Level Tasks (10)

-- 1. Minimum price of a product in Products
SELECT MIN(Price) AS MinPrice FROM Products;

-- 2. Maximum Salary from Employees
SELECT MAX(Salary) AS MaxSalary FROM Employees;

-- 3. Count of rows in Customers
SELECT COUNT(*) AS TotalCustomers FROM Customers;

-- 4. Count unique product categories from Products
SELECT COUNT(DISTINCT Category) AS UniqueCategories FROM Products;

-- 5. Total sales amount for product with id 7 in Sales (Orders) table
SELECT SUM(TotalAmount) AS TotalSalesForProduct7 FROM Orders WHERE ProductID = 7;

-- 6. Average age of employees in Employees
SELECT AVG(CAST(Age AS FLOAT)) AS AvgAge FROM Employees;

-- 7. Count number of employees in each department
SELECT DepartmentName, COUNT(*) AS EmployeeCount FROM Employees GROUP BY DepartmentName;

-- 8. Min and max price of products grouped by Category
SELECT Category, MIN(Price) AS MinPrice, MAX(Price) AS MaxPrice FROM Products GROUP BY Category;

-- 9. Total sales per Customer in Sales (Orders)
SELECT CustomerID, SUM(TotalAmount) AS TotalSales FROM Orders GROUP BY CustomerID;

-- 10. Filter departments having more than 5 employees
SELECT DepartmentName, COUNT(*) AS EmployeeCount 
FROM Employees 
GROUP BY DepartmentName 
HAVING COUNT(*) > 5;

-- Medium-Level Tasks (9)

-- 11. Total sales and average sales for each product category
SELECT p.Category, SUM(o.TotalAmount) AS TotalSales, AVG(o.TotalAmount) AS AvgSales
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
GROUP BY p.Category;

-- 12. Count number of employees from Department HR
SELECT COUNT(*) AS HREmployeesCount FROM Employees WHERE DepartmentName = 'HR';

-- 13. Highest and lowest Salary by department
SELECT DepartmentName, MAX(Salary) AS MaxSalary, MIN(Salary) AS MinSalary
FROM Employees
GROUP BY DepartmentName;

-- 14. Average salary per Department
SELECT DepartmentName, AVG(Salary) AS AvgSalary FROM Employees GROUP BY DepartmentName;

-- 15. AVG salary and COUNT(*) of employees working in each department
SELECT DepartmentName, AVG(Salary) AS AvgSalary, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentName;

-- 16. Filter product categories with average price > 400
SELECT Category, AVG(Price) AS AvgPrice
FROM Products
GROUP BY Category
HAVING AVG(Price) > 400;

-- 17. Total sales for each year in Sales (Orders)
SELECT YEAR(OrderDate) AS SalesYear, SUM(TotalAmount) AS TotalSales
FROM Orders
GROUP BY YEAR(OrderDate);

-- 18. Customers who placed at least 3 orders
SELECT CustomerID, COUNT(*) AS OrderCount
FROM Orders
GROUP BY CustomerID
HAVING COUNT(*) >= 3;

-- 19. Filter departments with average salary expenses > 60000
SELECT DepartmentName, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DepartmentName
HAVING AVG(Salary) > 60000;

-- Hard-Level Tasks (6)

-- 20. Average price for each product category, filter categories with average price > 150
SELECT Category, AVG(Price) AS AvgPrice
FROM Products
GROUP BY Category
HAVING AVG(Price) > 150;

-- 21. Total sales for each Customer, filter Customers with total sales > 1500
SELECT CustomerID, SUM(TotalAmount) AS TotalSales
FROM Orders
GROUP BY CustomerID
HAVING SUM(TotalAmount) > 1500;

-- 22. Total and average salary of employees in each department, filter avg salary > 65000
SELECT DepartmentName, SUM(Salary) AS TotalSalary, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DepartmentName
HAVING AVG(Salary) > 65000;

-- 23. Total amount for orders with freight > 50 and least purchases per customer
-- Note: The given tables don’t have freight column. Skipping as requested or requires additional data.

-- 24. Total sales and count unique products sold each month of each year, filter months with at least 2 products sold
SELECT 
    YEAR(OrderDate) AS SalesYear,
    MONTH(OrderDate) AS SalesMonth,
    SUM(TotalAmount) AS TotalSales,
    COUNT(DISTINCT ProductID) AS UniqueProductsSold
FROM Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
HAVING COUNT(DISTINCT ProductID) >= 2;

-- 25. MIN and MAX order quantity per Year
SELECT 
    YEAR(OrderDate) AS OrderYear,
MAX(Quantity) AS MaxQuantity
FROM Orders
GROUP BY YEAR(OrderDate);
    MIN(Quantity) AS MinQuantity,
