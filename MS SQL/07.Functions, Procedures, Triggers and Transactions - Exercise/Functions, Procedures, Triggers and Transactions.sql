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

CREATE PROC usp_EmployeesBySalaryLevel(@SalaryType VARCHAR(10))
		 AS
	 SELECT e.[FirstName]
	        , e .[LastName] 
	   FROM [Employees] AS e
	  WHERE dbo.ufn_GetSalaryLevel([Salary]) = @SalaryType

--7--

CREATE FUNCTION ufn_IsWordComprised(@setOfLetters NVARCHAR(50), @word NVARCHAR(50))
	RETURNS BIT
		     AS 
		  BEGIN
		DECLARE @result BIT = 1,
				@index INT = 1;

		WHILE(@index <= LEN(@word))
		BEGIN
			DECLARE @currLetter NVARCHAR (1) = SUBSTRING(@word, @index, 1)

			IF(CHARINDEX(@currLetter, @setOfLetters) = 0)
			BEGIN
				SET @result = 0;
				RETURN @result
			END

			SET @index += 1
			END
		RETURN @result;
		END







--21--

CREATE OR ALTER PROC usp_AssignProject(@emloyeeId INT, @projectID INT)
AS
BEGIN TRANSACTION
 DECLARE @numberOFprojects INT
  SELECT @numberOFprojects = 
		 (SELECT COUNT(*)
		 FROM [EmployeesProjects] AS e
		 WHERE e.[EmployeeID] = @emloyeeId)
	  IF(@numberOFprojects >= 3)
		BEGIN
			ROLLBACK
			RAISERROR ('The employee has too many projects!', 16, 1)
			RETURN
		END
INSERT INTO [EmployeesProjects] (EmployeeID, ProjectID)
	 VALUES (@emloyeeId, @projectID)

COMMIT
