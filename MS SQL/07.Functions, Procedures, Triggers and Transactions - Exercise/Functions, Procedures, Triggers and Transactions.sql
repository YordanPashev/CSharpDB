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

--8--

   CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentId INT) AS
       DECLARE @empIDsToBeDeleted TABLE( ID INT )
		
   INSERT INTO @empIDsToBeDeleted
	    SELECT e.[EmployeeID]
		  FROM [Employees] AS e
		 WHERE e.[DepartmentID] = @departmentId

   ALTER TABLE [Departments]
  ALTER COLUMN [ManagerID] int NULL

   DELETE FROM [EmployeesProjects]
         WHERE [EmployeeID] IN (SELECT ID FROM @empIDsToBeDeleted)

		UPDATE [Employees]
           SET [ManagerID] = NULL
         WHERE [ManagerID] IN (SELECT ID FROM @empIDsToBeDeleted)

		UPDATE [Departments]
		   SET [ManagerID] = NULL
         WHERE [ManagerID] IN (SELECT ID FROM @empIDsToBeDeleted)

   DELETE FROM [Employees]
         WHERE [EmployeeID] IN (SELECT ID FROM @empIDsToBeDeleted)

   DELETE FROM [Departments]
         WHERE [DepartmentID] = @departmentId 

		SELECT COUNT(*) AS [Employees Count] FROM Employees AS e
		  JOIN [Departments] AS d
		    ON d.[DepartmentID] = e.[DepartmentID]
         WHERE e.[DepartmentID] = @departmentId

--9--

CREATE PROC usp_GetHoldersFullName AS
	BEGIN
		SELECT CONCAT(ah.[FirstName], ' ', ah.[LastName]) AS [Full Name]
		  FROM [AccountHolders] AS ah
	END

--10--

 CREATE PROC usp_GetHoldersWithBalanceHigherThan (@minAmount DECIMAL(18,4))
 AS
 BEGIN
	SELECT ah.[FirstName]
		   , ah.[LastName]
	  FROM [AccountHolders] AS ah
	  JOIN (
			  SELECT SUM([Balance]) AS [HolderTotalBalance]
			         , [AccountHolderId]
				FROM [Accounts]
			GROUP BY [AccountHolderId]	
		   ) AS a
	    ON ah.[Id] = a.[AccountHolderId]
     WHERE a.[HolderTotalBalance] > @minAmount
  ORDER BY ah.[Firstname]
		   , ah.[LastName]
 END

--11--
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
