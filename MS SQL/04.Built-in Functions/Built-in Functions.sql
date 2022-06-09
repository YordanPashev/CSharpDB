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

--14--
 
  SELECT TOP (50)
	     [Name]
	     , FORMAT([Start], 'yyyy-MM-dd') AS [Start]
    FROM [Games]
   WHERE DATEPART(YEAR, [Start]) IN ('2011', '2012')
ORDER BY [Start]
		 ,[Name]

--15--

  SELECT 
         [UserName]
	     , SUBSTRING([Email], CHARINDEX('@', [Email]) + 1, LEN([Email])) AS [Email Provider]
    FROM [Users]
ORDER BY [Email Provider]
		 , [UserName]

--16--

  SELECT 
         [UserName]
		 , [IpAddress]
    FROM [Users]
   WHERE [IpAddress] LIKE '___.1%.%.___'
ORDER BY [UserName]

--17--

      SELECT [Name]   
			 ,CASE
				 WHEN DATEPART(HOUR, [Start]) BETWEEN 0 AND 11 THEN 'Morning'
				 WHEN DATEPART(HOUR, [Start]) BETWEEN 12 AND 17 THEN 'Afternoon'
				 WHEN DATEPART(HOUR, [Start]) BETWEEN 18 AND 23 THEN 'Evening'
			 END AS [Part of the Day]
	         ,CASE 
	         	 WHEN [Duration] BETWEEN 0 AND 3 THEN 'Extra Short'
	         	 WHEN [Duration] BETWEEN 4 AND 6 THEN 'Short'
	         	 WHEN [Duration] > 6 THEN 'Long'
	         	 ELSE 'Extra Long'
	         END AS [Duration]
        FROM [Games]
	ORDER BY [Name]
	         , [Duration] 
			 , [Part of the Day]

--18--

 SELECT [ProductName]
	    , [OrderDate]
	    , DATEADD(DAY, 3, [OrderDate]) AS [Pay Due]
	    , DATEADD(MONTH, 1, [OrderDate]) AS [Deliver Due]
   FROM [Orders]

--19--

CREATE TABLE [People](
             [Id] INT PRIMARY KEY IDENTITY
			 , [Name] NVARCHAR (50)
			 , [Birthdate] DATETIME2
)

 INSERT INTO [People]([Name], [Birthdate]) 
      VALUES
			 ('Victor', '2000-12-07 00:00:00.000')
			 , ('Steven', '1992-09-10 00:00:00.000')
			 , ('Stephen', '1910-09-19 00:00:00.000')
			 , ('John', '2010-01-06 00:00:00.000')

      SELECT [Name]
	         , DATEDIFF(YEAR, [Birthdate], GETDATE()) AS [Age in Years]
	         , DATEDIFF(MONTH, [Birthdate], GETDATE()) AS [Age in Months]
	         , DATEDIFF(DAY, [Birthdate], GETDATE()) AS [Age in Days]
	         , DATEDIFF(MINUTE, [Birthdate], GETDATE()) AS [Age in Minutes]
	    FROM [People]

