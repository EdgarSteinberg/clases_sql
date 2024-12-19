# para levantar este contenedor con el servidor de mysql:
docker compose up --build -d 


# acceder a ese contenedor para ver data tiene
docker exec -it mysql-server bash


# crear la base de datos desde el codigo sql creado
docker exec -it mysql-server mysql --verbose -u root -p -e "source /proyecto_sql_docker/estructura.sql;" 
docker exec -it -e MYSQL_PWD=coderhouse mysql-server mysql -u root -p -e "source /proyecto_sql_docker/estructura.sql;" 

# ver las tablas 
docker exec -it mysql-server mysql --verbose -u root -p -e "SHOW TABLES FROM donaton;" 


# popular la base de datos
docker exec -it mysql-server mysql --verbose -u root -p -e "source /proyecto_sql_docker/population.sql;"


# eliminar base de datos 
docker exec -it mysql-server mysql --verbose -u root -p -e "DROP DATABASE IF EXISTS donaton;" 


# crear base de datos
docker exec -it mysql-server mysql \
 --verbose \
 -u root \
 -p -e "\
DROP DATABASE IF EXISTS donaton; 
source /proyecto_sql_docker/estructura.sql; \
source /proyecto_sql_docker/population.sql; \
source /proyecto_sql_docker/objetos/1_vistas.sql; \
source /proyecto_sql_docker/objetos/2_funciones.sql; \
source /proyecto_sql_docker/objetos/3_procedimientos.sql; \
source /proyecto_sql_docker/objetos/4_triggers.sql; "


# dar de baja la base de datos
docker compose down



#usuarios levantar todo el proyecto como non-root
# crear base de datos

docker exec -it -e MYSQL_PWD="coderhouse" mysql-server\
 mysql \
 --verbose \
 -u root \
 -p -e "\
source /proyecto_sql_docker/usuario-non-root.sql"


docker exec -it -e MYSQL_PWD="pass_123" mysql-server mysql \
 --verbose \
 -u non_root \
 -p -e "\
source /proyecto_sql_docker/estructura.sql; \
source /proyecto_sql_docker/population.sql; \
source /proyecto_sql_docker/objetos/1_vistas.sql; \
source /proyecto_sql_docker/objetos/2_funciones.sql; \
source /proyecto_sql_docker/objetos/3_procedimientos.sql; \
source /proyecto_sql_docker/objetos/4_triggers.sql;
source /proyecto_sql_docker/objetos/5_usuarios.sql;"




# final con errores seguramente jaja
docker exec -it mysql-server mysql \
 --verbose \
 -u non_root \
 -p -e "\
 DROP DATABASES IF EXISTS donaton;
source /proyecto_sql_docker/estructura.sql; \
source /proyecto_sql_docker/population.sql; \
source /proyecto_sql_docker/objetos/1_vistas.sql; \
source /proyecto_sql_docker/objetos/2_funciones.sql; \
source /proyecto_sql_docker/objetos/3_procedimientos.sql; \
source /proyecto_sql_docker/objetos/4_triggers.sql;
source /proyecto_sql_docker/objetos/5_usuarios.sql;
source /proyecto_sql_docker/objetos/6_procedure_tcl.sql;"