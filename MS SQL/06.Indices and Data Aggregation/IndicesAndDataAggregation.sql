--1--

SELECT COUNT(*)
  FROM [WizzardDeposits]

--2--
  SELECT 
	     MAX(wd.[MagicWandSize]) AS [LongestMagicWand]
    FROM [WizzardDeposits] AS wd

--3--

  SELECT 
		 wd.[DepositGroup] 
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

  SELECT 
		  CASE 
			 WHEN wd.[Age] BETWEEN 0 AND 10 THEN '[0-10]'
			 WHEN wd.[Age] BETWEEN 11 AND 20 THEN '[11-20]'
			 WHEN wd.[Age] BETWEEN 21 AND 30 THEN '[21-30]'
			 WHEN wd.[Age] BETWEEN 31 AND 40 THEN '[31-40]'
			 WHEN wd.[Age] BETWEEN 41 AND 50 THEN '[41-50]'
			 WHEN wd.[Age] BETWEEN 51 AND 60 THEN '[51-60]'
			 WHEN wd.[Age] > 60 THEN '[61+]'
	      END AS [AgeGroups]
		 , COUNT(*) AS [WizardCount]
    FROM [WizzardDeposits] as wd
GROUP BY CASE 
			 WHEN wd.[Age] BETWEEN 0 AND 10 THEN '[0-10]'
			 WHEN wd.[Age] BETWEEN 11 AND 20 THEN '[11-20]'
			 WHEN wd.[Age] BETWEEN 21 AND 30 THEN '[21-30]'
			 WHEN wd.[Age] BETWEEN 31 AND 40 THEN '[31-40]'
			 WHEN wd.[Age] BETWEEN 41 AND 50 THEN '[41-50]'
			 WHEN wd.[Age] BETWEEN 51 AND 60 THEN '[51-60]'
			 WHEN wd.[Age] > 60 THEN '[61+]'
	      END 

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


