
DROP DATABASE IF EXISTS procedures;
CREATE DATABASE procedures;

USE procedures;

-- SELECT * FROM coderhouse_gamers.SYSTEM_USER;
-- Me transforme datos de usuarios de coderhouse_gamers y que le anexe
-- baja ciertos criteros de negocio una ciudad.

-- EXTRACT --> 2 bases de datos
-- 	usuarios + ciudades que le agreguen
-- TRANSFORM --> estos usuarios agregarle data y adaptarlo a la necesidad del negocio

-- LOAD -->> tabla dentro de una bse de datos que maneje cierto negocio

-- Todos los usuarios que tengan .edu .pl .gov quiero q sean de Munich
-- la gente que tengan . com que sean de paris
-- los que sean .or sean del resto de ciudades

-- FUncion

DELIMITER //
DROP FUNCTION IF EXISTS procedures.fx_search_city //

CREATE FUNCTION 
	procedures.fx_search_city(_mail VARCHAR(200))
RETURNS VARCHAR(200)
	READS SQL DATA
BEGIN
	
    DECLARE _id_ciudad INT;
    DECLARE nombre_ciudad VARCHAR(200) DEFAULT 'ciudad no reconocida';
    
	CASE 
		WHEN _mail LIKE '%.com' THEN
			SET _id_ciudad = 3;
		WHEN  _mail REGEXP '\\.(ed|pl|gov)$' THEN
			SET _id_ciudad = 8;
		ELSE 
			SET _id_ciudad = 10;
    END CASE;
    
    SELECT nombre INTO nombre_ciudad
		FROM funciones.ciudad
	WHERE id_ciudad = _id_ciudad;
    
    RETURN nombre_ciudad;
END //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS procedures.sp_transform_load_users //
CREATE PROCEDURE procedures.sp_transform_load_users(
	IN first_char VARCHAR(2)
)
BEGIN
	   
    INSERT INTO  `procedures`.`usuarios_nuevos_productiva`
    (first_name,last_name,email,ciudad)
	SELECT 
		s.first_name,
		s.last_name,
		s.email,
		procedures.fx_search_city(s.email) AS ciudad
FROM 
	coderhouse_gamers.SYSTEM_USER AS s

	WHERE 
		s.first_name LIKE CONCAT(first_char, '%');
END //

DELIMITER ;

CREATE TABLE `procedures`.`usuarios_nuevos_productiva` (
   `usuario_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,	
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(30) NOT NULL,
  `ciudad` varchar(200) DEFAULT NULL,
  stamp_ulpload DATETIME DEFAULT(CURRENT_TIMESTAMP)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CALL procedures.sp_transform_load_users('z');


-- Creacion de un usuario
-- Validar si el usuario existe si no existe crearlo
-- Validar que la ciudad exista dentro de la BD sino crearlo

-- procedure => 
-- validacion de existencia

-- procedure => 
-- creacion de ciudad
-- creacion de pais

-- procedure
-- ingreso de datos

DELIMITER //

DROP PROCEDURE IF EXISTS procedures.sp_validacion //
CREATE PROCEDURE procedures.sp_validacion(
IN _name VARCHAR(100), IN _last_name VARCHAR(200), IN _email VARCHAR(200),
IN _pais VARCHAR(30), IN _ciudad VARCHAR(30),
OUT existencia_usuario INT,
OUT existencia_pais INT,
OUT existencia_ciudad INT
)BEGIN
	
	SET existencia_usuario = 0;
    SET existencia_pais= 0;
    SET existencia_ciudad= 0;
    
    -- Validar existencia de usuario
	SELECT
			id_system_user INTO existencia_usuario
		FROM coderhouse_gamers.SYSTEM_USER
        WHERE email = email
        AND last_name = last_name
        AND first_name = _name
        LIMIT 1
        ;
    
    SELECT
		c.id_ciudad ,   p.id_pais INTO existencia_ciudad , existencia_pais
    FROM funciones.ciudad AS c
    INNER JOIN funciones.pais AS p
		USING(id_pais)
	WHERE c.nombre = _ciudad AND p.nombre = _pais;
    
END//

DROP PROCEDURE procedures.sp_ciudadano //
CREATE PROCEDURE procedures.sp_ciudadano(
IN _name VARCHAR(100), IN _last_name VARCHAR(200), IN _email VARCHAR(200),
OUT existencia_usuario INT)
BEGIN
	DECLARE id INT ;

	IF existencia_usuario = 0 THEN
		SELECT id_system_gamers.SYSTEM_USER
        ORDER BY id_system_user DESC
        LIMIT 1;
        
        SET id = id + 1;
        
		INSERT INTO coderhouse_gamers.SYSTEM_USER
        VALUE(id, _name, last_name, _email, 'change_me!', 1);
        SET existencia_pais = id;
	END IF;
END//


DROP PROCEDURE procedures.sp_ciudad_pais //

CREATE PROCEDURE procedures.sp_ciudad_pais(
	IN pais VARCHAR(30), IN _ciudad VARCHAR(30),
    OUT existencia_pais INT,
    OUT existencia_ciudad INT
)
BEGIN
	
		IF existencia_pais = 0 THEN
			INSERT INTO funciones.pais
			(nombre)
            VALUE(_pais);
            SELECT LAST_INSERT_ID() INTO existencia_pais;
		END IF;
		
		 IF existencia_pais = 0 THEN	
        	INSERT INTO funciones.ciudad
			(nombre, id_pais)
            VALUE(_ciudad, existencia_ciudad);
            SELECT LAST_INSERT_ID() INTO existencia_ciudad;
END ;


DELIMITER ;    

SET @existencia_usuario = 0;
SET @existencia_ciudad = 0;
SET @existencia_pais = 0;

CALL procedures.sp_validacion(
'jorge',
'amancio',
'mail@mail.com',
 'Francia',
 'París',
 @existencia_usuario ,
@existencia_ciudad ,
 @existencia_pais 
 );
 
 SELECT
  @existencia_usuario ,
@existencia_ciudad ,
 @existencia_pais FROM DUAL;
 

 