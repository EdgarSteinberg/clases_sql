-- USE coderhouse_gamers;
-- DELIMITER //

-- DROP TRIGGER IF EXISTS coderhouse_gamers.trigger_bi_pwd //

-- CREATE
--  TRIGGER coderhouse_gamers.trigger_bi_pwd
-- BEFORE INSERT 
-- ON coderhouse_gamers.SYSTEM_USER FOR EACH ROW
-- BEGIN
--     SET @msg = "Minimum eight characters, at least one letter and one number";

--     IF NOT NEW.password REGEXP '^(?=.*[A-Za-z])(?=.*[0-9])[A-Za-z0-9]{8,}$' THEN
--         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @msg;
--     END IF;
-- END //

-- -- update
-- DROP TRIGGER IF EXISTS coderhouse_gamers.trigger_au_pwd //

-- CREATE
-- 	TRIGGER coderhouse_gamers.trigger_au_pwd
-- 	AFTER UPDATE
-- 	ON coderhouse_gamers.SYSTEM_USER FOR EACH ROW
-- BEGIN
--     SET @default_value = "NO DECLARADO";

-- 	IF NEW.last_name = '' THEN 
-- 	
-- 		UPDATE coderhouse_gamers.SYSTEM_USER
-- 			SET last_name = @default_value
--         WHERE
-- 			id_system_user = OLD.id_system_user;
--   
--   END IF;
-- END //

-- DELIMITER ;


-- INSERT INTO `coderhouse_gamers`.`SYSTEM_USER`
-- (
--     `id_system_user`,
--     `first_name`,
--     `last_name`,
--     `email`,
--     `password`,
--     `id_user_type`
-- )
-- VALUES
-- (1400, "pirulo", "tomtom", "pirulo@mail.com", "HolaMundo71", 1);



-- TRIGGERS PARA AUDITORIA 
USE coderhouse_gamers;

CREATE TABLE `coderhouse_gamers`.`SYSTEM_USER_PRODUCTIVA`
(
	`id_system_user` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(200),
    `last_name` VARCHAR(200),
    `email` VARCHAR(200),
    `password` VARCHAR(200),
    `id_user_type` INT,
    `fecha_modificacion` DATETIME DEFAULT(CURRENT_TIMESTAMP),
    `usuario_modificador` VARCHAR(200)
    
);

ALTER TABLE 
    `coderhouse_gamers`.`SYSTEM_USER_PRODUCTIVA`
    ADD COLUMN reason_to_delete VARCHAR(200) DEFAULT 'NO INFO';

ALTER TABLE 
    `coderhouse_gamers`.`SYSTEM_USER_PRODUCTIVA`
    DROP PRIMARY KEY;
    
-- UPDATE CON TRIGGER

DELIMITER //

DROP TRIGGER IF EXISTS coderhouse_gamers.trigger_au_pwd //

CREATE
	TRIGGER coderhouse_gamers.trigger_au_pwd
	AFTER UPDATE
	ON coderhouse_gamers.SYSTEM_USER FOR EACH ROW
BEGIN
    SET @default_value = "NO DECLARADO";

	IF NEW.last_name = '' THEN 
	
		INSERT coderhouse_gamers.SYSTEM_USER_PRODUCTIVA
        VALUES
        (
		NEW.`id_system_user` ,
		NEW.`first_name` ,
		@default_value,
		NEW.`email` ,
		NEW.`password` ,
		NEW.`id_user_type` ,
        DEFAULT,
        USER()
        );
  
  END IF;
END //

DELIMITER ;


UPDATE`coderhouse_gamers`.`SYSTEM_USER`
	SET first_name = "Jose", last_name = ''
    WHERE id_system_user = 1400;


-- DELETE CON TRIGGER

DELIMITER //

DROP TRIGGER IF EXISTS coderhouse_gamers.trigger_ad_pwd //

CREATE
	TRIGGER coderhouse_gamers.trigger_ad_pwd
	AFTER DELETE
	ON coderhouse_gamers.SYSTEM_USER FOR EACH ROW
BEGIN
    SET @reason_to_delete = "BORRADO POR NO SUSCRIPCION";
	
		INSERT coderhouse_gamers.SYSTEM_USER_PRODUCTIVA
        VALUES
        (
		OLD.`id_system_user` ,
		OLD.`first_name` ,
		OLD.`last_name`,
		OLD.`email` ,
		OLD.`password` ,
		OLD.`id_user_type` ,
        DEFAULT,
        USER(),
            @reason_to_delete
        );

END //

DELIMITER ;


DELETE FROM`coderhouse_gamers`.`SYSTEM_USER`
 WHERE id_system_user = 1400;
 

--
USE coderhouse_gamers;

CREATE TABLE coderhouse_gamers.SYSTEM_USER_REPLICA AS 
    SELECT * FROM `coderhouse_gamers`.`SYSTEM_USER`;


DELIMITER //
DROP TRIGGER IF EXISTS coderhouse_gamers.ai_tabla_replica //
CREATE TRIGGER coderhouse_gamers.ai_tabla_replica
    AFTER INSERT
    ON coderhouse_gamers.SYSTEM_USER FOR EACH ROW
BEGIN
    INSERT INTO
        coderhouse_gamers.SYSTEM_USER_REPLICA
    VALUES
        (
    NEW.`id_system_user`
    , NEW.`first_name`
    , NEW.`last_name`
    , NEW.`email`
    , NEW.`password`
    , NEW.`id_user_type`
    );

END //

DROP TRIGGER IF EXISTS coderhouse_gamers.au_tabla_replica //
CREATE TRIGGER coderhouse_gamers.au_tabla_replica
    AFTER UPDATE
    ON coderhouse_gamers.SYSTEM_USER FOR EACH ROW
    FOLLOWS trigger_au_pwd
BEGIN
    UPDATE coderhouse_gamers.SYSTEM_USER_REPLICA
    SET 
        first_name = NEW.first_name,
        last_name = NEW.last_name,
        email = NEW.email,
        password = NEW.password,
        id_user_type = NEW.id_user_type
    WHERE id_system_user = NEW.id_system_user;

END //


DROP TRIGGER IF EXISTS coderhouse_gamers.ad_tabla_replica //
CREATE TRIGGER coderhouse_gamers.ad_tabla_replica
    AFTER DELETE
    ON coderhouse_gamers.SYSTEM_USER FOR EACH ROW
BEGIN

    DELETE FROM coderhouse_gamers.SYSTEM_USER_REPLICA
    WHERE id_system_user = OLD.id_system_user;

END //