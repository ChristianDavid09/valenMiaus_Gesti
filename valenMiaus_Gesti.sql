/* DROP DATABASE IF EXISTS `valenMiaus_Gesti`; */

CREATE DATABASE IF NOT EXISTS `valenMiaus_Gesti` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE `valenMiaus_Gesti`;

CREATE TABLE IF NOT EXISTS `usuarios` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    correo VARCHAR(100) NOT NULL UNIQUE,
    contrasenya VARCHAR(255) NOT NULL,
    tipo_usuario ENUM('Adoptante, Refugio, Voluntario, Admin_app') NOT NULL,
    telefono VARCHAR(15) DEFAULT NULL,
    direccion VARCHAR(255) DEFAULT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_ultima_conexion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS `colonias` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    ubicacion VARCHAR(255) NOT NULL,
    descripcion TEXT DEFAULT NULL,
    admin_principal INT NOT NULL,
    FOREIGN KEY (admin_principal) REFERENCES usuarios(id) ON DELETE CASCADE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS `felinos` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    edad INT NOT NULL,
    sexo ENUM('Macho', 'Hembra') NOT NULL,
    raza VARCHAR(50) DEFAULT NULL,
    color VARCHAR(50) DEFAULT NULL,
    estado_salud ENUM('Sano', 'En tratamiento', 'Fallecido') NOT NULL,
    id_colonia INT NOT NULL,
    FOREIGN KEY (id_colonia) REFERENCES colonias(id) ON DELETE CASCADE,
    foto VARCHAR(255) DEFAULT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS `adopciones` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_felino INT NOT NULL,
    FOREIGN KEY (id_felino) REFERENCES felinos(id) ON DELETE CASCADE,
    id_adoptante INT NOT NULL,
    FOREIGN KEY (id_adoptante) REFERENCES usuarios(id) ON DELETE CASCADE,
    estado ENUM('En proceso', 'Adoptada', 'Acogida', 'Cancelada') DEFAULT 'En proceso',
    observaciones TEXT DEFAULT NULL,
    fecha_adopcion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS `publicaciones` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_felino INT NOT NULL,
    FOREIGN KEY (id_felino) REFERENCES felinos(id) ON DELETE CASCADE,
    id_usuario INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE,
    id_adopcion INT DEFAULT NULL,
    FOREIGN KEY (id_adopcion) REFERENCES adopciones(id) ON DELETE CASCADE,
    url_foto VARCHAR(255) NOT NULL,
    fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS `mensajes` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    asunto ENUM('Consulta', 'Sugerencia', 'Reclamo') NOT NULL,
    mensaje TEXT NOT NULL,
    id_colonia INT NOT NULL,
    FOREIGN KEY (id_colonia) REFERENCES colonias(id) ON DELETE CASCADE,
    id_usuario INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE,
    id_felino INT DEFAULT NULL,
    FOREIGN KEY (id_felino) REFERENCES felinos(id) ON DELETE CASCADE,
    estado ENUM('Pendiente', 'Resuelto') DEFAULT 'Pendiente',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS `registra` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_adopcion INT NOT NULL,
    FOREIGN KEY (id_adopcion) REFERENCES adopciones(id) ON DELETE CASCADE,
    id_felino INT NOT NULL,
    FOREIGN KEY (id_felino) REFERENCES felinos(id) ON DELETE CASCADE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS `pertenece` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_publicacion INT NOT NULL,
    FOREIGN KEY (id_publicacion) REFERENCES publicaciones(id) ON DELETE CASCADE,
    id_felino INT NOT NULL,
    FOREIGN KEY (id_felino) REFERENCES felinos(id) ON DELETE CASCADE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

