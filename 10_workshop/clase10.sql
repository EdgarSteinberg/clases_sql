-- Markdown
-- Borrar la base de datos si existe y crearla nuevamente
DROP DATABASE IF EXISTS donaton;
CREATE DATABASE donaton;
USE donaton;

-- Tabla donacion
CREATE TABLE donacion(
    id_donacion INT NOT NULL AUTO_INCREMENT,
    id_donador INT,
    id_categoria_donacion INT, 
    id_centro_recepcion INT,
    cantidad DECIMAL(10,2),
    detalles VARCHAR(200),
    fecha_donacion DATETIME DEFAULT (CURRENT_TIMESTAMP),
    fecha_termino_donacion DATE,
    PRIMARY KEY(id_donacion)
);

-- Tabla donador
CREATE TABLE donador (
    id_donador INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100),
    email VARCHAR(200) UNIQUE,
    status_donador ENUM('Anonimo', 'Publica'),
    PRIMARY KEY(id_donador)
);

-- Tabla categoria_donacion
CREATE TABLE categoria_donacion (
    id_categoria_donacion INT NOT NULL AUTO_INCREMENT,
    descripcion VARCHAR(200),
    tipo VARCHAR(200),
    PRIMARY KEY(id_categoria_donacion)
);

-- Tabla centro_recepcion
CREATE TABLE centro_recepcion (
    id_centro_recepcion INT NOT NULL AUTO_INCREMENT,
    ubicacion VARCHAR(200) UNIQUE NOT NULL,
    encargado VARCHAR(200) NOT NULL,
    PRIMARY KEY (id_centro_recepcion)
);

-- Tabla voluntario
CREATE TABLE voluntario (
    id_voluntario INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(200) NOT NULL,
    fecha_nacimiento DATE,
    PRIMARY KEY (id_voluntario)
);

-- Tabla categoria_voluntario
CREATE TABLE categoria_voluntario (
    id_categoria_voluntario INT NOT NULL AUTO_INCREMENT,
    descripcion_tareas VARCHAR(200),
    PRIMARY KEY (id_categoria_voluntario)
);

-- Tabla beneficiarios
CREATE TABLE beneficiario (
    id_beneficiario INT NOT NULL AUTO_INCREMENT,
    direccion VARCHAR(200),
    nombre_encargado VARCHAR(200),
    fecha_creacion DATE,
    PRIMARY KEY (id_beneficiario)
);

-- Tabla intermedia centro_recepcion_beneficiario
CREATE TABLE centro_recepcion_beneficiario (
    id_centro_recepcion_beneficiario INT NOT NULL AUTO_INCREMENT,
    id_beneficiario INT, 
    id_centro_recepcion INT,
    id_voluntario INT,
    fecha_entrega DATE,
    PRIMARY KEY (id_centro_recepcion_beneficiario)
);

-- Tabla intermedia centro_recepcion_voluntario
CREATE TABLE centro_recepcion_voluntario (
    id_centro_recepcion_voluntario INT NOT NULL AUTO_INCREMENT,
    id_centro_recepcion INT,
    id_voluntario INT, 
    fecha_inicio_voluntario DATE,
    fecha_fin_voluntarin DATE, 
    PRIMARY KEY (id_centro_recepcion_voluntario)
);

-- Tabla intermedia voluntario_categoria
CREATE TABLE voluntario_categoria (
    id_voluntario_categoria INT NOT NULL AUTO_INCREMENT,
    id_categoria_voluntario INT, 
    id_beneficiario INT,
    PRIMARY KEY (id_voluntario_categoria)
);

-- Relaciones (FOREIGN KEY)

-- Foreign key en donacion referenciando id_donador en la tabla donador
ALTER TABLE donacion
    ADD CONSTRAINT fk_constraint_id_donador
    FOREIGN KEY(id_donador) REFERENCES donador(id_donador);

-- Foreign key en donacion referenciando id_categoria_donacion en categoria_donacion
ALTER TABLE donacion
    ADD CONSTRAINT fk_constraint_id_categoria_donacion
    FOREIGN KEY(id_categoria_donacion) REFERENCES categoria_donacion(id_categoria_donacion); 

-- Foreign key en donacion referenciando id_centro_recepcion en centro_recepcion
ALTER TABLE donacion
    ADD CONSTRAINT fk_constraint_id_centro_recepcion
    FOREIGN KEY(id_centro_recepcion) REFERENCES centro_recepcion(id_centro_recepcion); 

-- Foreign key en centro_recepcion_beneficiario referenciando id_beneficiarios en beneficiarios
ALTER TABLE centro_recepcion_beneficiario
    ADD CONSTRAINT fk_const_id_beneficiarios
    FOREIGN KEY(id_beneficiario) REFERENCES beneficiario(id_beneficiario);

-- Foreign key en centro_recepcion_beneficiario referenciando id_centro_recepcion en centro_recepcion
ALTER TABLE centro_recepcion_beneficiario
    ADD CONSTRAINT fk_const_id_centro_recepcion
    FOREIGN KEY(id_centro_recepcion) REFERENCES centro_recepcion(id_centro_recepcion); 

-- Foreign key en centro_recepcion_voluntario referenciando id_centro_recepcion en centro_recepcion
ALTER TABLE centro_recepcion_voluntario
    ADD CONSTRAINT fk_c_id_centro_recepcion
    FOREIGN KEY(id_centro_recepcion) REFERENCES centro_recepcion(id_centro_recepcion);

-- Foreign key en centro_recepcion_voluntario referenciando id_voluntario en voluntario
ALTER TABLE centro_recepcion_voluntario
    ADD CONSTRAINT fk_c_id_centro_voluntario
    FOREIGN KEY(id_voluntario) REFERENCES voluntario(id_voluntario); 

-- Foreign key en voluntario_categoria referenciando id_categoria_voluntario en categoria_voluntario
ALTER TABLE voluntario_categoria
    ADD CONSTRAINT fk_const_id_categoria
    FOREIGN KEY(id_categoria_voluntario) REFERENCES categoria_voluntario(id_categoria_voluntario); 

-- Foreign key en voluntario_categoria referenciando id_beneficiarios en beneficiarios
ALTER TABLE voluntario_categoria
    ADD CONSTRAINT fk_const_id_beneficiario_categoria
    FOREIGN KEY(id_beneficiario) REFERENCES beneficiario(id_beneficiario);
