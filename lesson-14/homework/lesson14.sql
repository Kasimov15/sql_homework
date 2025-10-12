------------------------------------------------------------
-- LESSON 14: DATE & TIME + STRING FUNCTIONS PRACTICE
------------------------------------------------------------

-- Clean up before creation
DROP TABLE IF EXISTS TestMultipleColumns, TestPercent, Splitter, testDots, CountSpaces, Employee, weather,
Activity, MultipleVals, fruits, RemoveLastComma, GetIntegers, p1, p2,
WeekPercentagePuzzle, Employees;

------------------------------------------------------------
-- TABLE CREATION & DATA INSERTS
------------------------------------------------------------

CREATE TABLE Employee (
    Id INT,
    Name VARCHAR(50),
    Salary INT,
    ManagerId INT
);

INSERT INTO Employee VALUES
(1, 'Joe', 70000, 3),
(2, 'Henry', 80000, 4),
(3, 'Sam', 60000, NULL),
(4, 'Max', 90000, NULL);

CREATE TABLE weather (
    Id INT,
    RecordDate DATE,
    Temperature INT
);

INSERT INTO weather VALUES
(1, '2015-01-01', 10),
(2, '2015-01-02', 25),
(3, '2015-01-03', 20),
(4, '2015-01-04', 30);

CREATE TABLE Activity (
    player_id INT,
    device_id INT,
    event_date DATE,
    games_played INT
);

INSERT INTO Activity VALUES
(1, 2, '2016-03-01', 5),
(1, 2, '2016-05-02', 6),
(2, 3, '2017-06-25', 1),
(3, 1, '2016-03-02', 0),
(3, 4, '2018-07-03', 5);

CREATE TABLE MultipleVals (Id INT, Vals VARCHAR(100));
INSERT INTO MultipleVals VALUES (1,'a,b,c'), (2,'x,y,z');

CREATE TABLE fruits (fruit_list VARCHAR(100));
INSERT INTO fruits VALUES ('apple,banana,orange,grape');

CREATE TABLE Splitter (Id INT, Vals VARCHAR(100));
INSERT INTO Splitter VALUES
(1,'P.K'),(2,'a.b'),(3,'c.d'),(4,'e.J'),(5,'t.u.b');

CREATE TABLE testDots (ID INT, Vals VARCHAR(100));
INSERT INTO testDots VALUES
(1,'0.0'),(2,'2.3.1.1'),(3,'4.1.a.3.9'),(4,'1.1.'),(5,'a.b.b.b.b.b..b..b'),(6,'6.');

CREATE TABLE GetIntegers (Id INT, VALS VARCHAR(100));
INSERT INTO GetIntegers VALUES
(1,'P1'),(2,'1 - Hero'),(3,'2 - Ramesh'),(4,'3 - KrishnaKANT'),(5,'21 - Avtaar'),
(6,'5Laila'),(7,'6  MMT'),(8,'7#7#'),(9,'#'),(10,'8'),(11,'98'),(12,'111'),(13,NULL);

CREATE TABLE TestPercent (Strs VARCHAR(100));
INSERT INTO TestPercent
SELECT 'Pawan' UNION ALL
SELECT 'Pawan%' UNION ALL
SELECT 'Pawan%Kumar' UNION ALL
SELECT '%';

CREATE TABLE TestMultipleColumns (Id INT, Name VARCHAR(20));
INSERT INTO TestMultipleColumns VALUES
(1,'Pawan,Kumar'),(2,'Sandeep,Goyal'),(3,'Isha,Mattoo'),
(4,'Gopal,Ranjan'),(5,'Neeraj,Garg'),(6,'Deepak,Sharma'),
(7,'Mayank,Tripathi');

CREATE TABLE CountSpaces (texts VARCHAR(100));
INSERT INTO CountSpaces VALUES
('P Q R S '),(' L M N O 0 0     '),('I  am here only '),
(' Welcome to the new world '),(' Hello world program'),(' Are u nuts ');

CREATE TABLE Employees (
 EMPLOYEE_ID int, FIRST_NAME varchar(50), LAST_NAME varchar(50),
 HIRE_DATE date, SALARY float, MANAGER_ID int
);

INSERT INTO Employees VALUES
(100,'Steven','King','2000-06-17',24000,0),
(101,'Neena','Kochhar','1987-06-18',17000,100),
(102,'Lex','De Haan','1987-06-19',17000,100),
(103,'Alexander','Hunold','2015-06-20',9000,102),
(104,'Bruce','Ernst','1987-06-21',6000,103),
(109,'Daniel','Faviet','2010-06-26',9000,108),
(110,'John','Chen','1987-06-27',8200,108),
(114,'Den','Raphaely','1987-07-01',11000,100),
(121,'Adam','Fripp','2011-07-08',8200,100),
(122,'Payam','Kaufling','2015-07-09',7900,100);

------------------------------------------------------------
--  EASY TASKS
------------------------------------------------------------

-- 1️ Split the Name column into Name and Surname
SELECT
 Id,
 PARSENAME(REPLACE(Name, ',', '.'), 2) AS Name,
 PARSENAME(REPLACE(Name, ',', '.'), 1) AS Surname
FROM TestMultipleColumns;

-- 2️ Find strings containing % character
SELECT * FROM TestPercent WHERE Strs LIKE '%[%]%';

-- 3️ Split a string by dot
SELECT Id, VALUE AS Part
FROM Splitter
CROSS APPLY STRING_SPLIT(Vals, '.');

-- 4️ Return rows where value has more than 2 dots
SELECT * FROM testDots
WHERE LEN(Vals) - LEN(REPLACE(Vals, '.', '')) > 2;

-- 5️ Count spaces in each string
SELECT texts, LEN(texts) - LEN(REPLACE(texts, ' ', '')) AS SpaceCount
FROM CountSpaces;

-- 6️ Employees who earn more than their manager
SELECT e.Name
FROM Employee e
JOIN Employee m ON e.ManagerId = m.Id
WHERE e.Salary > m.Salary;

-- 7️ Employees with 10–15 years of service
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, HIRE_DATE,
DATEDIFF(YEAR, HIRE_DATE, GETDATE()) AS YearsOfService
FROM Employees
WHERE DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 10 AND 15;

------------------------------------------------------------
--  MEDIUM TASKS
------------------------------------------------------------

-- 8️ Weather hotter than previous day
SELECT w1.Id, w1.RecordDate, w1.Temperature
FROM weather w1
JOIN weather w2 ON DATEDIFF(DAY, w2.RecordDate, w1.RecordDate) = 1
WHERE w1.Temperature > w2.Temperature;

-- 9️ First login date per player
SELECT player_id, MIN(event_date) AS first_login
FROM Activity
GROUP BY player_id;

-- 10 Third fruit from list
SELECT TRIM(value) AS third_fruit
FROM STRING_SPLIT((SELECT fruit_list FROM fruits), ',')
WHERE (SELECT COUNT(*) FROM STRING_SPLIT((SELECT fruit_list FROM fruits), ',') s2
       WHERE s2.value <= STRING_SPLIT((SELECT fruit_list FROM fruits), ',').value) = 3;

-- 11 Employment stage by years
SELECT FIRST_NAME, LAST_NAME, HIRE_DATE,
CASE
 WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) < 1 THEN 'New Hire'
 WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 1 AND 5 THEN 'Junior'
 WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 5 AND 10 THEN 'Mid-Level'
 WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 10 AND 20 THEN 'Senior'
 ELSE 'Veteran'
END AS EmploymentStage
FROM Employees;

-- 12 Extract leading integer from string
SELECT Id, VALS,
LEFT(VALS, PATINDEX('%[^0-9]%', VALS + 'X') - 1) AS LeadingInteger
FROM GetIntegers
WHERE VALS LIKE '[0-9]%';

------------------------------------------------------------
--   HARD TASKS
------------------------------------------------------------

-- 13 Swap first two letters in comma-separated string
SELECT Id,
STRING_AGG(value, ',') AS Swapped
FROM (
  SELECT Id, value, ROW_NUMBER() OVER(PARTITION BY Id ORDER BY (SELECT NULL)) AS rn
  FROM MultipleVals CROSS APPLY STRING_SPLIT(Vals, ',')
) t
PIVOT (
  MAX(value) FOR rn IN ([1],[2],[3])
) pvt
CROSS APPLY (SELECT [2] AS value UNION ALL SELECT [1] UNION ALL SELECT [3]) AS swap
GROUP BY Id;

-- 14 Convert string to rows (example)
SELECT value AS EachChar
FROM STRING_SPLIT('sdgfhsdgfhs@121313131', '');

-- 15 First login device for each player
SELECT player_id, device_id
FROM Activity a
WHERE event_date = (
    SELECT MIN(event_date)
    FROM Activity b
    WHERE a.player_id = b.player_id
);

-- 16 Separate integers and characters
DECLARE @str VARCHAR(100) = 'rtcfvty34redt';
SELECT
  @str AS Original,
  REPLACE(@str, REPLACE(@str, '', ''), '') AS NotNeeded,
  REPLACE(@str, '', '') AS NotUsed;

-- Bonus (real version):
SELECT 
  @str AS Original,
  REPLACE(@str, REPLACE(@str, '0', ''), '') AS Integers,
  REPLACE(@str, REPLACE(@str, '[0-9]', ''), '') AS Characters;

------------------------------------------------------------
-- END OF LESSON 14
------------------------------------------------------------
