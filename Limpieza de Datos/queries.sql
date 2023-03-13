-- Explorando datos

SELECT
	*
FROM
	proyecto3.nashvillehousing;
    
-- Limpiando datos

-- Estandarizando formato de fecha a YYYY-MM-DD
-- Ojo, la fecha debe estar en formato date!

SELECT
	SaleDate, DATE_FORMAT(SaleDate,'%Y-%m-%d') as FechaVenta
FROM
	proyecto3.nashvillehousing;
    
-- Populando datos de domicilio propiedad, podemos ver que a.PropertyAddress toma el valor de b.PropertyAddress! en la columna llama "DireccionDomicilio"
-- Creando un CTE dentro de un VIEW para crear una "tabla" nueva, en este caso como vista, en caso de no tener permisos para crear tablas.
CREATE VIEW domicilios_fixed
AS
(
	WITH domiciliosfix
	AS
	(
	SELECT
		a.UniqueID_, a.ParcelID, IFNULL(a.PropertyAddress,b.PropertyAddress) as DireccionDomicilio
	FROM
		proyecto3.nashvillehousing as a
	JOIN
		proyecto3.nashvillehousing as b
		ON a.ParcelID = b.ParcelID
		AND a.UniqueID_ <> b.UniqueID_
    )

SELECT * FROM domiciliosfix
);

-- Ahora que tenemos la tabla temporal con todos los domicilios que requerian "poblarse" ya que estaban nulos, hacemos una union de lo que no tenemos en amblas tablas para tener todos los que no tienen la tabla vista
CREATE VIEW domicilios_final
AS
	(
	SELECT
		*
	FROM
		domicilios_fixed
	WHERE UniqueID_ NOT IN (SELECT UniqueID_ FROM nashvillehousing)
    UNION
    SELECT
		*
	FROM
		domicilios_fixed
	);
    
-- Separando los elementos de la direccion en distintas columnas

SELECT
	PropertyAddress as direccion_full,
	TRIM(SUBSTRING(PropertyAddress, 1, LOCATE(',',PropertyAddress)-1)) as direccion,
    TRIM(SUBSTRING(PropertyAddress, LOCATE(',',PropertyAddress)+2, CHAR_LENGTH(PropertyAddress))) as ciudad
FROM
	nashvillehousing;
    
-- Cambiar a solo dos clases en columna "Sold as Vacant"
-- Hay 4 clases en total...

SELECT
	DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM
	nashvillehousing
GROUP BY
	SoldAsVacant;

-- Hagamos un CTE para poder agruparlo despues
WITH SoldAsVacantFixed
AS
	(
	SELECT
		SoldAsVacant,
		CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END as SoldAsVacantFixed
	FROM
		nashvillehousing
	)
SELECT
	DISTINCT (SoldAsVacantFixed),COUNT(SoldAsVacantFixed)
FROM 
	SoldAsVacantFixed
GROUP BY
	SoldAsVacantFixed;

-- Detectar duplicados (no lo uso mucho, pero nunca esta demás)
CREATE VIEW duplicados_filter
AS
	(WITH DuplicadosCheck
	AS
		(
		SELECT
			*,
			ROW_NUMBER() OVER (
			PARTITION BY ParcelID,
						PropertyAddress,
						SalePrice,
						SaleDate,
						LegalReference
						ORDER BY
							UniqueID_
							) as duplicateId
		FROM
			nashvillehousing
		ORDER BY 
			ParcelID)
	SELECT
		*
	FROM
		DuplicadosCheck
	WHERE
		duplicateId > 1);
    
-- Seleccionando todo sin duplicados!

SELECT
	*
FROM 
	nashvillehousing as a
WHERE
	a.UniqueID_ NOT IN (SELECT
							UniqueID_
						FROM
							duplicados_filter);
	





