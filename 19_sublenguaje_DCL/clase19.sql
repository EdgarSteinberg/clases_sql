SHOW TABLES FROM INFORMATION_SCHEMA;
SELECT * FROM INFORMATION_SCHEMA.TRIGGERS;

SHOW TABLES FROM mysql;

SELECT * FROM mysql.user;

-- Creando un usuario el @ permite que se conecte de cualquier parte
CREATE USER 'alvaro'@'%';
-- Delete usuario
DROP USER 'alvaro'@'%';

-- Agregando identificador = password
CREATE USER 'alvaro'@'%' IDENTIFIED BY 'test.db.1234';


-- te voy a regenerar el password pero con la posibilidad de q no seas vos despues del segundo intento no te permita volver a intentarlo

ALTER USER
	'alvaro'@'%'
    IDENTIFIED BY 'change.me.1234'
    PASSWORD EXPIRE INTERVAL 2 DAY
    FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 2;
    
    
-- Creando otro usuario con un password random
-- PS D:\> mysql -u Mauro -p --port 3306 --host 127.0.0.1
CREATE USER 
	'Mauro'@'%'
    IDENTIFIED BY RANDOM PASSWORD;

ALTER USER 
	'Mauro'@'%'
    IDENTIFIED BY RANDOM PASSWORD;   
    
-- 'Mauro', '%', 'fpDrXX&>-ZAKMy8ccUTR', '1'

-- con el usuario creado e ingresado al sistema puedo cambiar la contraseña 
SET PASSWORD = 'andromeda';

-- PERMISOS -> NOS VAN A DAR LA MIRADA SOBRE LOS CAMPOS DE TABLAS Y EN QUE DB QUE PUEDO MIRAR

SHOW GRANTS FOR 'Mauro'@'%';

-- Agregando todos los privilegios a un usuario 

GRANT ALL PRIVILEGES ON donaton.* TO 'Mauro'@'%';

FLUSH PRIVILEGES;


-- Negando los permisos para mauro
REVOKE ALL PRIVILEGES ON donaton.* FROM 'Mauro'@'%';

-- Otorgando permisos para que mauro pueda utilizar el SELECT y INSERTAR SOLO EN LA TABLA DONACION
GRANT SELECT ON donaton.beneficiario TO 'Mauro'@'%';
GRANT SELECT,INSERT ON donaton.donacion TO 'Mauro'@'%';



----------------------------------------------------------------------------
-- ROLES

CREATE ROLE
	'production';
GRANT ALL PRIVILEGES ON coderhouse_gamers.* TO 'production';

CREATE ROLE
	'dev';
GRANT SELECT ON coderhouse_gamers.CLASS TO 'dev'; 
GRANT SELECT ON coderhouse_gamers.GAME TO 'dev'; 

CREATE ROLE
	'qa';
GRANT SELECT, INSERT ON coderhouse_gamers.CLASS TO 'qa'; 
GRANT SELECT, DELETE ON coderhouse_gamers.GAME TO 'qa'; 

-- otorgar permisos
DROP USER IF EXISTS  'edgar'@'%','martin'@'%', 'pablo'@'%';

CREATE USER
'edgar'@'%'
IDENTIFIED BY 'production';
 
 CREATE USER
'martin'@'%'
IDENTIFIED BY 'dev';
 
 CREATE USER
'pablo'@'%'
IDENTIFIED BY 'qa';

-- Asignando roles a los usuarios
-- pablo
GRANT 'qa' TO 'pablo'@'%';
SET DEFAULT ROLE 'qa' TO 'pablo'@'%';
FLUSH PRIVILEGES;
-- mysql> SHOW GRANTS FOR pablo;


---------
CREATE ROLE admin_role;

GRANT ALL PRIVILEGES ON *.* TO admin_role WITH GRANT OPTION;


CREATE USER 'dario'@'%'
IDENTIFIED BY 'production';

GRANT 'production' TO 'dario'@'%';
GRANT admin_role TO 'dario'@'%';
GRANT ALL ON coderhouse_gamers.* TO 'dario'@'%' WITH GRANT OPTION;

SHOW GRANTS FOR dario;

DROP USER IF EXISTS'luna'@'%';
CREATE USER 'luna'@'%'
IDENTIFIED BY 'luna';
GRANT production TO 'luna'@'%';
SET DEFAULT ROLE production TO 'luna'@'%';
