-- Lesson-20: Practice

CREATE TABLE #Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    Price DECIMAL(10,2),
    SaleDate DATE
);

INSERT INTO #Sales (CustomerName, Product, Quantity, Price, SaleDate) VALUES
('Alice', 'Laptop', 1, 1200.00, '2024-01-15'),
('Bob', 'Smartphone', 2, 800.00, '2024-02-10'),
('Charlie', 'Tablet', 1, 500.00, '2024-02-20'),
('David', 'Laptop', 1, 1300.00, '2024-03-05'),
('Eve', 'Smartphone', 3, 750.00, '2024-03-12'),
('Frank', 'Headphones', 2, 100.00, '2024-04-08'),
('Grace', 'Smartwatch', 1, 300.00, '2024-04-25'),
('Hannah', 'Tablet', 2, 480.00, '2024-05-05'),
('Isaac', 'Laptop', 1, 1250.00, '2024-05-15'),
('Jack', 'Smartphone', 1, 820.00, '2024-06-01');

-- 1
SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (SELECT 1 FROM #Sales s2 WHERE s2.CustomerName=s1.CustomerName AND MONTH(s2.SaleDate)=3 AND YEAR(s2.SaleDate)=2024);

-- 2
SELECT TOP 1 Product,SUM(Quantity*Price) AS TotalRevenue
FROM #Sales
GROUP BY Product
ORDER BY TotalRevenue DESC;

-- 3
SELECT MAX(Total) AS SecondHighest
FROM (SELECT DISTINCT Quantity*Price AS Total FROM #Sales) t
WHERE Total < (SELECT MAX(Quantity*Price) FROM #Sales);

-- 4
SELECT MONTH(SaleDate) AS Month,SUM(Quantity) AS TotalQuantity
FROM #Sales
GROUP BY MONTH(SaleDate);

-- 5
SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
SELECT 1 FROM #Sales s2
WHERE s2.Product=s1.Product AND s2.CustomerName<>s1.CustomerName
);

-- 6
CREATE TABLE Fruits(Name VARCHAR(50),Fruit VARCHAR(50));
INSERT INTO Fruits VALUES 
('Francesko','Apple'),('Francesko','Apple'),('Francesko','Apple'),
('Francesko','Orange'),('Francesko','Banana'),('Francesko','Orange'),
('Li','Apple'),('Li','Orange'),('Li','Apple'),('Li','Banana'),
('Mario','Apple'),('Mario','Apple'),('Mario','Apple'),
('Mario','Banana'),('Mario','Banana'),('Mario','Orange');

SELECT Name,
SUM(CASE WHEN Fruit='Apple' THEN 1 ELSE 0 END) AS Apple,
SUM(CASE WHEN Fruit='Orange' THEN 1 ELSE 0 END) AS Orange,
SUM(CASE WHEN Fruit='Banana' THEN 1 ELSE 0 END) AS Banana
FROM Fruits
GROUP BY Name;

-- 7
CREATE TABLE Family(ParentId INT,ChildID INT);
INSERT INTO Family VALUES (1,2),(2,3),(3,4);
WITH cte AS (
SELECT ParentId,ChildID FROM Family
UNION ALL
SELECT f.ParentId,c.ChildID FROM Family f JOIN cte c ON f.ChildID=c.ParentId
)
SELECT DISTINCT ParentId AS PID,ChildID AS CHID FROM cte ORDER BY PID,CHID;

-- 8
CREATE TABLE #Orders(
CustomerID INT,
OrderID INT,
DeliveryState VARCHAR(100),
Amount MONEY,
PRIMARY KEY(CustomerID,OrderID)
);
INSERT INTO #Orders VALUES
(1001,1,'CA',340),(1001,2,'TX',950),(1001,3,'TX',670),
(1001,4,'TX',860),(2002,5,'WA',320),(3003,6,'CA',650),
(3003,7,'CA',830),(4004,8,'TX',120);
SELECT * FROM #Orders o
WHERE DeliveryState='TX'
AND EXISTS (SELECT 1 FROM #Orders i WHERE i.CustomerID=o.CustomerID AND i.DeliveryState='CA');

-- 9
CREATE TABLE #residents(resid INT IDENTITY,fullname VARCHAR(50),address VARCHAR(100));
INSERT INTO #residents VALUES
('Dragan','city=Bratislava country=Slovakia name=Dragan age=45'),
('Diogo','city=Lisboa country=Portugal age=26'),
('Celine','city=Marseille country=France name=Celine age=21'),
('Theo','city=Milan country=Italy age=28'),
('Rajabboy','city=Tashkent country=Uzbekistan age=22');
UPDATE #residents
SET fullname=SUBSTRING(address,CHARINDEX('name=',address)+5,CHARINDEX(' age',address)-CHARINDEX('name=',address)-5)
WHERE fullname NOT LIKE '%[A-Za-z]%';

-- 10
CREATE TABLE #Routes(
RouteID INT,
DepartureCity VARCHAR(30),
ArrivalCity VARCHAR(30),
Cost MONEY,
PRIMARY KEY(DepartureCity,ArrivalCity)
);
INSERT INTO #Routes VALUES
(1,'Tashkent','Samarkand',100),
(2,'Samarkand','Bukhoro',200),
(3,'Bukhoro','Khorezm',300),
(4,'Samarkand','Khorezm',400),
(5,'Tashkent','Jizzakh',100),
(6,'Jizzakh','Samarkand',50);

WITH Paths AS (
SELECT DepartureCity,ArrivalCity,CAST(DepartureCity+' - '+ArrivalCity AS VARCHAR(200)) AS Route,Cost
FROM #Routes
UNION ALL
SELECT p.DepartureCity,r.ArrivalCity,CAST(p.Route+' - '+r.ArrivalCity AS VARCHAR(200)),p.Cost+r.Cost
FROM Paths p JOIN #Routes r ON p.ArrivalCity=r.DepartureCity
)
SELECT Route,Cost FROM Paths
WHERE DepartureCity='Tashkent' AND ArrivalCity='Khorezm';

-- 11
CREATE TABLE #RankingPuzzle(ID INT,Vals VARCHAR(10));
INSERT INTO #RankingPuzzle VALUES
(1,'Product'),(2,'a'),(3,'a'),(4,'a'),(5,'a'),(6,'Product'),(7,'b'),(8,'b'),(9,'Product'),(10,'c');
SELECT *,SUM(CASE WHEN Vals='Product' THEN 1 ELSE 0 END) OVER (ORDER BY ID) AS RankGroup FROM #RankingPuzzle;

-- 12
CREATE TABLE #EmployeeSales (
EmployeeID INT PRIMARY KEY IDENTITY(1,1),
EmployeeName VARCHAR(100),
Department VARCHAR(50),
SalesAmount DECIMAL(10,2),
SalesMonth INT,
SalesYear INT
);
INSERT INTO #EmployeeSales VALUES
('Alice','Electronics',5000,1,2024),('Bob','Electronics',7000,1,2024),
('Charlie','Furniture',3000,1,2024),('David','Furniture',4500,1,2024),
('Eve','Clothing',6000,1,2024),('Frank','Electronics',8000,2,2024),
('Grace','Furniture',3200,2,2024),('Hannah','Clothing',7200,2,2024),
('Isaac','Electronics',9100,3,2024),('Jack','Furniture',5300,3,2024),
('Kevin','Clothing',6800,3,2024),('Laura','Electronics',6500,4,2024),
('Mia','Furniture',4000,4,2024),('Nathan','Clothing',7800,4,2024);

-- 12
SELECT * FROM #EmployeeSales e
WHERE SalesAmount>(SELECT AVG(SalesAmount) FROM #EmployeeSales WHERE Department=e.Department);

-- 13
SELECT * FROM #EmployeeSales e
WHERE EXISTS (
SELECT 1 FROM #EmployeeSales s
WHERE s.SalesMonth=e.SalesMonth
GROUP BY s.SalesMonth
HAVING e.SalesAmount=MAX(s.SalesAmount)
);

-- 14
SELECT e.EmployeeName
FROM #EmployeeSales e
WHERE NOT EXISTS (
SELECT m FROM (SELECT DISTINCT SalesMonth FROM #EmployeeSales) m
EXCEPT
SELECT SalesMonth FROM #EmployeeSales s WHERE s.EmployeeName=e.EmployeeName
);

CREATE TABLE Products (
ProductID INT PRIMARY KEY,
Name VARCHAR(50),
Category VARCHAR(50),
Price DECIMAL(10,2),
Stock INT
);
INSERT INTO Products VALUES
(1,'Laptop','Electronics',1200.00,15),(2,'Smartphone','Electronics',800.00,30),
(3,'Tablet','Electronics',500.00,25),(4,'Headphones','Accessories',150.00,50),
(5,'Keyboard','Accessories',100.00,40),(6,'Monitor','Electronics',300.00,20),
(7,'Mouse','Accessories',50.00,60),(8,'Chair','Furniture',200.00,10),
(9,'Desk','Furniture',400.00,5),(10,'Printer','Office Supplies',250.00,12),
(11,'Scanner','Office Supplies',180.00,8),(12,'Notebook','Stationery',10.00,100),
(13,'Pen','Stationery',2.00,500),(14,'Backpack','Accessories',80.00,30),
(15,'Lamp','Furniture',60.00,25);

-- 15
SELECT * FROM Products WHERE Price>(SELECT AVG(Price) FROM Products);

-- 16
SELECT * FROM Products WHERE Stock<(SELECT MAX(Stock) FROM Products);

-- 17
SELECT * FROM Products WHERE Category=(SELECT Category FROM Products WHERE Name='Laptop');

-- 18
SELECT * FROM Products WHERE Price>(SELECT MIN(Price) FROM Products WHERE Category='Electronics');

-- 19
SELECT * FROM Products p
WHERE Price>(SELECT AVG(Price) FROM Products WHERE Category=p.Category);

CREATE TABLE Orders(
OrderID INT PRIMARY KEY,
ProductID INT,
Quantity INT,
OrderDate DATE,
FOREIGN KEY(ProductID) REFERENCES Products(ProductID)
);
INSERT INTO Orders VALUES
(1,1,2,'2024-03-01'),(2,3,5,'2024-03-05'),(3,2,3,'2024-03-07'),(4,5,4,'2024-03-10'),
(5,8,1,'2024-03-12'),(6,10,2,'2024-03-15'),(7,12,10,'2024-03-18'),(8,7,6,'2024-03-20'),
(9,6,2,'2024-03-22'),(10,4,3,'2024-03-25'),(11,9,2,'2024-03-28'),(12,11,1,'2024-03-30'),
(13,14,4,'2024-04-02'),(14,15,5,'2024-04-05'),(15,13,20,'2024-04-08');

-- 20
SELECT DISTINCT p.Name FROM Products p
WHERE EXISTS (SELECT 1 FROM Orders o WHERE o.ProductID=p.ProductID);

-- 21
SELECT p.Name FROM Products p
WHERE p.ProductID IN (
SELECT ProductID FROM Orders
GROUP BY ProductID
HAVING AVG(Quantity)>(SELECT AVG(Quantity) FROM Orders)
);

-- 22
SELECT p.Name FROM Products p
WHERE NOT EXISTS (SELECT 1 FROM Orders o WHERE o.ProductID=p.ProductID);

-- 23
SELECT TOP 1 p.Name,SUM(o.Quantity) AS TotalQty
FROM Orders o JOIN Products p ON o.ProductID=p.ProductID
GROUP BY p.Name
ORDER BY TotalQty DESC;
