-- Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract covid
select location, date, total_cases, total_deaths, round((total_deaths:: decimal/total_cases) * 100, 2) as Death_Percentage
from covid_deaths
where location = 'United States' or location = 'Nigeria' and continent is not null
order by 1,2 desc;

-- Total Cases vs Population
-- Shows the percentage of population that got covid
select location, date, total_cases, population, round((total_cases:: decimal / population) * 100, 3) as covid_population
from covid_deaths
where location = 'United States' or location = 'Nigeria' and continent is not null
order by 1, 2 desc;

-- Looking at countries with highest infection rate compared to their Population
select location, population, max(total_cases) as Highest_Infection_Count, round((max(total_cases:: decimal) / population) * 100, 3) as percentage_population_infected
from covid_deaths
where continent is not null --and location = 'Nigeria'
group by 1, 2
order by 3 desc; 

-- Showing countries with highest Death Count Per Population
select location, max(total_deaths) as total_death_count
from covid_deaths
where continent is not null --and location = 'Nigeria'
group by 1
order by 2 desc;


-- Now lets break things down by Continent
-- Showing continents with the highest death count per Population
select continent, max(total_deaths) as total_death_count
from covid_deaths
where continent is not null
group by 1
order by 2 desc;

-- Global Numbers
-- Covid Cases and Death percentage by Day

SELECT date, SUM(NEW_CASES) AS TOTAL_CASES,
	SUM(NEW_DEATHS) AS TOTAL_DEATHS,
	ROUND(SUM(NEW_DEATHS :: decimal) / SUM(NEW_CASES) * 100,
		2) AS DEATH_PERCENTAGE
FROM COVID_DEATHS
WHERE CONTINENT IS NOT NULL
GROUP BY Date
ORDER BY 1 DESC, 2;


-- Global Numbers
-- Covid Cases and Death percentage by Month

SELECT DATE_TRUNC('month', date) AS date,
	SUM(NEW_CASES) AS TOTAL_CASES,
	SUM(NEW_DEATHS) AS TOTAL_DEATHS,
	ROUND(SUM(NEW_DEATHS :: decimal) / SUM(NEW_CASES) * 100,
		2) AS DEATH_PERCENTAGE
FROM COVID_DEATHS
WHERE CONTINENT IS NOT NULL
GROUP BY DATE_TRUNC('month', date)
ORDER BY 1, 2;

-- Global Numbers
-- Covid Cases and Death percentage by Year

SELECT DATE_TRUNC('year', date) AS date,
	SUM(NEW_CASES) AS TOTAL_CASES,
	SUM(NEW_DEATHS) AS TOTAL_DEATHS,
	ROUND(SUM(NEW_DEATHS :: decimal) / SUM(NEW_CASES) * 100,
		4) AS DEATH_PERCENTAGE
FROM COVID_DEATHS
WHERE CONTINENT IS NOT NULL
GROUP BY DATE_TRUNC('year', date)
ORDER BY 1, 2;

-- Global Numbers
-- Total Covid Cases and Death percentage

SELECT SUM(NEW_CASES) AS TOTAL_CASES,
	SUM(NEW_DEATHS) AS TOTAL_DEATHS,
	ROUND(SUM(NEW_DEATHS :: decimal) / SUM(NEW_CASES) * 100,
		4) AS DEATH_PERCENTAGE
FROM COVID_DEATHS
WHERE CONTINENT IS NOT NULL
ORDER BY 1, 2;


-- Covid Deaths and Vaccinations
-- A Join of the Deaths and Vaccinations Table

SELECT *
FROM COVID_DEATHS CD
JOIN COVID_VACCINATION CV ON CD.LOCATION = CV.LOCATION
AND CD.DATE = CV.DATE
LIMIT 500;

-- Covid Deaths and Vaccinations
-- Total Population vs Vaccinations

SELECT CD.CONTINENT,
	CD.LOCATION,
	CD.DATE,
	CD.POPULATION,
	CV.NEW_VACCINATIONS
FROM COVID_DEATHS CD
JOIN VACC_TABLE CV ON CD.LOCATION = CV.LOCATION
AND CD.DATE = CV.DATE
WHERE CD.CONTINENT IS NOT NULL
	AND CV.LOCATION = 'Canada'
ORDER BY 2,
	3 DESC;


-- Covid Deaths and Vaccinations
-- Percentage of Population Vaccinated

SELECT CD.CONTINENT,
	CD.LOCATION,
	DATE_TRUNC('year', CD.DATE) AS DAT,
	CD.POPULATION,
	MAX (CV.NEW_VACCINATIONS) AS NEW_VACCINATIONS,
	ROUND((MAX(CV.NEW_VACCINATIONS) / (CD.POPULATION)) * 100, 2) AS PERCENTAGE_VACCINATED
FROM COVID_DEATHS CD
JOIN VACC_TABLE CV ON CD.LOCATION = CV.LOCATION
	AND CD.DATE = CV.DATE
WHERE CD.CONTINENT IS NOT NULL
	AND CV.LOCATION = 'United States'
GROUP BY CD.CONTINENT,
		CD.LOCATION,
		CD.POPULATION,
	DATE_TRUNC('year',CD.DATE)
ORDER BY 1, 2, 3 DESC;


select t1.location,t1.population, max(t1.Rolling_people_vaccinated) as max_vac, (max(t1.Rolling_people_vaccinated) / (t1.population)) * 100  --round(max(t1.Rolling_people_vaccinated) / (t1.population) * 100, 2) as percentages
from
(select cd.continent, cd.location as location, cd.date, cd.population, cv.new_vaccinations, 
	sum(cv.new_vaccinations) over (partition by cd.location order by cd.location, cd.date) as Rolling_people_vaccinated
FROM COVID_DEATHS CD
JOIN VACC_TABLE CV ON CD.LOCATION = CV.LOCATION AND CD.DATE = CV.DATE
WHERE CD.CONTINENT IS NOT NULL --and cd.location = 'Nigeria'
order by 2, 3) t1
Group by t1.location, t1.population;


-- Temp Table
Drop table if exists Percent_people_vaccinated;
Create Table Percent_people_vaccinated
(continent varchar(255),
Location  varchar(255),
date date,
population numeric,
new_vaccinations numeric,
Rolling_people_vaccinated numeric
);

Insert into Percent_people_vaccinated
select cd.continent, cd.location as location, cd.date, cd.population, cv.new_vaccinations, 
	sum(cv.new_vaccinations) over (partition by cd.location order by cd.location, cd.date) as Rolling_people_vaccinated
FROM COVID_DEATHS CD
JOIN VACC_TABLE CV ON CD.LOCATION = CV.LOCATION AND CD.DATE = CV.DATE
WHERE CD.CONTINENT IS NOT NULL --and cd.location = 'Nigeria'
order by 2, 3;

select *,  (Rolling_people_vaccinated / population) * 100 as Percentage_vaccinated
from Percent_people_vaccinated
--where continent is not null
--Group  by location, Rolling_people_vaccinated, continent, date, population, (Rolling_people_vaccinated / population) * 100;


--Create Views
Create view Percent_people_vaccinated2 as
select cd.continent, cd.location as location, cd.date, cd.population, cv.new_vaccinations, 
	sum(cv.new_vaccinations) over (partition by cd.location order by cd.location, cd.date) as Rolling_people_vaccinated
FROM COVID_DEATHS CD
JOIN VACC_TABLE CV ON CD.LOCATION = CV.LOCATION AND CD.DATE = CV.DATE
WHERE CD.CONTINENT IS NOT NULL --and cd.location = 'Nigeria'
order by 2, 3;






























