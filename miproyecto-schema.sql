-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host:     Database: mcfit
-- ------------------------------------------------------
-- Server version	8.0.35

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `pedido`
--

DROP TABLE IF EXISTS `pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido` (
  `idPedido` int NOT NULL,
  `fecha` date DEFAULT NULL,
  `idEmpleado` int DEFAULT NULL,
  PRIMARY KEY (`idPedido`),
  KEY `fk_PEDIDO_EMPLEADO1_idx` (`idEmpleado`),
  CONSTRAINT `fk_PEDIDO_EMPLEADO1` FOREIGN KEY (`idEmpleado`) REFERENCES `empleado` (`idEmpleado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pagos`
--

DROP TABLE IF EXISTS `pagos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagos` (
  `idPago` int NOT NULL,
  `fechaPago` date DEFAULT NULL,
  `tipoPago` varchar(30) DEFAULT NULL,
  `idSocio` int DEFAULT NULL,
  `cantidadPago` int DEFAULT NULL,
  `conceptoPago` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`idPago`),
  KEY `fk_pagos` (`idSocio`),
  CONSTRAINT `fk_pagos` FOREIGN KEY (`idSocio`) REFERENCES `socio` (`idSocio`),
  CONSTRAINT `pagos_chk_1` CHECK ((`tipoPago` in (_utf8mb3'tarjeta',_utf8mb3'efectivo')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zona`
--

DROP TABLE IF EXISTS `zona`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `zona` (
  `color` varchar(45) NOT NULL,
  `idGimnasio` int NOT NULL,
  PRIMARY KEY (`color`,`idGimnasio`),
  KEY `fk_ZONA_GIMNASIO1_idx` (`idGimnasio`),
  CONSTRAINT `fk_ZONA_GIMNASIO` FOREIGN KEY (`idGimnasio`) REFERENCES `gimnasio` (`idGimnasio`),
  CONSTRAINT `zona_chk_1` CHECK ((`color` in (_utf8mb4'amarillo',_utf8mb4'rojo',_utf8mb4'verde')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ventas`
--

DROP TABLE IF EXISTS `ventas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ventas` (
  `idVentas` int NOT NULL,
  `fecha` date DEFAULT NULL,
  `idSocio` int DEFAULT NULL,
  PRIMARY KEY (`idVentas`),
  KEY `fk_VENTAS_SOCIO1_idx` (`idSocio`),
  CONSTRAINT `fk_VENTAS_SOCIO1` FOREIGN KEY (`idSocio`) REFERENCES `socio` (`idSocio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `detalle_pedido`
--

DROP TABLE IF EXISTS `detalle_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalle_pedido` (
  `idProducto` int NOT NULL,
  `idPedido` int NOT NULL,
  `cantProducto` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idProducto`,`idPedido`),
  KEY `fk_PRODUCTO_has_PEDIDO_PEDIDO1_idx` (`idPedido`),
  KEY `fk_PRODUCTO_has_PEDIDO_PRODUCTO1_idx` (`idProducto`),
  CONSTRAINT `fk_PRODUCTO_has_PEDIDO_PEDIDO1` FOREIGN KEY (`idPedido`) REFERENCES `pedido` (`idPedido`),
  CONSTRAINT `fk_PRODUCTO_has_PEDIDO_PRODUCTO1` FOREIGN KEY (`idProducto`) REFERENCES `producto` (`idProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `empleado`
--

DROP TABLE IF EXISTS `empleado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empleado` (
  `idEmpleado` int NOT NULL,
  `dni` varchar(45) DEFAULT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `apellido` varchar(45) DEFAULT NULL,
  `idGimnasio` int DEFAULT NULL,
  `idJefe` int DEFAULT NULL,
  `tipoEmpleado` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idEmpleado`),
  UNIQUE KEY `dni_UNIQUE` (`dni`),
  KEY `fk_EMPLEADO_GIMNASIO1_idx` (`idGimnasio`),
  KEY `fk_EMPLEADO_EMPLEADO1_idx` (`idJefe`),
  CONSTRAINT `fk_EMPLEADO_EMPLEADO1` FOREIGN KEY (`idJefe`) REFERENCES `empleado` (`idEmpleado`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_EMPLEADO_GIMNASIO1` FOREIGN KEY (`idGimnasio`) REFERENCES `gimnasio` (`idGimnasio`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `socio`
--

DROP TABLE IF EXISTS `socio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `socio` (
  `idSocio` int NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `apellido` varchar(45) DEFAULT NULL,
  `dni` varchar(45) DEFAULT NULL,
  `direccion` varchar(45) DEFAULT NULL,
  `mail` varchar(45) DEFAULT NULL,
  `telefono` varchar(45) DEFAULT NULL,
  `idGimnasio` int DEFAULT NULL,
  `cuota` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`idSocio`),
  UNIQUE KEY `mail_UNIQUE` (`mail`),
  UNIQUE KEY `telefono_UNIQUE` (`telefono`),
  UNIQUE KEY `dni_UNIQUE` (`dni`),
  KEY `fk_SOCIO_GIMNASIO1_idx` (`idGimnasio`),
  CONSTRAINT `fk_SOCIO_GIMNASIO1` FOREIGN KEY (`idGimnasio`) REFERENCES `gimnasio` (`idGimnasio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `detalle_venta`
--

DROP TABLE IF EXISTS `detalle_venta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalle_venta` (
  `idVentas` int NOT NULL,
  `idProducto` int NOT NULL,
  `cantProducto` int DEFAULT NULL,
  PRIMARY KEY (`idVentas`,`idProducto`),
  KEY `fk_VENTAS_has_PRODUCTO_PRODUCTO1_idx` (`idProducto`),
  KEY `fk_VENTAS_has_PRODUCTO_VENTAS1_idx` (`idVentas`),
  CONSTRAINT `fk_VENTAS_has_PRODUCTO_PRODUCTO1` FOREIGN KEY (`idProducto`) REFERENCES `producto` (`idProducto`),
  CONSTRAINT `fk_VENTAS_has_PRODUCTO_VENTAS1` FOREIGN KEY (`idVentas`) REFERENCES `ventas` (`idVentas`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gimnasio`
--

DROP TABLE IF EXISTS `gimnasio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gimnasio` (
  `idGimnasio` int NOT NULL,
  `direccion` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idGimnasio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `maquinas`
--

DROP TABLE IF EXISTS `maquinas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maquinas` (
  `numeroDeSerie` varchar(15) NOT NULL,
  `nombre` varchar(70) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `color` varchar(45) NOT NULL,
  `idGimnasio` int NOT NULL,
  PRIMARY KEY (`numeroDeSerie`),
  KEY `fk_MAQUINAS_ZONA_idx` (`color`),
  KEY `fk_MAQUINAS_ZONA_GIMNASIO_idx` (`idGimnasio`),
  KEY `maquinas_FK` (`color`,`idGimnasio`),
  CONSTRAINT `fk_MAQUINAS_ZONA` FOREIGN KEY (`color`) REFERENCES `zona` (`color`),
  CONSTRAINT `maquinas_FK` FOREIGN KEY (`color`, `idGimnasio`) REFERENCES `zona` (`color`, `idGimnasio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `producto`
--

DROP TABLE IF EXISTS `producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `producto` (
  `idProducto` int NOT NULL,
  `descripcion` varchar(70) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `precio` decimal(5,2) DEFAULT NULL,
  `stock` int DEFAULT NULL,
  PRIMARY KEY (`idProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-05-18 18:14:38
