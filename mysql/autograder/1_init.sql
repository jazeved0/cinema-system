CREATE DATABASE  IF NOT EXISTS `AUTOGRADING` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */;
USE `AUTOGRADING`;
-- MySQL dump 10.13  Distrib 8.0.15, for macos10.14 (x86_64)
--
-- Host: 127.0.0.1    Database: AUTOGRADING
-- ------------------------------------------------------
-- Server version	8.0.15

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `RESULT`
--

DROP TABLE IF EXISTS `RESULT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `RESULT` (
  `TaskNum` int(11) NOT NULL,
  `ErrorType` enum('EXTRA','MISSING','DUPLICATED') NOT NULL,
  `Value` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RESULT`
--

LOCK TABLES `RESULT` WRITE;
/*!40000 ALTER TABLE `RESULT` DISABLE KEYS */;
/*!40000 ALTER TABLE `RESULT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `T1`
--

DROP TABLE IF EXISTS `T1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `T1` (
  `username` varchar(50) NOT NULL,
  `status` enum('Approved','Declined','Pending') NOT NULL DEFAULT (_utf8mb4'Pending'),
  `isCustomer` int(11) DEFAULT NULL,
  `isAdmin` int(11) DEFAULT NULL,
  `isManager` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `T1`
--

LOCK TABLES `T1` WRITE;
/*!40000 ALTER TABLE `T1` DISABLE KEYS */;
INSERT INTO `T1` VALUES ('georgep','Approved',1,0,1);
/*!40000 ALTER TABLE `T1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `T10`
--

DROP TABLE IF EXISTS `T10`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `T10` (
  `movName` varchar(100) NOT NULL,
  `movDuration` int(11) NOT NULL,
  `movReleaseDate` date DEFAULT NULL,
  `movPlayDate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `T10`
--

LOCK TABLES `T10` WRITE;
/*!40000 ALTER TABLE `T10` DISABLE KEYS */;
INSERT INTO `T10` VALUES ('4400 The Movie',130,'2019-08-12',NULL),('Avengers: Endgame',181,'2019-04-26',NULL),('Calculus Returns: A ML Story',314,'2019-09-19',NULL),('Georgia Tech The Movie',100,'1985-08-13',NULL),('Spider-Man: Into the Spider-Verse',117,'2018-12-01',NULL),('The First Pokemon Movie',75,'1998-07-19',NULL);
/*!40000 ALTER TABLE `T10` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `T11`
--

DROP TABLE IF EXISTS `T11`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `T11` (
  `movName` varchar(100) NOT NULL,
  `thName` varchar(50) NOT NULL,
  `thStreet` varchar(255) NOT NULL,
  `thCity` varchar(50) NOT NULL,
  `thState` char(2) NOT NULL,
  `thZipcode` char(5) NOT NULL,
  `comName` varchar(50) NOT NULL,
  `movPlayDate` date NOT NULL,
  `movReleaseDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `T11`
--

LOCK TABLES `T11` WRITE;
/*!40000 ALTER TABLE `T11` DISABLE KEYS */;
INSERT INTO `T11` VALUES ('4400 The Movie','ABC Theater','880 Color Dr','Austin','TX','73301','Awesome Theater Company','2019-10-12','2019-08-12'),('Georgia Tech The Movie','ABC Theater','880 Color Dr','Austin','TX','73301','Awesome Theater Company','1985-08-13','1985-08-13'),('The First Pokemon Movie','ABC Theater','880 Color Dr','Austin','TX','73301','Awesome Theater Company','2018-07-19','1998-07-19'),('4400 The Movie','Cinema Star','100 Cool Place','San Francisco','CA','94016','4400 Theater Company','2019-09-12','2019-08-12'),('George P Burdell\'s Life Story','Cinema Star','100 Cool Place','San Francisco','CA','94016','4400 Theater Company','2010-05-20','1927-08-12'),('Georgia Tech The Movie','Cinema Star','100 Cool Place','San Francisco','CA','94016','4400 Theater Company','2019-09-30','1985-08-13'),('How to Train Your Dragon','Cinema Star','100 Cool Place','San Francisco','CA','94016','4400 Theater Company','2010-04-02','2010-03-21'),('Spaceballs','Cinema Star','100 Cool Place','San Francisco','CA','94016','4400 Theater Company','2000-02-02','1987-06-24'),('The King\'s Speech','Cinema Star','100 Cool Place','San Francisco','CA','94016','4400 Theater Company','2019-12-20','2010-11-26'),('George P Burdell\'s Life Story','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2019-07-14','1927-08-12'),('George P Burdell\'s Life Story','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2019-10-22','1927-08-12'),('How to Train Your Dragon','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2010-03-22','2010-03-21'),('How to Train Your Dragon','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2010-03-23','2010-03-21'),('Spaceballs','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','1999-06-24','1987-06-24'),('The King\'s Speech','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2019-12-20','2010-11-26'),('Calculus Returns: A ML Story','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2019-10-10','2019-09-19'),('Calculus Returns: A ML Story','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2019-12-30','2019-09-19'),('Spaceballs','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2010-04-02','1987-06-24'),('Spaceballs','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2023-01-23','1987-06-24'),('Spider-Man: Into the Spider-Verse','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2019-09-30','2018-12-01'),('4400 The Movie','Star Movies','745 GT St','Atlanta','GA','30332','EZ Theater Company','2019-08-12','2019-08-12'),('How to Train Your Dragon','Star Movies','745 GT St','Atlanta','GA','30332','EZ Theater Company','2010-03-25','2010-03-21');
/*!40000 ALTER TABLE `T11` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `T12`
--

DROP TABLE IF EXISTS `T12`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `T12` (
  `movName` varchar(100) NOT NULL,
  `thName` varchar(50) NOT NULL,
  `thStreet` varchar(255) NOT NULL,
  `thCity` varchar(50) NOT NULL,
  `thState` char(2) NOT NULL,
  `thZipcode` char(5) NOT NULL,
  `comName` varchar(50) NOT NULL,
  `movPlayDate` date NOT NULL,
  `movReleaseDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `T12`
--

LOCK TABLES `T12` WRITE;
/*!40000 ALTER TABLE `T12` DISABLE KEYS */;
INSERT INTO `T12` VALUES ('4400 The Movie','ABC Theater','880 Color Dr','Austin','TX','73301','Awesome Theater Company','2019-10-12','2019-08-12'),('The First Pokemon Movie','ABC Theater','880 Color Dr','Austin','TX','73301','Awesome Theater Company','2018-07-19','1998-07-19'),('4400 The Movie','Cinema Star','100 Cool Place','San Francisco','CA','94016','4400 Theater Company','2019-09-12','2019-08-12'),('Georgia Tech The Movie','Cinema Star','100 Cool Place','San Francisco','CA','94016','4400 Theater Company','2019-09-30','1985-08-13'),('The King\'s Speech','Cinema Star','100 Cool Place','San Francisco','CA','94016','4400 Theater Company','2019-12-20','2010-11-26'),('George P Burdell\'s Life Story','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2019-07-14','1927-08-12'),('George P Burdell\'s Life Story','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2019-10-22','1927-08-12'),('The King\'s Speech','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2019-12-20','2010-11-26'),('Calculus Returns: A ML Story','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2019-10-10','2019-09-19'),('Calculus Returns: A ML Story','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2019-12-30','2019-09-19'),('Spaceballs','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2023-01-23','1987-06-24'),('Spider-Man: Into the Spider-Verse','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2019-09-30','2018-12-01'),('4400 The Movie','Star Movies','745 GT St','Atlanta','GA','30332','EZ Theater Company','2019-08-12','2019-08-12');
/*!40000 ALTER TABLE `T12` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `T13`
--

DROP TABLE IF EXISTS `T13`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `T13` (
  `movName` varchar(100) NOT NULL,
  `thName` varchar(50) NOT NULL,
  `comName` varchar(50) NOT NULL,
  `creditCardNum` char(16) NOT NULL,
  `movPlayDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `T13`
--

LOCK TABLES `T13` WRITE;
/*!40000 ALTER TABLE `T13` DISABLE KEYS */;
INSERT INTO `T13` VALUES ('How to Train Your Dragon','Cinema Star','4400 Theater Company','1111111111111111','2010-04-02'),('How to Train Your Dragon','Main Movies','EZ Theater Company','1111111111111111','2010-03-22'),('How to Train Your Dragon','Main Movies','EZ Theater Company','1111111111111111','2010-03-23'),('How to Train Your Dragon','Star Movies','EZ Theater Company','1111111111111100','2010-03-25');
/*!40000 ALTER TABLE `T13` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `T14`
--

DROP TABLE IF EXISTS `T14`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `T14` (
  `thName` varchar(50) NOT NULL,
  `thStreet` varchar(255) NOT NULL,
  `thCity` varchar(50) NOT NULL,
  `thState` char(2) NOT NULL,
  `thZipcode` char(5) NOT NULL,
  `comName` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `T14`
--

LOCK TABLES `T14` WRITE;
/*!40000 ALTER TABLE `T14` DISABLE KEYS */;
INSERT INTO `T14` VALUES ('ABC Theater','880 Color Dr','Austin','TX','73301','Awesome Theater Company'),('Cinema Star','100 Cool Place','San Francisco','CA','94016','4400 Theater Company'),('Jonathan\'s Movies','67 Pearl Dr','Seattle','WA','98101','4400 Theater Company'),('Main Movies','123 Main St','New York','NY','10001','EZ Theater Company'),('ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company'),('Star Movies','4400 Rocks Ave','Boulder','CA','80301','4400 Theater Company'),('Star Movies','745 GT St','Atlanta','GA','30332','EZ Theater Company');
/*!40000 ALTER TABLE `T14` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `T15`
--

DROP TABLE IF EXISTS `T15`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `T15` (
  `thName` varchar(50) NOT NULL,
  `thStreet` varchar(255) NOT NULL,
  `thCity` varchar(50) NOT NULL,
  `thState` char(2) NOT NULL,
  `thZipcode` char(5) NOT NULL,
  `comName` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `T15`
--

LOCK TABLES `T15` WRITE;
/*!40000 ALTER TABLE `T15` DISABLE KEYS */;
INSERT INTO `T15` VALUES ('Cinema Star','100 Cool Place','San Francisco','CA','94016','4400 Theater Company'),('Jonathan\'s Movies','67 Pearl Dr','Seattle','WA','98101','4400 Theater Company'),('Star Movies','4400 Rocks Ave','Boulder','CA','80301','4400 Theater Company');
/*!40000 ALTER TABLE `T15` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `T16`
--

DROP TABLE IF EXISTS `T16`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `T16` (
  `thName` varchar(50) NOT NULL,
  `thStreet` varchar(255) NOT NULL,
  `thCity` varchar(50) NOT NULL,
  `thState` char(2) NOT NULL,
  `thZipcode` char(5) NOT NULL,
  `comName` varchar(50) NOT NULL,
  `visitDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `T16`
--

LOCK TABLES `T16` WRITE;
/*!40000 ALTER TABLE `T16` DISABLE KEYS */;
INSERT INTO `T16` VALUES ('Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2010-03-22'),('Star Movies','745 GT St','Atlanta','GA','30332','EZ Theater Company','2010-03-25'),('ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2010-03-20');
/*!40000 ALTER TABLE `T16` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `T17`
--

DROP TABLE IF EXISTS `T17`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `T17` (
  `thName` varchar(50) NOT NULL,
  `thStreet` varchar(255) NOT NULL,
  `thCity` varchar(50) NOT NULL,
  `thState` char(2) NOT NULL,
  `thZipcode` char(5) NOT NULL,
  `comName` varchar(50) NOT NULL,
  `visitDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `T17`
--

LOCK TABLES `T17` WRITE;
/*!40000 ALTER TABLE `T17` DISABLE KEYS */;
INSERT INTO `T17` VALUES ('Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2010-03-22'),('Star Movies','745 GT St','Atlanta','GA','30332','EZ Theater Company','2010-03-25');
/*!40000 ALTER TABLE `T17` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `T2`
--

DROP TABLE IF EXISTS `T2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `T2` (
  `username` varchar(50) NOT NULL,
  `status` enum('Approved','Declined','Pending') NOT NULL DEFAULT (_utf8mb4'Pending'),
  `isCustomer` int(11) DEFAULT NULL,
  `isAdmin` int(11) DEFAULT NULL,
  `isManager` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `T2`
--

LOCK TABLES `T2` WRITE;
/*!40000 ALTER TABLE `T2` DISABLE KEYS */;
/*!40000 ALTER TABLE `T2` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `T3`
--

DROP TABLE IF EXISTS `T3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `T3` (
  `username` varchar(50) NOT NULL,
  `creditCardCount` decimal(22,0) DEFAULT NULL,
  `userType` varchar(15) NOT NULL DEFAULT '',
  `status` enum('Approved','Declined','Pending') NOT NULL DEFAULT (_utf8mb4'Pending')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `T3`
--

LOCK TABLES `T3` WRITE;
/*!40000 ALTER TABLE `T3` DISABLE KEYS */;
INSERT INTO `T3` VALUES ('georgep',5,'CustomerManager','Approved'),('ilikemoney$$',3,'Customer','Approved'),('isthisthekrustykrab',3,'Customer','Approved'),('calcultron2',2,'Customer','Approved'),('entropyRox',2,'CustomerManager','Approved'),('calcultron',1,'CustomerManager','Approved'),('calcwizard',1,'Customer','Approved'),('cool_class4400',1,'CustomerAdmin','Approved'),('DNAhelix',1,'Customer','Approved'),('does2Much',1,'Customer','Approved'),('eeqmcsquare',1,'Customer','Approved'),('fullMetal',1,'Customer','Approved'),('imready',1,'Customer','Approved'),('notFullMetal',1,'Customer','Approved'),('programerAAL',1,'Customer','Approved'),('RitzLover28',1,'Customer','Approved'),('thePiGuy3.14',1,'Customer','Approved'),('theScienceGuy',1,'Customer','Approved'),('clarinetbeast',0,'Customer','Declined'),('fatherAI',0,'Manager','Approved'),('gdanger',0,'User','Declined'),('ghcghc',0,'Manager','Approved'),('imbatman',0,'Manager','Approved'),('manager1',0,'Manager','Approved'),('manager2',0,'Manager','Approved'),('manager3',0,'Manager','Approved'),('manager4',0,'Manager','Approved'),('radioactivePoRa',0,'Manager','Approved'),('smith_j',0,'User','Pending'),('texasStarKarate',0,'User','Declined');
/*!40000 ALTER TABLE `T3` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `T4`
--

DROP TABLE IF EXISTS `T4`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `T4` (
  `username` varchar(50) NOT NULL,
  `creditCardCount` decimal(22,0) DEFAULT NULL,
  `userType` varchar(15) NOT NULL DEFAULT '',
  `status` enum('Approved','Declined','Pending') NOT NULL DEFAULT (_utf8mb4'Pending')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `T4`
--

LOCK TABLES `T4` WRITE;
/*!40000 ALTER TABLE `T4` DISABLE KEYS */;
INSERT INTO `T4` VALUES ('georgep',5,'CustomerManager','Approved'),('ilikemoney$$',3,'Customer','Approved'),('isthisthekrustykrab',3,'Customer','Approved'),('calcultron2',2,'Customer','Approved'),('entropyRox',2,'CustomerManager','Approved'),('calcultron',1,'CustomerManager','Approved'),('calcwizard',1,'Customer','Approved'),('cool_class4400',1,'CustomerAdmin','Approved'),('DNAhelix',1,'Customer','Approved'),('does2Much',1,'Customer','Approved'),('eeqmcsquare',1,'Customer','Approved'),('fullMetal',1,'Customer','Approved'),('imready',1,'Customer','Approved'),('notFullMetal',1,'Customer','Approved'),('programerAAL',1,'Customer','Approved'),('RitzLover28',1,'Customer','Approved'),('thePiGuy3.14',1,'Customer','Approved'),('theScienceGuy',1,'Customer','Approved'),('fatherAI',0,'Manager','Approved'),('ghcghc',0,'Manager','Approved'),('imbatman',0,'Manager','Approved'),('manager1',0,'Manager','Approved'),('manager2',0,'Manager','Approved'),('manager3',0,'Manager','Approved'),('manager4',0,'Manager','Approved'),('radioactivePoRa',0,'Manager','Approved');
/*!40000 ALTER TABLE `T4` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `T5`
--

DROP TABLE IF EXISTS `T5`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `T5` (
  `comName` varchar(50) NOT NULL,
  `numTheater` bigint(21) NOT NULL DEFAULT '0',
  `numEmployee` bigint(21) NOT NULL DEFAULT '0',
  `numCityCover` bigint(21) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `T5`
--

LOCK TABLES `T5` WRITE;
/*!40000 ALTER TABLE `T5` DISABLE KEYS */;
INSERT INTO `T5` VALUES ('4400 Theater Company',3,6,3),('EZ Theater Company',2,2,2),('AI Theater Company',1,2,1),('Awesome Theater Company',1,1,1);
/*!40000 ALTER TABLE `T5` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `T6`
--

DROP TABLE IF EXISTS `T6`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `T6` (
  `comName` varchar(50) NOT NULL,
  `numTheater` bigint(21) NOT NULL DEFAULT '0',
  `numEmployee` bigint(21) NOT NULL DEFAULT '0',
  `numCityCover` bigint(21) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `T6`
--

LOCK TABLES `T6` WRITE;
/*!40000 ALTER TABLE `T6` DISABLE KEYS */;
INSERT INTO `T6` VALUES ('4400 Theater Company',3,6,3);
/*!40000 ALTER TABLE `T6` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `T7`
--

DROP TABLE IF EXISTS `T7`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `T7` (
  `thName` varchar(50) NOT NULL,
  `thManagerUsername` varchar(50) NOT NULL,
  `thCity` varchar(50) NOT NULL,
  `thState` char(2) NOT NULL,
  `thCapacity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `T7`
--

LOCK TABLES `T7` WRITE;
/*!40000 ALTER TABLE `T7` DISABLE KEYS */;
INSERT INTO `T7` VALUES ('Cinema Star','entropyRox','San Francisco','CA',4),('Jonathan\'s Movies','georgep','Seattle','WA',2),('Star Movies','radioactivePoRa','Boulder','CA',5);
/*!40000 ALTER TABLE `T7` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `T8`
--

DROP TABLE IF EXISTS `T8`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `T8` (
  `empFirstname` varchar(50) NOT NULL,
  `empLastname` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `T8`
--

LOCK TABLES `T8` WRITE;
/*!40000 ALTER TABLE `T8` DISABLE KEYS */;
INSERT INTO `T8` VALUES ('Claude','Shannon'),('George P.','Burdell'),('Manager','One'),('Three','Three'),('Four','Four'),('Marie','Curie');
/*!40000 ALTER TABLE `T8` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `T9`
--

DROP TABLE IF EXISTS `T9`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `T9` (
  `movName` varchar(100) NOT NULL,
  `movDuration` int(11) NOT NULL,
  `movReleaseDate` date DEFAULT NULL,
  `movPlayDate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `T9`
--

LOCK TABLES `T9` WRITE;
/*!40000 ALTER TABLE `T9` DISABLE KEYS */;
INSERT INTO `T9` VALUES ('4400 The Movie',130,'2019-08-12',NULL),('Avengers: Endgame',181,'2019-04-26',NULL),('Calculus Returns: A ML Story',314,'2019-09-19',NULL),('George P Burdell\'s Life Story',100,'1927-08-12','2019-07-14'),('George P Burdell\'s Life Story',100,'1927-08-12','2019-10-22'),('Georgia Tech The Movie',100,'1985-08-13',NULL),('How to Train Your Dragon',98,'2010-03-21','2010-03-22'),('How to Train Your Dragon',98,'2010-03-21','2010-03-23'),('Spaceballs',96,'1987-06-24','1999-06-24'),('Spider-Man: Into the Spider-Verse',117,'2018-12-01',NULL),('The First Pokemon Movie',75,'1998-07-19',NULL),('The King\'s Speech',119,'2010-11-26','2019-12-20');
/*!40000 ALTER TABLE `T9` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'AUTOGRADING'
--

--
-- Dumping routines for database 'AUTOGRADING'
--
/*!50003 DROP PROCEDURE IF EXISTS `grade` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `grade`(IN test_id INT, IN t_TA VARCHAR(200), IN t_student VARCHAR(200), IN base ENUM("UserLogin", "AdFilterUser", "AdFilterCom", "AdComDetailTh", "AdComDetailEmp", "ManFilterTh", "CosFilterMovie", "CosViewHistory", "UserFilterTh", "UserVisitHistory", "test"))
BEGIN
	SET @test_id = test_id;
	CALL hashing(t_TA, base);
	CALL hashing(t_student, base);
	CALL validate_test(test_id, t_TA, t_student);

	INSERT INTO RESULT (TaskNum, ErrorType, Value)
    SELECT @test_id, "DUPLICATED", hashing FROM DUPLICATED;
    INSERT INTO RESULT (TaskNum, ErrorType, Value)
    SELECT @test_id, "EXTRA", hashing FROM EXTRA;
    INSERT INTO RESULT (TaskNum, ErrorType, Value)
    SELECT @test_id, "MISSING", hashing FROM MISSED;

    CALL un_hashing(t_student);
    CALL un_hashing(t_TA);
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `hashing` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `hashing`(IN i_table VARCHAR(200), IN base ENUM("UserLogin", "AdFilterUser", "AdFilterCom", "AdComDetailTh", "AdComDetailEmp", "ManFilterTh", "CosFilterMovie", "CosViewHistory", "UserFilterTh", "UserVisitHistory", "test"))
BEGIN
-- UserLogin (username, status, isCustomer, isAdmin, isManager)
	DECLARE CONTINUE HANDLER FOR 1060 SET @duplicated_column = 1;
  SET SQL_SAFE_UPDATES = 0;
  SET @alter = CONCAT("ALTER TABLE ", i_table, " ADD hashing VARCHAR(3000) DEFAULT NULL");
  IF base = "test" THEN
    SET @hash = CONCAT("UPDATE ", i_table, " SET hashing = CONCAT_WS('$', id, name)");
  END IF;
  IF base = "UserLogin" THEN
    SET @hash = CONCAT("UPDATE ", i_table, " SET hashing = CONCAT_WS('$', TRIM(username), TRIM(status), TRIM(isCustomer), TRIM(isAdmin), TRIM(isManager))");
  END IF;
-- AdFilterUser (username, creditCardCount, userType, status) 
  IF base = "AdFilterUser" THEN
    SET @hash = CONCAT("UPDATE ", i_table, " SET hashing = CONCAT_WS('$', TRIM(username), TRIM(creditCardCount), TRIM(userType), TRIM(status))");
  END IF;
-- AdFilterCom (comName, numCityCover, numTheater, numEmployee) 
  IF base = "AdFilterCom" THEN
    SET @hash = CONCAT("UPDATE ", i_table, " SET hashing = CONCAT_WS('$', TRIM(comName), TRIM(numCityCover), TRIM(numTheater), TRIM(numEmployee))");
  END IF;
-- AdComDetailTh (thName, thManagerUsername, thCity, thState, thCapacity) 
  IF base = "AdComDetailTh" THEN
    SET @hash = CONCAT("UPDATE ", i_table, " SET hashing = CONCAT_WS('$', TRIM(thName), TRIM(thManagerUsername), TRIM(thCity), TRIM(thState), TRIM(thCapacity))");
  END IF;
-- AdComDetailEmp (empFirstname, empLastname) 
  IF base = "AdComDetailEmp" THEN
    SET @hash = CONCAT("UPDATE ", i_table, " SET hashing = CONCAT_WS('$', TRIM(empFirstname), TRIM(empLastname))");
  END IF;
-- ManFilterTh (movName, movDuration, movReleaseDate, movPlayDate) 
  IF base = "ManFilterTh" THEN
    SET @hash = CONCAT("UPDATE ", i_table, " SET hashing = CONCAT_WS('$', TRIM(movName), TRIM(movDuration), TRIM(movReleaseDate), IF(ISNULL(movPlayDate), '', TRIM(movPlayDate)))");
  END IF;
-- CosFilterMovie (movName, thName, thStreet, thCity, thState, thZipcode, comName, movPlayDate, movReleaseDate) 
  IF base = "CosFilterMovie" THEN
    SET @hash = CONCAT("UPDATE ", i_table, " SET hashing = CONCAT_WS('$', TRIM(movName), TRIM(thName), TRIM(thStreet), TRIM(thCity), TRIM(thState), TRIM(thZipcode), TRIM(comName), TRIM(movPlayDate), TRIM(movReleaseDate))");
  END IF;
-- CosViewHistory (movName, thName, comName, creditCardNum, movPlayDate) 
  IF base = "CosViewHistory" THEN
    SET @hash = CONCAT("UPDATE ", i_table, " SET hashing = CONCAT_WS('$', TRIM(movName), TRIM(thName), TRIM(comName), TRIM(creditCardNum), TRIM(movPlayDate))");
  END IF;
-- UserFilterTh (thName, thStreet, thCity, thState, thZipcode, comName) 
  IF base = "UserFilterTh" THEN
    SET @hash = CONCAT("UPDATE ", i_table, " SET hashing = CONCAT_WS('$', TRIM(thName), TRIM(thStreet), TRIM(thCity), TRIM(thState), TRIM(thZipcode), TRIM(comName))");
  END IF;
-- UserVisitHistory (thName, thStreet, thCity, thState, thZipcode, comName, visitDate) 
  IF base = "UserVisitHistory" THEN
    SET @hash = CONCAT("UPDATE ", i_table, " SET hashing = CONCAT_WS('$', TRIM(thName), TRIM(thStreet), TRIM(thCity), TRIM(thState), TRIM(thZipcode), TRIM(comName), TRIM(visitDate))");
  END IF;

  	  PREPARE stm1 FROM @alter;
      EXECUTE stm1;
      DEALLOCATE PREPARE stm1;
  
      PREPARE stm2 FROM @hash;
      EXECUTE stm2;
      DEALLOCATE PREPARE stm2;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `un_hashing` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `un_hashing`(IN i_table VARCHAR(200))
BEGIN
DECLARE CONTINUE HANDLER FOR 1091 SET @unknown_column = 1;
  	SET @drop = CONCAT("ALTER TABLE ", i_table, " DROP COLUMN hashing");
      PREPARE stm3 FROM @drop;
      EXECUTE stm3;
      DEALLOCATE PREPARE stm3;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `validate_test` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `validate_test`(IN test_id INT, IN t_TA VARCHAR(200), IN t_student VARCHAR(200))
BEGIN
	DROP TABLE IF EXISTS EXTRA;
	DROP TABLE IF EXISTS MISSED;
	DROP TABLE IF EXISTS DUPLICATED;
	SET @duplicated = CONCAT("CREATE TABLE DUPLICATED SELECT hashing FROM ", t_student, " GROUP BY hashing HAVING COUNT(*) > 1");
	SET @comm = CONCAT(" WHERE ", t_TA, ".hashing = ", t_student, ".hashing)");
	SET @extra = CONCAT("CREATE TABLE EXTRA SELECT hashing FROM ", t_student, " WHERE NOT EXISTS (SELECT 1 FROM ", t_TA, @comm);
	SET @missed = CONCAT("CREATE TABLE MISSED SELECT hashing FROM ", t_TA, " WHERE NOT EXISTS (SELECT 1 FROM ", t_student, @comm);
    
    PREPARE stm1 FROM @extra;
    EXECUTE stm1;
    DEALLOCATE PREPARE stm1;
    
    PREPARE stm2 FROM @missed;
    EXECUTE stm2;
    DEALLOCATE PREPARE stm2;

    PREPARE stm3 FROM @duplicated;
    EXECUTE stm3;
    DEALLOCATE PREPARE stm3;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-25 19:01:16
