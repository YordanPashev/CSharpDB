--1--

SELECT COUNT(*)
  FROM [WizzardDeposits]

--2--
  SELECT 
	     MAX(wd.[MagicWandSize]) AS [LongestMagicWand]
    FROM [WizzardDeposits] AS wd

--3--

  SELECT 
		 wd.[DepositGroup]  AS [LongestMagicWand]
		 , MAX(wd.[MagicWandSize])
    FROM [WizzardDeposits] AS wd
GROUP BY wd.[DepositGroup]

--4--

  SELECT TOP(2)
		 [DepositGroup]
	FROM [WizzardDeposits]
GROUP BY [DepositGroup] 
ORDER BY AVG([MagicWandSize]) 

--5--

  SELECT 
		 [DepositGroup]
		 , SUM([DepositAmount]) AS [TotalSum]
	FROM [WizzardDeposits]
GROUP BY [DepositGroup] 

--6--

  SELECT 
		 [DepositGroup]
		 , SUM([DepositAmount]) AS [TotalSum]
	FROM [WizzardDeposits] AS wd
   WHERE wd.[MagicWandCreator] = 'Ollivander family' 
GROUP BY [DepositGroup] 
  
--7--

  SELECT 
		 wd.[DepositGroup]
		 , SUM(wd.[DepositAmount]) AS [TotalSum]
	FROM [WizzardDeposits] AS wd
   WHERE wd.[MagicWandCreator] = 'Ollivander family' 
GROUP BY wd.[DepositGroup]
  HAVING SUM(wd.[DepositAmount]) < 150000
ORDER BY SUM(wd.[DepositAmount]) DESC

--8--

  SELECT 
		 wd.[DepositGroup]
		 , wd.[MagicWandCreator]
		 , MIN(wd.[DepositCharge]) AS [MinDepositCharge]
	FROM [WizzardDeposits] AS wd
GROUP BY wd.[DepositGroup]
		 , wd.[MagicWandCreator]
ORDER BY wd.[MagicWandCreator]
		 , wd.[DepositGroup]

--9--

  SELECT ag.[AgeGroup]
         , COUNT(*)
    FROM (
		  SELECT 
				  CASE 
						 WHEN wd.[Age] BETWEEN 0 AND 10 THEN '[0-10]'
						 WHEN wd.[Age] BETWEEN 11 AND 20 THEN '[11-20]'
						 WHEN wd.[Age] BETWEEN 21 AND 30 THEN '[21-30]'
						 WHEN wd.[Age] BETWEEN 31 AND 40 THEN '[31-40]'
						 WHEN wd.[Age] BETWEEN 41 AND 50 THEN '[41-50]'
						 WHEN wd.[Age] BETWEEN 51 AND 60 THEN '[51-60]'
						 WHEN wd.[Age] > 60 THEN '[61+]'
				  END AS [AgeGroup]
		    FROM [WizzardDeposits] as wd
		  ) AS ag
GROUP BY [AgeGroup]

--10--

  SELECT DISTINCT SUBSTRING(wd.[FirstName], 1, 1) AS [FirstLetter]
    FROM [WizzardDeposits] AS wd
   WHERE wd.[DepositGroup] = 'Troll Chest'
GROUP BY SUBSTRING(wd.[FirstName], 1, 1)
ORDER BY [FirstLetter]

--11--

  SELECT wd.[DepositGroup]
		 , wd.[IsDepositExpired]
		 , AVG(wd.[DepositInterest]) AS [AverageInterest]
	FROM [WizzardDeposits] AS wd 
   WHERE wd.[DepositStartDate] > '1985-01-01'
GROUP BY wd.[DepositGroup] 
		 , wd.[IsDepositExpired]
ORDER BY wd.[DepositGroup] DESC
		 , wd.[IsDepositExpired]

--12--

SELECT 
	   ABS(SUM(HostGuestQuery.[Guest Wizard Deposit] - HostGuestQuery.[Host Wizard Deposit]))
	AS [SumDifference]
  FROM (
		  SELECT ws.[FirstName] AS [Host Wizard]
				 , ws.[DepositAmount] AS [Host Wizard Deposit] 
				 , LEAD(ws.[FirstName]) OVER (ORDER BY [Id]) AS [Guest Wizard]
				 , LEAD(ws.[DepositAmount]) OVER (ORDER BY[Id]) AS [Guest Wizard Deposit]
			FROM [WizzardDeposits] AS ws
	   ) AS HostGuestQuery
 WHERE [Guest Wizard] IS NOT NULL


--13--

  SELECT e.[DepartmentId]
	     , SUM(e.[Salary]) AS [TotalSalary]
    FROM [Employees] AS e
GROUP BY e.[DepartmentID]

--14--

  SELECT e.[DepartmentID]
	     , MIN(e.[Salary]) AS [MinimulSalary]
    FROM [Employees] AS e
   WHERE e.[DepartmentID] IN (2, 5, 7)
     AND [HireDate] > '2000-01-01'
GROUP BY e.[DepartmentID] 

--15--

SELECT *
  INTO [EmployeesAverageSalaries]
  FROM [Employees] AS e
 WHERE e.[Salary] > 30000

 DELETE FROM [EmployeesAverageSalaries] 
	   WHERE [ManagerID] = 42

 UPDATE [EmployeesAverageSalaries]
    SET [Salary] = [Salary] + 5000
  WHERE [DepartmentID] = 1

  SELECT eas.[DepartmentID]
         , AVG(eas.[Salary]) AS [AverageSalary]
	FROM [EmployeesAverageSalaries] AS eas
GROUP BY [DepartmentID]
  
--16--

  SELECT e.[DepartmentID]
	     , MAX(e.[Salary]) AS [MinimulSalary]
    FROM [Employees] AS e
GROUP BY e.[DepartmentID] 
  HAVING MAX(e.[Salary]) NOT BETWEEN 30000 AND 70000

 --17--

SELECT COUNT(*) AS [Count]
  FROM [Employees] AS e
 WHERE e.[ManagerID] IS NULL

 --18--

 SELECT DISTINCT 
		[DepartmentID]
        , d.[Salary]
   FROM (
		 SELECT e.[DepartmentID]
				, [Salary]
				, [FirstName]
				, DENSE_RANK() OVER (PARTITION BY e.[DepartmentID] ORDER BY e.[Salary] DESC) AS [ThirdHighestSalary]
		   FROM [Employees] AS e
	    ) AS d
  WHERE d.[ThirdHighestSalary] = 3

 --19--

  SELECT TOP(10)
		 e.[FirstName]
		 , e.[LastName]
		 , e.[DepartmentID]
    FROM (
		   SELECT [DepartmentID]
				  , AVG([Salary]) AS [DepartmentAverageSalary]
		     FROM [Employees] 
	     GROUP BY [DepartmentID] 
         ) AS dg 
		 , [Employees] AS e
   WHERE e.DepartmentID = dg.DepartmentID
     AND [DepartmentAverageSalary] < e.[Salary]
ORDER By e.[DepartmentID]


 