SELECT *
FROM CovidDeaths

--SELECT *
--FROM CovidVaccinations

-- looking at total cases vs total deaths

SELECT location , date , total_cases , total_deaths , (total_deaths/total_cases)*100 as DeathTocaseRatio
From CovidDeaths
WHERE total_deaths is not null And location = 'india'
order by 2 

-- looking at total cases vs population
SELECT location , date ,total_cases , population ,(total_cases/population)*100 as CasesPerPopulation 
From CovidDeaths
WHERE location = 'india'
Order by CasesPerPopulation desc

-- looking at contries with Highest infection rate compare to population

SELECT location , MAX(total_cases)as HighestInfectionCount , population ,MAX(total_cases/population)*100 as PercentPopulationinfected 
From CovidDeaths
Group by location,population
order by PercentPopulationinfected desc

-- Showing Deathcount per population

SELECT location , Max(cast(total_deaths as int)) As MaxDeathCount
From CovidDeaths
Where continent is not null 
GROUP by location
Order by 2 desc


-- Break it by Continent 


SELECT location, Max(cast(total_deaths as int)) As MaxDeathCount
From CovidDeaths
Where continent is null 
GROUP by continent,location
Order by 2 desc

-- showing continent with hisgest death count per population


SELECT continent, Max(cast(total_deaths as int)) As MaxDeathCount
From CovidDeaths
Where continent is not null 
GROUP by continent
Order by 2 desc

--Global numbers


SELECT  sum(new_cases) as Totalcases, sum(cast(new_deaths AS int))As TotalDeaths, 
sum(cast(new_deaths AS int))/ sum(new_cases)*100  as DeathTocaseRatio
From CovidDeaths
WHERE continent is not null 


SELECT *
FROM CovidVaccinations

--JOinn 2 tables 

Select *
From CovidDeaths as dea
Join  CovidVaccinations as vac
on dea.location = vac.location 
and dea.date = vac.date

-- Total populatioin vs vaccination 


Select dea.location , dea.continent, dea.date,dea.population ,vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location ,dea.date) AS RollingPeopleVaccinated
From CovidDeaths as dea
Join  CovidVaccinations as vac
on dea.location = vac.location 
and dea.date = vac.date
WHERE vac.new_vaccinations is not null and dea.continent is not null
order by 1,3

--Use CTE

with PopvsVac (location,continent,date,population,new_vaccinations,RollingPeopleVaccinated)
As 
(
Select dea.location , dea.continent, dea.date,dea.population ,vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location ,dea.date) AS RollingPeopleVaccinated
From CovidDeaths as dea
Join  CovidVaccinations as vac
on dea.location = vac.location 
and dea.date = vac.date
WHERE vac.new_vaccinations is not null and dea.continent is not null
--order by 1,3
)
SELECT *,(RollingPeopleVaccinated/population)*100 As RollingPeopleVaccinatedPercent 
FROM PopvsVac

Select dea.location , dea.population 
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location) AS RollingPeopleVaccinated
From CovidDeaths as dea
Join  CovidVaccinations as vac
on dea.location = vac.location 
and dea.date = vac.date
WHERE vac.new_vaccinations is not null and dea.continent is not null
--Group by dea.location 
order by 1

-- creating view to storre data for later visualizations

create View PercentPopulationVaccinated as 

Select dea.location , dea.continent, dea.date,dea.population ,vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location ,dea.date) AS RollingPeopleVaccinated
From CovidDeaths as dea
Join  CovidVaccinations as vac
on dea.location = vac.location 
and dea.date = vac.date
WHERE vac.new_vaccinations is not null and dea.continent is not null
--order by 1,3

SELECT* 
FRom PercentPopulationVaccinated
