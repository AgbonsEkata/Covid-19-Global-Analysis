-- Global Numbers
-- Total Covid Cases and Death percentage

SELECT SUM(NEW_CASES) AS TOTAL_CASES,
	SUM(NEW_DEATHS) AS TOTAL_DEATHS,
	ROUND(SUM(NEW_DEATHS :: decimal) / SUM(NEW_CASES) * 100,
		4) AS DEATH_PERCENTAGE
FROM COVID_DEATHS
WHERE CONTINENT IS NOT NULL
ORDER BY 1, 2;

-- Now lets break things down by Continent
-- Showing continents with the highest death count per Population
SELECT LOCATION, SUM(NEW_DEATHS) AS TOTAL_DEATH_COUNT
FROM COVID_DEATHS
WHERE CONTINENT IS NULL
	AND LOCATION not in ('World',
						'High income',
						'Upper middle income',
						'Lower middle income',
						'European Union',
						'Low income',
						'International')
GROUP BY 1
ORDER BY 2 DESC;

-- Looking at countries with highest infection rate compared to their Population
SELECT LOCATION,
	POPULATION,
	MAX(TOTAL_CASES) AS HIGHEST_INFECTION_COUNT,
	ROUND((MAX(TOTAL_CASES:: decimal) / POPULATION) * 100, 3) AS PERCENTAGE_POPULATION_INFECTED
FROM COVID_DEATHS
WHERE CONTINENT IS NOT NULL  --and location = 'Nigeria'
GROUP BY 1, 2
ORDER BY 3 DESC;


-- Looking at countries with highest infection rate compared to their Population
SELECT LOCATION,
	POPULATION,
	DATE,
	MAX(TOTAL_CASES) AS HIGHEST_INFECTION_COUNT,
	ROUND((MAX(TOTAL_CASES:: decimal) / POPULATION) * 100, 3) AS PERCENTAGE_POPULATION_INFECTED
FROM COVID_DEATHS
WHERE CONTINENT IS NOT NULL  --and location = 'Nigeria'
GROUP BY 1, 2, 3
ORDER BY 1, 4 DESC;