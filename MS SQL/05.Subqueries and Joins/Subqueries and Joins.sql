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
