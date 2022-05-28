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

CREATE DATABASE [Movies]

CREATE TABLE [Directors](
			 [Id] INT PRIMARY KEY IDENTITY
			 ,[DirectorName] NVARCHAR (100) NOT NULL
			 ,[Notes] NVARCHAR (MAX) 
)
INSERT INTO [Directors] ([DirectorName], [Notes])
	 VALUES
	 ('Dimitrichko', NULL)
	 ,('Stamat', NULL)
	 ,('Tishaka', NULL)
	 ,('Pe6kata', NULL)
	 ,('Chochko', NULL)

CREATE TABLE [Genres](
			 [Id] INT PRIMARY KEY IDENTITY
			 ,[GenreName] NVARCHAR (50) NOT NULL
			 ,[Notes] NVARCHAR (MAX) 
)

INSERT INTO [Genres] ([GenreName], [Notes])
	 VALUES
	 ('Action', NULL)
	 ,('Drama', NULL)
	 ,('Sci-Fi', NULL)
	 ,('Documentary', NULL)
	 ,('Musical', NULL)

CREATE TABLE [Categories](
			 [Id] INT PRIMARY KEY IDENTITY
			 ,[CategoryName] NVARCHAR (50) NOT NULL
			 ,[Notes] NVARCHAR (MAX) 
)

INSERT INTO [Categories]([CategoryName], [Notes])
	 VALUES
	 ('18+', NULL)
	 ,('Family', NULL)
	 ,('16+', NULL)
	 ,('Animation', NULL)
	 ,('Romance', NULL)

CREATE TABLE [Movies](
			 [Id] INT PRIMARY KEY IDENTITY
			 ,[Title] NVARCHAR (200) NOT NULL 
			 ,[DirectorId] INT NOT NULL
			 ,[CopyrightYear] INT  NOT NULL
			 ,CHECK ([CopyrightYear] >= 1900)
			 ,[CategoryId] INT NOT NULL 
			 ,[Length] TIME NOT NULL
			 ,[GenreId] INT NOT NULL
			 ,[Rating] DECIMAL (1,1) 
			 ,[Notes] NVARCHAR (MAX)
			 ,FOREIGN KEY ([DirectorID]) REFERENCES [Directors](Id)
			 ,FOREIGN KEY ([GenreId]) REFERENCES [Genres]([Id])
			 ,FOREIGN KEY ([CategoryId])REFERENCES [Categories]([Id])
)

INSERT INTO [Movies] ([Title], [DirectorId], [CopyrightYear], [CategoryId], [Length],  [GenreId], [Rating],  [Notes])
	 VALUES
	 ('AVENGER', 1, '2000', 1, '1:22:33', 3 , NULL, NULL)
	 ,('DR. STRANGE', 2, '2022', 2, '1:52:33', 2 , NULL, NULL)
	 ,('THE GOTHFATHER', 3, '1970', 3, '2:42:33', 3 , NULL, NULL)
	 ,('VHERA', 4, '1988', 4, '1:45:33', 4 , NULL, NULL)
	 ,('JACKASSS 3', 5, '2016', 5, '1:30:33', 5, NULL, NULL)

--14--

CREATE DATABASE [CarRental]

CREATE TABLE [Categories](
			 [Id] INT PRIMARY KEY IDENTITY
			 ,[CategoryName] NVARCHAR (50) NOT NULL
			 ,[DailyRate] DECIMAL NOT NULL
			 ,[WeeklyRate] DECIMAL NOT NULL
			 ,[MonthlyRate] DECIMAL NOT NULL
			 ,[WeekendRate] DECIMAL
)

INSERT INTO [Categories] ([CategoryName], [DailyRate], [WeeklyRate], [MonthlyRate], [WeekendRate])
	 VALUES				 
	 ('HATCHBACK', 50,  200, 600, NULL)
	 ,('MINIVAN', 80,  300, 800, NULL)
	 ,('SPORT CAR', 100,  800, 2300, NULL)

CREATE TABLE [Cars](
			 [Id] INT PRIMARY KEY IDENTITY
			 ,[PlateNumber] NVARCHAR (10) NOT NULL
			 ,[Manufacturer] NVARCHAR (25)
			 ,[Model] NVARCHAR (25)
			 ,[CarYear] CHAR (4) NOT NULL
			 ,[CategoryId] INT NOT NULL
			 ,[Doors]CHAR (1) 
			 ,[Picture] VARBINARY (MAX) 
			 ,[Condition] NVARCHAR (20)
			 ,[Available] VARCHAR (5)
			 ,CHECK([Available] = 'BUSSY' OR [Available] = 'FREE')
			 ,FOREIGN KEY ([CategoryId])REFERENCES [Categories]([Id])
)

INSERT INTO [Cars] ([PlateNumber], [Manufacturer], [Model], [CarYear], [CategoryId], [Doors], [Picture], [Condition], [Available])
	 VALUES
	 ('P6792PK', 'Reno', 'Scenic', 1998, 2, 5, NULL, 'USED','BUSSY')
	 ,('CA888KK','VW', 'Golf', 2009, 1, 3, NULL, 'USED','FREE')
	 ,('K8972PP','Buggatti', 'Divo', 2022, 2, 5, NULL, 'BRAND NEW','FREE')

CREATE TABLE [Employees](
			 [Id] INT PRIMARY KEY IDENTITY
			 ,[FirstName] NVARCHAR (50) NOT NULL
			 ,[LastName] NVARCHAR (50) NOT NULL
			 ,[Title] NVARCHAR (20) NOT NULL
			 ,[Notes] NVARCHAR (MAX)
)

INSERT INTO [Employees] ([FirstName], [LastName], [Title], [Notes])
	 VALUES
	 ('Jonkata', 'Borimechkov', 'Junior', NULL)
	 ,('Iliya', 'Bichmeto', 'Senior', NULL)
	 ,('Dimitrichko', 'Guzolizov', 'Middle', NULL)


CREATE TABLE [Customers](
			 [Id] INT PRIMARY KEY IDENTITY
			 ,[DriverLicenceNumber] NVARCHAR (20) NOT NULL
			 ,[FullName] NVARCHAR (100) NOT NULL
			 ,[Address]  NVARCHAR (200) NOT NULL
			 ,[City] NVARCHAR (50) NOT NULL
			 ,[ZIPCode] VARCHAR (4) NOT NULL
			 ,[Notes] NVARCHAR (MAX)
)

INSERT INTO [Customers] ([DriverLicenceNumber], [FullName], [Address], [City], [ZIPCode])
	 VALUES
	 ('671234123HH12', 'Peshkata Peshkov', 'Sofia', 'Fakulteta', '1400')
	 ,('9812734JKSAHS', 'Gospodin Gospodinov', 'Sofia', 'Krystova vada', '1200')
	 ,('354SDKJFHS128', 'Rachko Rachkov', 'Aytos', 'Komluka', '5400')
			
CREATE TABLE [RentalOrders] (
			 [Id] INT PRIMARY KEY IDENTITY
			 ,[EmployeeId] INT NOT NULL
			 ,[CustomerId] INT NOT NULL
			 ,[CarId] INT NOT NULL
			 ,[TankLevel] NVARCHAR (10) NOT NULL
			 ,[KilometrageStart] INT NOT NULL
			 ,[KilometrageEnd] INT NOT NULL
			 ,[TotalKilometrage] INT NOT NULL
			 ,[StartDate] DATE NOT NULL
			 ,[EndDate] DATE NOT NULL
			 ,[TotalDays] INT NOT NULL
			 ,[RateApplied] INT NOT NULL
			 ,[TaxRate] INT NOT NULL
			 ,[OrderStatus] NVARCHAR (50 )NOT NULL
			 ,[Notes] NVARCHAR (MAX)
			 ,FOREIGN KEY ([EmployeeId]) REFERENCES [Employees](Id)
			 ,FOREIGN KEY ([CustomerId]) REFERENCES [Customers]([Id])
			 ,FOREIGN KEY ([CarId])REFERENCES [Cars]([Id])
)

INSERT INTO [RentalOrders] ([EmployeeId], [CustomerId], [CarId], [TankLevel], [KilometrageStart], [KilometrageEnd], [TotalKilometrage], [StartDate], [EndDate], [TotalDays], [RateApplied], [TaxRate], [OrderStatus])
	  VALUES
	  (1, 1, 1, 'Full', 123666, 123667, 1, '2022-12-12', '2022-12-12', 1, 6, 1, 'FINISHED')
	  ,(2, 2, 2, 'Empty', 123666, 123667, 1, '2022-12-12', '2022-10-13', 1, 6, 1, 'FINISHED')
	  ,(2, 2, 2, 'Half', 123666, 123667, 1, '2022-12-12', '2022-09-13', 1, 6, 1, 'FINISHED')

--15--

CREATE DATABASE [Hotel]

CREATE TABLE [Employees](
			 [Id] INT PRIMARY KEY IDENTITY
			 ,[FirstName] NVARCHAR (50) NOT NULL
			 ,[LastName] NVARCHAR (50) NOT NULL
			 ,[Title] NVARCHAR (50) NOT NULL
			 ,[Notes] NVARCHAR (150)
)

INSERT INTO [Employees] ([FirstName], [LastName], [Title], [Notes])
	 VALUES				 
	 ('Johny', 'Cage',  'Midle', NULL)
	 ,('Fikret', 'Jipsov',  'Junior', NULL)
	 ,('Kurti', 'Ivanov',  'Senior', NULL)
	 

CREATE TABLE [Customers](
			[AccountNumber] VARCHAR(10) NOT NULL
			,[FirstName]  NVARCHAR (50) NOT NULL
			,[LastName]  NVARCHAR (50) NOT NULL
			,[PhoneNumber] VARCHAR(15)
			,[EmergencyName] NVARCHAR (50)
			,[EmergencyNumber] VARCHAR (15)
			,[Notes] NVARCHAR (150)
)

ALTER TABLE [Customers]
ADD PRIMARY KEY ([AccountNumber])

INSERT INTO [Customers] ([AccountNumber], [FirstName], [LastName], [PhoneNumber], [EmergencyName], [EmergencyNumber], [Notes])
	 VALUES
	 ('1234467890', 'Ivan', 'Ivanov', '0888888888', 'Vancho', '0877777777', NULL)
	 ,('0123456789', 'Dragan', 'Draganov', '0888123456', 'Vancho', '0877779821', NULL)
	 ,('1237894560', 'Pencho', 'Penchov', '0888987123', 'Vancho', '0877564321', NULL)

CREATE TABLE [RoomStatus](
			 [RoomStatus] NVARCHAR (30) PRIMARY KEY
			 ,[Notes] NVARCHAR (MAX)
)

INSERT INTO [RoomStatus] ([RoomStatus], [Notes])
	 VALUES
	 ('FREE', NULL)
	 ,('BUSY', NULL)
	 ,('WILL BE AVAILABLE SOON', NULL)

CREATE TABLE [RoomTypes](
			 [RoomType] NVARCHAR (20) NOT NULL PRIMARY KEY
			 ,[Notes] NVARCHAR (MAX)
)

INSERT INTO [RoomTypes] ([RoomType], [Notes])
	 VALUES
	 ('Standart Room', NULL)
	 ,('Studio', NULL)
	 ,('Apartmet', NULL)
			
CREATE TABLE [BedTypes] (
			 [BedType] NVARCHAR (50) PRIMARY KEY
			 ,[Notes] NVARCHAR (MAX)
)

INSERT INTO [BedTypes] ([BedType], [Notes])
	 VALUES
	 ('Two Beds', NULL)
	 ,('Three Beds', NULL)
	 ,('Four Beds', NULL)

CREATE TABLE [Rooms] (
			 [RoomNumber] VARCHAR (1) NOT NULL
			 ,[RoomType] NVARCHAR (20) NOT NULL
			 ,[BedType] NVARCHAR (50) NOT NULL
			 ,[Rate] DECIMAL
			 ,[RoomStatus] NVARCHAR (30)
			 ,[Notes] NVARCHAR (MAX)
			 ,FOREIGN KEY ([RoomType]) REFERENCES [RoomTypes]([RoomType])
			 ,FOREIGN KEY ([BedType]) REFERENCES [BedTypes]([BedType])
			 ,FOREIGN KEY ([RoomStatus]) REFERENCES [RoomStatus]([RoomStatus])
)

INSERT INTO [Rooms] ([RoomNumber], [RoomType], [BedType], [Rate], [RoomStatus], [Notes])
	 VALUES
	 ('1', 'Apartmet', 'Four Beds', 6.4, 'BUSY', NULL )
	 ,('2', 'Standart Room', 'Three Beds', 6.4, 'FREE', NULL )
	 ,('3', 'Studio', 'Two Beds', 6.4, 'WILL BE AVAILABLE SOON', NULL )


CREATE TABLE [Payments]( 
			 [Id] INT PRIMARY KEY IDENTITY
			 ,[EmployeeId] INT NOT NULL
			 ,[PaymentDate] DATE NOT NULL
			 ,[AccountNumber] VARCHAR(10) NOT NULL
			 ,[FirstDateOccupied] DATE NOT NULL
			 ,[LastDateOccupied] DATE NOT NULL
			 ,[TotalDays] INT NOT NULL
			 ,[AmountCharged] DECIMAL NOT NULL
			 ,[TaxRate] DECIMAL NOT NULL
			 ,[TaxAmount] DECIMAL NOT NULL
			 ,[PaymentTotal] DECIMAL NOT NULL
			 ,[Notes] NVARCHAR (MAX)
			 ,FOREIGN KEY ([EmployeeId]) REFERENCES [Employees]([Id])
			 ,FOREIGN KEY ([AccountNumber]) REFERENCES [Customers]([AccountNumber])
)

INSERT INTO [Payments] ([EmployeeId], [PaymentDate], [AccountNumber], [FirstDateOccupied], [LastDateOccupied], [TotalDays], [AmountCharged], [TaxRate], [TaxAmount], [PaymentTotal])
 	 VALUES
	 (1, '2022-10-10', '0123456789', '2022-10-08', '2022-10-10', 2, 155.55, 10, 15.5, 17.05)
	 ,(2, '2022-10-10', '1234467890', '2022-10-08', '2022-10-10', 2, 200, 10, 20, 220)
	 ,(3, '2022-10-10', '1237894560', '2022-10-08', '2022-10-10', 2, 80, 10, 8, 88)

CREATE TABLE [Occupancies]( 
			 [Id] INT PRIMARY KEY IDENTITY
			 ,[EmployeeId] INT NOT NULL
			 ,[DateOccupied] DATE NOT NULL
			 ,[AccountNumber] VARCHAR(10) NOT NULL
			 ,[RoomNumber] VARCHAR (1) NOT NULL
			 ,[RateApplied] DECIMAL 
			 ,[PhoneCharge] DECIMAL
			 ,[Notes] NVARCHAR (MAX)
			 ,FOREIGN KEY ([EmployeeId]) REFERENCES [Employees]([Id])
			 ,FOREIGN KEY ([AccountNumber]) REFERENCES [Customers]([AccountNumber])
)

INSERT INTO [Occupancies] ([EmployeeId], [DateOccupied], [AccountNumber], [RoomNumber], [RateApplied], [PhoneCharge], [Notes])
 	 VALUES
	 (1, '2022-10-10', '0123456789', 1, NULL, NULL, NULL)
	 ,(2, '2022-10-10', '0123456789', 2, NULL, NULL, NULL)
	 ,(3, '2022-10-10', '0123456789', 3, NULL, NULL, NULL)

--16--

CREATE DATABASE [SoftUni]

CREATE TABLE [Towns](
				[Id] INT PRIMARY KEY IDENTITY
				,[Name] NVARCHAR (50) NOT NULL
)
CREATE TABLE[Addresses](
			[Id] INT PRIMARY KEY IDENTITY
			,[AddressText] NVARCHAR (200) NOT NULL
			,[TownId] INT NOT NULL
			,FOREIGN KEY ([TownID]) REFERENCES [Towns]([Id])
)

CREATE TABLE[Departments](
				[Id] INT PRIMARY KEY IDENTITY
				,[Name] NVARCHAR (50) NOT NULL
)

CREATE TABLE[Employees](
			[Id] INT PRIMARY KEY IDENTITY
			,[FirstName] NVARCHAR (50) NOT NULL
			,[MiddleName] NVARCHAR (50) NOT NULL
			,[LastName] NVARCHAR (50) NOT NULL
			,[JobTitle] NVARCHAR (50) NOT NULL
			,[DepartmentId] INT NOT NULL
			,[HireDate] DATE NOT NULL
			,[Salary] DECIMAL NOT NULL
			,[AddressId] INT 
			,FOREIGN KEY ([DepartmentId]) REFERENCES [Departments]([Id])
			,FOREIGN KEY ([AddressId]) REFERENCES [Addresses]([Id])
)

--18--

INSERT INTO [Towns]
	 VALUES
	 ('Sofia')
	 ,('Plovdiv')
	 ,('Varna')
	 ,('Burgas')

INSERT INTO [Departments]
	 VALUES
	 ('Engineering')
	 ,('Sales')
	 ,('Marketing')
	 ,('Software Development')
	 ,('Quality Assurance')

	 
INSERT INTO [Employees] ([FirstName], [MiddleName], [LastName], [JobTitle], [DepartmentId], [HireDate], [Salary])
	 VALUES
	 ('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00)
	 ,('Petar', 'petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00)
	 ,('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25)
	 ,('Gerogi', 'Teziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00)
	 ,('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88)

--19--

SELECT * FROM [Towns]
SELECT * FROM [Departments]
SELECT * FROM [Employees]

--20--

SELECT * FROM [Towns]
	 ORDER BY [Name]
SELECT * FROM [Departments]
	 ORDER BY [Name]
SELECT * FROM [Employees]
	 ORDER BY [Salary] DESC

--21--

SELECT [Name] FROM [Towns]
	 ORDER BY [Name]
SELECT [Name] FROM [Departments]
	 ORDER BY [Name]
SELECT [FirstName], [LastName], [JobTitle], [Salary] FROM [Employees]
	 ORDER BY [Salary] DESC

--22--

UPDATE [Employees] SET [Salary] = [Salary] * 1.1
SELECT [Salary] FROM [Employees]

--23--

UPDATE [Payments] SET [TaxRate] = [TaxRate] * 0=97;
SELECT [TaxRate] FROM [Payments]

--24--

TRUNCATE TABLE [Occupancies]


