CREATE DATABASE ColonialJourney

GO

USE ColonialJourney

--1--

CREATE TABLE [Planets](
			 [Id] INT PRIMARY KEY IDENTITY
			 , [Name] VARCHAR (30) NOT NULL
			 )

CREATE TABLE [Spaceports](
			 [Id] INT PRIMARY KEY IDENTITY
			 , [Name] VARCHAR (50) NOT NULL
			 , [PlanetId] INT NOT NULL
			 , FOREIGN KEY ([PlanetId]) REFERENCES [Planets]([Id])
			 )

CREATE TABLE [Spaceships](
			 [Id] INT PRIMARY KEY IDENTITY
			 , [Name] VARCHAR (50) NOT NULL
			 , [Manufacturer] NVARCHAR (30) NOT NULL
			 , [LightSpeedRate] INT DEFAULT 0
			 )

CREATE TABLE [Colonists](
			 [Id] INT PRIMARY KEY IDENTITY
			 , [FirstName] VARCHAR (20) NOT NULL
			 , [LastName] VARCHAR (20) NOT NULL
			 , [Ucn] VARCHAR (10) UNIQUE NOT NULL
			 , [BirthDate] DATE NOT NULL
			 )

CREATE TABLE [Journeys](
			 [Id] INT PRIMARY KEY IDENTITY
			 , [JourneyStart] DATETIME2 NOT NULL
			 , [JourneyEnd] DATETIME2 NOT NULL
			 , [Purpose] VARCHAR (11) NOT NULL
			   CHECK ([Purpose] = 'Medical' OR [Purpose] = 'Technical' OR
					  [Purpose] = 'Educational' OR [Purpose] = 'Military')
			 , [DestinationSpaceportId] INT NOT NULL
			 , [SpaceshipId] INT NOT NUll
			 , FOREIGN KEY ([DestinationSpaceportId]) REFERENCES [Spaceports]([Id])
			 , FOREIGN KEY ([SpaceshipId]) REFERENCES [Spaceships]([Id])
			 )

CREATE TABLE [TravelCards](
			 [Id] INT PRIMARY KEY IDENTITY
			 , [CardNumber] VARCHAR(10) NOT NULL UNIQUE
			 , [JobDuringJourney] VARCHAR (8)
			   CHECK ([JobDuringJourney] = 'Pilot' OR [JobDuringJourney] = 'Engineer' OR
					  [JobDuringJourney] = 'Trooper' OR [JobDuringJourney] = 'Cleaner' OR
					  [JobDuringJourney] = 'Cook')
			 , [ColonistId] INT NOT NULL
			 , [JourneyId] INT NOT NUll
			 , FOREIGN KEY ([ColonistId]) REFERENCES [Colonists]([Id])
			 , FOREIGN KEY ([JourneyId]) REFERENCES [Journeys]([Id])
			 )

--2--

INSERT INTO [Planets]([Name])
	 VALUES
		    ('Mars')
			, ('Earth')
			, ('Jupiter')
			, ('Saturn')

INSERT INTO [Spaceships]([Name], [Manufacturer], [LightSpeedRate])
	 VALUES
		    ('Golf', 'VW', 3)
			, ('WakaWaka', 'Wakanda', 4)
			, ('Falcon9', 'SpaceX', 1)
			, ('Bed', 'Vidolov', 6)

--3--

UPDATE [Spaceships]
   SET [LightSpeedRate] += 1
 WHERE [Id] BETWEEN 8 AND 12

 --4--

 DELETE FROM [TravelCards]
	  WHERE [JourneyId] BETWEEN 1 AND 3

DELETE FROM [Journeys]
	  WHERE [Id] BETWEEN 1 AND 3

--5--

   SELECT j.[Id]
	      , FORMAT(j.[JourneyStart], 'dd/MM/yyy')
	      , FORMAT(j.[JourneyEnd], 'dd/MM/yyyy')
     FROM [Journeys] AS j
    WHERE j.[Purpose] = 'Military' 
 ORDER BY j.[JourneyStart]

 --6--

  SELECT c.[Id]
	     , CONCAT(c.[FirstName], ' ', c.LastName) AS full_name
    FROM [Colonists] AS c
    JOIN [TravelCards] AS t
      ON c.[Id] = t.[ColonistId]
   WHERE t.[JobDuringJourney] = 'Pilot'
ORDER BY c.[Id]

--7--

  SELECT COUNT(*) AS [count]
    FROM [Colonists] AS c
    JOIN [TravelCards] AS t
      ON c.[Id] = t.[ColonistId]
	JOIN [Journeys] AS j
      ON t.[JourneyId] = j.[Id]
   WHERE j.[Purpose] = 'Technical'

 --8--

  SELECT s.[Name]
         , s.[Manufacturer]
    FROM [Colonists] AS c
    JOIN [TravelCards] AS t
      ON c.[Id] = t.[ColonistId]
	JOIN [Journeys] AS j
      ON t.[JourneyId] = j.[Id]
	JOIN [Spaceships] AS s
	  ON j.[SpaceshipId] = s.[Id]
   WHERE t.[JobDuringJourney] = 'Pilot'
     AND c.[BirthDate] > '1989.01.01'
ORDER BY s.[Name]

--9--

   SELECT p.[Name] AS [PlanetName]
		  , COUNT(p.[Id]) AS [JourneysCount]
     FROM [Planets] AS p
LEFT JOIN [Spaceports] as s
	   ON p.[Id] = s.[PlanetId]
LEFT JOIN [Journeys] as j
	   ON s.[Id] = j.[DestinationSpaceportId]
	WHERE j.[JourneyStart] IS NOT NULL
 GROUP BY p.[Name]
 ORDER BY COUNT(p.[Id]) DESC
		  , p.[Name]

--10--

  SELECT rjc.JobDuringJourney
         , rjc.FullName
 		 , rjc.[JobRank]
    FROM (
		   SELECT t.[JobDuringJourney] AS [JobDuringJourney]
				  , CONCAT(c.[FirstName], ' ', c.[LastName]) AS FullName
			      , DENSE_RANK() OVER (PARTITION BY t.[JobDuringJourney] ORDER BY c.[BirthDate]) AS [JobRank]
			 FROM [Colonists] AS c
		     JOIN [TravelCards] AS t
			   ON c.[Id] = t.[ColonistId]
		  ) AS rjc
	WHERE rjc.[JobRank] = 2

--11--
 
 CREATE FUNCTION dbo.udf_GetColonistsCount(@planetName VARCHAR (30))
 RETURNS INT
 BEGIN
   DECLARE @result INT 
   SET @result = (SELECT COUNT(*) AS [Count]
	 FROM Colonists AS c
LEFT JOIN [TravelCards] AS t
       ON c.[Id] = t.[ColonistId]
LEFT JOIN [Journeys] AS j
       ON t.JourneyId = j.[Id]
LEFT JOIN [Spaceports] AS s
       ON j.[DestinationSpaceportId] =s.[Id]
LEFT JOIN [Planets] AS p
       ON s.[PlanetId] = p.[Id]
 WHERE p.[Name] = @planetName
 )
 RETURN @result
 END

 --12--

CREATE OR ALTER PROC usp_ChangeJourneyPurpose(@JourneyId INT , @NewPurpose VARCHAR(11)) AS
BEGIN 

	IF NOT EXISTS (
	   SELECT j.[Purpose]
		 FROM [Journeys] AS j
	    WHERE j.[Id] = @JourneyId
		 )
	BEGIN 
		;THROW 51000, 'The journey does not exist!', 1
	END 

    ELSE
	BEGIN
	 IF EXISTS(
	   SELECT j.[Purpose]
		 FROM [Journeys] AS j
		WHERE j.[Id] = @JourneyId AND j.[Purpose] = @NewPurpose 
		 )
		 BEGIN
			;THROW 51000, 'You cannot change the purpose!', 2
		 END
	  ELSE 
	  BEGIN
			UPDATE [Journeys]
		   	   SET [Purpose] = @NewPurpose
		     WHERE [Id] = @JourneyId
	  END
	END	  
END





