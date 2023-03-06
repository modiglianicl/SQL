-- Script para cargar datos masivamente --
USE proyecto1;

LOAD DATA LOCAL INFILE 'C:/Users/chuck/Desktop/portfolio_project_1/CovidDeaths.csv'
INTO TABLE covid_deaths
COLUMNS TERMINATED BY ';'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/chuck/Desktop/portfolio_project_1/CovidVaccinations.csv'
INTO TABLE covid_vacc
COLUMNS TERMINATED BY ';'
IGNORE 1 LINES;

-- En caso de que no funcione! usar esto --

show global variables like 'local_infile';
SET GLOBAL local_infile = TRUE;