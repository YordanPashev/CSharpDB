--1--

CREATE TABLE[Owners](
               [Id] INT PRIMARY KEY IDENTITY
			   , [Name] VARCHAR (50) NOT NULL
			   , [PhoneNumber] VARCHAR (15) NOT NULL
			   , [Address] VARCHAR (50) 
)

CREATE TABLE[AnimalTypes](
               [Id] INT PRIMARY KEY IDENTITY
			   , [AnimalType] VARCHAR (30) NOT NULL
)


CREATE TABLE[Cages](
               [Id] INT PRIMARY KEY IDENTITY
			   , [AnimalTypeId] INT FOREIGN KEY REFERENCES [AnimalTypes]([Id]) NOT NULL
)


CREATE TABLE[Animals](
               [Id] INT PRIMARY KEY IDENTITY
			   , [Name] VARCHAR (30) NOT NULL
			   , [BirthDate] DATE NOT NULL
			   , [OwnerId] INT FOREIGN KEY REFERENCES [Owners]([Id]) 
			   , [AnimalTypeId] INT FOREIGN KEY REFERENCES [AnimalTypes]([Id]) NOT NULL
)


CREATE TABLE[AnimalsCages](
               [CageId] INT FOREIGN KEY REFERENCES [Cages]([Id]) NOT NULL
			   , [AnimalId] INT FOREIGN KEY REFERENCES [Animals]([Id]) NOT NULL
			   , PRIMARY KEY ([CageId], [AnimalId])
)


CREATE TABLE[VolunteersDepartments](
               [Id] INT PRIMARY KEY IDENTITY
			   , [DepartmentName] VARCHAR (30) NOT NULL
)


CREATE TABLE[Volunteers](
               [Id] INT PRIMARY KEY IDENTITY
			   , [Name] VARCHAR (50) NOT NULL
			   , [PhoneNumber] VARCHAR (15) NOT NULL
			   , [Address] VARCHAR (50)
			   , [AnimalId] INT FOREIGN KEY REFERENCES [Animals]([Id]) 
			   , [DepartmentId] INT FOREIGN KEY REFERENCES [VolunteersDepartments]([Id]) NOT NULL		   
)




--2-- 

INSERT INTO [Volunteers]([Name], [PhoneNumber], [Address], [AnimalId], [DepartmentId])
     VALUES
	        ('Anita Kostova', '0896365412', 'Sofia, 5 Rosa str.', 15, 1)
			, ('Dimitur Stoev', '0877564223', NULL, 42, 4)
			, ('Kalina Evtimova', '0896321112', 'Silistra, 21 Breza str.', 9, 7)
			, ('Stoyan Tomov', '0898564100', 'Montana, 1 Bor str.', 18, 8)
			, ('Boryana Mileva', '0888112233', NULL, 31, 5)

INSERT INTO [Animals]([Name], [BirthDate], [OwnerId], [AnimalTypeId])
     VALUES
	        ('Giraffe', '2018-09-21', 21, 1)
			, ('Harpy Eagle', '2015-04-17', 15, 3)
			, ('Hamadryas Baboon', '2017-11-02', NULL, 1)
			, ('Tuatara', '2021-06-30', 2, 4)

--3--

UPDATE [Animals]
   SET [OwnerId] = 4
 WHERE [OwnerId] IS NULL

 --4--

 SELECT * FROM [VolunteersDepartments]
 SELECT * FROM [Volunteers]

 DELETE FROM [Volunteers]
       WHERE [DepartmentId] = 2

 DELETE FROM [VolunteersDepartments]
       WHERE [Id] = 2

--5--

  SELECT v.[Name]
         , v.[PhoneNumber]
		 , v.[Address]
		 , v.[AnimalId]
		 , v.[DepartmentId]
    FROM [Volunteers] AS v
ORDER BY v.[Name]
         , v.[AnimalId]
         , v.[DepartmentId]

--6--

   SELECT a.[Name]
          , [at].[AnimalType]
		  , FORMAT([BirthDate], 'dd.MM.yyyy')
     FROM [Animals] as a
LEFT JOIN [AnimalTypes] AS [at]
       ON a.[AnimalTypeId] = [at].[Id]
 ORDER BY a.[Name]

--7--

SELECT TOP (5) 
		       o.[Name] AS [Owner]
	           , COUNT(a.[Name]) AS [CountOfAnimals]
          FROM [Owners] AS o 
     LEFT JOIN [Animals] AS a
            ON o.[Id] = a.[OwnerId]
      GROUP BY o.[Name]	
	  ORDER BY [CountOfAnimals] DESC

--8--

   SELECT CONCAT(o.[Name], '-', a.[Name]) AS OwnersAnimals
          , o.[PhoneNumber]
		  , ac.[CageId] AS CageId
     FROM [Animals] AS a
     JOIN [Owners] AS o
	   ON a.[OwnerId] = o.[Id]
     JOIN [AnimalsCages] AS ac
       ON a.[Id] = ac.[AnimalId]
     JOIN [AnimalTypes] AS [at]
       ON a.[AnimalTypeId] = [at].[Id]
    WHERE [at].[AnimalType] = 'mammals' 
 ORDER BY o.[Name]    
          , a.[Name] DESC

--9--

   SELECT v.[Name]
          , v.[PhoneNumber]
		  , CASE 
				WHEN v.[Address] LIKE '%Sofia,%' THEN TRIM(REPLACE((v.[Address]), 'Sofia,', ''))
				WHEN v.[Address] LIKE '%Sofia ,%' THEN TRIM(REPLACE((v.[Address]), 'Sofia ,', '')) 
		  END AS [AnimalType]
     FROM [Volunteers] AS v
LEFT JOIN [VolunteersDepartments] AS vd
       ON v.[DepartmentId] = vd.[Id]
    WHERE vd.[DepartmentName] = 'Education program assistant'
	  AND v.Address LIKE '%Sofia%'
 ORDER BY v.Name

--10--

    SELECT a.[Name]
	       , DATEPART(YEAR, a.[BirthDate])
		   , [at].[AnimalType]
      FROM [Animals] AS a
 LEFT JOIN [AnimalTypes] AS [at]
        ON a.[AnimalTypeId] = [at].Id
     WHERE a.OwnerId IS NULL 
	   AND BirthDate > '01.01.2018'
	   AND [at].AnimalType <> 'Birds'
  ORDER BY a.[Name]

--11--
GO

CREATE FUNCTION udf_GetVolunteersCountFromADepartment (@VolunteersDepartment VARCHAR (30))
RETURNS INT
BEGIN
      DECLARE @result INT = ( SELECT COUNT(*) AS [CountOfVolunteers]
							FROM [Volunteers] AS v
					   LEFT JOIN [VolunteersDepartments] AS vd
					          ON v.[DepartmentId] = vd.[Id]							
						   WHERE vd.[DepartmentName] = @VolunteersDepartment
						   )

	  RETURN @result
END	  
	  
--12--
Go

CREATE PROC usp_AnimalsWithOwnersOrNot(@AnimalName VARCHAR (30)) AS
BEGIN
		   SELECT a.[Name]
		          , CASE
						WHEN o.[Id] IS NULL THEN 'For adoption'
						ELSE o.[Name]
				    END AS [OwnersName]
		     FROM [Animals] AS a
		LEFT JOIN [Owners] as o
			   ON a.[OwnerId] = o.[Id]
			WHERE a.[Name] = @AnimalName
END

