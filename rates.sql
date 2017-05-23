-- MySQL dump 10.13  Distrib 5.7.18, for Linux (x86_64)
--
-- Host: localhost    Database: UberNurse_development
-- ------------------------------------------------------
-- Server version	5.7.18-0ubuntu0.17.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `rates`
--

DROP TABLE IF EXISTS `rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zone` varchar(255) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  `speciality` varchar(255) DEFAULT NULL,
  `amount` float DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rates`
--

LOCK TABLES `rates` WRITE;
/*!40000 ALTER TABLE `rates` DISABLE KEYS */;
INSERT INTO `rates` VALUES (1,'North','Care Giver','Geriatric Care',10,'2017-05-22 16:59:30','2017-05-22 16:59:30'),(2,'North','Nurse','Generalist',13,'2017-05-23 03:29:27','2017-05-23 03:29:27'),(3,'North','Nurse','Geriatric Care',12,'2017-05-23 03:29:27','2017-05-23 03:29:27'),(4,'North','Nurse','Pediatric Care',14,'2017-05-23 03:29:27','2017-05-23 03:29:27'),(5,'North','Nurse','Mental Health',12,'2017-05-23 03:29:27','2017-05-23 03:29:27'),(6,'North','Care Giver','Generalist',10,'2017-05-23 03:29:27','2017-05-23 03:29:27'),(7,'North','Care Giver','Geriatric Care',13,'2017-05-23 03:29:27','2017-05-23 03:29:27'),(8,'North','Care Giver','Pediatric Care',14,'2017-05-23 03:29:27','2017-05-23 03:29:27'),(9,'North','Care Giver','Mental Health',12,'2017-05-23 03:29:28','2017-05-23 03:29:28'),(10,'South','Nurse','Generalist',10,'2017-05-23 03:29:28','2017-05-23 03:29:28'),(11,'South','Nurse','Geriatric Care',11,'2017-05-23 03:29:28','2017-05-23 03:29:28'),(12,'South','Nurse','Pediatric Care',11,'2017-05-23 03:29:28','2017-05-23 03:29:28'),(13,'South','Nurse','Mental Health',14,'2017-05-23 03:29:28','2017-05-23 03:29:28'),(14,'South','Care Giver','Generalist',11,'2017-05-23 03:29:28','2017-05-23 03:29:28'),(15,'South','Care Giver','Geriatric Care',13,'2017-05-23 03:29:28','2017-05-23 03:29:28'),(16,'South','Care Giver','Pediatric Care',12,'2017-05-23 03:29:29','2017-05-23 03:29:29'),(17,'South','Care Giver','Mental Health',12,'2017-05-23 03:29:29','2017-05-23 03:29:29');
/*!40000 ALTER TABLE `rates` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-05-23 12:12:55
