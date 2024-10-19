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
ORDER BY id_level
;