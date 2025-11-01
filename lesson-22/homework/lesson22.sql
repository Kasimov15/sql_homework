-- Lesson 22: Aggregated Window Functions

-- 1. Create main table
CREATE TABLE sales_data (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    product_category VARCHAR(50),
    product_name VARCHAR(100),
    quantity_sold INT,
    unit_price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    order_date DATE,
    region VARCHAR(50)
);

-- 2. Insert data
INSERT INTO sales_data VALUES
(1,101,'Alice','Electronics','Laptop',1,1200.00,1200.00,'2024-01-01','North'),
(2,102,'Bob','Electronics','Phone',2,600.00,1200.00,'2024-01-02','South'),
(3,103,'Charlie','Clothing','T-Shirt',5,20.00,100.00,'2024-01-03','East'),
(4,104,'David','Furniture','Table',1,250.00,250.00,'2024-01-04','West'),
(5,105,'Eve','Electronics','Tablet',1,300.00,300.00,'2024-01-05','North'),
(6,106,'Frank','Clothing','Jacket',2,80.00,160.00,'2024-01-06','South'),
(7,107,'Grace','Electronics','Headphones',3,50.00,150.00,'2024-01-07','East'),
(8,108,'Hank','Furniture','Chair',4,75.00,300.00,'2024-01-08','West'),
(9,109,'Ivy','Clothing','Jeans',1,40.00,40.00,'2024-01-09','North'),
(10,110,'Jack','Electronics','Laptop',2,1200.00,2400.00,'2024-01-10','South'),
(11,101,'Alice','Electronics','Phone',1,600.00,600.00,'2024-01-11','North'),
(12,102,'Bob','Furniture','Sofa',1,500.00,500.00,'2024-01-12','South'),
(13,103,'Charlie','Electronics','Camera',1,400.00,400.00,'2024-01-13','East'),
(14,104,'David','Clothing','Sweater',2,60.00,120.00,'2024-01-14','West'),
(15,105,'Eve','Furniture','Bed',1,800.00,800.00,'2024-01-15','North'),
(16,106,'Frank','Electronics','Monitor',1,200.00,200.00,'2024-01-16','South'),
(17,107,'Grace','Clothing','Scarf',3,25.00,75.00,'2024-01-17','East'),
(18,108,'Hank','Furniture','Desk',1,350.00,350.00,'2024-01-18','West'),
(19,109,'Ivy','Electronics','Speaker',2,100.00,200.00,'2024-01-19','North'),
(20,110,'Jack','Clothing','Shoes',1,90.00,90.00,'2024-01-20','South'),
(21,111,'Kevin','Electronics','Mouse',3,25.00,75.00,'2024-01-21','East'),
(22,112,'Laura','Furniture','Couch',1,700.00,700.00,'2024-01-22','West'),
(23,113,'Mike','Clothing','Hat',4,15.00,60.00,'2024-01-23','North'),
(24,114,'Nancy','Electronics','Smartwatch',1,250.00,250.00,'2024-01-24','South'),
(25,115,'Oscar','Furniture','Wardrobe',1,1000.00,1000.00,'2024-01-25','East');

-- ===================== EASY QUERIES =====================

-- 1. Running Total Sales per Customer
SELECT customer_id, customer_name, order_date, total_amount,
       SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS running_total
FROM sales_data;

-- 2. Number of Orders per Product Category
SELECT product_category, COUNT(*) AS order_count
FROM sales_data
GROUP BY product_category;

-- 3. Maximum Total Amount per Product Category
SELECT product_category, MAX(total_amount) AS max_amount
FROM sales_data
GROUP BY product_category;

-- 4. Minimum Price of Products per Product Category
SELECT product_category, MIN(unit_price) AS min_price
FROM sales_data
GROUP BY product_category;

-- 5. Moving Average of Sales (3 days window)
SELECT order_date, total_amount,
       AVG(total_amount) OVER (ORDER BY order_date ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS moving_avg
FROM sales_data;

-- 6. Total Sales per Region
SELECT region, SUM(total_amount) AS total_sales
FROM sales_data
GROUP BY region;

-- 7. Rank Customers by Total Purchase Amount
SELECT customer_id, customer_name,
       SUM(total_amount) AS total_spent,
       RANK() OVER (ORDER BY SUM(total_amount) DESC) AS rank_by_spending
FROM sales_data
GROUP BY customer_id, customer_name;

-- 8. Difference Between Current and Previous Sale per Customer
SELECT customer_id, customer_name, order_date, total_amount,
       total_amount - LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS diff_prev
FROM sales_data;

-- 9. Top 3 Most Expensive Products per Category
SELECT *
FROM (
    SELECT product_category, product_name, unit_price,
           RANK() OVER (PARTITION BY product_category ORDER BY unit_price DESC) AS price_rank
    FROM sales_data
) AS ranked
WHERE price_rank <= 3;

-- 10. Cumulative Sum of Sales per Region by Order Date
SELECT region, order_date,
       SUM(total_amount) OVER (PARTITION BY region ORDER BY order_date) AS cumulative_sales
FROM sales_data;

-- ===================== MEDIUM QUERIES =====================

-- 1. Cumulative Revenue per Product Category
SELECT product_category, order_date, total_amount,
       SUM(total_amount) OVER (PARTITION BY product_category ORDER BY order_date) AS cumulative_revenue
FROM sales_data;

-- 2. Sum of Previous Values Example
CREATE TABLE OneColumn (Value SMALLINT);
INSERT INTO OneColumn VALUES (10),(20),(30),(40),(100);

SELECT Value,
       SUM(Value) OVER (ORDER BY Value ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS SumOfPrevious
FROM OneColumn;

-- 3. Customers with Purchases in More Than One Category
SELECT customer_id, customer_name
FROM sales_data
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT product_category) > 1;

-- 4. Customers with Above-Average Spending per Region
SELECT customer_id, customer_name, region, SUM(total_amount) AS total_spent
FROM sales_data
GROUP BY customer_id, customer_name, region
HAVING SUM(total_amount) > (
    SELECT AVG(total_amount)
    FROM sales_data s2
    WHERE s2.region = sales_data.region
);

-- 5. Rank Customers by Spending Within Each Region
SELECT region, customer_name, SUM(total_amount) AS total_spent,
       RANK() OVER (PARTITION BY region ORDER BY SUM(total_amount) DESC) AS regional_rank
FROM sales_data
GROUP BY region, customer_name;

-- 6. Running Total (Cumulative Sales) per Customer
SELECT customer_id, customer_name, order_date,
       SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS cumulative_sales
FROM sales_data;

-- 7. Monthly Growth Rate
SELECT FORMAT(order_date,'yyyy-MM') AS month,
       SUM(total_amount) AS total_sales,
       LAG(SUM(total_amount)) OVER (ORDER BY FORMAT(order_date,'yyyy-MM')) AS prev_month_sales,
       (SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY FORMAT(order_date,'yyyy-MM'))) /
       NULLIF(LAG(SUM(total_amount)) OVER (ORDER BY FORMAT(order_date,'yyyy-MM')),0) * 100 AS growth_rate
FROM sales_data
GROUP BY FORMAT(order_date,'yyyy-MM');

-- 8. Customers Whose Current Sale > Previous Sale
SELECT customer_id, customer_name, order_date, total_amount
FROM (
    SELECT customer_id, customer_name, order_date, total_amount,
           LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_amount
    FROM sales_data
) t
WHERE total_amount > prev_amount;

-- ===================== HARD QUERIES =====================

-- 1. Products with Price Above Average
SELECT product_name, unit_price
FROM sales_data
WHERE unit_price > (SELECT AVG(unit_price) FROM sales_data);

-- 2. Sum of val1 + val2 per group (MyData)
CREATE TABLE MyData (Id INT, Grp INT, Val1 INT, Val2 INT);
INSERT INTO MyData VALUES
(1,1,30,29),(2,1,19,0),(3,1,11,45),(4,2,0,0),(5,2,100,17);

SELECT Id, Grp, Val1, Val2,
       CASE WHEN ROW_NUMBER() OVER (PARTITION BY Grp ORDER BY Id)=1
            THEN SUM(Val1+Val2) OVER (PARTITION BY Grp)
       END AS Tot
FROM MyData;

-- 3. Sum Puzzle
CREATE TABLE TheSumPuzzle (ID INT, Cost INT, Quantity INT);
INSERT INTO TheSumPuzzle VALUES
(1234,12,164),(1234,13,164),(1235,100,130),(1235,100,135),(1236,12,136);

SELECT ID,
       SUM(Cost) AS TotalCost,
       SUM(DISTINCT Quantity) AS TotalQuantity
FROM TheSumPuzzle
GROUP BY ID;

-- 4. Find Missing Seat Ranges
CREATE TABLE Seats (SeatNumber INT);
INSERT INTO Seats VALUES
(7),(13),(14),(15),(27),(28),(29),(30),
(31),(32),(33),(34),(35),(52),(53),(54);

WITH AllNums AS (
    SELECT TOP 60 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects
)
SELECT MIN(n) AS GapStart, MAX(n) AS GapEnd
FROM AllNums
WHERE n NOT IN (SELECT SeatNumber FROM Seats)
GROUP BY DATEDIFF(DAY, n, ROW_NUMBER() OVER (ORDER BY n))
ORDER BY GapStart;
