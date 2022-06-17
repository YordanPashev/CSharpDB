--1--
CREATE TABLE [Users](
					 [Id] INT PRIMARY KEY IDENTITY
				     , [Username] NVARCHAR (30) UNIQUE NOT NULL
				     , [Password] NVARCHAR (50) NOT NULL
				     , [Name] NVARCHAR (50) 
				     , [Birthdate] DATETIME2
				     , [Age] INT CHECK ([Age] BETWEEN 14 AND 110)
				     , [Email] NVARCHAR (50) NOT NULL
)


CREATE TABLE [Departments](
					 [Id] INT PRIMARY KEY IDENTITY
				     , [Name] NVARCHAR (50) NOT NULL
)


CREATE TABLE [Employees](
					 [Id] INT PRIMARY KEY IDENTITY
				     , [FirstName] NVARCHAR (25) 
				     , [LastName] NVARCHAR (25)
				     , [Birthdate] DATETIME2
				     , [Age] INT CHECK ([Age] BETWEEN 18 AND 110)
				     , [DepartmentId] INT FOREIGN KEY REFERENCES [Departments]([Id])
)

CREATE TABLE [Categories](
					 [Id] INT PRIMARY KEY IDENTITY
				     , [Name] NVARCHAR (50) NOT NULL
				     , [DepartmentId] INT FOREIGN KEY REFERENCES [Departments]([Id]) NOT NULL
)

CREATE TABLE [Status](
					 [Id] INT PRIMARY KEY IDENTITY
				     , Label NVARCHAR (30) NOT NULL
)

CREATE TABLE [Reports](
					 [Id] INT PRIMARY KEY IDENTITY
				     , [CategoryId] INT FOREIGN KEY REFERENCES [Categories]([Id])
				     , [StatusId] INT FOREIGN KEY REFERENCES [Status]([Id])
				     , [OpenDate] DATETIME2 NOT NULL
				     , [CloseDate] DATETIME2
					 , [Description] NVARCHAR(200) NOT NULL
				     , [UserId] INT FOREIGN KEY REFERENCES [Users]([Id]) NOT NULL
					 , [EmployeeId] INT FOREIGN KEY REFERENCES [Employees]([Id])
)

--2--

INSERT INTO [Employees]([FirstName], [LastName], [Birthdate], [DepartmentId])
     VALUES
	        ('Marlo', 'O''Malley', '1958-9-21', 1)
			,('Niki', 'Stanaghan', '1969-11-26', 4)
			,('Ayrton', 'Senna', '1960-03-21', 9)
			,('Ronnie', 'Peterson', '1944-02-14', 9)
			,('Giovanna', 'Amati', '1959-07-20', 5)

INSERT INTO [Reports]([CategoryId], [StatusId], [OpenDate], [CloseDate], [Description], [UserId], [EmployeeId])
     VALUES
	        (1 , 1, '2017-04-13', NULL, 'Stuck Road on Str.133', 6, 2)
	        , (6 , 3, '2015-09-05', '2015-12-06', 'Charity trail running', 3, 5)
	        , (14 , 2, '2015-09-07', NULL, 'Falling bricks on Str.58', 5, 2)
	        , (4 , 3, '2017-07-03', '2017-07-06', 'Cut off streetlight on Str.11', 1, 1)

--3--

UPDATE [Reports]
   SET [CloseDate] = GETDATE()
 WHERE [CloseDate] IS NULL

--4--

DELETE FROM [Reports]
      WHERE [StatusId] = 4

--5--

  SELECT r.[Description]	
	     , FORMAT(r.[OpenDate], 'dd-MM-yyyy')
    FROM [Reports] AS r
   WHERE r.[EmployeeId] IS NULL
ORDER BY r.[OpenDate]
		 , r.[Description] 

--6--

  SELECT r.[Description]	
		 , c.[Name]
    FROM [Reports] AS r
	JOIN [Categories] AS c
	  ON r.[CategoryId] = c.[Id]
   WHERE [CategoryId] IS NOT NULL
ORDER BY r.[Description]
	    , c.[Name]

--7--

   SELECT TOP (5)
		  c.[Name] AS CategoryName
		  , COUNT (c.[Id]) AS [ReportsNumber]
     FROM [Reports] AS r
LEFT JOIN [Categories] AS c
	   ON r.[CategoryId] = c.[Id]
 GROUP BY c.[Name]
 ORDER BY [ReportsNumber] DESC
		  , c.[Name]

--8--

  SELECT u.[Username]
		 , c.[Name] AS [CategoryName]
    FROM [Users] AS u
	JOIN [Reports] AS r
	  On u.[Id] = r.[UserId]
    JOIN [Categories] AS c
	  ON r.[CategoryId] = c.[id] 
   WHERE DATEPART(DAY, u.[Birthdate]) = DATEPART(DAY, r.[OpenDate])
     AND DATEPART(MONTH, u.[Birthdate]) = DATEPART(MONTH, r.[OpenDate])
ORDER BY u.[Username]
		 , c.[Name] 

--9--

   SELECT CONCAT(e.[FirstName], ' ',e.[LastName]) AS [FullName]
		  , COUNT(r.[UserId]) AS [UsersCount]
     FROM [Employees] AS e
LEFT JOIN [Reports] AS r
       ON e.[Id] = r.[EmployeeId]
	WHERE e.[FirstName] IS NOT NULL
 GROUP BY CONCAT(e.[FirstName], ' ', e.[LastName])
 ORDER BY [UsersCount] DESC
		  , [FullName]

--10--

   SELECT CASE
			  WHEN d.[Name] IS NULL THEN 'None'
			  ELSE CONCAT (e.[FirstName], ' ', e.[LastName]) 
	      END AS [Employee]
		  , CASE
			  WHEN d.[Name] IS NULL THEN 'None'
			  ELSE d.[Name] 
	      END AS [Department]
		  , c.[Name] AS [Category]
		  , r.[Description] 
		  , FORMAT(r.[OpenDate], 'dd.MM.yyyy')
		  , s.[Label] AS [Status]
		  , u.[Name] AS [User]
     FROM [Reports] AS r
LEFT JOIN [Employees] AS e
	   ON r.[EmployeeId] = e.Id
LEFT JOIN [Departments] AS d
	   ON e.[DepartmentId] = d.[Id]
LEFT JOIN [Categories] AS c
	   ON r.[CategoryId] = c.[Id]
LEFT JOIN [Status] AS s
	   ON r.[StatusId] = s.[Id]
LEFT JOIN [Users] AS u
	   ON r.[UserId] = u.[Id]
 ORDER BY e.[FirstName] DESC
          , e.[LastName] DESC
		  , d.[Name]
		  , c.[Name]
		  , r.[Description]
		  , r.[OpenDate]
		  , s.[Label]

--11--

CREATE FUNCTION udf_HoursToComplete(@StartDate DATETIME2, @EndDate DATETIME2)
RETURNS INT 
BEGIN
	DECLARE @result INT
	SET  @result = DATEDIFF(hour, @StartDate, @EndDAte)
	IF(@result IS NULL)
	BEGIN
	      SET @result = 0
	END
	RETURN @result
END

SELECT dbo.udf_HoursToComplete(OpenDate, CloseDate) AS TotalHours
   FROM Reports

--12--

CREATE PROC usp_AssignEmployeeToReport(@EmployeeId INT, @ReportId INT) AS
BEGIN
		DECLARE @EmployeeCategoryId INT = (
										 SELECT e.[DepartmentId]
										   FROM [Employees] AS e
 										   WHERE e.[Id] = @EmployeeId
									       )
		
		DECLARE @ReportCategoryId INT = (
										  SELECT c.[DepartmentId]
										    FROM [Reports] AS r 
										    JOIN [Categories] AS c
											  ON r.[CategoryId] = c.[Id]
										   WHERE r.[Id] = @ReportId
									  )

		IF(@EmployeeCategoryId != @ReportCategoryId)
		BEGIN
				;THROW 51000, 'Employee doesn''t belong to the appropriate department!', 1
		END

		ELSE
		BEGIN
			UPDATE [Reports]
			   SET [EmployeeId] = @EmployeeId
			 WHERE [Id] = @ReportId
		END	
END
