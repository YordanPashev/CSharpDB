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
