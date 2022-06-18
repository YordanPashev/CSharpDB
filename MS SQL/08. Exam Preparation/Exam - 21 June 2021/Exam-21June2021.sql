--1--

CREATE TABLE [Cities](
                [Id] INT PRIMARY KEY IDENTITY
				, [Name] NVARCHAR (20) NOT NULL
				, [CountryCode] NVARCHAR (2) NOT NULL
)

CREATE TABLE [Hotels](
                [Id] INT PRIMARY KEY IDENTITY
				, [Name] NVARCHAR (30) NOT NULL
				, [CityId] INT FOREIGN KEY REFERENCES [Cities]([Id]) NOT NULL
				, [EmployeeCount] INT NOT NULL
				, [BaseRate] DECIMAL (18,2)
)

CREATE TABLE [Rooms](
                [Id] INT PRIMARY KEY IDENTITY
				, [Price] DECIMAL (18,2) NOT NULL
				, [Type] NVARCHAR (20) NOT NULL
				, [Beds] INT NOT NULL
				, [HotelId] INT FOREIGN KEY REFERENCES [Hotels]([Id])NOT NULL
)

CREATE TABLE [Trips](
                [Id] INT PRIMARY KEY IDENTITY
				, [RoomId] INT FOREIGN KEY REFERENCES [Rooms]([Id])NOT NULL
				, [BookDate] DATE NOT NULL
				, [ArrivalDate] DATE NOT NULL
				, [ReturnDate] DATE NOT NULL
				, [CancelDate] DATE
				, CHECK ([BookDate] < [ArrivalDate])
				, CHECK ([ArrivalDate] < [ReturnDate])
)

CREATE TABLE [Accounts](
                [Id] INT PRIMARY KEY IDENTITY
				, [FirstName] NVARCHAR (50) NOT NULL
				, [MiddleName] NVARCHAR (20)
				, [LastName] NVARCHAR (50) NOT NULL
				, [CityId] INT FOREIGN KEY REFERENCES [Cities]([Id]) NOT NULL
				, [BirthDate] DATE NOT NULL
				, [Email] NVARCHAR (100) UNIQUE NOT NULL
)

CREATE TABLE [AccountsTrips](
                [AccountId] INT FOREIGN KEY REFERENCES [Accounts]([Id]) NOT NULL
				, [TripId] INT FOREIGN KEY REFERENCES [Trips]([Id]) NOT NULL
				, [Luggage] INT CHECK([Luggage] >= 0) NOT NULL
				, PRIMARY KEY ([AccountId], [TripId])
)

--2--

INSERT INTO [Accounts]([FirstName], [MiddleName], [LastName], [CityId], BirthDate, [Email])
     VALUES
	        ('John', 'Smith', 'Smith', 34, '1975-07-21', 'j_smith@gmail.com')
			, ('Gosho', NULL, 'Petrov', 11, '1978-05-16', 'g_petrov@gmail.com')
			, ('Ivan', 'Petrovich', 'Pavlov', 59, '1849-09-26', 'i_pavlov@softuni.bg')
			, ('Friedrich', 'Wilhelm', 'Nietzsche', 2, '1844-10-15', 'f_nietzsche@softuni.bg')

INSERT INTO [Trips]([RoomId], [BookDate], [ArrivalDate], [ReturnDate], [CancelDate])
     VALUES 
	        (101, '2015-04-12', '2015-04-14', '2015-04-20', '2015-02-02')
			, (102, '2015-07-07', '2015-07-15', '2015-07-22', '2015-04-29')
			, (103, '2013-07-17', '2013-07-23', '2013-07-24', NULL)
			, (104, '2012-03-17', '2012-03-31', '2012-04-01', '2012-01-10')
			, (109, '2017-08-07', '2017-08-28', '2017-08-29', NULL)

--3--

UPDATE [Rooms]
   SET [Price] = [Price] * 1.14
 WHERE [HotelId] IN (5, 7, 9)

--4--

DELETE FROM [AccountsTrips]
	  WHERE [AccountId] = 47

--5--

   SELECT [FirstName]
          , [Lastname]
	      , FORMAT([BirthDate], 'MM-dd-yyyy') AS [BirthDate] 
	      , c.[Name] AS [Hometown]
		  , a.[Email]
     FROM [Accounts] AS a
LEFT JOIN [Cities] AS c
       ON a.[CityId] = c.[Id]
	WHERE SUBSTRING(a.[Email], 1, 1) = 'e'
 ORDER BY c.[Name]

 --6--

    SELECT c.[Name]
          , COUNT(c.[Name]) AS [Hotels]
     FROM [Hotels] AS h
LEFT JOIN [Cities] AS c
       ON h.[CityId] = c.[Id]
 GROUP BY c.[Name]
 ORDER BY [Hotels] DESC
		  , c.[Name]

--7--

    SELECT a.[Id] AS [AccountId]
	       , CONCAT(a.[FirstName], ' ', a.[LastName]) AS [FullName]
		   , MAX(DATEDIFF(DAY, t.[ArrivalDate], t.[ReturnDate])) AS [LongestTrip]
           , MIN(DATEDIFF(DAY, t.[ArrivalDate], t.[ReturnDate])) AS [ShortestTrip]
      FROM [Trips] AS t
 LEFT JOIN [AccountsTrips] AS [at]
        ON t.[Id] = at.[TripId]
 LEFT JOIN [Accounts] AS a
        ON [at].[AccountId] = a.[Id]
     WHERE [MiddleName] IS NULL
	   AND t.[CancelDate] IS NULL
	   AND [at].[AccountId] IS NOT NULL
  GROUP BY a.[Id], a.[FirstName], a.[LastName]
  ORDER BY [LongestTrip] DESC
           , [ShortestTrip]

--8--

   SELECT TOP (10)
          c.[Id]
          , c.[Name] AS [City]
		  , c.[CountryCode] AS [Country]
          , ga.[Accounts] AS [Accounts]
     FROM [Cities] AS c
LEFT JOIN (  SELECT a.[CityId]
                    , COUNT(a.[Id]) AS [Accounts]
               FROM [Accounts] AS a
		  GROUP BY a.[CityId]
		  ) AS ga
       ON c.[Id] = ga.[CityId]
 ORDER BY ga.[Accounts] DESC

--9--

   SELECT a.[Id] 
          , a.[Email]
		  , c.[Name] AS [City]
		  , COUNT (a.[Email]) AS [Trips]
     FROM [Trips] AS t
LEFT JOIN [Rooms] AS r
       ON t.[RoomId] = r.[Id]
LEFT JOIN [Hotels] AS h
       ON r.[HotelId] = h.[Id]
LEFT JOIN [AccountsTrips] AS ac
       ON t.[Id] = ac.[TripId]
LEFT JOIN [Accounts] AS a
       ON ac.[AccountId] = a.[Id]
LEFT JOIN [Cities] AS c
       ON a.[CityId] = c.[Id]
    WHERE a.[CityId] = h.[CityId]
 GROUP BY a.[Id], a.[Email], c.[Name]
 ORDER BY [Trips] DESC
          , a.[Id]

--10--

   SELECT t.[Id]
          , CASE
		      WHEN a.[MiddleName] IS NOT NULL THEN CONCAT(a.[FirstName], ' ',a.[MiddleName], ' ',  a.[LastName]) 
			  ELSE CONCAT(a.[FirstName], ' ',  a.[LastName]) 
			END AS [Full Name]
 		  , aht.[Name] AS [From]
		  , hc.[Name] AS [To]
		  , CASE
				 WHEN t.[CancelDate] IS NULL THEN CAST(CONCAT(DATEDIFF(DAY, t.[ArrivalDate], t.[ReturnDate]), ' days') AS NVARCHAR)
				 ELSE 'Canceled'
			END AS [Duration]
     FROM [Trips] AS t
LEFT JOIN [Rooms] AS r
       ON t.[RoomId] = r.[Id]
LEFT JOIN [Hotels] AS h
       ON r.[HotelId] = h.[Id]
LEFT JOIN [AccountsTrips] AS ac
       ON t.[Id] = ac.[TripId]
LEFT JOIN [Accounts] AS a
       ON ac.[AccountId] = a.[Id]
LEFT JOIN [Cities] AS aht
       ON a.[CityId] = aht.[Id]
LEFT JOIN [Cities] AS hc
       ON h.[CityId] = hc.[Id]
	WHERE a.[Id] IS NOT NULL
ORDER BY [Full Name] 
         , t.[Id]

--11--

CREATE FUNCTION udf_GetAvailableRoom (@HotelId INT , @Date DATE, @People INT)
RETURNS NVARCHAR (100)
BEGIN
      DECLARE @RoomId INT 
      DECLARE @Type NVARCHAR (20)
      DECLARE @Beds INT 
	  DECLARE @TotalPrice DECIMAl (18,2)

	  DECLARE @resultRoomInfo TABLE(
									[RoomId] INT 
									, [RoomType] NVARCHAR (20)
									, [TotalPrice] DECIMAl (18,2)
									, [Beds] INT
	  )

	  INSERT INTO @resultRoomInfo([RoomId], [RoomType], [TotalPrice], [Beds])
	   SELECT TOP (1)
				  r.[Id]
				  , r.[Type]
				  , (h.[BaseRate] + r.[Price]) * @People 
				  , r.[Beds]
			 FROM [Rooms] AS r
		LEFT JOIN [Trips] AS t
		       ON r.[Id] = t.[RoomId]
		LEFT JOIN [Hotels] AS h
		       ON r.[HotelId] = h.[Id]
		    WHERE h.[Id] = @HotelId
			  AND r.[Beds] >= @People
         ORDER BY r.[Price] DESC

		DECLARE @arrivalDate DATE = (SELECT TOP (1)
				  t.[ArrivalDate]
			 FROM [Rooms] AS r
		LEFT JOIN [Trips] AS t
		       ON r.[Id] = t.[RoomId]
		LEFT JOIN [Hotels] AS h
		       ON r.[HotelId] = h.[Id]
		    WHERE h.[Id] = @HotelId
			  AND r.[Beds] >= @People
         ORDER BY r.[Price] DESC
		 )

		 DECLARE @returnDate DATE = (SELECT TOP (1)
				  t.[ReturnDate]
			 FROM [Rooms] AS r
		LEFT JOIN [Trips] AS t
		       ON r.[Id] = t.[RoomId]
		LEFT JOIN [Hotels] AS h
		       ON r.[HotelId] = h.[Id]
		    WHERE h.[Id] = @HotelId
			  AND r.[Beds] >= @People
         ORDER BY r.[Price] DESC
		 )

        SET @RoomId = (SELECT TOP(1) [RoomId] FROM @resultRoomInfo)
		SET @Type = (SELECT TOP(1) [RoomType] FROM @resultRoomInfo)
		SET @TotalPrice = (SELECT TOP(1) [TotalPrice] FROM @resultRoomInfo)
		SET @Beds = (SELECT TOP(1) [Beds] FROM @resultRoomInfo)

		DECLARE @result NVARCHAR (250)

		IF(@Date BETWEEN @arrivalDate and @returnDate OR @RoomId IS NULL)
		BEGIN
			SET @result = 'No rooms available'
		END

		ELSE
		BEGIN
			SET @result = CONCAT('Room ', @RoomId, ': ', @Type, ' (', @Beds, ' beds', ') - $', @TotalPrice)
		END

		RETURN @result
END

--12--

CREATE PROC usp_SwitchRoom (@TripId INT, @TargetRoomId INT) AS
BEGIN
		DECLARE @TripHotelId INT = (
		                        SELECT TOP (1)
								       r.HotelId 
							      FROM [Rooms] AS r
	                         LEFT JOIN [Trips] AS t
	                                ON r.[Id] = t.[RoomId]
		                         WHERE t.[Id] = @TripId
		 )

		 DECLARE @TargetRoomHotelId INT = (
		                        SELECT TOP (1)
									   r.HotelId 
							      FROM [Rooms] AS r
								 WHERE r.[Id] = @TargetRoomId
		 )

		 DECLARE @currentRoomBedsCount INT = (
		                        SELECT COUNT(*)
							      FROM [AccountsTrips] AS a
	                             WHERE a.[TripId] = @TripId
		 )

		 DECLARE @newRoomBedsCount INT = (
		                        SELECT TOP (1)
									   r.[Beds] 
							      FROM [Rooms] AS r
								 WHERE r.[Id] = @TargetRoomId
		 )

		

		 IF(@currentRoomBedsCount > @newRoomBedsCount)
		 BEGIN
				; THROW 50001, 'Not enough beds in target room!', 1
		 END

		 ELSE IF(@TripHotelId = @TargetRoomHotelId)
		 BEGIN
			UPDATE [Trips]
			   SET [RoomId] = @TargetRoomId
			 WHERE [Id] = @TripId
		 END

		 ELSE
		 BEGIN
			   ; THROW 50002, 'Target room is in another hotel!', 1
		 END
END