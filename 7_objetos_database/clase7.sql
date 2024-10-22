-- Crear la Base de datos
DROP DATABASE IF EXISTS clase7;
CREATE DATABASE clase7;

USE clase7;


-- [troops] 1 -- * [friends]

-- Crear la tabla TROOP
CREATE TABLE TROOP(
	id_troop INT NOT NULL AUTO_INCREMENT,
    descripcion VARCHAR(100),
    
    PRIMARY KEY(id_troop)
);

-- Crear la tabla FRIENDS

CREATE TABLE FRIENDS(
	id_friends INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    id_troop INT,
    
    PRIMARY KEY(id_friends)
);

-- Agregar ka restriccion de clave externa usando ALTER TABLE

ALTER TABLE FRIENDS
	ADD CONSTRAINT fk_troop_id
FOREIGN KEY(id_troop) REFERENCES TROOP(id_troop);

-- INSERCION DE 20 REGISTROS PARA FRIENDS 
-- INSERCION DE 5 REGISTROSS PARA TROOPS

-- Insertar registros en la tabla TROOP
INSERT INTO TROOP (descripcion)
VALUES
    ('Troop Air'),
    ('Troop Attack'),
    ('Troop Naive'),
    ('Troop Ground'),
    ('Troop War');

-- Insertar registros en la tabla FRIENDS
-- Insertar 10 registros con TROOP = 1
INSERT INTO FRIENDS (first_name, last_name, id_troop)
VALUES
    ('John', 'Doe', 1),
    ('Jane', 'Smith', 1),
    ('Alice', 'Johnson', 1),
    ('Bob', 'Williams', 1),
    ('William', 'Garcia', 1),
    ('Sophia', 'Lopez', 1),
    ('Ethan', 'Adams', 1),
    ('Charlotte', 'Rivera', 1),
    ('Daniel', 'King', 1),
    ('David', 'Evans', 1);

-- Insertar 10 registros con TROOP = 2
INSERT INTO FRIENDS (first_name, last_name, id_troop)
VALUES
    ('Michael', 'Brown', 2),
    ('Olivia', 'Martinez', 2),
    ('Alexander', 'Scott', 2),
    ('Mia', 'Baker', 2),
    ('Matthew', 'Hall', 2),
    ('Liam', 'Wright', 2),
    ('Jane', 'Smith', 2),
    ('Michael', 'Brown', 2),
    ('Olivia', 'Martinez', 2),
    ('Alexander', 'Scott', 2);

-- Insertar 10 registros con TROOP = 3
INSERT INTO FRIENDS (first_name, last_name, id_troop)
VALUES
    ('Emma', 'Jones', 3),
    ('James', 'Hernandez', 3),
    ('Ava', 'Green', 3),
    ('Amelia', 'Lee', 3),
    ('Emma', 'Jones', 3),
    ('James', 'Hernandez', 3),
    ('Ava', 'Green', 3),
    ('Amelia', 'Lee', 3),
    ('Jane', 'Smith', 3),
    ('Michael', 'Brown', 3);

-- Insertar 20 registros con TROOP = NULL
INSERT INTO FRIENDS (first_name, last_name, id_troop)
VALUES
    ('John', 'Doe', NULL),
    ('Jane', 'Smith', NULL),
    ('Alice', 'Johnson', NULL),
    ('Bob', 'Williams', NULL),
    ('William', 'Garcia', NULL),
    ('Sophia', 'Lopez', NULL),
    ('Ethan', 'Adams', NULL),
    ('Charlotte', 'Rivera', NULL),
    ('Daniel', 'King', NULL),
    ('David', 'Evans', NULL),
    ('Michael', 'Brown', NULL),
    ('Olivia', 'Martinez', NULL),
    ('Alexander', 'Scott', NULL),
    ('Mia', 'Baker', NULL),
    ('Matthew', 'Hall', NULL),
    ('Liam', 'Wright', NULL),
    ('Emma', 'Jones', NULL),
    ('James', 'Hernandez', NULL),
    ('Ava', 'Green', NULL),
    ('Amelia', 'Lee', NULL);


-- VISTAS

-- EJEMPLO DE UNA VISTA EN MYSQL
CREATE VIEW VW_FRIENDS AS
SELECT 
    f.*,
    COALESCE(
        t.DESCRIPCION,
        'TROPA NO DETERMINADA :S'
    ) AS DESCRIPCION
FROM FRIENDS AS f
LEFT JOIN TROOP AS t
    ON f.id_troop = t.id_troop
WHERE f.LAST_NAME LIKE 'D%';


-- INSERTAR UN NUEVO FRIEND
INSERT INTO FRIENDS (first_name, last_name, id_troop)
VALUES
	('JACK', 'DANIELDS', NULL);

-- LLAMAR A LA VISTA

SELECT 
	*
FROM VW_FRIENDS;


-- FUNCIONES
DROP FUNCTION IF EXISTS func_concat;

DELIMITER // 
CREATE FUNCTION func_concat
( 		EXTRA_VALUE VARCHAR(20),
		SEP_CHAR VARCHAR(10),
        NAME VARCHAR(100),
        LAST_NAME VARCHAR(100)
) RETURNS VARCHAR(255)
DETERMINISTIC
	BEGIN
		SET @total = CONCAT_WS(
			SEP_CHAR,
            EXTRA_VALUE,
            NAME,
            LAST_NAME
        );
        RETURN @total;
	END//
DELIMITER ;

-- USABILIDAD
CREATE VIEW VW_DATA_CONCAT_FIRE AS
SELECT func_concat(
	CONCAT('usuario # ' , f.id_friends , ' :'),
    ' ',
    f.first_name,
    f.last_name
) AS concatenacion,
T.descripcion
FROM clase7.friends AS f
JOIN clase7.troop AS t
	ON f.id_troop = t.id_troop;
    
SELECT * FROM clase7.vw_data_concat_fire;

-- TRIGGER

DELIMITER //

CREATE TRIGGER before_insert_trigger
BEFORE INSERT ON TROOP
FOR EACH ROW
BEGIN
	-- Realizar alguna accion, como validar los datos antes de la insercion
	IF NEW.DESCRIPCION NOT LIKE 'TROOP %' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO SE PERMITEN NOMBRES DE TROPPS VACIAS';
	END IF;
END //

DELIMITER ;

INSERT INTO TROOP
	(DESCRIPCION)
    VALUES('NO VA A FuNCIONAR');
    

INSERT INTO TROOP
	(DESCRIPCION)
    VALUES('TROOP NO VA A FuNCIONAR');

SELECT 
	*
FROM TROOP;


DELIMITER //

CREATE PROCEDURE InsertFriendWithTroop (
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_troop_id INT
)
BEGIN
    DECLARE troop_count INT;

    -- Verificar si existe una tropa con el ID proporcionado
    SELECT COUNT(*) INTO troop_count FROM TROOP WHERE id_troop = p_troop_id;

    IF troop_count > 0 THEN
        -- Insertar el amigo en la tabla FRIENDS
        INSERT INTO FRIENDS (first_name, last_name, id_troop)
        VALUES (p_first_name, p_last_name, p_troop_id);
    ELSE
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'No se puede insertar el amigo porque no existe una tropa con el ID proporcionado';
    END IF;
END//

DELIMITER ;


CALL InsertFriendWithTroop('Nico', 'Bueti', 2);
CALL InsertFriendWithTroop('EDGAR', 'Steinberg', 10);