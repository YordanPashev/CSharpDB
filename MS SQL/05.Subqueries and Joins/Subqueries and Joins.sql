--1--
  SELECT TOP (5) 
	     e.[EmployeeID]
	     , e.[JobTitle]
	     , a.[AddressID]
	     , a.[AddressText]
    FROM [Employees] AS e
    JOIN [Addresses] AS a ON a.[AddressID] = e.[AddressID]
ORDER BY [AddressID]

--2--

  SELECT TOP (50) 
	     e.[FirstName]
	     , e.[LastName]
	     , t.[Name] AS [Town]
	     , a.[AddressText]
    FROM [Employees] AS e
    JOIN [Addresses] AS a ON a.[AddressID] = e.[AddressID]
    JOIN [Towns] AS t ON t.[TownId] = a.[TownID]
ORDER BY [FirstName]
		 , [LastName]

--3--

  SELECT 
         e.[EmployeeID]
		 , e.[FirstName]
		 , e.[LastName]
		 , d.[Name] AS 'DepartmentName'
    FROM [Employees] AS e
    JOIN [Departments] AS d ON d.[DepartmentID] = e.[DepartmentID]
   WHERE d.[Name] = 'Sales'
ORDER BY [EmployeeID]

--4--

  SELECT TOP (5) 
         e.[EmployeeID]
		 , e.[FirstName]
		 , e.[Salary]
		 , d.[Name] AS 'DepartmentName'
    FROM [Employees] AS e
    JOIN [Departments] AS d ON d.[DepartmentID] = e.[DepartmentID]
   WHERE e.[Salary] > 15000
ORDER BY d.[DepartmentID]

--5--

    SELECT TOP (3) e.[EmployeeID]
          ,e.[Firstname]FROM [Employees] AS e
LEFT JOIN [EmployeesProjects] AS ep ON ep.[EmployeeID] = e.[EmployeeID]
    WHERE ep.[EmployeeID] IS NULL
 ORDER BY ep.[EmployeeID]

 --6--

    SELECT 
	       e.[FirstName]
		   , e.[Lastname]
		   , e.[HireDate]
		   , d.[Name] AS [DeptName]
      FROM [Departments] AS d
	  JOIN [Employees] AS e 
	    ON d.[DepartmentID] = e.[DepartmentID]
	 WHERE e.[HireDate] > '1999-01-01'
	   AND d.[Name] IN ('Sales', 'Finance') 
  ORDER BY e.[HireDate]

--7--

  SELECT TOP (5)
		 ep.[EmployeeID]
		 , e.[FirstName]
		 , p.[Name] AS [ProjectName]
    FROM [EmployeesProjects] AS ep
	JOIN [Employees] AS e
      ON e.[EmployeeID] = ep.[EmployeeID]
    JOIN [Projects] AS p
      ON p.[ProjectID] = ep.[ProjectID] 
   WHERE p.[StartDate] > '2002-08-13' 
     AND [EndDate] IS NULL
ORDER BY [EmployeeID]

--8--

  SELECT 
		  ep.[EmployeeID]
		  , e.[FirstName]
		  , [Name] AS [Project Name]
     FROM [Employees] AS e
	 JOIN [EmployeesProjects] AS ep
       ON e.[EmployeeID] = ep.[EmployeeID]
LEFT JOIN [Projects] AS p
       ON p.[ProjectID] = ep.[ProjectID]
	  AND p.[StartDate] < '2005.01.01'
    WHERE ep.[EmployeeID] = 24 

--9--

  SELECT 
	     e.[EmployeeID]
	     , e.[FirstName]
	     , e.[ManagerID]
		 , m.[FirstName] AS [ManagerName]
    FROM [Employees] AS e
    JOIN [Employees] AS m 
      ON m.[EmployeeID] = e.[ManagerID]
   WHERE e.[ManagerID] IN (3, 7)
ORDER BY e.[EmployeeID]

--10--

    SELECT TOP (50) 
	       e.[EmployeeID]
	       , CONCAT(e.[FirstName], ' ', e.[LastName])
		   , CONCAT(m.[FirstName], ' ', m.[LastName]) AS [ManagerName]
	   	   , d.[Name] AS [DepartmentName]
      FROM [Employees] AS e
      JOIN [Departments] AS d 
   	    ON e.[DepartmentID] = d.[DepartmentID] 
 LEFT JOIN [Employees] AS m 
        ON m.[EmployeeID] = e.[ManagerID]
  ORDER BY e.[EmployeeID]

--11--
  SELECT 
         MIN(a.[AverageSalary]) AS [MinAverageSalary]
    FROM 
	(
  SELECT AVG(e.[Salary]) AS [AverageSalary]
    FROM [Employees] AS e
GROUP BY e.[DepartmentId]
	) AS a

--12--

  SELECT 
		 mc.[CountryCode]
		 , m.[MountainRange]
		 , p.[PeakName]
		 , p.Elevation
    FROM [Peaks] AS p
    JOIN [MountainsCountries] AS mc 
      ON p.MountainId = mc.MountainId
    JOIN [Mountains] AS m
      ON mc.[MountainId] = m.[Id]
   WHERE mc.[CountryCode] = 'BG'
     AND p.[Elevation] > 2835
ORDER BY p.[Elevation] DESC

--13--

 SELECT 
		m.[CountryCode]
		, m.[MountainRanges]
   FROM (SELECT [CountryCode]
				, COUNT([MountainId]) AS [MountainRanges]
		   FROM [MountainsCountries]
           WHERE [CountryCode] IN ('US', 'BG', 'RU')
		GROUP BY [CountryCode]
  ) AS m

--14--