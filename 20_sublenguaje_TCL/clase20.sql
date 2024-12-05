USE donaton;

SET AUTOCOMMIT = FALSE;

INSERT INTO donaton.beneficiario
VALUES
(NULL,"amancion alcorta", "Luisito Rey", CURRENT_DATE());

SET SQL_SAFE_UPDATES = FALSE;

DELETE FROM donaton.beneficiario;

DELETE FROM donaton.centro_recepcion_beneficiario;

-- ROLLBACK es algo parecido al CRL + Z
ROLLBACK;

INSERT INTO donaton.voluntario
VALUES
(NULL, "dobbie", DATE_SUB(CURRENT_DATE(), INTERVAL 19 YEAR));

COMMIT;


-- Soy un boliche 

CREATE TABLE donaton.bolichito
AS
SELECT * FROM donaton.voluntario;

SET AUTOCOMMIT = FALSE;
SELECT COUNT(1) FROM donaton.bolichito;

DELETE FROM donaton.bolichito
WHERE id_voluntario >= 10;

INSERT INTO donaton.`bolichito` (`nombre`, `fecha_nacimiento`) VALUES
('Andrés García', '1985-04-23'),
('María López', '1990-08-15'),
('Juan Pérez', '1978-11-05');
SAVEPOINT primera_tanda;

INSERT INTO donaton.`bolichito` (`nombre`, `fecha_nacimiento`) VALUES
('Lucía González', '1995-02-20'),
('Carlos Mendoza', '1982-06-18'),
('Sofía Rodríguez', '2000-09-12');
SAVEPOINT segunda_tanda;

INSERT INTO donaton.`bolichito` (`nombre`, `fecha_nacimiento`) VALUES
('Miguel Torres', '1987-03-30'),
('Ana Martínez', '1992-07-08'),
('Javier Fernández', '1980-01-25'),
('Laura Ramírez', '1998-10-14');
SAVEPOINT tercera_tanda;

ROLLBACK;

ROLLBACK TO segunda_tanda;

commit;

---------------------------------------------------------
-- 2da parte de la clase

DELIMITER //
DROP PROCEDURE IF EXISTS donaton.ingesta_personas//
CREATE PROCEDURE donaton.ingesta_personas(IN cuota INT)
BEGIN
    DECLARE max_personas INT DEFAULT 150;
    DECLARE total_personas INT DEFAULT 0;
    DECLARE identificacion VARCHAR(200); -- Corregido aquí
    DECLARE fecha_nacimiento DATE;
    
    SELECT COUNT(*) INTO total_personas FROM donaton.bolichito;
    
    -- Iniciar transacción
    START TRANSACTION;
    
    WHILE total_personas < cuota DO
        SET identificacion = CONCAT('Persona', total_personas + 1); -- Corregido aquí
        SET fecha_nacimiento = DATE_SUB(CURDATE(), INTERVAL (20 + total_personas MOD 30) YEAR);
        
        INSERT INTO donaton.bolichito (`nombre`, `fecha_nacimiento`)
        VALUES (identificacion, fecha_nacimiento); -- Corregido aquí
        
        SET total_personas = total_personas + 1;
    END WHILE;

    SELECT COUNT(*) INTO total_personas FROM bolichito;
    
    IF total_personas < max_personas THEN
        SELECT 'NO SE HA LLENADO EL BOLICHE' AS msg,
        (max_personas - total_personas )AS cupo_disponible
        ;
        COMMIT;
    ELSE
		SELECT 'NO SE PUEDE INGRESAR ESTAS PERSONAS, EL BOLICHE ESTA LLENO ' 
        ROLLBACK;
    END IF;
END//
DELIMITER ;

CALL donaton.ingesta_personas(29);