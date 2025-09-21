-- ================================================
-- Combined SQL script solving all tasks from 
-- lesson-10 homework (IslomovSH / SQL-homework)
-- ================================================

/* ===== EASY LEVEL ===== */

/* Task 1: Employees with salary > 50000, with department names */
SELECT e.Name AS EmployeeName,
       e.Salary,
       d.DepartmentName
FROM Employees e
JOIN Departments d
  ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > 50000;

/* Task 2: Customer names and order dates for orders placed in 2023 */
SELECT c.FirstName,
       c.LastName,
       o.OrderDate
FROM Customers c
JOIN Orders o
  ON c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) = 2023;

/* Task 3: All employees and their department names (include those without department) */
SELECT e.Name AS EmployeeName,
       d.DepartmentName
FROM Employees e
LEFT JOIN Departments d
  ON e.DepartmentID = d.DepartmentID;

/* Task 4: List all suppliers and the products they supply (suppliers with no products too) */
SELECT s.SupplierName,
       p.ProductName
FROM Suppliers s
LEFT JOIN Products p
  ON s.SupplierID = p.SupplierID;

/* Task 5: All orders and their payments; include orders w/o payments, and payments not linked to any order */
SELECT o.OrderID,
       o.OrderDate,
       p.PaymentDate,
       p.Amount
FROM Orders o
LEFT JOIN Payments p
  ON o.OrderID = p.OrderID
UNION
-- to include payments with no matching orders
SELECT p.OrderID,
       NULL AS OrderDate,
       p.PaymentDate,
       p.Amount
FROM Payments p
WHERE p.OrderID IS NULL
  OR NOT EXISTS (
    SELECT 1 FROM Orders o2 WHERE o2.OrderID = p.OrderID
  );

/* Task 6: Each employee’s name along with their manager’s name */
SELECT e.Name AS EmployeeName,
       m.Name AS ManagerName
FROM Employees e
LEFT JOIN Employees m
  ON e.ManagerID = m.EmployeeID;

/* Task 7: Names of students enrolled in course named 'Math 101' */
SELECT s.Name AS StudentName,
       c.CourseName
FROM Students s
JOIN Enrollments en
  ON s.StudentID = en.StudentID
JOIN Courses c
  ON en.CourseID = c.CourseID
WHERE c.CourseName = 'Math 101';

/* Task 8: Customers who have placed an order with more than 3 items */
SELECT c.FirstName,
       c.LastName,
       o.Quantity
FROM Customers c
JOIN Orders o
  ON c.CustomerID = o.CustomerID
WHERE o.Quantity > 3;

/* Task 9: Employees working in the 'Human Resources' department */
SELECT e.Name AS EmployeeName,
       d.DepartmentName
FROM Employees e
JOIN Departments d
  ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Human Resources';


/* ===== MEDIUM LEVEL ===== */

/* Task M1: Departments with more than 5 employees */
SELECT d.DepartmentName,
       COUNT(e.EmployeeID) AS EmployeeCount
FROM Departments d
JOIN Employees e
  ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
HAVING COUNT(e.EmployeeID) > 5;

/* Task M2: Products that have never been sold */
SELECT p.ProductID,
       p.ProductName
FROM Products p
LEFT JOIN Orders o
  ON p.ProductID = o.ProductID
WHERE o.OrderID IS NULL;

/* Task M3: Return customer names who have placed at least one order, with total orders count */
SELECT c.FirstName,
       c.LastName,
       COUNT(o.OrderID) AS TotalOrders
FROM Customers c
JOIN Orders o
  ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.LastName
HAVING COUNT(o.OrderID) >= 1;

/* Task M4: Show only records where both employee and department exist (no NULLs) */
SELECT e.Name AS EmployeeName,
       d.DepartmentName
FROM Employees e
INNER JOIN Departments d
  ON e.DepartmentID = d.DepartmentID;

/* Task M5: Pairs of employees who report to the same manager */
SELECT e1.Name AS Employee1,
       e2.Name AS Employee2,
       e1.ManagerID
FROM Employees e1
JOIN Employees e2
  ON e1.ManagerID = e2.ManagerID
WHERE e1.EmployeeID < e2.EmployeeID -- avoid duplicates & self-pairing;

/* Task M6: All orders placed in 2022 with customer name */
SELECT o.OrderID,
       o.OrderDate,
       c.FirstName,
       c.LastName
FROM Orders o
JOIN Customers c
  ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = 2022;

/* Task M7: Employees from 'Sales' department whose salary above 60000 */
SELECT e.Name AS EmployeeName,
       e.Salary,
       d.DepartmentName
FROM Employees e
JOIN Departments d
  ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Sales'
  AND e.Salary > 60000;

/* Task M8: Orders that have a corresponding payment */
SELECT o.OrderID,
       o.OrderDate,
       p.PaymentDate,
       p.Amount
FROM Orders o
JOIN Payments p
  ON o.OrderID = p.OrderID;

/* Task M9: Products that were never ordered */
SELECT p.ProductID,
       p.ProductName
FROM Products p
LEFT JOIN Orders o
  ON p.ProductID = o.ProductID
WHERE o.OrderID IS NULL;


/* ===== HARD LEVEL ===== */

/* Task H1: Employees whose salary > average salary in their department */
SELECT e.Name AS EmployeeName,
       e.Salary
FROM Employees e
WHERE e.Salary >
    (
      SELECT AVG(e2.Salary)
      FROM Employees e2
      WHERE e2.DepartmentID = e.DepartmentID
    );

/* Task H2: Orders placed before 2020 that have no corresponding payment */
SELECT o.OrderID,
       o.OrderDate
FROM Orders o
LEFT JOIN Payments p
  ON o.OrderID = p.OrderID
WHERE YEAR(o.OrderDate) < 2020
  AND p.PaymentID IS NULL;

/* Task H3: Products that do not have a matching category */
-- assuming there is a Categories table and Products.Category references it
SELECT p.ProductID,
       p.ProductName
FROM Products p
LEFT JOIN Categories c
  ON p.Category = c.CategoryID
WHERE c.CategoryID IS NULL;

/* Task H4: Employees who report to same manager and earn more than 60000 */
SELECT e1.Name AS Employee1,
       e2.Name AS Employee2,
       e1.ManagerID,
       e1.Salary AS Salary1,
       e2.Salary AS Salary2
FROM Employees e1
JOIN Employees e2
  ON e1.ManagerID = e2.ManagerID
WHERE e1.EmployeeID < e2.EmployeeID
  AND e1.Salary > 60000
  AND e2.Salary > 60000;

/* Task H5: Employees in departments whose name starts with 'M' */
SELECT e.Name AS EmployeeName,
       d.DepartmentName
FROM Employees e
JOIN Departments d
  ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName LIKE 'M%';

/* Task H6: Sales where amount > 500, include product name */
SELECT s.SaleID,
       p.ProductName,
       s.SaleAmount
FROM Sales s
JOIN Products p
  ON s.ProductID = p.ProductID
WHERE s.SaleAmount > 500;

/* Task H7: Students who have not enrolled in the course 'Math 101' */
SELECT st.StudentID,
       st.Name AS StudentName
FROM Students st
WHERE NOT EXISTS
(
  SELECT 1
  FROM Enrollments en
  JOIN Courses c
    ON en.CourseID = c.CourseID
  WHERE en.StudentID = st.StudentID
    AND c.CourseName = 'Math 101'
);

/* Task H8: Orders that are missing payment details */
SELECT o.OrderID,
       o.OrderDate,
       p.PaymentID
FROM Orders o
LEFT JOIN Payments p
  ON o.OrderID = p.OrderID
WHERE p.PaymentID IS NULL;

/* Task H9: Products that belong to either 'Electronics' or 'Furniture' category */
SELECT p.ProductID,
       p.ProductName,
       c.CategoryName
FROM Products p
JOIN Categories c
  ON p.Category = c.CategoryID
WHERE c.CategoryName IN ('Electronics','Furniture');

-- End of combined script
