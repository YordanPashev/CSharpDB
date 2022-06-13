--1--

CREATE PROC usp_GetEmployeesSalaryAbove35000
         AS 
	 SELECT e.[FirstName]
			, e.[LastName]
	   FROM [Employees] AS e
	  WHERE e.[Salary] > 35000
--2--

CREATE PROC usp_GetEmployeesSalaryAboveNumber(@Salary DECIMAL(18,4))
         AS 
	 SELECT e.[FirstName]
			, e.[LastName]
	   FROM [Employees] AS e
	  WHERE e.[Salary] >= @Salary

--3--

CREATE PROC usp_GetTownsStartingWith(@string NVARCHAR(20))
         AS 
	 SELECT t.[Name]
	   FROM [Towns] AS t
	  WHERE t.[Name] LIKE @string + '%'

--4--

CREATE PROC usp_GetEmployeesFromTown(@town NVARCHAR(50))
         AS 
	 SELECT e.[FirstName]
			, e.[LastName]
	   FROM [Employees] AS e
       JOIN [Addresses] AS a
	     ON e.[AddressID] = a.[AddressID]
       JOIN [Towns] AS t
		 ON a.[TownID] = t.[TownID] 
	  WHERE t.[Name] = @town

	  EXEC usp_GetEmployeesFromTown 'Sofia'

--5--

CREATE FUNCTION ufn_GetSalaryLevel (@salary DECIMAL(18,4))
RETURNS NVARCHAR(10)
AS
BEGIN
	  DECLARE @result NVARCHAR(10);
	  IF(@salary < 30000)
	  BEGIN
		SET @result = 'Low'
	  END
	  IF(@salary BETWEEN 30000 AND 50000)
	  BEGIN
		SET @result = 'Average'
	  END
	  IF(@salary > 50000)
	  BEGIN
		SET @result = 'High'
	  END
	  RETURN @result
END

--6--