/* 
Transportes Naches
Versión 1: 25-02-2025
From Uriel Zavala & Karla Martínez
*/
DROP DATABASE IF EXISTS transportesNaches;
CREATE DATABASE transportesNaches;
USE transportesNaches;

CREATE TABLE persona(
idPersona INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(30) NOT NULL,
apellidoPaterno VARCHAR(20) NOT NULL,
apellidoMaterno VARCHAR(20),
telefono VARCHAR(13) NOT NULL,
correo VARCHAR(50)
);
CREATE TABLE rol(
idRol INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(13) NOT NULL);

CREATE TABLE usuario(
idUsuario INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
nombreUsuario VARCHAR(20) NOT NULL,
contrasenia VARCHAR(20) NOT NULL,
rol ENUM('Administrador','Operador'),
activoUsuario INT NOT NULL
);

CREATE TABLE operador(
idOperador INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
activoOperador INT NOT NULL,
idPersona INT NOT NULL,
idUsuario INT NOT NULL,
CONSTRAINT fk_usuario_operador FOREIGN KEY (idUsuario) REFERENCES usuario (idUsuario),
CONSTRAINT fk_persona_operador FOREIGN KEY (idPersona) REFERENCES persona (idPersona)
);

CREATE TABLE cliente(
idCliente INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
calificacion VARCHAR(15) NOT NULL,
idPersona INT NOT NULL,
CONSTRAINT fk_persona_cliente FOREIGN KEY(idPersona) REFERENCES persona (idPersona)
);

CREATE TABLE tipoGasto(
idTipoGasto INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
descripcion VARCHAR(255)
);

CREATE TABLE gasto(
idGasto INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
cantidad DOUBLE NOT NULL,
nota VARCHAR(255),
subTotal DOUBLE NOT NULL,
importe DOUBLE NOT NULL,
total DOUBLE NOT NULL,
idTipoGasto INT NOT NULL,
CONSTRAINT fk_tipoGasto_gasto FOREIGN KEY(idTipoGasto) REFERENCES tipoGasto (idTipoGasto)
);

CREATE TABLE estadoUnidad(
idEstado INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
gasolina ENUM('Bueno', 'Regular', 'Bajo') NOT NULL,
tipoGas VARCHAR(20) NOT NULL,
llantas ENUM('Bueno', 'Regular', 'Malo') NOT NULL,
aceite  ENUM('Bueno', 'Regular', 'Malo') NOT NULL,
anticongelante ENUM('Bueno', 'Regular', 'Malo') NOT NULL,
liquidoFrenos ENUM('Bueno', 'Regular', 'Malo') NOT NULL
);

CREATE TABLE gps(
idGps INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
latitud DECIMAL(10,6) NOT NULL,
longitud DECIMAL(10,6) NOT NULL,
foto          LONGTEXT,
urlWeb        VARCHAR(65)
);

CREATE TABLE unidad(
idUnidad INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
tipoVehiculo VARCHAR(100) NOT NULL,
placas VARCHAR(15) NOT NULL,
rendimientoUnidad DOUBLE NOT NULL,
fechaVencimientoPol DATE NOT NULL,
dispinibilidad ENUM('Disponible','En viaje','Reparación'),
activoUnidad INT NOT NULL,
idEstado INT NOT NULL,
idGps INT NOT NULL,
CONSTRAINT fk_estadoUnidad_unidad FOREIGN KEY (idEstado) REFERENCES estadoUnidad (idEstado),
CONSTRAINT fk_gps_unidad FOREIGN KEY (idGps) REFERENCES gps (idGps)
);

CREATE TABLE viaje(
idViaje INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
origen VARCHAR(200) NOT NULL,
destino VARCHAR(200) NOT NULL,
distancia DOUBLE NOT NULL,
tiempo TIME NOT NULL,
pago DOUBLE NOT NULL,
idUnidad INT NOT NULL,
CONSTRAINT fk_unidad_viaje FOREIGN KEY(idUnidad) REFERENCES unidad (idUnidad)
);
CREATE TABLE monto(
idMonto INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
montoInicial DOUBLE NOT NULL,
montoIngresado DOUBLE NOT NULL,
montoEgresado DOUBLE NOT NULL,
montoFinal DOUBLE NOT NULL,
idViaje INT NOT NULL,
idGasto INT NOT NULL,
CONSTRAINT fk_viaje_monto FOREIGN KEY(idViaje) REFERENCES viaje (idViaje),
CONSTRAINT fk_gasto_monto FOREIGN KEY(idGasto) REFERENCES gasto (idGasto)
);

CREATE TABLE notaGasto(
idNota INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
fechaLlenado DATE NOT NULL,
fechaSalida DATE NOT NULL,
fechaLlegada DATE NOT NULL,
horaSalida TIME NOT NULL,
horaLlegada TIME NOT NULL,
kmInicio DOUBLE NOT NULL,
kmFinal DOUBLE NOT NULL,
fotoTablero LONGTEXT NOT NULL,
fotoAcuse LONGTEXT NOT NULL,
idOperador INT NOT NULL,
idCliente INT NOT NULL,
idUnidad INT NOT NULL,
idViaje INT NOT NULL,
idGasto INT NOT NULL,
CONSTRAINT fk_operador_nota FOREIGN KEY(idOperador) REFERENCES operador (idOperador),
CONSTRAINT fk_cliente_nota FOREIGN KEY(idCliente) REFERENCES cliente (idCliente),
CONSTRAINT fk_unidad_nota FOREIGN KEY(idUnidad) REFERENCES unidad (idUnidad),
CONSTRAINT fk_gasto_nota FOREIGN KEY(idGasto) REFERENCES gasto (idGasto),
CONSTRAINT fk_viaje_nota FOREIGN KEY(idViaje) REFERENCES viaje (idViaje)
);

CREATE TABLE estadoNotaGasto (
    idEstadoNota INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    idNota INT NOT NULL,
    idEstado INT NOT NULL,
    comentario VARCHAR(255), -- Opcional, para registrar detalles del cambio de estado
    CONSTRAINT fk_estadoNota_nota FOREIGN KEY (idNota) REFERENCES notaGasto(idNota),
    CONSTRAINT fk_estadoNota_estado FOREIGN KEY (idEstado) REFERENCES estadoUnidad(idEstado)
);