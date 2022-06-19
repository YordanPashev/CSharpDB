--1--

CREATE TABLE [Countries](
                [Id] INT PRIMARY KEY IDENTITY
				, [Name] NVARCHAR (50) UNIQUE
)

CREATE TABLE [Customers](
                [Id] INT PRIMARY KEY IDENTITY
				, [FirstName] NVARCHAR (25) 
				, [LastName] NVARCHAR (25) 
				, [Gender] VARCHAR (1) CHECK ([Gender] IN ('M', 'F'))
				, [Age] INT
				, [PhoneNumber] NVARCHAR (10) CHECK(LEN([PhoneNumber]) = 10)
				, [CountryId] INT FOREIGN KEY REFERENCES [Countries]([Id]) 
)

CREATE TABLE [Products](
                [Id] INT PRIMARY KEY IDENTITY
				, [Name] NVARCHAR (25) UNIQUE
				, [Description] NVARCHAR (250) 
				, [Recipe] NVARCHAR (MAX)
				, [Price] DECIMAL (18,2) CHECK ([Price] > 0.00)
)

CREATE TABLE [Feedbacks](
                [Id] INT PRIMARY KEY IDENTITY
				, [Description] NVARCHAR (255)
				, [Rate] DECIMAL (18,2) CHECK ([Rate] BETWEEN 0.00 AND 10.00)
				, [ProductId] INT FOREIGN KEY REFERENCES [Products]([Id]) 
				, [CustomerId] INT FOREIGN KEY REFERENCES [Customers]([Id]) 
)

CREATE TABLE [Distributors](
                [Id] INT PRIMARY KEY IDENTITY
				, [Name] NVARCHAR (25) UNIQUE
				, [AddressText] NVARCHAR (30)
				, [Summary] NVARCHAR (200)
				, [CountryId] INT FOREIGN KEY REFERENCES [Countries]([Id]) 
)

CREATE TABLE [Ingredients](
                [Id] INT PRIMARY KEY IDENTITY
				, [Name] NVARCHAR (30) 
				, [Description] NVARCHAR (200) 
				, [OriginCountryId] INT FOREIGN KEY REFERENCES [Countries]([Id]) 
				, [DistributorId] INT FOREIGN KEY REFERENCES [Distributors]([Id]) 			
)

CREATE TABLE [ProductsIngredients](
                [ProductId] INT FOREIGN KEY REFERENCES [Products]([Id]) 
				, [IngredientId] INT FOREIGN KEY REFERENCES [Ingredients]([Id]) 
				, PRIMARY KEY ([ProductId], [IngredientId])
)

--2--

INSERT INTO [Distributors]([Name], [CountryId], [AddressText], [Summary])
     VALUES
	        ('Deloitte & Touche', 2, '6 Arch St #9757', 'Customizable neutral traveling')
			, ('Congress Title', 13, '58 Hancock St', 'Customer loyalty')
			, ('Kitchen People', 1, '3 E 31st St #77', 'Triple-buffered stable delivery')
			, ('General Color Co Inc', 21, '6185 Bohn St #72', 'Focus group')
			, ('Beck Corporation', 23, '21 E 64th Ave', 'Quality-focused 4th generation hardware')

INSERT INTO [Customers]([FirstName], [LastName], [Age], [Gender], [PhoneNumber], [CountryId])
     VALUES
	        ('Francoise', 'Rautenstrauch', 15, 'M', '0195698399', 5)
	        , ('Kendra', 'Loud', 22, 'F', '0063631526', 11)	
	        , ('Lourdes', 'Bauswell', 50, 'M', '0139037043', 8)	
	        , ('Hannah', 'Edmison', 18, 'F', '0043343686', 1)					
	        , ('Tom', 'Loeza', 31, 'M', '0144876096', 23)					
	        , ('Queenie', 'Kramarczyk', 30, 'F', '0064215793', 29)					
	        , ('Hiu', 'Portaro', 25, 'M', '0068277755', 16)					
	        , ('Josefa', 'Opitz', 43, 'F', '0197887645', 17)					
			
--3--

UPDATE [Ingredients]
   SET [DistributorId] = 35
 WHERE [Name] IN ('Bay Leaf', 'Paprika', 'Poppy')

UPDATE [Ingredients]
   SET [OriginCountryId] = 14
 WHERE [OriginCountryId] = 8 

--4--

 DELETE FROM [Feedbacks]
       WHERE [CustomerId] = 14 OR [ProductId] = 5

--5--

  SELECT p.[Name]
	     , p.[Price] 
	     , p.[Description] 
    FROM [Products] AS p
ORDER BY p.[Price] DESC
         , p.[Name]

--6--

   SELECT f.[ProductId]
		  , f.[Rate]
		  , f.[Description]
		  , c.[Id]
		  , c.[Age]
		  , c.[Gender]
     FROM [Feedbacks] AS f
LEFT JOIN [Customers] AS c
       ON f.[CustomerId] = c.[Id]
	WHERE f.[Rate] < 5.00
 ORDER BY f.[ProductId] DESC
          , f.[Rate]

--7--

   SELECT CONCAT(c.[FirstName], ' ', c.[LastName]) 
		  , c.[PhoneNumber]
		  , c.[Gender]
    FROM  [Customers] AS c
    WHERE c.[Id] NOT IN (SELECT f.[CustomerId] 
						   FROM [Feedbacks] AS f)
 ORDER BY c.[Id] 

 --8--

    SELECT c.[FirstName]
	      , c.[Age]
		  , c.[PhoneNumber]
      FROM [Customers] c
 LEFT JOIN [Countries] AS cn
        ON c.[CountryId] = cn.[Id]
     WHERE (c.[Age] >= 21 AND c.[FirstName] LIKE '%an%')
	    OR (c.[PhoneNumber] LIKE '%38' AND cn.[Name] <> 'Greece') 
 ORDER BY c.[FirstName] 
          , c.[Age] DESC

--9--

   SELECT d.name [DistributorName]
		  , i.Name AS [IngredientName]
		  , p.Name AS [ProductName]
		  , AVG(f.Rate) AS [AverageRate]
     FROM [Ingredients] AS i
LEFT JOIN [Distributors] AS d
       ON i.[DistributorId] = d.Id
LEFT JOIN [ProductsIngredients] as [pi]
       ON i.[Id] = [pi].[IngredientId]
LEFT JOIN [Products] AS p
       ON [pi].[ProductId] = p.[Id]
LEFT JOIN [Feedbacks] AS f
       ON p.[Id] = f.[ProductId]
 GROUP BY d.[Name], i.[Name], p.[Name]
   HAVING AVG(f.Rate) BETWEEN 5 AND 8
 ORDER BY d.[Name]
          , i.[Name]
		  , p.[Name]

--10--

SELECT din.[CountryName], din.[DisributorName]
FROM (SELECT c.[Name] AS [CountryName]
	   , d.[Name] AS [DisributorName]
	   , RANK() OVER (PARTITION BY c.[Name] ORDER BY COUNT(i.Name) DESC)  AS [DistributorsRank] 
FROM [Countries] AS c
LEFT JOIN [Distributors] AS d
ON d.[CountryId] = c.Id
LEFT JOIN [Ingredients] AS i
      ON d.Id = i.[DistributorId]
	  GROUP BY c.[Name], d.[Name]
	) AS din
WHERE [DistributorsRank] = 1
ORDER BY din.[CountryName], din.[DisributorName]

--11--

CREATE VIEW v_UserWithCountries AS
   SELECT CONCAT(c.[FirstName], ' ', c.[LastName]) AS [CustomerName]
		  , c.[Age]
		  , c.[Gender]
		  , cn.[Name] AS [CountryName]
	 FROM [Customers] AS c
LEFT JOIN [Countries] AS cn
	    ON c.[CountryId] = cn.[Id]


		SELECT TOP 5 *
  FROM v_UserWithCountries
 ORDER BY Age