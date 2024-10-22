USE coderHouse_gamers;
-- Resolver las siguientes consultas:

-- Todos los comentarios sobre juegos desde 2019 en adelante. (YEAR)
	SELECT
		*
	FROM
		coderhouse_gamers.commentary
	WHERE 
	-- comment_date > '2019-12-31'
    YEAR(comment_date) > 2019
	ORDER BY comment_date
        ;
-- Todos los comentarios sobre juegos anteriores a 2011.
	SELECT
		*
	FROM
		coderhouse_gamers.commentary
	WHERE 
	-- comment_date > '2019-12-31'
    YEAR(comment_date) < 2011
	ORDER BY comment_date DESC
        ;
        
-- Los usuarios y texto de aquellos comentarios sobre juegos cuyo código de juego (id_game) sea 73
SELECT
	*
FROM 
	coderhouse_gamers.game
WHERE id_game = 73;

-- Los usuarios y texto de aquellos comentarios sobre juegos cuyo id de juego no sea 73.
SELECT
	*
FROM 
	coderhouse_gamers.game
WHERE id_game != 73;

-- Aquellos juegos de nivel 1.
-- Aquellos juegos sean de nivel 14, 5 ó 9.
-- Aquellos juegos de nombre 'Riders Republic' o 'The Dark Pictures: House Of Ashes'.
-- Aquellos juegos cuyo nombre empiece con 'Gran'.
-- Aquellos juegos cuyo nombre contenga 'field'.


-- LIMIT
SELECT 
	*
FROM 
	coderhouse_gamers.game LIMIT 10; -- TOP -MS Server

-- TRAER TODOS LOS JUEGOS QUE NO EMPIECEN CON F . OPERADOR (IN)
SELECT 
	*
FROM 
	coderhouse_gamers.game 
WHERE 
	name NOT LIKE 'F%'
	AND id_level IN (11,13,1)
    AND id_class != 195
    AND id_game BETWEEN 20 AND 50
ORDER BY id_level, id_class
;

SELECT
	*
FROM 
	coderhouse_gamers.system_user;
    
-- CONCAT 
-- LOWER 
-- ADD COLS

SELECT
	CONCAT(last_name, ', ', first_name) AS Nombre_Completo
FROM
	coderhouse_gamers.system_user;
    
SELECT
	LOWER(CONCAT(last_name, ', ', first_name)) AS Nombre_Completo,
    CONCAT('Bienvenido: ', email) AS mensaje_bienvenida,
    'Password: changeme123' AS password_user
FROM
	coderhouse_gamers.system_user;
    
-- Funciones de Agregado
-- GRUP BY -- HAVING
SELECT
	id_user_type,
    COUNT(DISTINCT id_system_user) AS Total_De_Usuarios
FROM coderhouse_gamers.system_user
GROUP BY id_user_type
HAVING Total_De_Usuarios > 5
;

-- Que juego tuvo mas cantidad de comentarios
SELECT
	id_game,
    COUNT(commentary) AS Total_De_Comentarios_Por_Juego
FROM	
	coderhouse_gamers.commentary
GROUP BY id_game
ORDER BY  Total_De_Comentarios_Por_Juego DESC
LIMIT 1
;


-- JOIN
-- UN JOIN POR DEFAULT SIEMPRE ES INNERJOIN
SELECT 
    *
FROM
    coderhouse_gamers.game;
SELECT 
    *
FROM
    coderhouse_gamers.commentary;

SELECT
	c.id_game,
    COUNT(c.commentary) AS total_de_comentarios,
    g.*
FROM
	coderhouse_gamers.commentary AS c
JOIN coderhouse_gamers.game as g
	on c.id_game = g.id_game
GROUP BY c.id_game
ORDER BY total_de_comentarios DESC
LIMIT 10;


-- Used SQLite3 for this example

-- table PEOPLE: containing unique ID and corresponding names.
CREATE TABLE PEOPLE (id INT, name CHAR);

INSERT INTO PEOPLE VALUES(1, "A");
INSERT INTO PEOPLE VALUES(2, "B");
INSERT INTO PEOPLE VALUES(3, "C");
INSERT INTO PEOPLE VALUES(4, "D");

-- ADDRESS: containing the history of address information of each ID.
CREATE TABLE ADDRESS (id INTEGER, address VARCHAR(100), updatedate date);

INSERT INTO ADDRESS VALUES(1, "address-1-1", "2016-01-01");
INSERT INTO ADDRESS VALUES(1, "address-1-2", "2016-09-02");
INSERT INTO ADDRESS VALUES(2, "address-2-1", "2015-11-01");
INSERT INTO ADDRESS VALUES(3, "address-3-1", "2016-12-01");
INSERT INTO ADDRESS VALUES(3, "address-3-2", "2014-09-11");
INSERT INTO ADDRESS VALUES(3, "address-3-3", "2015-01-01");
INSERT INTO ADDRESS VALUES(4, "address-4-1", "2010-05-21");
INSERT INTO ADDRESS VALUES(4, "address-4-2", "2012-02-11");
INSERT INTO ADDRESS VALUES(4, "address-4-3", "2015-04-27");
INSERT INTO ADDRESS VALUES(4, "address-4-4", "2014-01-01");


-- 10.1 Join table PEOPLE and ADDRESS, but keep only one address information for each person (we don't mind which record we take for each person). 
    -- i.e., the joined table should have the same number of rows as table PEOPLE

SELECT
	*
FROM
	coderhouse_gamers.people AS p
LEFT JOIN coderhouse_gamers.address AS a
	on p.id = a.id;
