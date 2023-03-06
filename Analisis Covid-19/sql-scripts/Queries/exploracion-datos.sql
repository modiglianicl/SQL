-- Seleccionando datos que usaremos
SELECT
	location,
	STR_TO_DATE(date,'%d/%m/%Y') as 'date',
    total_cases,
    new_cases,
    total_deaths,
    population
FROM 
	proyecto1.covid_deaths
ORDER BY
	location,'date';  
    
-- Viendo el total de casos vs total de muertes
-- Muestra la probabilidad de morir si nos enfermamos de COVID-19 en cierto país

SELECT
	location,
	STR_TO_DATE(date,'%d/%m/%Y') as 'date',
    population,
    total_cases,
    total_deaths,
    ROUND((total_deaths/total_cases)*100,5) as porcentaje_muertes
FROM 
	proyecto1.covid_deaths
WHERE 
	location = 'Chile'
ORDER BY
	'date';

-- Viendo el total de casos vs la poblacion
-- Muestra que porcentaje de la poblacion se enfermo por COVID-19
SELECT
	location,
	STR_TO_DATE(date,'%d/%m/%Y') as 'date',
    total_cases,
    new_cases,
    total_deaths,
    population,
    ROUND(total_cases/population,3)*100 casos_por_poblacion
FROM 
	proyecto1.covid_deaths
WHERE
	location = 'Chile'
ORDER BY
	'date';

-- Viendo paises con tasas maximas de infeccion comparadas a su poblacion
-- Ordenado de mayor a menor
SELECT
	location,
	STR_TO_DATE(date,'%d/%m/%Y') as 'date',
    MAX(total_cases) as max_infeccion,
    MAX(ROUND(total_cases/population,3)*100) casos_por_poblacion
FROM 
	proyecto1.covid_deaths
WHERE
	NOT location IN ('World','Asia','North America','Europe','European Union','South America','International','Africa','South Africa') -- Eliminamos continentes, queremos ver por pais
GROUP BY
	location
ORDER BY
	casos_por_poblacion DESC;
    
-- Mostrando paises con la mayor cantidad de muertes por poblacion

SELECT
	location,
	STR_TO_DATE(date,'%d/%m/%Y') as 'date',
    MAX(total_deaths) as max_muertes
FROM 
	proyecto1.covid_deaths
WHERE
	NOT location IN ('World','Asia','North America','Europe','European Union','South America','International','Africa','South Africa') -- Eliminamos continentes, queremos ver por pais
GROUP BY
	location
ORDER BY
	max_muertes DESC;
    
-- Veamos ahora por continente la maxima cantidad de muertes y su fecha

SELECT
	continent,
	STR_TO_DATE(date,'%d/%m/%Y') as 'date',
    MAX(total_deaths) as max_muertes
FROM 
	proyecto1.covid_deaths
WHERE
	continent IS NOT NULL -- Nos arroja un continente "invisible", error de la db?
    AND NOT continent = '' -- Eliminamos de la query al continente sin nombre
GROUP BY
	continent
ORDER BY
	max_muertes DESC;
    
-- Query para ver continent is null, es decir todo
-- Veamos ahora por continente la maxima cantidad de muertes y su fecha
-- Me di cuenta que hay paises sin continente y paises labeleados como continentes!!

SELECT
	location,
	STR_TO_DATE(date,'%d/%m/%Y') as 'date',
    MAX(total_deaths) as max_muertes
FROM 
	proyecto1.covid_deaths
WHERE
	continent = '' -- Lo debo poner como '', ya que por alguna razon lo tomo como un string invisible y NULL
GROUP BY
	location
ORDER BY
	max_muertes DESC;
    

-- Numeros globales por fecha
SELECT
    STR_TO_DATE(date,'%d/%m/%Y') as 'fecha',
    SUM(new_cases) as nuevos_casos,
    SUM(new_deaths) as nuevas_muertes,
    SUM(new_deaths)/SUM(new_cases)*100 as porcentaje_muertes
FROM
	proyecto1.covid_deaths
WHERE
	continent is not null
GROUP BY
	date
ORDER BY
	1,2;
    
-- Numeros globales totales
SELECT
    SUM(new_cases) as nuevos_casos,
    SUM(new_deaths) as nuevas_muertes,
    SUM(new_deaths)/SUM(new_cases)*100 as porcentaje_muertes
FROM
	proyecto1.covid_deaths
WHERE
	continent is not null
ORDER BY
	1,2;