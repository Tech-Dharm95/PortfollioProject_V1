SELECT*
FROM PortfolioProject..Coviddeaths
order by 3,4

--SELECT*
--FROM PortfolioProject..CovidVacination
--order by 3,4

--Select Data that we are going to be using

SELECT Location, date, total_cases,new_cases, total_deaths, population
FROM PortfolioProject..Coviddeaths
order by 1,2

--Looking at Total Cases Vs Total Deaths
--Shows likelihood of dying if you contact covid in your country

SELECT Location, date, total_cases,new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..Coviddeaths
Where location like '%states%'
order by 1,2

--Looking at Total Cases Vs Population
--Shows that percentage of population got covid
SELECT Location, date, total_cases,new_cases, Population, (total_cases/population)*100 as PercentPopulationInfacted
FROM PortfolioProject..Coviddeaths
Where location like '%states%'
order by 1,2

--Looking at Countries with highest Infection Rate compared to Population

SELECT Location, Population, MAX(total_cases) as HighestInfectionCount,Max((total_cases/population))*100 as PercentPopulationInfacted
FROM PortfolioProject..Coviddeaths
Group by Location, Population
order by PercentPopulationInfacted desc

----For United states
SELECT Location, Population, MAX(total_cases) as HighestInfectionCount,Max((total_cases/population))*100 as PercentPopulationInfacted
FROM PortfolioProject..Coviddeaths
Where location like '%states%'
Group by Location, Population

--Showing Countries with Highest Death Count Per Population

Select Location, MAX(CAST(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..Coviddeaths
--Where Location like '%states%'
Where continent is not null
Group by Location
order by TotalDeathCount desc

SELECT*
FROM PortfolioProject..Coviddeaths
Where continent is not null
order by 3,4

---Let's Break Thing Down by Continent

Select continent, MAX(CAST(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..Coviddeaths
--Where Location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

Select location, MAX(CAST(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..Coviddeaths
--Where Location like '%states%'
Where continent is null
Group by location
order by TotalDeathCount desc

--Showing continents with the highest death count per population

Select continent, MAX(CAST(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..Coviddeaths
--Where Location like '%states%'
Where continent is not null
Group by Continent
order by TotalDeathCount desc

--GLOBAL Numbers
SELECT SUM(new_cases) as total_cases,SUM(CAST(new_deaths as int))as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..Coviddeaths
--Where location like '%states%'
Where continent is not null
--Group by date
order by 1,2

SELECT*
FROM PortfolioProject..CovidVacination

--LETS JOIN BOTH TABLE CovidDeath and CovidVacination
--Looking at total Population vs Vaccinations
SELECT dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
FROM PortfolioProject..Coviddeaths dea
Join PortfolioProject..CovidVacination vac
  on dea.location = vac.location
  and dea.date = vac.date
Where dea.continent is not null
order by 2,3

--Partition by location


SELECT dea.continent, dea.location,dea.date,dea.population, vac.new_vaccinations 
, SUM(cast(vac.new_Vaccinations as int)) over (Partition by dea.Location order by dea.location,
dea.date) as RollingPeopleVaccinated
--,(RollingpeopleVaccinated/Population)*100
FROM PortfolioProject..Coviddeaths dea
Join PortfolioProject..CovidVacination vac
  on dea.location = vac.location
  and dea.date = vac.date
 Where dea.continent is not null
--order by 2,3

--Temp Table

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location,dea.date,dea.population, vac.new_vaccinations 
, SUM(CONVERT(int,vac.new_Vaccinations)) over (Partition by dea.Location order by dea.location,
dea.date) as RollingPeopleVaccinated
--,(RollingpeopleVaccinated/Population)*100
FROM PortfolioProject..Coviddeaths dea
Join PortfolioProject..CovidVacination vac
  on dea.location = vac.location
  and dea.date = vac.date
 Where dea.continent is not null

