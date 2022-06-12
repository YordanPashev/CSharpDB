--1--
  SELECT TOP (5) 
	     e.[EmployeeID]
	     , e.[JobTitle]
	     , a.[AddressID]
	     , a.[AddressText]
    FROM [Employees] AS e
    JOIN [Addresses] AS a ON a.[AddressID] = e.[AddressID]
ORDER BY e.[AddressID]

--2--

  SELECT TOP (50) 
	     e.[FirstName]
	     , e.[LastName]
	     , t.[Name] AS [Town]
	     , a.[AddressText]
    FROM [Employees] AS e
    JOIN [Addresses] AS a ON a.[AddressID] = e.[AddressID]
    JOIN [Towns] AS t ON t.[TownId] = a.[TownID]
ORDER BY e.[FirstName]
		 , e.[LastName]

--3--

  SELECT 
         e.[EmployeeID]
		 , e.[FirstName]
		 , e.[LastName]
		 , d.[Name] AS 'DepartmentName'
    FROM [Employees] AS e
    JOIN [Departments] AS d ON d.[DepartmentID] = e.[DepartmentID]
   WHERE d.[Name] = 'Sales'
ORDER BY e.[EmployeeID]

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
 
  SELECT [CountryCode]
		 , COUNT([MountainId]) AS [MountainRanges]
    FROM [MountainsCountries]
   WHERE [CountryCode] IN ('US', 'BG', 'RU')
GROUP BY [CountryCode]

--14--

   SELECT TOP (5)
          c.[CountryName]
		  , r.[RiverName]
     FROM [Countries] AS c 
LEFT JOIN [CountriesRivers] AS cr
	   ON cr.[CountryCode] = c.[CountryCode]
LEFT JOIN [Rivers] AS r
	   ON r.[Id] = cr.[RiverId]
	WHERE c.[ContinentCode] = 'AF'
 ORDER BY c.[CountryName]

 --15--
      SELECT 
			 rc.[ContinentCode]
			 , rc.[CurrencyCode]
			 , rc.[CurrencyUsage] AS [CurrencyUsage] 
	    FROM ( 
			   SELECT 
					  c.[ContinentCode]
					  , c.[CurrencyCode]
					  , COUNT(c.[CurrencyCode]) AS [CurrencyUsage] 
					  , DENSE_RANK() OVER (PARTITION BY c.ContinentCode ORDER BY COUNT(c.CurrencyCode) DESC) AS [rank] 
				 FROM [Countries] AS c
			 GROUP BY c.[ContinentCode], c.[CurrencyCode]
			 ) AS  rc
	WHERE rc.[rank] = 1 
	  AND rc.[CurrencyUsage] > 1
 --16--

   SELECT COUNT(*)
     FROM [Countries] AS c
LEFT JOIN [MountainsCountries] AS m  
       ON m.[CountryCode] = c.[CountryCode]
	WHERE m.[MountainId] IS NULL

--17--

   SELECT TOP (5) 
	      sd.[CountryName]
		  , MAX(sd.[HighestPeakElevation])
		  , MAX (sd.LongestRiverLength)
     FROM (
			SELECT
					c.[CountryName]
					, p.[Elevation] AS [HighestPeakElevation]
					, r.[Length] AS [LongestRiverLength]
			   FROM [Countries] AS c
		  LEFT JOIN [CountriesRivers] as cr
				 ON c.[CountryCode] = cr.[CountryCode] 
		  LEFT JOIN [Rivers] AS r 
			     ON cr.[RiverId] = r.[Id]
		  LEFT JOIN [MountainsCountries] as m
			     ON c.[CountryCode] = m.[CountryCode] 
		  LEFT JOIN [Peaks] AS p
			     ON p.[MountainId] = m.[MountainId]
		   ) AS sd
 GROUP BY sd.CountryName
 ORDER BY MAX(sd.[HighestPeakElevation]) DESC
		  , MAX(sd.[LongestRiverLength]) DESC
		  , MAX(sd.CountryName)

--18--

   SELECT TOP (5)
		    rc.[CountryName] AS [Country]
		    , CASE 
		   			WHEN rc.[PeakName] IS NULL THEN '(no highest peak)'
		   			ELSE rc.[PeakName] 
		       END AS [Highest Peak Name]
		    , CASE
		     		WHEN rc.[Elevation] IS NULL THEN 0
		   			ELSE rc.[Elevation]
		   	END AS [Highest Peak Elevation]
		    , CASE 
		   			WHEN rc.[MountainRange] IS NULL THEN '(no mountain)'
		   			ELSE rc.[MountainRange]
		     END AS [Mountain]
     FROM (
		   SELECT 
		     c.[CountryName]
		     , p.[PeakName]
		     , p.[Elevation] 
		   	 , m.[MountainRange]
		      , DENSE_RANK() OVER (PARTITION BY c.[CountryName] ORDER BY p.[Elevation]) AS peakRank
		   FROM [Countries] AS c
	  LEFT JOIN [MountainsCountries] as mc
             ON c.[CountryCode] = mc.[CountryCode] 
      LEFT JOIN [Peaks] AS p
             ON p.[MountainId] = mc.[MountainId]
      LEFT JOIN [Mountains] AS m
            ON m.[Id] = mc.[MountainId]
	   ) AS rc
	 WHERE rc.[peakRank] = 1  
  ORDER BY CountryName, [Highest Peak Name]



