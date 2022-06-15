--1--

CREATE TABLE Sizes(
				  [Id] INT PRIMARY KEY IDENTITY
				  , [Length] INT NOT NULL
				  CHECK ([Length] BETWEEN 10 AND 25)
				  , [RingRange] DECIMAL(3,2) NOT NULL
				  CHECK ([RingRange] BETWEEN 1.5 AND 7.5)
                  )

CREATE TABLE Tastes(
				  [Id] INT PRIMARY KEY IDENTITY
				  , [TasteType] NVARCHAR (20) NOT NULL
				  , [TasteStrength] NVARCHAR (20) NOT NULL
				  , [ImageURL] NVARCHAR (100) NOT NULL			  
                  )

CREATE TABLE Brands(
				  [Id] INT PRIMARY KEY IDENTITY
				  , [BrandName] NVARCHAR (30) UNIQUE NOT NULL
				  , [TasteStrength] NVARCHAR (20) 
				  , [BrandDescription] NVARCHAR (MAX) 	  
                  )

CREATE TABLE Cigars(
				  [Id] INT PRIMARY KEY IDENTITY
				  , [CigarName] NVARCHAR (80) NOT NULL
				  , [BrandId] INT NOT NULL
				  , [TastId] INT NOT NULL
				  , [SizeId] INT NOT NULL
				  , [PriceForSingleCigar] DECIMAL (8,2) NOT NULL
				  , [ImageURL] NVARCHAR (100) NOT NULL
				  , FOREIGN KEY ([BrandId]) REFERENCES [Brands]([Id])
				  , FOREIGN KEY ([TastId]) REFERENCES [Tastes]([Id])
				  , FOREIGN KEY ([SizeId]) REFERENCES [Sizes]([Id])
                  )

CREATE TABLE Addresses(
				  [Id] INT PRIMARY KEY IDENTITY
				  , [Town] NVARCHAR (30) UNIQUE NOT NULL
				  , [Country] NVARCHAR (30) NOT NULL
				  , [Streat] NVARCHAR (100) NOT NULL
				  , [ZIP] NVARCHAR (20) NOT NULL			  
				  )

CREATE TABLE Clients(
				  [Id] INT PRIMARY KEY IDENTITY
				  , [FirstName] NVARCHAR (30) NOT NULL
				  , [LastName] NVARCHAR (30) NOT NULL
				  , [Email] NVARCHAR (50) NOT NULL
				  , [AddressId] INT NOT NULL	
				  , FOREIGN KEY ([AddressId]) REFERENCES [Addresses]([Id])
                  )

CREATE TABLE ClientsCigars(
				  [ClientId] INT FOREIGN KEY REFERENCES [Clients]([Id]) NOT NULL
				  , [CigarId] INT  FOREIGN KEY REFERENCES [Cigars]([Id]) NOT NULL
				  , PRIMARY KEY ([ClientId], [CigarId])
				  ) 

--2--

INSERT INTO [Cigars]([CigarName], [BrandId], [TastId], [SizeId], [PriceForSingleCigar], [ImageURL])
	 VALUES
			('COHIBA ROBUSTO', 9, 1, 5, 15.50, 'cohiba-robusto-stick_18.jpg')
			, ('COHIBA SIGLO I', 9, 1, 10, 410.00, 'cohiba-siglo-i-stick_12.jpg')
			, ('HOYO DE MONTERREY LE HOYO DU MAIRE', 14, 5, 11, 7.50, 'hoyo-du-maire-stick_17.jpg')
			, ('HOYO DE MONTERREY LE HOYO DE SAN JUAN', 14, 4, 15, 32.00, 'hoyo-de-san-juan-stick_20.jpg')			
			, ('TRINIDAD COLONIALES', 2, 3, 8, 85.21, 'trinidad-coloniales-stick_30.jpg')

INSERT INTO [Addresses]([Town], [Country], [Streat], [ZIP])
	 VALUES
			('Sofia', 'Bulgaria', '18 Bul. Vasil levski', 1000)
			, ('Athens', 'Greece', '4342 McDonald Avenue', 10435)
			, ('Zagreb', 'Croatia', '4333 Lauren Drive', 10000)

--3--

UPDATE [Cigars]
   SET [PriceForSingleCigar] = PriceForSingleCigar * 1.2
 WHERE [TastId] = 1

 UPDATE [Brands]
    SET [BrandDescription] = 'New description'
  WHERE [BrandDescription] IS NULL

--4--

DELETE [Clients]
 WHERE [AddressId] IN (SELECT Id 
					   FROM [Addresses] AS a
					  WHERE a.[Country] LIKE 'C%'
					 )
DELETE [Addresses]
 WHERE [Country] LIKE 'C%'

--5--

  SELECT [CigarName]
	     , [PriceForSingleCIgar]
	     , [ImageURL]
    FROM [Cigars]
ORDER BY [PriceForSingleCigar]
         , [CigarName] DESC

--6--

  SELECT c.[Id]  
		 , c.[CigarName]
	     , c.[PriceForSingleCIgar]
		 , t.[TasteType]
		 , t.TasteStrength
    FROM [Cigars] AS c
	JOIN [Tastes] AS t
	  ON c.[TastId] = t.[Id]
   WHERE t.[TasteType] IN ('Earthy', 'Woody')
ORDER BY c.[PriceForSingleCigar] DESC

--7-- 

   SELECT c.[Id] AS [Id]
          , CONCAT(c.[FirstName], ' ', c.[LastName]) AS [ClientName]
	      , c.[Email]
     FROM [Clients] AS c
LEFT JOIN [ClientsCigars] AS cc
       ON c.[Id] = cc.[ClientId]
    WHERE cc.[CigarId] IS NULL
 ORDER BY [ClientName]

 --8--

   SELECT TOP (5) 
		  c.[CigarName]
		  , c.[PriceForSingleCigar]
		  , c.[ImageURL]
     FROM [Cigars] AS c
LEFT JOIN [Sizes] AS s
	   ON c.[SizeId] = s.[Id] 
    WHERE s.[Length] >= 12 
	  AND (c.CigarName LIKE '%ci%'OR (c.[PriceForSingleCigar] > 50) 
	  AND s.[RingRange] > 2.55)
 ORDER BY c.[CigarName]
		  , c.[PriceForSingleCigar] DESC

--9--

   SELECT 
          CONCAT(cmec.[FirstName], ' ', cmec.[LastName]) AS [FullName]
		  , cmec.[Country]
		  , cmec.[ZIP]
		  , CONCAT('$', cmec.[PriceForSingleCigar]) AS [CigarPrice]
     FROM (
	    SELECT cl.[FirstName]
			   , cl.[LastName]
			   , c.[PriceForSingleCigar]
			   , a.[ZIP]
			   , a.[Country]
			   , DENSE_RANK () OVER (PARTITION BY cl.[Id] ORDER BY c.[PriceForSingleCigar] DESC) AS [MostExpCig]
	      FROM [Addresses] AS a
     LEFT JOIN [Clients] AS cl
	        ON a.[Id] = cl.[AddressId]
     LEFT JOIN [ClientsCigars] AS cc
            ON cl.[Id] = cc.[ClientId]
     LEFT JOIN [Cigars] AS c
	        ON cc.[CigarId] = c.[Id]
		 WHERE cl.[Id] IS NOT NULL
		   AND a.ZIP NOT LIKE '%[A-Z]%'
		   ) AS cmec
	 WHERE cmec.[MostExpCig] = 1
  ORDER BY [FullName]

--10--

        SELECT c.LastName
		       , AVG(s.[Length]) AS [CiagrLength]
		       , CEILING(AVG(s.[RingRange])) AS [CiagrRingRange]
		  FROM [ClientsCigars] AS cc
	      JOIN [Clients] AS c
            ON cc.[ClientId] = c.[Id]
	      JOIN [Cigars] AS ci
            ON cc.[CigarId] = ci.[Id]
	      JOIN [Sizes] AS s
            ON s.[Id] = ci.[SizeId]
         WHERE c.[Id] IN (SELECT [ClientId] FROM [ClientsCigars])
	  GROUP BY c.LastName
      ORDER BY AVG(s.[Length]) DESC

--11--

CREATE FUNCTION udf_ClientWithCigars(@name NVARCHAR(30))
RETURNS INT
BEGIN
		DECLARE @result INT

		SET @result = (SELECT COUNT(*)
		  FROM [ClientsCigars] AS cc
		  JOIN [Clients] AS cl
			ON cc.ClientId = cl.Id
		 WHERE cl.[Firstname] = @name
		 )

		 RETURN @result
END

--12--

CREATE PROC usp_SearchByTaste(@taste NVARCHAR (20)) AS
BEGIN
		SELECT c.[CigarName] 
		       , CONCAT('$', c.[PriceForSingleCigar]) AS [Price]
			   , t.[TasteType]
			   , b.[BrandName]
			   , CONCAT(s.[Length], ' ', 'cm') AS [CigarLength]
			   , CONCAT(s.[RingRange], ' ', 'cm') AS [CigarRingRange]
		  FROM [Tastes] AS t
		  JOIN [Cigars] AS c
		    ON t.[Id] = c.[TastId]
		  JOIN [Sizes] AS s
		    ON c.SizeId = s.[Id] 
		  JOIN [Brands] AS b
		    ON c.[BrandId] = b.[Id]
		 WHERE t.TasteType = @taste
	  ORDER BY s.[Length]
			   , s.[RingRange] DESC		
END
