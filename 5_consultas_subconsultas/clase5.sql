-- CLASE 5 
-- EJEMPLOS DE JOINS
DROP DATABASE IF EXISTS joins_schema;
CREATE DATABASE joins_schema; 

USE joins_schema;

CREATE TABLE pais (
	nombre_pais VARCHAR(100) PRIMARY KEY,
    area_total INT
);

CREATE TABLE ciudad(
	nombre_ciudad VARCHAR(100) PRIMARY KEY,
    pais_pertenece VARCHAR(100)
);


INSERT INTO joins_schema.pais VALUES
("argentina" , 600),
("mexico", 12000) ;

INSERT INTO joins_schema.ciudad VALUES
("lima", "peru"),
("chaco","argentina"),
("tilcara","argentina"),
("bogota","colombia");


SELECT *
FROM joins_schema.pais ;

SELECT *
FROM joins_schema.ciudad;


SELECT 
	p.nombre_pais AS nombre_pais_tabla_pais,
	c.pais_pertenece AS nombre_pais_tabla_ciudad,
    c.nombre_ciudad 
FROM joins_schema.pais  AS p -- izq
-- INNER JOIN joins_schema.ciudad AS c
-- LEFT JOIN joins_schema.ciudad AS c  -- der
 RIGHT JOIN joins_schema.ciudad AS c
	ON p.nombre_pais = c.pais_pertenece
;

-- UNION => 

USE coderhouse_gamers;

SELECT * FROM coderhouse_gamers.system_user LIMIT 10;
-- OBTENER TODOS LOS USUARIOS QUE TENGAN A_C COMO NOMBRES TODO EN MAYUSCULAS
-- Y EN LA MISMA TABLA TENER LOS DE F-Z PERO TODO EN MINISCULAS

SELECT 
	UPPER(CONCAT_WS(", ", last_name, first_name)) AS Nombre_completo,
    UPPER(email) AS 'ema@il'
FROM
	coderhouse_gamers.system_user
WHERE 
	first_name REGEXP '^[a-c]'
-- ORDER BY first_name
UNION
SELECT 
	LOWER(CONCAT_WS("; ", last_name, first_name)) AS nombre,
    LOWER(email) AS 'email'
FROM
	coderhouse_gamers.system_user
WHERE
	first_name REGEXP '^[f-z]';
-- ORDER BY first_name DESC;

--  NUMERICS - STRING - BOOL - DATE - UUID(string) - NULL -> SON TAMBIEN TIPO DE DATOS

-- -> FLOAT(6,2)    9999,99

-- STRING:
 -- CHAR, VARCHAR, --> BINARY, VARBINARY, BLOB, TEXT.., ENUM.., and SET.

-- DATE YYYY-MM-DD--> ISO 8601 'YYYY-MM-DD hh:mm:ss'  TIMESTAMP (UNIX) -> DATETIME == YYYY-MM-DD hh:mm:ss

-- BOOL - TRUE/FALSE  analogo -> TINY INT 1 - 0 ;


-- CAST :: SQL - NO SQL - BACK END FRONT


-- GROUP BY || => LAS SUBQUERIES -> solamente cuando no tengo FK's Mejoran la performance de toda query que 
-- no tenga indices per se

-- SUBQUERY (UNA QUERY DENtRO DE OTRA QUERY)
-- <sql> --> codorehouse_gamers.play codehouse_gamars.system_user

-- CUANTOS JUEGOS FUERON COMPLETADOS POR TODOS LOS USUARIOS DONDE EL EMAIL CONTINE .COM

SELECT * FROM coderhouse_gamers.PLAY LIMIT 10;

SELECT 
	id_system_user
FROM coderhouse_gamers.system_user
WHERE email REGEXP '.com$'; -- LIKE '%.com'


-- QUERY MAIN
SELECT * FROM coderhouse_gamers.PLAY 
WHERE id_system_user IN (
-- SUBQUERY
	SELECT id_system_user
    FROM coderhouse_gamers.system_user
    WHERE email REGEXP '.com$'
);

-- OPERADOR EXISTS
	SELECT p.* 
	FROM coderhouse_gamers.PLAY AS p 
	WHERE EXISTS (
-- SUBQUERY
		SELECT id_system_user -- INT
		FROM coderhouse_gamers.system_user AS U
		WHERE email REGEXP '.com$'
		AND P.id_system_user = u.id_system_user
);

SELECT 
	universo.id_game AS juego
,	COUNT(universo.completed) AS total_usuarios
FROM (
    SELECT * FROM coderhouse_gamers.PLAY 
	WHERE id_system_user IN (
	-- SUBQUERY
		SELECT id_system_user
		FROM coderhouse_gamers.SYSTEM_USER
		WHERE email REGEXP '.com$'
	)
)AS universo 
WHERE universo.completed = 1
GROUP BY universo.id_game
HAVING total_usuarios > 6
ORDER BY total_usuarios DESC
LIMIT 2;


