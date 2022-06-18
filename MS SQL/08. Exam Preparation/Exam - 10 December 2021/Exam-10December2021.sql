--1--

CREATE TABLE [Passengers](
               [Id] INT PRIMARY KEY IDENTITY
			   , [FullName] NVARCHAR(100) UNIQUE NOT NULL
			   , [Email] NVARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE [Pilots](
               [Id] INT PRIMARY KEY IDENTITY
			   , [FirstName] NVARCHAR(30) UNIQUE NOT NULL
			   , [LastName] NVARCHAR(30) UNIQUE NOT NULL
			   , [Age] TINYINT CHECK ([Age] BETWEEN 21 AND 62) NOT NULL
			   , [Rating] FLOAT CHECK ([Rating] BETWEEN 0.0 AND 10.0) NOT NULL
)

CREATE TABLE [AircraftTypes](
               [Id] INT PRIMARY KEY IDENTITY
			   , [TypeName] NVARCHAR(30) UNIQUE NOT NULL
)

CREATE TABLE [Aircraft](
               [Id] INT PRIMARY KEY IDENTITY
			   , [Manufacturer] NVARCHAR(25) NOT NULL
			   , [Model] NVARCHAR (30) NOT NULL
			   , [Year] INT NOT NULL
			   , [FlightHours] INT 
			   , [Condition] NVARCHAR (1) NOT NULL
			   , [TypeId] INT FOREIGN KEY REFERENCES [AircraftTypes]([Id]) NOT NULL
)

CREATE TABLE [PilotsAircraft](
               [AircraftId] INT FOREIGN KEY REFERENCES [Aircraft]([Id]) NOT NULL
               , [PilotId] INT FOREIGN KEY REFERENCES [Pilots]([Id]) NOT NULL
			   , PRIMARY KEY ([AircraftId],[PilotId]) 
)

CREATE TABLE [Airports](
               [Id] INT PRIMARY KEY IDENTITY
			   , [AirportName] NVARCHAR(70) NOT NULL
			   , [Country] NVARCHAR(100) NOT NULL
)

CREATE TABLE [FlightDestinations](
               [Id] INT PRIMARY KEY IDENTITY
			   , [AirportId] INT FOREIGN KEY REFERENCES [Airports]([Id]) NOT NULL
			   , [Start] DATETIME2 NOT NULL
			   , [AircraftId] INT FOREIGN KEY REFERENCES [Aircraft]([Id]) NOT NULL
			   , [PassengerId] INT FOREIGN KEY REFERENCES [Passengers]([Id]) NOT NULL
			   , [TicketPrice] DECIMAL(18,2) DEFAULT 15 NOT NULL
)

--2--

INSERT INTO [Passengers] ([FullName], [Email])
	 SELECT CONCAT(p.[FirstName], ' ', p.[LastName]) 
		    , CONCAT(p.[FirstName], p.[LastName], '@gmail.com')
	   FROM [Pilots] AS p
	  WHERE p.[Id] BETWEEN 5 AND 15

--3--

UPDATE [Aircraft]
   SET [Condition] = 'A'
 WHERE ([Condition] = 'C' OR [Condition] = 'B')
   AND ([FlightHours] IS NULL OR [FlightHours] <= 100)
   AND [Year] >= 2013

--4--

DELETE FROM [Passengers]
	  WHERE LEN([FullName]) <= 10

--5--

  SELECT a.[Manufacturer]
         , a.[Model] 
         , a.[FlightHours]  
         , a.[Condition]  
    FROM [Aircraft] AS a
ORDER BY a.[FlightHours] DESC

--6--

   SELECT p.[FirstName]
		  , p.[LastName]
		  , a.[Manufacturer]
		  , a.[Model]
		  , a.[FlightHours]
     FROM [PilotsAircraft] AS pa
     JOIN [Aircraft] AS a
       ON pa.[AircraftId] = a.[Id] 
     JOIN [Pilots] AS p
       ON pa.[PilotId] = p.[Id]
    WHERE a.FlightHours IS NOT NULL
	  AND a.FlightHours < 304
 ORDER BY a.[FlightHours] DESC
          , p.[FirstName]

--7--

    SELECT TOP(20)
		   f.[Id]
		   , f.[Start]
		   , p.[FullName]
	       , a.[AirportName]
		   , f.[TicketPrice]
      FROM [FlightDestinations] AS f
 LEFT JOIN [Airports] AS a
        ON f.[AirportId] = a.[Id]
 LEFT JOIN [Passengers] AS p
        ON f.[PassengerId] = p.[Id]
	 WHERE DATEPART(DAY, f.[Start]) % 2 = 0
  ORDER BY f.[TicketPrice] DESC
           , a.AirportName

--8--

  SELECT ga.[AircraftId]
         , a.[Manufacturer]
		 , a.[FlightHours]
		 , ga.[FlightDestinationsCount]
		 , ga.[AvgPrice]
    FROM (
	         SELECT [AircraftId]
				    , ROUND(AVG(f.[TicketPrice]), 2) AS [AvgPrice]
				    , COUNT(*) AS [FlightDestinationsCount]
	           FROM [FlightDestinations] AS f
           GROUP BY [AircraftId] 
          ) AS ga
LEFT JOIN [Aircraft] AS a
       ON ga.[AircraftId] = a.[Id]
    WHERE ga.[FlightDestinationsCount] >= 2
 ORDER BY ga.[FlightDestinationsCount] DESC
          , ga.[AircraftId] 

--9--
    SELECT p.[FullName]
		   , gp.[CountOfAircraft]
	       , gp.[TotalPayed]
      FROM ( SELECT [PassengerId]
					, COUNT(f.[AircraftId]) AS [CountOfAircraft]
	                , SUM(f.[TicketPrice]) AS [TotalPayed]
	           FROM [FlightDestinations] as f
            GROUP BY PassengerId
		   ) AS gp
	  JOIN [Passengers] as p
	    ON gp.[PassengerId] = p.Id
	 WHERE SUBSTRING(p.[FullName], 2, 1) = 'a'
	   AND gp.[CountOfAircraft] > 1
  ORDER BY p.[FullName]

--10--

  SELECT a.[AirportName]
         , f.[Start] AS DayTime
		 , f.[TicketPrice]
		 , p.[FullName]
		 , ac.[Manufacturer]
		 , ac.[Model]
    FROM [FlightDestinations] AS f
    JOIN [Airports] AS a
      On a.[Id] = f.[AirportId]
    JOIN [Passengers] AS p
     ON f.[PassengerId] = p.[Id] 
    JOIN [Aircraft] AS ac
      On f.[AircraftId] = ac.[Id]
   WHERE DATEPART(HOUR, f.[Start]) BETWEEN 6 AND 20
     AND f.TicketPrice > 2500
ORDER BY ac.[Model]

--11--

CREATE FUNCTION udf_FlightDestinationsByEmail(@email NVARCHAR(50))
RETURNS INT
BEGIN

     DECLARE @result INT = (SELECT COUNT(*)
							  FROM [FlightDestinations] AS f
							  JOIN [Passengers] AS p
							    ON f.[PassengerId] = p.[Id]
						     WHERE p.[Email] = @email
						  GROUP BY f.[PassengerId]
						   )

	 IF(@result IS NULL)
	 BEGIN
          SET @result = 0
	 END

	 RETURN @result
END

--12--

CREATE PROC usp_SearchByAirportName(@airportName NVARCHAR (70)) AS
BEGIN

        DECLARE @airportId INT = ( SELECT a.[Id]
									 FROM [Airports] as a
								    WHERE a.[AirportName] = @airportName
								 )

		SELECT a.[AirportName]
		       , p.[FullName]
			   , CASE
			         WHEN f.[TicketPrice] <= 400 THEN 'Low' 
			         WHEN f.[TicketPrice] BETWEEN 401 AND 1500 THEN 'Medium' 
			         WHEN f.[TicketPrice] > 1500 THEN 'High' 
			     END AS [LevelOfTicketPrice]
			   , ac.[Manufacturer]
			   , ac.[Condition]
			   , [at].[TypeName]
		  FROM [FlightDestinations] AS f
		  JOIN [Airports] AS a
		    ON f.[AirportId] = a.[Id]
		  JOIN [Passengers] AS p
		    ON f.[PassengerId] = p.[Id]
		  JOIN [Aircraft] AS ac
		    ON f.[AircraftId] = ac.[Id]
		  JOIN [AircraftTypes] AS [at]
		    ON ac.[TypeId] = [at].[Id]
		 WHERE f.[AirportId] = @airportId
	  ORDER BY ac.[Manufacturer]
	           , p.[FullName]	  

END