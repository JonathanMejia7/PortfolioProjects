-- Looking for the data we collected

SELECT *
FROM PortfolioProject .dbo.Goalkeeping
ORDER BY 1

SELECT *
FROM PortfolioProject .dbo.AdvancedGoalkeeping
ORDER BY 1

-- Cleaning Data: Separating country code and country name for both tables

SELECT 
    SUBSTRING(Nation, 1, 2),
    LTRIM(RTRIM(SUBSTRING(Nation, 4, LEN(Nation))))
FROM PortfolioProject .dbo.Goalkeeping

UPDATE Goalkeeping
SET Nation = LTRIM(RTRIM(SUBSTRING(Nation, 4, LEN(Nation))))

SELECT 
    SUBSTRING(Nation, 1, 2),
    LTRIM(RTRIM(SUBSTRING(Nation, 4, LEN(Nation))))
FROM PortfolioProject .dbo.AdvancedGoalkeeping

UPDATE AdvancedGoalkeeping
SET Nation = LTRIM(RTRIM(SUBSTRING(Nation, 4, LEN(Nation))))


-- Changing names of columns, so we could identificate them better

-- Goalkeeping table

-- Save%1 to PKSave% 

EXEC sp_rename 'Goalkeeping.[Save%1]', 'PKSave%', 'COLUMN'

-- AdvancedGoalkeeping table

-- Att1 to PassAtt

EXEC sp_rename 'AdvancedGoalkeeping.[Att1]', 'PassAtt', 'COLUMN'

-- Att2 to GKicksAtt

EXEC sp_rename 'AdvancedGoalkeeping.[Att2]', 'GKicksAtt', 'COLUMN'

-- Launch%1 to GKicksLaunch%

EXEC sp_rename 'AdvancedGoalkeeping.[Launch%1]', 'GKicksLaunch%', 'COLUMN'

-- Launch% to PassLauch%

EXEC sp_rename 'AdvancedGoalkeeping.[Launch%]', 'PassLauch%', 'COLUMN'

-- PassLauch% to PassLaunch%

EXEC sp_rename 'AdvancedGoalkeeping.[PassLauch%]', 'PassLaunch%', 'COLUMN'

-- AvgLen to PassAvgLen

EXEC sp_rename 'AdvancedGoalkeeping.[AvgLen]', 'PassAvgLen', 'COLUMN'

--AvgLen1 to GKicksAvgLen

EXEC sp_rename 'AdvancedGoalkeeping.[AvgLen1]', 'GKicksAvgLen', 'COLUMN'

-- /90 to PsxG-GA/90

EXEC sp_rename 'AdvancedGoalkeeping.[/90]', 'PsxG-GA/90', 'COLUMN'

-- Changing "NULLs" to 0

SELECT *
FROM PortfolioProject .dbo.Goalkeeping
WHERE [PkSave%] IS NULL

UPDATE Goalkeeping
SET [PkSave%] = 0
WHERE [PkSave%] IS NULL

ALTER TABLE PortfolioProject .dbo.Goalkeeping
ALTER COLUMN [PkSave%]FLOAT 

-- We see that there's no data about Robert Sanchez, so we transform NULL to 0

SELECT *
FROM PortfolioProject .dbo.AdvancedGoalkeeping
WHERE Player = 'Robert Sanchez'

UPDATE AdvancedGoalkeeping
	SET CK = 0,
		OG = 0,
		PSxG = 0,
		[PSxG/SoT] = 0,
		[PSxG+/-] = 0,
		[PSxG-GA/90] = 0,
		Cmp = 0,
		Att = 0,
		[Cmp%] = 0,
		PassAtt = 0,
		Thr = 0,
		[PassLaunch%] = 0,
		PassAvgLen = 0,
		GKicksAtt = 0,
		[GKicksLaunch%] = 0,
		GKicksAvgLen = 0,
		Opp = 0,
		Stp = 0,
		[Stp%] = 0,
		[#OPA] = 0,
		[#OPA/90] = 0,
		AvgDist = 0
WHERE Player = 'Robert Sanchez' 

-- Create new tables for comparision with Andre Onana

SELECT *
INTO pl_vs_onana_goalkeeping
FROM Goalkeeping

SELECT *
INTO pl_vs_onana_adv_goalkeeping
FROM AdvancedGoalkeeping

-- Inserting Onana's data into the new tables

INSERT INTO pl_vs_onana_goalkeeping
SELECT * 
FROM PortfolioProject .dbo.OnanaGoalkeeping

INSERT INTO pl_vs_onana_adv_goalkeeping
SELECT * 
FROM PortfolioProject .dbo.OnanaAdvancedGoalkeeping

-- Checking if the rows where inserted 

SELECT *
FROM PortfolioProject .dbo.pl_vs_onana_goalkeeping

SELECT *
FROM PortfolioProject .dbo.pl_vs_onana_adv_goalkeeping

