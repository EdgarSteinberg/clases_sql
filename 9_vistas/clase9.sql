-- QUE TAL SI, GENERAMOS UN KPI PARA SABER
-- CUAL ES LA CATEGORIA DE USUARIOS


USE coderhouse_gamers;


-- CUANTOS JUEGOS COMPLETO CADA JUGADOR
SELECT
	id_system_user,
    COUNT(id_game) AS Total_juegos_completados
FROM
	coderhouse_gamers.PLAY
WHERE completed = 1
GROUP BY id_system_user
ORDER BY Total_juegos_completados DESC
;

-- VISTA

-- CREATE 
-- 	OR REPLACE VIEW coderhouse_gamers.vw_total_juegos_completados_by_user
-- 	AS
-- 		SELECT
-- 			id_system_user,
-- 			COUNT(id_game) AS Total_juegos_completados
-- 		FROM
-- 			coderhouse_gamers.PLAY
-- 		WHERE completed = 1
-- 		GROUP BY id_system_user
-- 		ORDER BY Total_juegos_completados DESC
-- 		;



-- LLAMANDO A LA VISTA

SELECT
	*
FROM
	coderhouse_gamers.vw_total_juegos_completados_by_user;
    


-- Utilizamos la vista para hacer una nueva tabla de categoria que son los juegos completados y un count para el total por categoria

SELECT
	Total_juegos_completados AS categoria,
    COUNT(id_system_user) AS total_por_categoria
FROM
	coderhouse_gamers.vw_total_juegos_completados_by_user
GROUP BY categoria    
    ;
    
    
-- Luego la pasamos a una vista

CREATE 
	OR REPLACE
    VIEW vw_super_tabla_categorica
    AS SELECT
			Total_juegos_completados AS categoria,
			COUNT(id_system_user) AS total_por_categoria
		FROM
			coderhouse_gamers.vw_total_juegos_completados_by_user
		GROUP BY categoria  ;

-- INSERTAMOS A UN USUARIO 5 JUEGOS COMPLETADOS Y OTRO CON 6
INSERt INTO coderhouse_gamers.PLAY VALUES
(2,21,1),
(10,21,1),
(22,21,1),
(77,21,1),
(78,21,1),
(66,21,1);

SELECT 
	*
FROM vw_super_tabla_categorica;


-- TABLAS TEMPORALES SOLO VIVEN EN LA SESION DE CREADO
CREATE
	TEMPORARY TABLE
	coderhouse_gamers.temp_categorias
    AS
		SELECT *
		FROM coderhouse_gamers.vw_super_tabla_categorica
        WHERE total_por_categoria > 50;
	
-- LLAMO A LA TABLA
SELECT *
FROM coderhouse_gamers.temp_categorias;


-- SUPER QUERIE CON SUBQUERIE
-- Muestre nombre, apellido y mail de los usuarios que juegan al juego FIFA 22.

CREATE
	OR REPLACE
	VIEW coderhouse_gamers.vw_vista_con_subquery
    AS
SELECT
	SU.first_name AS nombre,
    SU.last_name AS apellido,
    SU.email AS email
FROM coderhouse_gamers.system_user AS SU
WHERE id_system_user IN
	(
	SELECT
		id_system_user
	FROM coderhouse_gamers.PLAY AS P
    WHERE EXISTS
		(SELECT
			id_game
		FROM coderhouse_gamers.GAME AS G
        WHERE G.id_game = P.id_game
        AND G.name LIKE '%FIFA 22%'));

-- JOIN QUE CUMPLE LA MISMA CONSIGNA
	SELECT 
		SU.first_name AS nombre,
        SU.last_name AS apellido,
        SU.email AS mail
	FROM 
		coderhouse_gamers.system_user AS SU
	JOIN coderhouse_gamers.PLAY AS P
	-- ON SU.id_system_user = P.id_system_user
		USING(id_system_user)
	JOIN coderhouse_gamers.GAME AS G
	-- ON P.id_game = G.id_game
		USING(id_game)
	WHERE G.name LIKE '%FIFA 22%';

-- VISTA CON JOIN
CREATE
	OR REPLACE
    VIEW coderhouse_gamers.vw_vista_con_joins
    AS
    SELECT 
		SU.first_name AS nombre,
        SU.last_name AS apellido,
        SU.email AS mail
	FROM 
		coderhouse_gamers.system_user AS SU
	JOIN coderhouse_gamers.PLAY AS P
	-- ON SU.id_system_user = P.id_system_user
		USING(id_system_user)
	JOIN coderhouse_gamers.GAME AS G
	-- ON P.id_game = G.id_game
		USING(id_game)
	WHERE G.name LIKE '%FIFA 22%';
    
    SELECT *
    FROM coderhouse_gamers.vw_vista_con_joins;
    
    
-- PARA VERIFICAR LA PERFORMANCIA
--     
SET profiling = 1;
SHOW PROFILES;

SELECT *
FROM coderhouse_gamers.vw_vista_con_subquery;

-- SHOW PROFILE FOR QUERY <Query_ID>;

SELECT *
FROM coderhouse_gamers.vw_vista_con_joins;

SHOW PROFILE FOR QUERY 3;
        

-- Muestre los distintos juegos que tuvieron una votación mayor a 9.

DESCRIBE coderhouse_gamers.VOTE;

SELECT
	DISTINCT g.name AS nombre_juego
FROM
	coderhouse_gamers.VOTE
LEFT JOIN coderhouse_gamers.GAME g
	USING(id_game)
WHERE
	 value > 6
ORDER BY nombre_juego;

-- VISTA
CREATE
	OR REPLACE
    VIEW coderhouse_gamers.vw_juegos_gt_nueve
    AS
    SELECT
	DISTINCT g.name AS nombre_juego
	FROM
		coderhouse_gamers.VOTE
	LEFT JOIN coderhouse_gamers.GAME g
		USING(id_game)
	WHERE
		 value > 6
	ORDER BY nombre_juego;
     
SELECT *
FROM coderhouse_gamers.vw_juegos_gt_nueve;


-- Muestre first_name y last_name de los usuarios que tengan mail ‘webnode.com’

SELECT
	CONCAT(first_name, ", ", last_name) AS full_name,
    IF (CHAR_LENGTH(password) >=8, "cumple criterio" , "no cumple criterio") AS strong_passwrod
FROM 
	coderhouse_gamers.system_user
WHERE
	email LIKE '%webnode.com%';
    
-- VISTA

CREATE
	OR REPLACE
    VIEW coderhouse_gamers.vw_usuario_si_cumple_condicion
    AS
	SELECT
		CONCAT(first_name, ", ", last_name) AS full_name,
		IF (CHAR_LENGTH(password) >=8, "cumple criterio" , "no cumple criterio") AS strong_passwrod
	FROM 
		coderhouse_gamers.system_user
	WHERE
		email LIKE '%.com%';
        
SELECT
	*
FROM
	coderhouse_gamers.vw_usuario_si_cumple_condicion;
    
SHOW CREATE TABLE coderhouse_gamers.vw_usuario_si_cumple_condicion;

CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `vw_usuario_si_cumple_condicion` AS
    SELECT 
        CONCAT(`system_user`.`first_name`,
                ', ',
                `system_user`.`last_name`) AS `full_name`,
        IF((CHAR_LENGTH(`system_user`.`password`) >= 8),
            'cumple criterio',
            'no cumple criterio') AS `strong_passwrod`
    FROM
        `system_user`
    WHERE
        (`system_user`.`email` LIKE '%.com%')