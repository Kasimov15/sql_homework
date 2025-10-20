-- LESSON 12: PRACTICE
------------------------------------------------------------
-- 1. Combine Two Tables
------------------------------------------------------------
CREATE TABLE Person (
    personId INT PRIMARY KEY,
    lastName VARCHAR(255),
    firstName VARCHAR(255)
);

CREATE TABLE Address (
    addressId INT PRIMARY KEY,
    personId INT,
    city VARCHAR(255),
    state VARCHAR(255)
);

TRUNCATE TABLE Person;
INSERT INTO Person (personId, lastName, firstName)
VALUES (1, 'Wang', 'Allen'),
       (2, 'Alice', 'Bob');

TRUNCATE TABLE Address;
INSERT INTO Address (addressId, personId, city, state)
VALUES (1, 2, 'New York City', 'New York'),
       (2, 3, 'Leetcode', 'California');

SELECT 
    p.firstName,
    p.lastName,
    a.city,
    a.state
FROM Person p
LEFT JOIN Address a ON p.personId = a.personId;


------------------------------------------------------------
-- 2. Employees Earning More Than Their Managers
------------------------------------------------------------
CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    salary INT,
    managerId INT
);

TRUNCATE TABLE Employee;
INSERT INTO Employee (id, name, salary, managerId)
VALUES (1, 'Joe', 70000, 3),
       (2, 'Henry', 80000, 4),
       (3, 'Sam', 60000, NULL),
       (4, 'Max', 90000, NULL);

SELECT e.name AS Employee
FROM Employee e
JOIN Employee m ON e.managerId = m.id
WHERE e.salary > m.salary;


------------------------------------------------------------
-- 3. Duplicate Emails
------------------------------------------------------------
CREATE TABLE IF NOT EXISTS PersonEmail (
    id INT PRIMARY KEY,
    email VARCHAR(255)
);

TRUNCATE TABLE PersonEmail;
INSERT INTO PersonEmail (id, email)
VALUES (1, 'a@b.com'),
       (2, 'c@d.com'),
       (3, 'a@b.com');

SELECT email AS Email
FROM PersonEmail
GROUP BY email
HAVING COUNT(email) > 1;


------------------------------------------------------------
-- 4. Delete Duplicate Emails (keep smallest id)
------------------------------------------------------------
DELETE FROM PersonEmail
WHERE id NOT IN (
    SELECT MIN(id)
    FROM PersonEmail
    GROUP BY email
);

SELECT * FROM PersonEmail;


------------------------------------------------------------
-- 5. Parents who have only girls
------------------------------------------------------------
CREATE TABLE boys (
    Id INT PRIMARY KEY,
    name VARCHAR(100),
    ParentName VARCHAR(100)
);

CREATE TABLE girls (
    Id INT PRIMARY KEY,
    name VARCHAR(100),
    ParentName VARCHAR(100)
);

INSERT INTO boys (Id, name, ParentName)
VALUES (1, 'John', 'Michael'),
       (2, 'David', 'James'),
       (3, 'Alex', 'Robert'),
       (4, 'Luke', 'Michael'),
       (5, 'Ethan', 'David'),
       (6, 'Mason', 'George');

INSERT INTO girls (Id, name, ParentName)
VALUES (1, 'Emma', 'Mike'),
       (2, 'Olivia', 'James'),
       (3, 'Ava', 'Robert'),
       (4, 'Sophia', 'Mike'),
       (5, 'Mia', 'John'),
       (6, 'Isabella', 'Emily'),
       (7, 'Charlotte', 'George');

SELECT DISTINCT g.ParentName
FROM girls g
WHERE g.ParentName NOT IN (SELECT DISTINCT ParentName FROM boys);


------------------------------------------------------------
-- 6. Total over 50 and least (TSQL2012 - Sales.Orders)
------------------------------------------------------------
-- Assuming Sales.Orders exists in tsql2012 DB

SELECT
    custid,
    SUM(val) AS TotalSalesOver50,
    MIN(weight) AS LeastWeight
FROM Sales.Orders
WHERE weight > 50
GROUP BY custid;


------------------------------------------------------------
-- 7. Carts
------------------------------------------------------------
DROP TABLE IF EXISTS Cart1;
DROP TABLE IF EXISTS Cart2;

CREATE TABLE Cart1 (Item VARCHAR(100) PRIMARY KEY);
CREATE TABLE Cart2 (Item VARCHAR(100) PRIMARY KEY);

INSERT INTO Cart1 (Item)
VALUES ('Sugar'), ('Bread'), ('Juice'), ('Soda'), ('Flour');

INSERT INTO Cart2 (Item)
VALUES ('Sugar'), ('Bread'), ('Butter'), ('Cheese'), ('Fruit');

SELECT 
    COALESCE(c1.Item, '') AS [Item Cart 1],
    COALESCE(c2.Item, '') AS [Item Cart 2]
FROM Cart1 c1
FULL OUTER JOIN Cart2 c2 ON c1.Item = c2.Item
ORDER BY [Item Cart 1], [Item Cart 2];


------------------------------------------------------------
-- 8. Customers Who Never Order
------------------------------------------------------------
CREATE TABLE Customers (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE Orders (
    id INT PRIMARY KEY,
    customerId INT
);

TRUNCATE TABLE Customers;
INSERT INTO Customers (id, name)
VALUES (1, 'Joe'),
       (2, 'Henry'),
       (3, 'Sam'),
       (4, 'Max');

TRUNCATE TABLE Orders;
INSERT INTO Orders (id, customerId)
VALUES (1, 3),
       (2, 1);

SELECT c.name AS Customers
FROM Customers c
LEFT JOIN Orders o ON c.id = o.customerId
WHERE o.customerId IS NULL;


------------------------------------------------------------
-- 9. Students and Examinations
------------------------------------------------------------
CREATE TABLE Students (
    student_id INT,
    student_name VARCHAR(20)
);

CREATE TABLE Subjects (
    subject_name VARCHAR(20)
);

CREATE TABLE Examinations (
    student_id INT,
    subject_name VARCHAR(20)
);

TRUNCATE TABLE Students;
INSERT INTO Students (student_id, student_name)
VALUES (1, 'Alice'),
       (2, 'Bob'),
       (13, 'John'),
       (6, 'Alex');

TRUNCATE TABLE Subjects;
INSERT INTO Subjects (subject_name)
VALUES ('Math'), ('Physics'), ('Programming');

TRUNCATE TABLE Examinations;
INSERT INTO Examinations (student_id, subject_name)
VALUES (1, 'Math'),
       (1, 'Physics'),
       (1, 'Programming'),
       (2, 'Programming'),
       (1, 'Physics'),
       (1, 'Math'),
       (13, 'Math'),
       (13, 'Programming'),
       (13, 'Physics'),
       (2, 'Math'),
       (1, 'Math');

SELECT 
    s.student_id,
    s.student_name,
    sub.subject_name,
    COUNT(e.subject_name) AS attended_exams
FROM Students s
CROSS JOIN Subjects sub
LEFT JOIN Examinations e 
    ON s.student_id = e.student_id AND sub.subject_name = e.subject_name
GROUP BY s.student_id, s.student_name, sub.subject_name
ORDER BY s.student_id, sub.subject_name;
