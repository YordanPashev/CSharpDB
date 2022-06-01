--2--

SELECT * FROM [Departments]

GO

--3--

SELECT [Name] FROM [Departments]

GO

--4--
 
SELECT 
	   [FirstName], [LastName], [Salary]
  FROM [Employees]

  GO

--5--
 
SELECT 
	   [FirstName], [MiddleName], [LastName]
  FROM [Employees]

  GO

--6--

ALTER TABLE [Employees]
	ADD [Full Email Address] NVARCHAR(50)
	SELECT CONCAT ([FirstName],'.', [LastName], '@softuni.bg')
	FROM [Employees]

GO

--7--

SELECT DISTINCT [Salary] AS 'Salary'
  FROM [Employees]
  
  GO

  --8--

  SELECT *
    FROM [Employees]
   WHERE [JobTitle] = 'Sales Representative'

  GO

--9--

SELECT [FirstName], [LastName], [JobTitle]
  FROM [Employees]
 WHERE [Salary] BETWEEN 20000 AND 30000

GO

--10--

SELECT 
CONCAT ([FirstName], ' ', [MiddleName], ' ', [LastName], ' ') AS 'Full Name'
  FROM [Employees]
 WHERE [Salary] IN (25000,  14000,  12500, 23600)

 GO

--11--

 SELECT [FirstName], [LastName] 
   FROM [Employees]
  WHERE [ManagerID] IS NULL

 GO