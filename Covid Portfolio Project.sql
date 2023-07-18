SELECT *
FROM PortfolioProject .dbo.CovidDeaths
ORDER BY 3,4

SELECT *
FROM PortfolioProject .dbo.CovidVaccinations
ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject .dbo.CovidDeaths
ORDER BY 1,2

-- Converting the dataset with FLOAT

Alter TABLE PortfolioProject .dbo.CovidDeaths
Alter column total_cases FLOAT

Alter TABLE PortfolioProject .dbo.CovidDeaths
Alter column total_deaths FLOAT

Alter TABLE PortfolioProject .dbo.CovidVaccinations
Alter column new_vaccinations FLOAT

Alter TABLE PortfolioProject .dbo.CovidDeaths
Alter column population FLOAT

-- Looking at Total Cases vs Total Deaths
-- This show the likelihood of dying if you contract Covid in Ecuador

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject .dbo.CovidDeaths
WHERE location like '%Ecuador%'
ORDER BY 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of Ecuador´s population got Covid

SELECT location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProject .dbo.CovidDeaths
WHERE location like '%Ecuador%'
ORDER BY 1,2

-- Looking at Countries with Highest Infection Rate compared to Popualtion

SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject .dbo.CovidDeaths
WHERE continent is not null
GROUP BY Location, Population 
ORDER BY PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject .dbo.CovidDeaths
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount desc

-- Showing Continents with Highest Death Count

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject .dbo.CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc

-- Global Numbers

SELECT date, 
       SUM(new_cases) AS total_cases, 
       SUM(new_deaths) AS total_deaths, 
       (SUM(new_deaths) * 100.0) / NULLIF(SUM(new_cases), 0) AS DeathPercentage
FROM PortfolioProject .dbo.CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY date
ORDER BY 1, 2

-- Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		SUM (CAST(vac.new_vaccinations AS bigint)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject .dbo.CovidDeaths dea
JOIN PortfolioProject .dbo.CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL 
ORDER BY 2, 3

-- Using CTE

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		SUM (CAST(vac.new_vaccinations AS bigint)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject .dbo.CovidDeaths dea
JOIN PortfolioProject .dbo.CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL 
)

SELECT *, (RollingPeopleVaccinated/NULLIF (Population,0))*100
FROM PopvsVac

-- Temp Table

DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		SUM (CAST(vac.new_vaccinations AS bigint)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject .dbo.CovidDeaths dea
JOIN PortfolioProject .dbo.CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date


SELECT *, (RollingPeopleVaccinated/NULLIF (Population,0))*100
FROM #PercentPopulationVaccinated

-- Creating View to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		SUM (CAST(vac.new_vaccinations AS bigint)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject .dbo.CovidDeaths dea
JOIN PortfolioProject .dbo.CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null


SELECT * 
FROM PercentPopulationVaccinated