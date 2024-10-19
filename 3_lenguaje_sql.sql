-- DQL : DATA QUERY LANGUAGE.

-- DROP DATABASE coderhouse_gamers; -- Borra la BD.
USE coderhouse_gamers; -- Me paro sobre la BD.

SELECT -- Selecioname.
	* -- Todas las columnas .
FROM
 coderhouse_gamers.system_user; -- sytem_user.

-- Un poco mas declarativo.

SELECT	
	first_name,
    last_name,
    email
FROM
	coderhouse_gamers.system_user;


-- Alias o Renombramiento de columnas AS .
SELECT	
	first_name AS Nombre,
    last_name AS Apellido,
    email AS Correo
FROM
	coderhouse_gamers.system_user;
    

-- Funciones Escalares o de Transformacion.
-- LOWER (minuscula).
SELECT	
	LOWER(first_name) AS Nombre,
    LOWER(last_name) AS Apellido,
    LOWER(email) AS Correo
FROM
	coderhouse_gamers.system_user;

-- UPPER Mayuscula.
SELECT	
	UPPER(first_name) AS Nombre,
    UPPER(last_name) AS Apellido,
    UPPER(email) AS Correo
FROM
	coderhouse_gamers.system_user;


-- DISTINCT me trae los nombres distintos.
SELECT DISTINCT
	first_name AS Nombre
FROM 
	coderhouse_gamers.system_user;

-- COUNT
SELECT
	COUNT(*)
FROM 
	coderhouse_gamers.system_user;
    
SELECT
	COUNT(first_name)
FROM 
	coderhouse_gamers.system_user;
    
SELECT
	COUNT(DISTINCT first_name)
FROM 
	coderhouse_gamers.system_user;
    
    
-- Nueva columna que me diga si algo es verdadero.
SELECT
	first_name,
    first_name = 'TAM' AS 'ES_TAM'
FROM
	coderhouse_gamers.system_user;

-- WHERE Nos permite a nosotros hacer validaciones que se los conoce como filtros.

SELECT
	first_name AS Nombre,
    last_name,
    UPPER(email) AS Correo_Electronico
FROM 
	coderhouse_gamers.system_user
WHERE
	first_name = 'TAM';
    
    
-- Practicas con la sentencia WHERE

-- Buscar user = TYSON
SELECT
	*
FROM
	coderhouse_gamers.system_user
WHERE
	first_name = 'TYSON';

-- Buscar id_user_type > 334
SELECT
	id_user_type,
    first_name AS Nombre,
    last_name AS Apellido,
    email AS Corre_Electronico
FROM
	coderhouse_gamers.system_user
WHERE 
	id_user_type > 334;

-- Buscar id_system_user = 56 y 88
SELECT
	id_system_user,
    first_name AS Nombre,
    last_name AS Apellido,
    email AS Corre_Electronico
FROM
	coderhouse_gamers.system_user
WHERE 
	id_system_user = 56 OR id_system_user = 88;
    
-- Buscar todos los nombres que arranquen con M
SELECT
	first_name
FROM
	coderhouse_gamers.system_user
WHERE
	first_name LIKE 'M%';