--1--

SELECT 
	   [FirstName]
	   , [LastName]
  FROM [Employees]
 WHERE [FirstName] LIKE 'Sa%'

 --2--

 SELECT 
	   [FirstName]
	   , [LastName]
  FROM [Employees]
 WHERE [LastName] LIKE '%ei%'

 --3--

 SELECT [FirstName]
   FROM [Employees]
  WHERE [DepartmentID] IN (3, 10)
    AND DATEPART(YEAR, [HireDate]) >= 1995
	AND	DATEPART(YEAR, [HireDate]) <= 2005

--4--

SELECT 
	   [FirstName]
	   , [LastName]
  FROM [Employees]
 WHERE [JobTitle] NOT LIKE '%engineer%'

 --5--

   SELECT [Name]
     FROM [Towns]
    WHERE LEN([Name]) BETWEEN 5 AND 6 
 ORDER BY [Name]

 --6--

  SELECT *
	FROM [Towns]
   WHERE SUBSTRING([Name], 1, 1) IN ('M', 'K', 'B', 'E')
ORDER BY [Name]

--7--

SELECT *
	FROM [Towns]
   WHERE SUBSTRING([Name], 1, 1) NOT IN ('R', 'B', 'D')
ORDER BY [Name]

--8--

GO 

CREATE VIEW V_EmployeesHiredAfter2000 AS
 SELECT [FirstName]
		, [LastName]
   FROM [Employees]
  WHERE DATEPART(YEAR, [HireDate]) > 2000

GO

--9--

   SELECT [FirstName]
		  , [LastName]
     FROM [Employees]
    WHERE LEN([LastName]) = 5

--10--

SELECT 
	   [EmployeeID]
	   , [FirstName]
	   , [LastName]
	   , [Salary]
	   , DENSE_RANK() OVER (partition by [Salary] ORDER BY [EmployeeID]) AS [Rank]
  FROM [Employees]
 WHERE 
	   [Salary] BETWEEN 10000 AND 50000
 ORDER BY [Salary] DESC

 --11--

  SELECT *
    FROM (
  SELECT
	     [EmployeeID]
	     , [FirstName]
	     , [LastName]
	     , [Salary]
	     , DENSE_RANK() OVER (partition by [Salary] ORDER BY [EmployeeID]) AS [Rank]
    FROM [Employees]
   WHERE [Salary] BETWEEN 10000 AND 50000) AS [Ranked_Table_by_Salary]
   WHERE [Rank] = 2
ORDER BY [Salary] DESC

--12--

  SELECT 
		 [CountryName] AS [Country Name]
		 , [ISOCode] AS [ISO Code]
	FROM [Countries]
   WHERE [CountryName] LIKE '%a%a%a%'
ORDER BY [IsoCode]

--13--

  SELECT 
		 p.[PeakName] 
	  	 , r.[RiverName] 
	 	 , CONCAT(LOWER(p.[PeakName]), LOWER(SUBSTRING(r.[RiverName],2,LEN(r.[RiverName])))) AS [Mix]
    FROM [Peaks] AS p
    JOIN [Rivers] AS r 
      ON RIGHT(p.[PeakName], 1) = LEFT(r.RiverName, 1)
ORDER BY [Mix]
