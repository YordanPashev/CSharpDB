--1--

CREATE TABLE [Users](
			         [Id] INT PRIMARY KEY IDENTITY
					 , [Username] VARCHAR(30) NOT NULL
					 , [Password] VARCHAR(30) NOT NULL
					 , [Email] NVARCHAR(50) NOT NULL
)

CREATE TABLE [Repositories](
			         [Id] INT PRIMARY KEY IDENTITY
					 , Name VARCHAR(50) NOT NULL
)

CREATE TABLE [RepositoriesContributors](
			         [RepositoryId] INT FOREIGN KEY REFERENCES [Repositories]([Id]) NOT NULL
					 , [ContributorId] INT FOREIGN KEY REFERENCES [Users]([Id]) NOT NULL
					 , PRIMARY KEY ([RepositoryId], [ContributorId])
)

CREATE TABLE [Issues](
			         [Id] INT PRIMARY KEY IDENTITY
					 , [Title] VARCHAR(255) NOT NULL
					 , [IssueStatus] VARCHAR(6) 
					 , [RepositoryId] INT FOREIGN KEY REFERENCES [Repositories]([Id]) NOT NULL
					 , [AssigneeId] INT FOREIGN KEY REFERENCES [Users]([Id]) NOT NULL
)

CREATE TABLE [Commits](
			         [Id] INT PRIMARY KEY IDENTITY
					 , [Message] VARCHAR(255) NOT NULL
					 , [IssueId] INT FOREIGN KEY REFERENCES [Issues]([Id]) 
					 , [RepositoryId] INT FOREIGN KEY REFERENCES [Repositories]([Id]) NOT NULL
					 , [ContributorId] INT FOREIGN KEY REFERENCES [Users]([Id]) NOT NULL
)

CREATE TABLE [Files](
			         [Id] INT PRIMARY KEY IDENTITY
					 , [Name] VARCHAR(100) NOT NULL
					 , [Size] DECIMAL(18,2) NOT NULL
					 , [ParentId] INT FOREIGN KEY REFERENCES [Files]([Id]) 
					 , [CommitId] INT FOREIGN KEY REFERENCES [Commits]([Id]) NOT NULL
)

--2--

INSERT INTO [Files]([Name], [Size], [ParentId], [CommitId])
     VALUES 
	      ('Trade.idk', 2598.0, 1, 1)
		  , ('menu.net', 9238.31, 2, 2)
		  , ('Administrate.soshy', 1246.93, 3, 3)
		  , ('Controller.php', 7353.15, 4, 4)
		  , ('Find.java', 9957.86, 5, 5)
		  , ('Controller.json', 14034.87, 3, 6)
		  , ('Operate.xix', 7662.92, 7, 7)

INSERT INTO Issues([Title], [IssueStatus], [RepositoryId], [AssigneeId])
     VALUES 
	      ('Critical Problem with HomeController.cs file', 'open', 1, 4)
		  , ('Typo fix in Judge.html', 'open', 4, 3)
		  , ('Implement documentation for UsersService.cs', 'closed', 8, 2)
		  , ('Unreachable code in Index.cs', 'open', 9, 8)

--3--

UPDATE [Issues]
   SET [IssueStatus] = 'closed'
 WHERE [AssigneeId] = 6

 --4--

 DELETE FROM [RepositoriesContributors]
       WHERE [RepositoryId] = 3

 DELETE FROM [Issues]
       WHERE [RepositoryId] = 3


--5--

  SELECT [Id]	
	     , [Message]
	     , [RepositoryId]
	     , [ContributorId]
    FROM Commits AS c
ORDER BY c.[Id]
		 , c.[Message]
		 , [RepositoryId]
	     , [ContributorId]

--6--

  SELECT [Id]
         , [Name]
		 , [Size]
    FROM [Files] AS f
   WHERE f.[Size] > 1000 
	 AND f.[Name] LIKE '%html%'
ORDER BY [Size] DESC
         , [Name]
		 , [Id]

--7--

   SELECT i.[Id]
		  , CONCAT(u.[Username], ' : ', i.[Title]) AS [IssueAssignee]
     FROM [Issues] AS i
     JOIN [Users] AS u
	   ON i.[AssigneeId] = u.[Id]
 ORDER BY i.[Id] DESC
		  , i.[AssigneeId]

--8--

 SELECT  f.[Id]
		, f.[Name]
		, CONCAT(f.[Size], 'KB') AS SIze
     FROM Files AS f
LEFT JOIN [Files] AS p
	   ON f.Id = p.[ParentId]
    WHERE p.[ParentId] IS NULL
 ORDER BY f.[Id] 
		  , f.[Name]
		  , f.[Size] DESC

--9--

  SELECT TOP (5) 
         r.Id
		 , r.Name
		 , COUNT(c.Id) AS [Commits]
    FROM [Repositories] AS r
    JOIN [Commits] AS c
      ON r.[Id] = c.[RepositoryId]
    JOIN [RepositoriesContributors] AS rc
      ON r.[Id] = rc.[RepositoryId]
GROUP BY r.[Id], r.[Name]
ORDER BY [Commits] DESC
		 , r.[Id]
		 , r.[Name] ASC

--10--

   SELECT u.[Username]
		  , AVG(f.[Size]) AS [Size]
     FROM [RepositoriesContributors] AS rc
     JOIN [Users] AS u
       ON rc.[ContributorId] = u.[Id]
     JOIN [Commits] AS c
       ON u.[Id] = c.ContributorId
     JOIN [Files] AS f
       ON c.[Id] = f.[CommitId]
 GROUP BY u.[Username]
 ORDER BY AVG(f.[Size]) DESC
		  , u.[Username]

--11--

CREATE FUNCTION udf_AllUserCommits(@username VARCHAR (30))
RETURNS INT
BEGIN

	RETURN (SELECT COUNT(*)
	    FROM [Users] AS u
   LEFT JOIN [Commits] AS c
          ON u.[Id] = c.[ContributorId]
	   WHERE u.[Username] = @username
	GROUP BY c.[ContributorId]
	)	 
END

--12--

CREATE PROC usp_SearchForFiles(@fileExtension VARCHAR(20)) AS
BEGIN
	  SELECT f.[Id]
			 , f.[Name]
			 , CONCAT(f.[Size], 'KB') AS [Size]
	    FROM [Files] as f
	   WHERE f.Name LIKE '%.' + @fileExtension
	ORDER BY f.[Id]
			 , f.[Name]
			 , f.[Size] DESC
END
