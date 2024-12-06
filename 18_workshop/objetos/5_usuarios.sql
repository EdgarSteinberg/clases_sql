USE donaton;

DROP USER IF EXISTS
 'usuario_1'@'%',
  'usuario_2'@'%', 
  'usuario_3'@'%';


-- Creación de usuario 1 con acceso solo a la vista 'vw_donaciones_por_periodo' y 'vw_donaciones_por_categoria'
CREATE USER "usuario_1"@"%" IDENTIFIED BY "pass_123";

GRANT SELECT ON donaton.vw_donaciones_por_periodo TO "usuario_1"@"%";
GRANT SELECT ON donaton.vw_donaciones_por_categoria TO "usuario_1"@"%";

-- Creación de usuario 2 con acceso de solo lectura a todas las tablas de la base de datos donaton
CREATE USER "usuario_2"@"%" IDENTIFIED BY "pass_123";
GRANT SELECT ON donaton.* TO "usuario_2"@"%";

-- Creación de usuario 3 con acceso completo a todas las tablas y objetos de la base de datos donaton
CREATE USER "usuario_3"@"%" IDENTIFIED BY "pass_123";
GRANT ALL PRIVILEGES ON donaton.* TO "usuario_3"@"%";

-- Actualiza los privilegios para que tengan efecto inmediato
FLUSH PRIVILEGES;

-- Verifica la creación de los usuarios y sus permisos
SELECT * FROM mysql.user;
