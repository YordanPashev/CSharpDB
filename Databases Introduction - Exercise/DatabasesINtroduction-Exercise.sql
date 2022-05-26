USE [Minions]

--1--
CREATE TABLE [Minions] (
	[Id] INT PRIMARY KEY,
	[Name] NVARCHAR(50) NOT NULL, 
	[Age] INT NOT NULL
)

--2--
CREATE TABLE [Towns](
	[Id] INT PRIMARY KEY ,
	[Name] NVARCHAR(50) NOT NULL, 
)

--3--
ALTER TABLE [Minions]
		ADD [TownId] INT FOREIGN KEY REFERENCES [Towns] (Id) NOT NULL

ALTER TABLE [Minions]
ALTER COLUMN [Age] INT NULL

--4--
INSERT INTO [Towns] ([Id], [Name])
	 VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna')


INSERT INTO [Minions] ([Id], [Name], [Age], [TownId])
	 VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2)

SELECT * FROM [Minions]
SELECT * FROM [Towns]

--5--
TRUNCATE TABLE [Minions]

--6--
DROP TABLE [Minions]
DROP TABLE [Towns]

--7--
CREATE TABLE [People](
		     [Id] INT PRIMARY KEY IDENTITY,
			 [Name] NVARCHAR (200) NOT NULL,
			 [Picture] VARBINARY (MAX),
			 CHECK (DATALENGTH ([Picture]) <= 2000000),
			 [Height] DECIMAL (3, 2),
			 [Weight] DECIMAL (5, 2),
			 [Gender] CHAR(1) NOT NULL,
			 CHECK ([Gender] = 'f' OR [Gender] = 'm'),
			 [Birthdate] DATE NOT NULL,
			 [Biography] NVARCHAR (MAX)
)

INSERT INTO People ([Name], [Picture], [Height], [Weight], [Gender], [Birthdate], [Biography])
	 VALUES
('Dimitrichko', NULL, 1.87, 72.2, 'f', '02-11-1992', NULL),
('Penka', NULL, 1.70, 80.2, 'm', '12-01-1991', NULL),
('Spiridon', NULL, 1.87, 112.5, 'f', '02-01-1998', NULL),
('Kuna', NULL, 1.55, 45.3, 'm', '04-12-1995', NULL),
('Sebastian', NULL, 1.87, 78, 'f', '05-01-1996', NULL)

--8--
CREATE TABLE [Users](
			 [Id] INT PRIMARY KEY IDENTITY,
			 [Username] VARCHAR (30) UNIQUE NOT NULL,
			 [Password] VARCHAR (26) NOT NULL,
			 [ProfilePicture] VARBINARY (MAX),
			 CHECK (DATALENGTH ([ProfilePicture]) <= 921600 ),
			 [LastLoginTime] DATE,
			 [IsDeleted] BIT
)

INSERT INTO [Users] ([Username], [Password], [ProfilePicture], [LastLoginTime], [IsDeleted])
	 VALUES
('Dimitrichko', 'patka66', NULL, '2015-12-08', 'false'),
('Pena', 'kmeticata', NULL, '2015-12-08', 'false'),
('Kancho', 'sexbox', NULL, '2015-12-08', 'true'),
('Conko', '12345', NULL, '2015-12-08', 'false'),
('Bai Ivan', 'obcharchetoivan', NULL, '2015-12-08', 'false')

--9--
ALTER TABLE [Users]
DROP PRIMARY KEY
ADD CONSTRAINT PRIMARY KEY ([Id], [Username]);

--10--
ALTER TABLE [Users]
ADD CONSTRAINT CK_Users_Password CHECK (LEN(Password) >= 5)

--11--
ALTER TABLE [Users]
ADD CONSTRAINT df_LastLoginTime DEFAULT CURRENT_TIMESTAMP FOR [LastLoginTime] 

--12--
ALTER TABLE [Users]
DROP CONSTRAINT PK_Users

ALTER TABLE [Users]
ADD CONSTRAINT PK_Users PRIMARY KEY ([Id])

ALTER TABLE [Users]
ADD CONSTRAINT UQ_Users_Username CHECK (LEN(Username) >= 3)

--13--

SELECT * FROM [Users]
