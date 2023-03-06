-- Viendo a toda la poblacion vs vacunacion

SELECT 
	dea.continent,
    dea.location,
    STR_TO_DATE(dea.date,'%d/%m/%Y') as 'date',
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, STR_TO_DATE(dea.date,'%d/%m/%Y')) as suma_acumulada_vac
FROM proyecto1.covid_deaths as dea
JOIN proyecto1.covid_vacc as vac
	ON dea.location = vac.location
    AND dea.date = vac.date -- Join en base a dos columnas!
WHERE
	NOT dea.continent = ''
ORDER BY
	2,3;

-- USEMOS CTE para poder manipular mas facil la tabla creada anteriormente

WITH PopvsVac (continent,location,date,population,new_vaccionations,suma_acumulada_vac)
as
(
SELECT 
	dea.continent,
    dea.location,
    STR_TO_DATE(dea.date,'%d/%m/%Y') as 'date',
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, STR_TO_DATE(dea.date,'%d/%m/%Y')) as suma_acumulada_vac
FROM proyecto1.covid_deaths as dea
JOIN proyecto1.covid_vacc as vac
	ON dea.location = vac.location
    AND dea.date = vac.date -- Join en base a dos columnas!
WHERE
	NOT dea.continent = ''
-- ORDER BY
	-- 2,3
)
SELECT 
	*, ROUND((suma_acumulada_vac/population),2)*100
FROM
	PopvsVAC
ORDER BY
	2,3;

-- TABLA TEMPORAL (OTRA OPCION)
CREATE TEMPORARY TABLE PorcentajePoblacionVacunada
SELECT 
	dea.continent,
    dea.location,
    STR_TO_DATE(dea.date,'%d/%m/%Y') as 'date',
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, STR_TO_DATE(dea.date,'%d/%m/%Y')) as suma_acumulada_vac
FROM proyecto1.covid_deaths as dea
JOIN proyecto1.covid_vacc as vac
	ON dea.location = vac.location
    AND dea.date = vac.date -- Join en base a dos columnas!
WHERE
	NOT dea.continent = ''
ORDER BY
	2,3;

-- SELECCIONANDO TABLA TEMPORAL
SELECT
	*
FROM
	PorcentajePoblacionVacunada;
    
-- CREANDO VISTA (PARA USAR EN HERRAMIENTA DE BI MAS ADELANTE)

CREATE VIEW PorcentajePoblacionVacunada
AS
SELECT 
	dea.continent,
    dea.location,
    STR_TO_DATE(dea.date,'%d/%m/%Y') as 'date',
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, STR_TO_DATE(dea.date,'%d/%m/%Y')) as suma_acumulada_vac
FROM proyecto1.covid_deaths as dea
JOIN proyecto1.covid_vacc as vac
	ON dea.location = vac.location
    AND dea.date = vac.date -- Join en base a dos columnas!
WHERE
	NOT dea.continent = ''
ORDER BY
	2,3;
