
USE donaton;

-- INSERT STATEMENT

-- INSERT
-- 	INTO <table>
--     (cols ...)
--     VALUES
--     (),(),()

DESCRIBE donaton.beneficiario;
INSERT
	INTO donaton.beneficiario
    (id_beneficiario, direccion,nombre_encargado,fecha_creacion)
    VALUES
    (1, 'La Plata', 'Pepito', CURRENT_DATE());
    
SELECT 
    *
FROM
    donaton.beneficiario;

-- Crea una columna nueva
ALTER TABLE	
	donaton.beneficiario
    ADD COLUMN antiguedad_1980 DECIMAL(10,2)
    AS ( DATEDIFF(fecha_creacion, '1980-01-01') /365);

-- Elimina la columna agregada
ALTER TABLE 
	donaton.beneficiario
    DROP COLUMN antiguedad_1980;
    
INSERT
	INTO donaton.beneficiario
    -- (id_beneficiario, direccion,nombre_encargado,fecha_creacion)
    ( direccion,nombre_encargado,fecha_creacion)
    VALUES
    ( 'vera', 'Edgar Steinberg', '1990-02-18');
    
 INSERT
	INTO donaton.beneficiario
    VALUES
    (NULL, 'Lambare', 'Edgar Steinberg', '1990-02-18');   
    

SHOW CREATE TABLE donaton.beneficiario;

CREATE TABLE `beneficiario` (
    `id_beneficiario` INT NOT NULL AUTO_INCREMENT,
    `direccion` VARCHAR(200) DEFAULT NULL,
    `nombre_encargado` VARCHAR(200) DEFAULT NULL,
    `fecha_creacion` DATE DEFAULT NULL,
    PRIMARY KEY (`id_beneficiario`)
)  ENGINE=INNODB AUTO_INCREMENT=6 DEFAULT CHARSET=UTF8MB4 COLLATE = UTF8MB4_0900_AI_CI;
 
 ALTER TABLE donaton.beneficiario
	MODIFY COLUMN fecha_creacion DATE DEFAULT(CURRENT_DATE);
    
CREATE TABLE `beneficiario` (
   `id_beneficiario` int NOT NULL AUTO_INCREMENT,
   `direccion` varchar(200) DEFAULT NULL,
   `nombre_encargado` varchar(200) DEFAULT NULL,
   `fecha_creacion` date DEFAULT (curdate()),
   PRIMARY KEY (`id_beneficiario`)
 ) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
 
 INSERT
	INTO donaton.beneficiario
    (direccion,nombre_encargado,fecha_creacion)
    VALUES
    ('Cuba 87123', 'Celia Cruz', DEFAULT);

 
 INSERT
	INTO donaton.beneficiario
    (direccion,nombre_encargado)
    VALUES
    ('Argentina', 'Leonel Messi');
    
 INSERT
	INTO donaton.beneficiario
    (nombre_encargado, direccion)
    VALUES
    ('Enrique Bochini', 'Bochini y cordero'),
	('Diego Maradona', 'Segurola ');

SELECT 
    *
FROM
    donaton.beneficiario;
    
-- Actualizar Datos
-- UPDATE

-- UPDATE 
-- 	<table>
--     SET cols = valor_new , . .. .
--     WHERE condcicion

SELECT 
    *
FROM
    donaton.beneficiario
WHERE
	nombre_encargado LIKE 'Celia%'
    AND direccion LIKE 'Cuba%'
    ;


SET SQL_SAFE_UPDATES = FALSE;
UPDATE 
	donaton.beneficiario
    SET direccion = 'Miami Fort 777'
WHERE
	nombre_encargado LIKE 'Celia%'
    AND direccion LIKE 'Cuba%'
    ;

UPDATE
	donaton.beneficiario
    SET direccion = 'Miami Fort 666'
WHERE id_beneficiario = 
    (SELECT id_beneficiario
    FROM donaton.beneficiario
    WHERE
		nombre_encargado LIKE 'Celia%'
		AND direccion LIKE 'Miami%'
    LIMIT 1    
        );
        
        
        
-- DELETE

DELETE FROM
	donaton.beneficiario
WHERE
	nombre_encargado LIKE 'Celia%'
    AND direccion LIKE 'Miami Fort 777%';
    
SET FOREING_KEY_CHECKS = FALSE;
TRUNCATE TABLE donaton.beneficiario;