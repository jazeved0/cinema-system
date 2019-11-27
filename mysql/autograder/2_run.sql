-- CS4400 Introduction to Database Systems (v7/Tuesday, November 26, 2019)
-- Self-Contained Autograding/Testing Script for Phase 3 of the Course Project

-- This procedure is used to support the scoring process.  It creates an SQL query
-- that identifies rows that are either MISSING from the expected answer, or EXTRA
-- (and should not be included) relative to the expected answer.
DROP PROCEDURE IF EXISTS magic44_check_step;
DELIMITER //
CREATE PROCEDURE magic44_check_step(step_number CHAR(10), step_table CHAR(254), hash_format VARCHAR(2000))
BEGIN
SET @sql_text = concat("insert into magic44_scoring \n",
"(select ",step_number,", 'missing', concat(",hash_format,") \n",
"from magic44_table",step_number," \n",
"where concat(",hash_format,") not in (select concat(",hash_format,") \n",
"from ",step_table,")) \n",
"union (select ",step_number,", 'extra', concat(",hash_format,") \n",
"from ",step_table," \n",
"where concat(",hash_format,") not in \n",
"(select concat(",hash_format,") from magic44_table",step_number,"))");
select @sql_text;
PREPARE statement from @sql_text;
EXECUTE statement;
END //
DELIMITER ;

-- This table is used to store the scoring results.  The problem column refers
-- to the testing step as listed below.  The error_category column contains
-- MISSING or EXTRA.  The row_hash column contains the values of the row in a
-- single string with the attribute values separated by a delimeter (#).
DROP TABLE IF EXISTS magic44_scoring;
CREATE TABLE magic44_scoring (
problem decimal(5,0) NOT NULL,
error_category char(20) NOT NULL,
row_hash text NOT NULL
);

-- The following tables contain the expected answers for the corresponding tests.
-- The tables are stored in your database while the script runs, and then deleted
-- once the script has been completed.
DROP TABLE IF EXISTS `magic44_table1`;
CREATE TABLE `magic44_table1` (
  `username` varchar(100) NOT NULL,
  `creditCardCount` bigint(21) NOT NULL DEFAULT '0',
  `userType` varchar(15) NOT NULL DEFAULT '',
  `status` char(10) DEFAULT NULL
);

INSERT INTO `magic44_table1` VALUES ('theScienceGuy',1,'Customer','Approved'),('thePiGuy3.14',1,'Customer','Approved'),('texasStarKarate',0,'User','Declined'),('smith_j',0,'User','Pending'),('RitzLover28',1,'Customer','Approved'),('radioactivePoRa',0,'Manager','Approved'),('programerAAL',1,'Customer','Approved'),('notFullMetal',1,'Customer','Approved'),('manager4',0,'Manager','Approved'),('manager3',0,'Manager','Approved'),('manager2',0,'Manager','Approved'),('manager1',0,'Manager','Approved'),('isthisthekrustykrab',3,'Customer','Approved'),('imready',1,'Customer','Approved'),('imbatman',0,'Manager','Approved'),('ilikemoney$$',3,'Customer','Approved'),('ghcghc',0,'Manager','Approved'),('georgep',5,'CustomerManager','Approved'),('gdanger',0,'User','Declined'),('fullMetal',1,'Customer','Approved'),('fatherAI',0,'Manager','Approved'),('entropyRox',2,'CustomerManager','Approved'),('eeqmcsquare',1,'Customer','Approved'),('does2Much',1,'Customer','Approved'),('DNAhelix',1,'Customer','Approved'),('cool_class4400',1,'CustomerAdmin','Approved'),('clarinetbeast',0,'Customer','Declined'),('calcwizard',1,'Customer','Approved'),('calcultron2',2,'Customer','Approved'),('calcultron',1,'CustomerManager','Approved');

DROP TABLE IF EXISTS `magic44_table2`;
CREATE TABLE `magic44_table2` (
  `comName` varchar(100) NOT NULL DEFAULT '',
  `numCityCover` bigint(21) NOT NULL DEFAULT '0',
  `numTheater` bigint(21) NOT NULL DEFAULT '0',
  `numEmployee` bigint(21) NOT NULL DEFAULT '0'
);

INSERT INTO `magic44_table2` VALUES ('EZ Theater Company',2,2,2),('Awesome Theater Company',1,1,1),('AI Theater Company',1,1,2),('4400 Theater Company',3,3,6);

DROP TABLE IF EXISTS `magic44_table3`;
CREATE TABLE `magic44_table3` (
  `movName` varchar(100) NOT NULL DEFAULT '',
  `movDuration` int(11) DEFAULT NULL,
  `movReleaseDate` date NOT NULL,
  `movPlayDate` date DEFAULT NULL
);

INSERT INTO `magic44_table3` VALUES ('4400 The Movie',130,'2019-08-12','2019-09-12'),('George P Burdell\'s Life Story',100,'1927-08-12','2010-05-20'),('Georgia Tech The Movie',100,'1985-08-13','2019-09-30'),('How to Train Your Dragon',98,'2010-03-21','2010-04-02'),('Spaceballs',96,'1987-06-24','2000-02-02'),('The King\'s Speech',119,'2010-11-26','2019-12-20'),('Avengers: Endgame',181,'2019-04-26',NULL),('Calculus Returns: A ML Story',314,'2019-09-19',NULL),('Spider-Man: Into the Spider-Verse',117,'2018-12-01',NULL),('The First Pokemon Movie',75,'1998-07-19',NULL);

DROP TABLE IF EXISTS `magic44_table4`;
CREATE TABLE `magic44_table4` (
  `movName` varchar(100) NOT NULL DEFAULT '',
  `movDuration` int(11) DEFAULT NULL,
  `movReleaseDate` date NOT NULL,
  `movPlayDate` date DEFAULT NULL
);

INSERT INTO `magic44_table4` VALUES ('4400 The Movie',130,'2019-08-12',NULL),('Avengers: Endgame',181,'2019-04-26',NULL),('Calculus Returns: A ML Story',314,'2019-09-19',NULL),('George P Burdell\'s Life Story',100,'1927-08-12',NULL),('Georgia Tech The Movie',100,'1985-08-13',NULL),('How to Train Your Dragon',98,'2010-03-21',NULL),('Spaceballs',96,'1987-06-24',NULL),('Spider-Man: Into the Spider-Verse',117,'2018-12-01',NULL),('The First Pokemon Movie',75,'1998-07-19',NULL),('The King\'s Speech',119,'2010-11-26',NULL);

DROP TABLE IF EXISTS `magic44_table5`;
CREATE TABLE `magic44_table5` (
  `movName` varchar(100) NOT NULL DEFAULT '',
  `movDuration` int(11) DEFAULT NULL,
  `movReleaseDate` date NOT NULL,
  `movPlayDate` date DEFAULT NULL
);

INSERT INTO `magic44_table5` VALUES ('Calculus Returns: A ML Story',314,'2019-09-19','2019-10-10'),('Calculus Returns: A ML Story',314,'2019-09-19','2019-12-30'),('Spaceballs',96,'1987-06-24','2010-04-02'),('Spaceballs',96,'1987-06-24','2023-01-23'),('Spider-Man: Into the Spider-Verse',117,'2018-12-01','2019-09-30'),('4400 The Movie',130,'2019-08-12',NULL),('Avengers: Endgame',181,'2019-04-26',NULL),('George P Burdell\'s Life Story',100,'1927-08-12',NULL),('Georgia Tech The Movie',100,'1985-08-13',NULL),('How to Train Your Dragon',98,'2010-03-21',NULL),('The First Pokemon Movie',75,'1998-07-19',NULL),('The King\'s Speech',119,'2010-11-26',NULL);

DROP TABLE IF EXISTS `magic44_table6`;
CREATE TABLE `magic44_table6` (
  `movName` varchar(100) NOT NULL DEFAULT '',
  `movDuration` int(11) DEFAULT NULL,
  `movReleaseDate` date NOT NULL,
  `movPlayDate` date DEFAULT NULL
);

INSERT INTO `magic44_table6` VALUES ('4400 The Movie',130,'2019-08-12','2019-10-12'),('Georgia Tech The Movie',100,'1985-08-13','1985-08-13'),('The First Pokemon Movie',75,'1998-07-19','2018-07-19'),('Avengers: Endgame',181,'2019-04-26',NULL),('Calculus Returns: A ML Story',314,'2019-09-19',NULL),('George P Burdell\'s Life Story',100,'1927-08-12',NULL),('How to Train Your Dragon',98,'2010-03-21',NULL),('Spaceballs',96,'1987-06-24',NULL),('Spider-Man: Into the Spider-Verse',117,'2018-12-01',NULL),('The King\'s Speech',119,'2010-11-26',NULL);

DROP TABLE IF EXISTS `magic44_table7`;
CREATE TABLE `magic44_table7` (
  `thName` varchar(100) NOT NULL,
  `thStreet` varchar(100) DEFAULT NULL,
  `thCity` varchar(100) DEFAULT NULL,
  `thState` char(2) DEFAULT NULL,
  `thZipcode` char(5) DEFAULT NULL,
  `comName` varchar(100) NOT NULL
);

INSERT INTO `magic44_table7` VALUES ('Cinema Star','100 Cool Place','San Francisco ','CA','94016','4400 Theater Company'),('Jonathan\'s Movies','67 Pearl Dr','Seattle','WA','98101','4400 Theater Company'),('Star Movies','4400 Rocks Ave','Boulder','CA','80301','4400 Theater Company'),('ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company'),('ABC Theater','880 Color Dr','Austin','TX','73301','Awesome Theater Company'),('Main Movies','123 Main St','New York','NY','10001','EZ Theater Company'),('Star Movies','745 GT St','Atlanta','GA','30332','EZ Theater Company');

DROP TABLE IF EXISTS `magic44_table8`;
CREATE TABLE `magic44_table8` (
  `username` varchar(100) NOT NULL,
  `creditCardCount` bigint(21) NOT NULL DEFAULT '0',
  `userType` varchar(15) NOT NULL DEFAULT '',
  `status` char(10) DEFAULT NULL
);

INSERT INTO `magic44_table8` VALUES ('theScienceGuy',1,'Customer','Approved'),('thePiGuy3.14',1,'Customer','Approved'),('RitzLover28',1,'Customer','Approved'),('radioactivePoRa',0,'Manager','Approved'),('programerAAL',1,'Customer','Approved'),('notFullMetal',1,'Customer','Approved'),('manager4',0,'Manager','Approved'),('manager3',0,'Manager','Approved'),('manager2',0,'Manager','Approved'),('manager1',0,'Manager','Approved'),('isthisthekrustykrab',3,'Customer','Approved'),('imready',1,'Customer','Approved'),('imbatman',0,'Manager','Approved'),('ilikemoney$$',3,'Customer','Approved'),('ghcghc',0,'Manager','Approved'),('georgep',5,'CustomerManager','Approved'),('fullMetal',1,'Customer','Approved'),('fatherAI',0,'Manager','Approved'),('entropyRox',2,'CustomerManager','Approved'),('eeqmcsquare',1,'Customer','Approved'),('does2Much',1,'Customer','Approved'),('DNAhelix',1,'Customer','Approved'),('cool_class4400',1,'CustomerAdmin','Approved'),('calcwizard',1,'Customer','Approved'),('calcultron2',2,'Customer','Approved'),('calcultron',1,'CustomerManager','Approved');

DROP TABLE IF EXISTS `magic44_table9`;
CREATE TABLE `magic44_table9` (
  `username` varchar(100) NOT NULL,
  `creditCardCount` bigint(21) NOT NULL DEFAULT '0',
  `userType` varchar(15) NOT NULL DEFAULT '',
  `status` char(10) DEFAULT NULL
);

INSERT INTO `magic44_table9` VALUES ('clarinetbeast',0,'Customer','Declined'),('gdanger',0,'User','Declined'),('texasStarKarate',0,'User','Declined');

DROP TABLE IF EXISTS `magic44_table10`;
CREATE TABLE `magic44_table10` (
  `username` varchar(100) NOT NULL,
  `creditCardCount` bigint(21) NOT NULL DEFAULT '0',
  `userType` varchar(15) NOT NULL DEFAULT '',
  `status` char(10) DEFAULT NULL
);

INSERT INTO `magic44_table10` VALUES ('smith_j',0,'User','Pending');

DROP TABLE IF EXISTS `magic44_table11`;
CREATE TABLE `magic44_table11` (
  `username` varchar(100) NOT NULL,
  `creditCardCount` bigint(21) NOT NULL DEFAULT '0',
  `userType` varchar(15) NOT NULL DEFAULT '',
  `status` char(10) DEFAULT NULL
);

INSERT INTO `magic44_table11` VALUES ('smith_j',0,'User','Pending');

DROP TABLE IF EXISTS `magic44_table12`;
CREATE TABLE `magic44_table12` (
  `username` varchar(100) NOT NULL,
  `creditCardCount` bigint(21) NOT NULL DEFAULT '0',
  `userType` varchar(15) NOT NULL DEFAULT '',
  `status` char(10) DEFAULT NULL
);

INSERT INTO `magic44_table12` VALUES ('cool_class4400',1,'CustomerAdmin','Approved'),('calcultron',1,'CustomerManager','Approved'),('calcultron2',2,'Customer','Approved'),('calcwizard',1,'Customer','Approved'),('DNAhelix',1,'Customer','Approved'),('does2Much',1,'Customer','Approved'),('eeqmcsquare',1,'Customer','Approved'),('entropyRox',2,'CustomerManager','Approved'),('fatherAI',0,'Manager','Approved'),('fullMetal',1,'Customer','Approved'),('georgep',5,'CustomerManager','Approved'),('ghcghc',0,'Manager','Approved'),('ilikemoney$$',3,'Customer','Approved'),('imbatman',0,'Manager','Approved'),('imready',1,'Customer','Approved'),('isthisthekrustykrab',3,'Customer','Approved'),('manager1',0,'Manager','Approved'),('manager2',0,'Manager','Approved'),('manager3',0,'Manager','Approved'),('manager4',0,'Manager','Approved'),('notFullMetal',1,'Customer','Approved'),('programerAAL',1,'Customer','Approved'),('radioactivePoRa',0,'Manager','Approved'),('RitzLover28',1,'Customer','Approved'),('thePiGuy3.14',1,'Customer','Approved'),('theScienceGuy',1,'Customer','Approved'),('clarinetbeast',0,'Customer','Declined'),('gdanger',0,'User','Declined'),('texasStarKarate',0,'User','Declined'),('smith_j',0,'User','Pending');

DROP TABLE IF EXISTS `magic44_table13`;
CREATE TABLE `magic44_table13` (
  `comName` varchar(100) NOT NULL DEFAULT '',
  `numCityCover` bigint(21) NOT NULL DEFAULT '0',
  `numTheater` bigint(21) NOT NULL DEFAULT '0',
  `numEmployee` bigint(21) NOT NULL DEFAULT '0'
);

INSERT INTO `magic44_table13` VALUES ('AI Theater Company',1,1,2),('Awesome Theater Company',1,1,1),('EZ Theater Company',2,2,2);

DROP TABLE IF EXISTS `magic44_table14`;
CREATE TABLE `magic44_table14` (
  `comName` varchar(100) NOT NULL DEFAULT '',
  `numCityCover` bigint(21) NOT NULL DEFAULT '0',
  `numTheater` bigint(21) NOT NULL DEFAULT '0',
  `numEmployee` bigint(21) NOT NULL DEFAULT '0'
);

INSERT INTO `magic44_table14` VALUES ('EZ Theater Company',2,2,2);

DROP TABLE IF EXISTS `magic44_table15`;
CREATE TABLE `magic44_table15` (
  `comName` varchar(100) NOT NULL DEFAULT '',
  `numCityCover` bigint(21) NOT NULL DEFAULT '0',
  `numTheater` bigint(21) NOT NULL DEFAULT '0',
  `numEmployee` bigint(21) NOT NULL DEFAULT '0'
);

INSERT INTO `magic44_table15` VALUES ('Awesome Theater Company',1,1,1);

DROP TABLE IF EXISTS `magic44_table16`;
CREATE TABLE `magic44_table16` (
  `empFirstname` varchar(100) DEFAULT NULL,
  `empLastname` varchar(100) DEFAULT NULL
);

INSERT INTO `magic44_table16` VALUES ('Dwight','Schrute'),('Alan','Turing');

DROP TABLE IF EXISTS `magic44_table17`;
CREATE TABLE `magic44_table17` (
  `thName` varchar(100) NOT NULL,
  `thManagerUsername` varchar(255) NOT NULL,
  `thCity` varchar(100) DEFAULT NULL,
  `thState` char(2) DEFAULT NULL,
  `thCapacity` int(11) DEFAULT NULL
);

INSERT INTO `magic44_table17` VALUES ('Cinema Star','entropyRox','San Francisco ','CA',4),('Jonathan\'s Movies','georgep','Seattle','WA',2),('Star Movies','radioactivePoRa','Boulder','CA',5);

DROP TABLE IF EXISTS `magic44_table18`;
CREATE TABLE `magic44_table18` (
  `movName` varchar(100) NOT NULL DEFAULT '',
  `movDuration` int(11) DEFAULT NULL,
  `movReleaseDate` date NOT NULL,
  `movPlayDate` date DEFAULT NULL
);

INSERT INTO `magic44_table18` VALUES ('4400 The Movie',130,'2019-08-12','2019-10-12'),('Georgia Tech The Movie',100,'1985-08-13','1985-08-13'),('The First Pokemon Movie',75,'1998-07-19','2018-07-19'),('Avengers: Endgame',181,'2019-04-26',NULL),('Calculus Returns: A ML Story',314,'2019-09-19',NULL),('George P Burdell\'s Life Story',100,'1927-08-12',NULL),('How to Train Your Dragon',98,'2010-03-21',NULL),('Spaceballs',96,'1987-06-24',NULL),('Spider-Man: Into the Spider-Verse',117,'2018-12-01',NULL),('The King\'s Speech',119,'2010-11-26',NULL);

DROP TABLE IF EXISTS `magic44_table19`;
CREATE TABLE `magic44_table19` (
  `movName` varchar(100) NOT NULL DEFAULT '',
  `movDuration` int(11) DEFAULT NULL,
  `movReleaseDate` date NOT NULL,
  `movPlayDate` date DEFAULT NULL
);

INSERT INTO `magic44_table19` VALUES ('Georgia Tech The Movie',100,'1985-08-13','1985-08-13'),('George P Burdell\'s Life Story',100,'1927-08-12',NULL),('How to Train Your Dragon',98,'2010-03-21',NULL),('Spaceballs',96,'1987-06-24',NULL);

DROP TABLE IF EXISTS `magic44_table20`;
CREATE TABLE `magic44_table20` (
  `movName` varchar(100) NOT NULL DEFAULT '',
  `movDuration` int(11) DEFAULT NULL,
  `movReleaseDate` date NOT NULL,
  `movPlayDate` date DEFAULT NULL
);

INSERT INTO `magic44_table20` VALUES ('How to Train Your Dragon',98,'2010-03-21',NULL),('Spider-Man: Into the Spider-Verse',117,'2018-12-01',NULL),('The King\'s Speech',119,'2010-11-26',NULL);

DROP TABLE IF EXISTS `magic44_table21`;
CREATE TABLE `magic44_table21` (
  `movName` varchar(100) NOT NULL,
  `thName` varchar(100) NOT NULL,
  `thStreet` varchar(100) DEFAULT NULL,
  `thCity` varchar(100) DEFAULT NULL,
  `thState` char(2) DEFAULT NULL,
  `thZipcode` char(5) DEFAULT NULL,
  `comName` varchar(100) NOT NULL,
  `movPlayDate` date NOT NULL,
  `movReleaseDate` date NOT NULL
);

INSERT INTO `magic44_table21` VALUES ('4400 The Movie','Cinema Star','100 Cool Place','San Francisco ','CA','94016','4400 Theater Company','2019-09-12','2019-08-12'),('George P Burdell\'s Life Story','Cinema Star','100 Cool Place','San Francisco ','CA','94016','4400 Theater Company','2010-05-20','1927-08-12'),('Georgia Tech The Movie','Cinema Star','100 Cool Place','San Francisco ','CA','94016','4400 Theater Company','2019-09-30','1985-08-13'),('How to Train Your Dragon','Cinema Star','100 Cool Place','San Francisco ','CA','94016','4400 Theater Company','2010-04-02','2010-03-21'),('Spaceballs','Cinema Star','100 Cool Place','San Francisco ','CA','94016','4400 Theater Company','2000-02-02','1987-06-24'),('The King\'s Speech','Cinema Star','100 Cool Place','San Francisco ','CA','94016','4400 Theater Company','2019-12-20','2010-11-26'),('Calculus Returns: A ML Story','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2019-10-10','2019-09-19'),('Calculus Returns: A ML Story','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2019-12-30','2019-09-19'),('Spaceballs','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2010-04-02','1987-06-24'),('Spaceballs','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2023-01-23','1987-06-24'),('Spider-Man: Into the Spider-Verse','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2019-09-30','2018-12-01'),('4400 The Movie','ABC Theater','880 Color Dr','Austin','TX','73301','Awesome Theater Company','2019-10-12','2019-08-12'),('Georgia Tech The Movie','ABC Theater','880 Color Dr','Austin','TX','73301','Awesome Theater Company','1985-08-13','1985-08-13'),('The First Pokemon Movie','ABC Theater','880 Color Dr','Austin','TX','73301','Awesome Theater Company','2018-07-19','1998-07-19'),('George P Burdell\'s Life Story','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2019-07-14','1927-08-12'),('George P Burdell\'s Life Story','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2019-10-22','1927-08-12'),('How to Train Your Dragon','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2010-03-22','2010-03-21'),('How to Train Your Dragon','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2010-03-23','2010-03-21'),('Spaceballs','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','1999-06-24','1987-06-24'),('The King\'s Speech','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2019-12-20','2010-11-26'),('4400 The Movie','Star Movies','745 GT St','Atlanta','GA','30332','EZ Theater Company','2019-08-12','2019-08-12'),('How to Train Your Dragon','Star Movies','745 GT St','Atlanta','GA','30332','EZ Theater Company','2010-03-25','2010-03-21');

DROP TABLE IF EXISTS `magic44_table22`;
CREATE TABLE `magic44_table22` (
  `movName` varchar(100) NOT NULL,
  `thName` varchar(100) NOT NULL,
  `thStreet` varchar(100) DEFAULT NULL,
  `thCity` varchar(100) DEFAULT NULL,
  `thState` char(2) DEFAULT NULL,
  `thZipcode` char(5) DEFAULT NULL,
  `comName` varchar(100) NOT NULL,
  `movPlayDate` date NOT NULL,
  `movReleaseDate` date NOT NULL
);

INSERT INTO `magic44_table22` VALUES ('Spaceballs','Cinema Star','100 Cool Place','San Francisco ','CA','94016','4400 Theater Company','2000-02-02','1987-06-24'),('Spaceballs','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2010-04-02','1987-06-24'),('Spaceballs','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2023-01-23','1987-06-24');

DROP TABLE IF EXISTS `magic44_table23`;
CREATE TABLE `magic44_table23` (
  `movName` varchar(100) NOT NULL,
  `thName` varchar(100) NOT NULL,
  `thStreet` varchar(100) DEFAULT NULL,
  `thCity` varchar(100) DEFAULT NULL,
  `thState` char(2) DEFAULT NULL,
  `thZipcode` char(5) DEFAULT NULL,
  `comName` varchar(100) NOT NULL,
  `movPlayDate` date NOT NULL,
  `movReleaseDate` date NOT NULL
);

INSERT INTO `magic44_table23` VALUES ('How to Train Your Dragon','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2010-03-22','2010-03-21'),('How to Train Your Dragon','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2010-03-23','2010-03-21'),('Spaceballs','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','1999-06-24','1987-06-24'),('How to Train Your Dragon','Star Movies','745 GT St','Atlanta','GA','30332','EZ Theater Company','2010-03-25','2010-03-21');

DROP TABLE IF EXISTS `magic44_table24`;
CREATE TABLE `magic44_table24` (
  `movName` varchar(100) NOT NULL,
  `thName` varchar(100) NOT NULL,
  `comName` varchar(100) NOT NULL,
  `creditCardNum` char(16) NOT NULL,
  `movPlayDate` date NOT NULL
);

INSERT INTO `magic44_table24` VALUES ('How to Train Your Dragon','Star Movies','EZ Theater Company','1111111111111100','2010-03-25'),('How to Train Your Dragon','Cinema Star','4400 Theater Company','1111111111111111','2010-04-02'),('How to Train Your Dragon','Main Movies','EZ Theater Company','1111111111111111','2010-03-22'),('How to Train Your Dragon','Main Movies','EZ Theater Company','1111111111111111','2010-03-23');

DROP TABLE IF EXISTS `magic44_table25`;
CREATE TABLE `magic44_table25` (
  `movName` varchar(100) NOT NULL,
  `thName` varchar(100) NOT NULL,
  `comName` varchar(100) NOT NULL,
  `creditCardNum` char(16) NOT NULL,
  `movPlayDate` date NOT NULL
);

DROP TABLE IF EXISTS `magic44_table26`;
CREATE TABLE `magic44_table26` (
  `thName` varchar(100) NOT NULL,
  `thStreet` varchar(100) DEFAULT NULL,
  `thCity` varchar(100) DEFAULT NULL,
  `thState` char(2) DEFAULT NULL,
  `thZipcode` char(5) DEFAULT NULL,
  `comName` varchar(100) NOT NULL
);

INSERT INTO `magic44_table26` VALUES ('Cinema Star','100 Cool Place','San Francisco ','CA','94016','4400 Theater Company'),('Star Movies','4400 Rocks Ave','Boulder','CA','80301','4400 Theater Company');

DROP TABLE IF EXISTS `magic44_table27`;
CREATE TABLE `magic44_table27` (
  `thName` varchar(100) NOT NULL,
  `thStreet` varchar(100) DEFAULT NULL,
  `thCity` varchar(100) DEFAULT NULL,
  `thState` char(2) DEFAULT NULL,
  `thZipcode` char(5) DEFAULT NULL,
  `comName` varchar(100) NOT NULL
);

DROP TABLE IF EXISTS `magic44_table28`;
CREATE TABLE `magic44_table28` (
  `username` varchar(100) NOT NULL,
  `status` char(10) DEFAULT NULL,
  `isCustomer` bigint(1) NOT NULL DEFAULT '0',
  `isAdmin` bigint(1) NOT NULL DEFAULT '0',
  `isManager` bigint(1) NOT NULL DEFAULT '0'
);

INSERT INTO `magic44_table28` VALUES ('calcwizard','Approved',1,0,0);

DROP TABLE IF EXISTS `magic44_table29`;
CREATE TABLE `magic44_table29` (
  `username` varchar(100) NOT NULL,
  `status` char(10) DEFAULT NULL,
  `isCustomer` bigint(1) NOT NULL DEFAULT '0',
  `isAdmin` bigint(1) NOT NULL DEFAULT '0',
  `isManager` bigint(1) NOT NULL DEFAULT '0'
);

INSERT INTO `magic44_table29` VALUES ('gdanger','Declined',0,0,0);

DROP TABLE IF EXISTS `magic44_table30`;
CREATE TABLE `magic44_table30` (
  `username` varchar(100) NOT NULL,
  `status` char(10) DEFAULT NULL,
  `isCustomer` bigint(1) NOT NULL DEFAULT '0',
  `isAdmin` bigint(1) NOT NULL DEFAULT '0',
  `isManager` bigint(1) NOT NULL DEFAULT '0'
);

INSERT INTO `magic44_table30` VALUES ('imbatman','Approved',0,0,1);

DROP TABLE IF EXISTS `magic44_table35`;
CREATE TABLE `magic44_table35` (
  `username` varchar(100) NOT NULL,
  `creditCardCount` bigint(21) NOT NULL DEFAULT '0',
  `userType` varchar(15) NOT NULL DEFAULT '',
  `status` char(10) DEFAULT NULL
);

INSERT INTO `magic44_table35` VALUES ('wonderwoman',0,'CustomerManager','Pending'),('theScienceGuy',1,'Customer','Approved'),('thePiGuy3.14',1,'Customer','Approved'),('texasStarKarate',0,'User','Declined'),('smith_j',0,'User','Pending'),('rubble3',0,'Customer','Pending'),('RitzLover28',1,'Customer','Approved'),('radioactivePoRa',0,'Manager','Approved'),('programerAAL',1,'Customer','Approved'),('notFullMetal',1,'Customer','Approved'),('manager4',0,'Manager','Approved'),('manager3',0,'Manager','Approved'),('manager2',0,'Manager','Approved'),('manager1',0,'Manager','Approved'),('isthisthekrustykrab',3,'Customer','Approved'),('imready',1,'Customer','Approved'),('imbatman',0,'Manager','Approved'),('ilikemoney$$',3,'Customer','Approved'),('ghcghc',0,'Manager','Approved'),('georgep',5,'CustomerManager','Approved'),('gdanger',0,'User','Declined'),('fullMetal',1,'Customer','Approved'),('flinstone4',0,'User','Pending'),('fatherAI',0,'Manager','Approved'),('entropyRox',2,'CustomerManager','Approved'),('eeqmcsquare',1,'Customer','Approved'),('does2Much',1,'Customer','Approved'),('DNAhelix',1,'Customer','Approved'),('cool_class4400',1,'CustomerAdmin','Approved'),('clarinetbeast',0,'Customer','Declined'),('calcwizard',1,'Customer','Approved'),('calcultron2',2,'Customer','Approved'),('calcultron',1,'CustomerManager','Approved'),('b_allen',0,'Manager','Pending');

DROP TABLE IF EXISTS `magic44_table38`;
CREATE TABLE `magic44_table38` (
  `username` varchar(100) NOT NULL,
  `creditCardCount` bigint(21) NOT NULL DEFAULT '0',
  `userType` varchar(15) NOT NULL DEFAULT '',
  `status` char(10) DEFAULT NULL
);

INSERT INTO `magic44_table38` VALUES ('wonderwoman',0,'CustomerManager','Pending'),('theScienceGuy',1,'Customer','Approved'),('thePiGuy3.14',1,'Customer','Approved'),('texasStarKarate',0,'User','Declined'),('smith_j',0,'User','Declined'),('rubble3',0,'Customer','Pending'),('RitzLover28',1,'Customer','Approved'),('radioactivePoRa',0,'Manager','Approved'),('programerAAL',1,'Customer','Approved'),('notFullMetal',1,'Customer','Approved'),('manager4',0,'Manager','Approved'),('manager3',0,'Manager','Approved'),('manager2',0,'Manager','Approved'),('manager1',0,'Manager','Approved'),('isthisthekrustykrab',3,'Customer','Approved'),('imready',1,'Customer','Approved'),('imbatman',0,'Manager','Approved'),('ilikemoney$$',3,'Customer','Approved'),('ghcghc',0,'Manager','Approved'),('georgep',5,'CustomerManager','Approved'),('gdanger',0,'User','Declined'),('fullMetal',1,'Customer','Approved'),('flinstone4',0,'User','Pending'),('fatherAI',0,'Manager','Approved'),('entropyRox',2,'CustomerManager','Approved'),('eeqmcsquare',1,'Customer','Approved'),('does2Much',1,'Customer','Approved'),('DNAhelix',1,'Customer','Approved'),('cool_class4400',1,'CustomerAdmin','Approved'),('clarinetbeast',0,'Customer','Approved'),('calcwizard',1,'Customer','Approved'),('calcultron2',2,'Customer','Approved'),('calcultron',1,'CustomerManager','Approved'),('b_allen',0,'Manager','Pending');

DROP TABLE IF EXISTS `magic44_table40`;
CREATE TABLE `magic44_table40` (
  `thName` varchar(100) NOT NULL,
  `thStreet` varchar(100) DEFAULT NULL,
  `thCity` varchar(100) DEFAULT NULL,
  `thState` char(2) DEFAULT NULL,
  `thZipcode` char(5) DEFAULT NULL,
  `comName` varchar(100) NOT NULL
);

INSERT INTO `magic44_table40` VALUES ('Cinema Star','100 Cool Place','San Francisco ','CA','94016','4400 Theater Company'),('Jonathan\'s Movies','67 Pearl Dr','Seattle','WA','98101','4400 Theater Company'),('Perimeter Cinema','1 Roundabout Circle','Waco','TX','90467','4400 Theater Company'),('Star Movies','4400 Rocks Ave','Boulder','CA','80301','4400 Theater Company'),('ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company'),('ABC Theater','880 Color Dr','Austin','TX','73301','Awesome Theater Company'),('Main Movies','123 Main St','New York','NY','10001','EZ Theater Company'),('Star Movies','745 GT St','Atlanta','GA','30332','EZ Theater Company');

DROP TABLE IF EXISTS `magic44_table42`;
CREATE TABLE `magic44_table42` (
  `movName` varchar(100) NOT NULL DEFAULT '',
  `movDuration` int(11) DEFAULT NULL,
  `movReleaseDate` date NOT NULL,
  `movPlayDate` date DEFAULT NULL
);

INSERT INTO `magic44_table42` VALUES ('4400 The Movie',130,'2019-08-12','2019-10-12'),('Georgia Tech The Movie',100,'1985-08-13','1985-08-13'),('The First Pokemon Movie',75,'1998-07-19','2018-07-19'),('Avengers: Endgame',181,'2019-04-26',NULL),('Calculus Returns: A ML Story',314,'2019-09-19',NULL),('Doctor Strange',115,'2016-10-20',NULL),('George P Burdell\'s Life Story',100,'1927-08-12',NULL),('How to Train Your Dragon',98,'2010-03-21',NULL),('Spaceballs',96,'1987-06-24',NULL),('Spider-Man: Into the Spider-Verse',117,'2018-12-01',NULL),('The King\'s Speech',119,'2010-11-26',NULL);

DROP TABLE IF EXISTS `magic44_table44`;
CREATE TABLE `magic44_table44` (
  `movName` varchar(100) NOT NULL DEFAULT '',
  `movDuration` int(11) DEFAULT NULL,
  `movReleaseDate` date NOT NULL,
  `movPlayDate` date DEFAULT NULL
);

INSERT INTO `magic44_table44` VALUES ('4400 The Movie',130,'2019-08-12','2019-08-12'),('How to Train Your Dragon',98,'2010-03-21','2010-03-25'),('Spaceballs',96,'1987-06-24','2019-12-06'),('Avengers: Endgame',181,'2019-04-26',NULL),('Calculus Returns: A ML Story',314,'2019-09-19',NULL),('Doctor Strange',115,'2016-10-20',NULL),('George P Burdell\'s Life Story',100,'1927-08-12',NULL),('Georgia Tech The Movie',100,'1985-08-13',NULL),('Spider-Man: Into the Spider-Verse',117,'2018-12-01',NULL),('The First Pokemon Movie',75,'1998-07-19',NULL),('The King\'s Speech',119,'2010-11-26',NULL);

DROP TABLE IF EXISTS `magic44_table46`;
CREATE TABLE `magic44_table46` (
  `movName` varchar(100) NOT NULL,
  `thName` varchar(100) NOT NULL,
  `comName` varchar(100) NOT NULL,
  `creditCardNum` char(16) NOT NULL,
  `movPlayDate` date NOT NULL
);

INSERT INTO `magic44_table46` VALUES ('How to Train Your Dragon','Star Movies','EZ Theater Company','1111111111111100','2010-03-25'),('How to Train Your Dragon','Cinema Star','4400 Theater Company','1111111111111111','2010-04-02'),('How to Train Your Dragon','Main Movies','EZ Theater Company','1111111111111111','2010-03-22'),('How to Train Your Dragon','Main Movies','EZ Theater Company','1111111111111111','2010-03-23');

DROP TABLE IF EXISTS `magic44_table48`;
CREATE TABLE `magic44_table48` (
  `thName` varchar(100) DEFAULT NULL,
  `thStreet` varchar(100) DEFAULT NULL,
  `thCity` varchar(100) DEFAULT NULL,
  `thState` char(2) DEFAULT NULL,
  `thZipcode` char(5) DEFAULT NULL,
  `comName` varchar(100) DEFAULT NULL,
  `visitDate` date DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL
);

INSERT INTO `magic44_table48` VALUES ('ABC Theater','880 Color Dr','Austin','TX','73301','Awesome Theater Company','2019-12-24','ghcghc');

DROP TABLE IF EXISTS `magic44_table52`;
CREATE TABLE `magic44_table52` (
  `username` varchar(100) NOT NULL,
  `creditCardCount` bigint(21) NOT NULL DEFAULT '0',
  `userType` varchar(15) NOT NULL DEFAULT '',
  `status` char(10) DEFAULT NULL
);

INSERT INTO `magic44_table52` VALUES ('wonderwoman',0,'CustomerManager','Pending'),('theScienceGuy',1,'Customer','Approved'),('thePiGuy3.14',1,'Customer','Approved'),('texasStarKarate',0,'User','Declined'),('smith_j',0,'User','Declined'),('rubble3',0,'Customer','Pending'),('RitzLover28',1,'Customer','Approved'),('radioactivePoRa',0,'Manager','Approved'),('programerAAL',1,'Customer','Approved'),('notFullMetal',1,'Customer','Approved'),('manager4',0,'Manager','Approved'),('manager3',0,'Manager','Approved'),('manager2',0,'Manager','Approved'),('manager1',0,'Manager','Approved'),('isthisthekrustykrab',3,'Customer','Approved'),('imready',1,'Customer','Approved'),('imbatman',0,'Manager','Approved'),('ilikemoney$$',3,'Customer','Approved'),('ghcghc',0,'Manager','Approved'),('georgep',5,'CustomerManager','Approved'),('gdanger',0,'User','Declined'),('fullMetal',1,'Customer','Approved'),('flinstone4',0,'User','Pending'),('fatherAI',0,'Manager','Approved'),('entropyRox',2,'CustomerManager','Approved'),('eeqmcsquare',1,'Customer','Approved'),('does2Much',1,'Customer','Approved'),('DNAhelix',1,'Customer','Approved'),('cool_class4400',1,'CustomerAdmin','Approved'),('clarinetbeast',0,'Customer','Approved'),('calcwizard',1,'Customer','Approved'),('calcultron2',2,'Customer','Approved'),('calcultron',1,'CustomerManager','Approved'),('b_allen',0,'Manager','Pending');

DROP TABLE IF EXISTS `magic44_table54`;
CREATE TABLE `magic44_table54` (
  `thName` varchar(100) NOT NULL,
  `thStreet` varchar(100) DEFAULT NULL,
  `thCity` varchar(100) DEFAULT NULL,
  `thState` char(2) DEFAULT NULL,
  `thZipcode` char(5) DEFAULT NULL,
  `comName` varchar(100) NOT NULL
);

INSERT INTO `magic44_table54` VALUES ('Cinema Star','100 Cool Place','San Francisco ','CA','94016','4400 Theater Company'),('Jonathan\'s Movies','67 Pearl Dr','Seattle','WA','98101','4400 Theater Company'),('Perimeter Cinema','1 Roundabout Circle','Waco','TX','90467','4400 Theater Company'),('Star Movies','4400 Rocks Ave','Boulder','CA','80301','4400 Theater Company'),('ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company'),('ABC Theater','880 Color Dr','Austin','TX','73301','Awesome Theater Company'),('Main Movies','123 Main St','New York','NY','10001','EZ Theater Company'),('Star Movies','745 GT St','Atlanta','GA','30332','EZ Theater Company');

DROP TABLE IF EXISTS `magic44_table56`;
CREATE TABLE `magic44_table56` (
  `movName` varchar(100) NOT NULL,
  `thName` varchar(100) NOT NULL,
  `thStreet` varchar(100) DEFAULT NULL,
  `thCity` varchar(100) DEFAULT NULL,
  `thState` char(2) DEFAULT NULL,
  `thZipcode` char(5) DEFAULT NULL,
  `comName` varchar(100) NOT NULL,
  `movPlayDate` date NOT NULL,
  `movReleaseDate` date NOT NULL
);

INSERT INTO `magic44_table56` VALUES ('4400 The Movie','Cinema Star','100 Cool Place','San Francisco ','CA','94016','4400 Theater Company','2019-09-12','2019-08-12'),('George P Burdell\'s Life Story','Cinema Star','100 Cool Place','San Francisco ','CA','94016','4400 Theater Company','2010-05-20','1927-08-12'),('Georgia Tech The Movie','Cinema Star','100 Cool Place','San Francisco ','CA','94016','4400 Theater Company','2019-09-30','1985-08-13'),('How to Train Your Dragon','Cinema Star','100 Cool Place','San Francisco ','CA','94016','4400 Theater Company','2010-04-02','2010-03-21'),('Spaceballs','Cinema Star','100 Cool Place','San Francisco ','CA','94016','4400 Theater Company','2000-02-02','1987-06-24'),('The King\'s Speech','Cinema Star','100 Cool Place','San Francisco ','CA','94016','4400 Theater Company','2019-12-20','2010-11-26'),('Calculus Returns: A ML Story','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2019-10-10','2019-09-19'),('Calculus Returns: A ML Story','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2019-12-30','2019-09-19'),('Spaceballs','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2010-04-02','1987-06-24'),('Spaceballs','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2023-01-23','1987-06-24'),('Spider-Man: Into the Spider-Verse','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2019-09-30','2018-12-01'),('4400 The Movie','ABC Theater','880 Color Dr','Austin','TX','73301','Awesome Theater Company','2019-10-12','2019-08-12'),('Georgia Tech The Movie','ABC Theater','880 Color Dr','Austin','TX','73301','Awesome Theater Company','1985-08-13','1985-08-13'),('The First Pokemon Movie','ABC Theater','880 Color Dr','Austin','TX','73301','Awesome Theater Company','2018-07-19','1998-07-19'),('George P Burdell\'s Life Story','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2019-07-14','1927-08-12'),('George P Burdell\'s Life Story','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2019-10-22','1927-08-12'),('How to Train Your Dragon','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2010-03-22','2010-03-21'),('How to Train Your Dragon','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2010-03-23','2010-03-21'),('Spaceballs','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','1999-06-24','1987-06-24'),('The King\'s Speech','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2019-12-20','2010-11-26'),('4400 The Movie','Star Movies','745 GT St','Atlanta','GA','30332','EZ Theater Company','2019-08-12','2019-08-12'),('How to Train Your Dragon','Star Movies','745 GT St','Atlanta','GA','30332','EZ Theater Company','2010-03-25','2010-03-21'),('Spaceballs','Star Movies','745 GT St','Atlanta','GA','30332','EZ Theater Company','2019-12-06','1987-06-24');

DROP TABLE IF EXISTS `magic44_table62`;
CREATE TABLE `magic44_table62` (
  `movName` varchar(100) NOT NULL,
  `thName` varchar(100) NOT NULL,
  `thStreet` varchar(100) DEFAULT NULL,
  `thCity` varchar(100) DEFAULT NULL,
  `thState` char(2) DEFAULT NULL,
  `thZipcode` char(5) DEFAULT NULL,
  `comName` varchar(100) NOT NULL,
  `movPlayDate` date NOT NULL,
  `movReleaseDate` date NOT NULL
);

INSERT INTO `magic44_table62` VALUES ('4400 The Movie','Cinema Star','100 Cool Place','San Francisco ','CA','94016','4400 Theater Company','2019-09-12','2019-08-12'),('George P Burdell\'s Life Story','Cinema Star','100 Cool Place','San Francisco ','CA','94016','4400 Theater Company','2010-05-20','1927-08-12'),('Georgia Tech The Movie','Cinema Star','100 Cool Place','San Francisco ','CA','94016','4400 Theater Company','2019-09-30','1985-08-13'),('How to Train Your Dragon','Cinema Star','100 Cool Place','San Francisco ','CA','94016','4400 Theater Company','2010-04-02','2010-03-21'),('Spaceballs','Cinema Star','100 Cool Place','San Francisco ','CA','94016','4400 Theater Company','2000-02-02','1987-06-24'),('The King\'s Speech','Cinema Star','100 Cool Place','San Francisco ','CA','94016','4400 Theater Company','2019-12-20','2010-11-26'),('Calculus Returns: A ML Story','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2019-10-10','2019-09-19'),('Calculus Returns: A ML Story','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2019-12-30','2019-09-19'),('Spaceballs','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2010-04-02','1987-06-24'),('Spaceballs','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2023-01-23','1987-06-24'),('Spider-Man: Into the Spider-Verse','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2019-09-30','2018-12-01'),('4400 The Movie','ABC Theater','880 Color Dr','Austin','TX','73301','Awesome Theater Company','2019-10-12','2019-08-12'),('Georgia Tech The Movie','ABC Theater','880 Color Dr','Austin','TX','73301','Awesome Theater Company','1985-08-13','1985-08-13'),('Georgia Tech The Movie','ABC Theater','880 Color Dr','Austin','TX','73301','Awesome Theater Company','2010-04-02','1985-08-13'),('The First Pokemon Movie','ABC Theater','880 Color Dr','Austin','TX','73301','Awesome Theater Company','2018-07-19','1998-07-19'),('George P Burdell\'s Life Story','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2019-07-14','1927-08-12'),('George P Burdell\'s Life Story','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2019-10-22','1927-08-12'),('How to Train Your Dragon','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2010-03-22','2010-03-21'),('How to Train Your Dragon','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2010-03-23','2010-03-21'),('Spaceballs','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','1999-06-24','1987-06-24'),('The King\'s Speech','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2019-12-20','2010-11-26'),('4400 The Movie','Star Movies','745 GT St','Atlanta','GA','30332','EZ Theater Company','2019-08-12','2019-08-12'),('How to Train Your Dragon','Star Movies','745 GT St','Atlanta','GA','30332','EZ Theater Company','2010-03-25','2010-03-21'),('Spaceballs','Star Movies','745 GT St','Atlanta','GA','30332','EZ Theater Company','2019-12-06','1987-06-24');

DROP TABLE IF EXISTS `magic44_table63`;
CREATE TABLE `magic44_table63` (
  `movName` varchar(100) NOT NULL,
  `thName` varchar(100) NOT NULL,
  `comName` varchar(100) NOT NULL,
  `creditCardNum` char(16) NOT NULL,
  `movPlayDate` date NOT NULL
);

INSERT INTO `magic44_table63` VALUES ('Spaceballs','ML Movies','AI Theater Company','1111111111111100','2010-04-02'),('How to Train Your Dragon','Star Movies','EZ Theater Company','1111111111111100','2010-03-25'),('How to Train Your Dragon','Cinema Star','4400 Theater Company','1111111111111111','2010-04-02'),('The First Pokemon Movie','ML Movies','AI Theater Company','1111111111111111','2010-04-02'),('How to Train Your Dragon','Main Movies','EZ Theater Company','1111111111111111','2010-03-22'),('How to Train Your Dragon','Main Movies','EZ Theater Company','1111111111111111','2010-03-23');

-- The actual tests are listed below.  The tests for select queries are evaluated
-- directly by executing the corresponding stored procedures, and then comparing the
-- actual results to the expected results listed in the tables above. Insert, update
-- and delete queries are evaluated indirectly by re-executing select queries to
-- identify changes to the appropriate tables. 

-- The first seven (7) steps of this script [step #1 through step #7] are designed
-- to check the select queries in an unfiltered manner as much as possible, to help
-- confirm that the initial data has been loaded correctly.
-- [step #1: screen 13c] (wide-aperture/unfiltered select queries)
CALL admin_filter_user('', 'ALL', '', '');
CALL magic44_check_step('1', 'AdFilterUser', "username, '#', creditCardCount, '#', userType, '#', status");

-- [step #2: screen 14]
CALL admin_filter_company('ALL', null, null, null, null, null, null, '', '');
CALL magic44_check_step('2', 'AdFilterCom', "comName, '#', numCityCover, '#', numTheater, '#', numEmployee");

-- [step #3: screen 18]
CALL manager_filter_th('entropyRox', '', null, null, null, null, null, null, null);
CALL magic44_check_step('3', 'ManFilterTh', "movName, '#', movDuration, '#', movReleaseDate, '#', movPlayDate");

-- [step #4: screen 18]
CALL manager_filter_th('georgep', '', null, null, null, null, null, null, null);
CALL magic44_check_step('4', 'ManFilterTh', "movName, '#', movDuration, '#', movReleaseDate, '#', movPlayDate");

-- [step #5: screen 18]
CALL manager_filter_th('ghcghc', '', null, null, null, null, null, null, null);
CALL magic44_check_step('5', 'ManFilterTh', "movName, '#', movDuration, '#', movReleaseDate, '#', movPlayDate");

-- [step #6: screen 18]
CALL manager_filter_th('imbatman', '', null, null, null, null, null, null, null);
CALL magic44_check_step('6', 'ManFilterTh', "movName, '#', movDuration, '#', movReleaseDate, '#', movPlayDate");

-- [step #7: screen 22a]
CALL user_filter_th('ALL', 'ALL', '', '');
CALL magic44_check_step('7', 'UserFilterTh', "thName, '#', thStreet, '#', thCity, '#', thState, '#', thZipcode, '#', comName");

-- The next twenty-three (23) steps of this script [step #8 through step #30] are designed
-- to test the filters on some of the select queries to ensure that the proper rows
-- are being included and excluded.
-- [step #8: screen 13c] (filtered select queries)
CALL admin_filter_user('', 'Approved', '', '');
CALL magic44_check_step('8', 'AdFilterUser', "username, '#', creditCardCount, '#', userType, '#', status");

-- [step #9: screen 13c]
CALL admin_filter_user('', 'Declined', '', 'ASC');
CALL magic44_check_step('9', 'AdFilterUser', "username, '#', creditCardCount, '#', userType, '#', status");

-- [step #10: screen 13c]
CALL admin_filter_user('', 'Pending', 'creditCardCount', '');
CALL magic44_check_step('10', 'AdFilterUser', "username, '#', creditCardCount, '#', userType, '#', status");

-- [step #11: screen 13c]
CALL admin_filter_user('smith_j', 'ALL', '', '');
CALL magic44_check_step('11', 'AdFilterUser', "username, '#', creditCardCount, '#', userType, '#', status");

-- [step #12: screen 13c]
CALL admin_filter_user('', 'ALL', 'status', 'ASC');
CALL magic44_check_step('12', 'AdFilterUser', "username, '#', creditCardCount, '#', userType, '#', status");

-- [step #13: screen 14]
CALL admin_filter_company('', 1, 2, null, null, null, null, '', 'ASC');
CALL magic44_check_step('13', 'AdFilterCom', "comName, '#', numCityCover, '#', numTheater, '#', numEmployee");

-- [step #14: screen 14]
CALL admin_filter_company('', null, null, 2, 3, 1, 2, 'numCityCover', '');
CALL magic44_check_step('14', 'AdFilterCom', "comName, '#', numCityCover, '#', numTheater, '#', numEmployee");

-- [step #15: screen 14]
CALL admin_filter_company('Awesome Theater Company', null, null, null, null, null, null, '', '');
CALL magic44_check_step('15', 'AdFilterCom', "comName, '#', numCityCover, '#', numTheater, '#', numEmployee");

-- [step #16: screen 16a]
CALL admin_view_comDetail_emp('EZ Theater Company');
CALL magic44_check_step('16', 'AdComDetailEmp', "empFirstname, '#', empLastname");

-- [step #17: screen 16b]
CALL admin_view_comDetail_th('4400 Theater Company');
CALL magic44_check_step('17', 'AdComDetailTh', "thName, '#', thManagerUsername, '#', thCity, '#', thState, '#', thCapacity");

-- [step #18: screen 18]
CALL manager_filter_th('imbatman', '', null, null, null, null, null, null, null);
CALL magic44_check_step('18', 'ManFilterTh', "movName, '#', movDuration, '#', movReleaseDate, '#', movPlayDate");

-- [step #19: screen 18]
CALL manager_filter_th('imbatman', '', 90, 100, null, null, null, null, False);
CALL magic44_check_step('19', 'ManFilterTh', "movName, '#', movDuration, '#', movReleaseDate, '#', movPlayDate");

-- [step #20: screen 18]
CALL manager_filter_th('imbatman', '', null, null, '2000-01-01', '2019-01-01', null, null, True);
CALL magic44_check_step('20', 'ManFilterTh', "movName, '#', movDuration, '#', movReleaseDate, '#', movPlayDate");

-- [step #21: screen 20a]
CALL customer_filter_mov('ALL', 'ALL', '', '', null, null);
CALL magic44_check_step('21', 'CosFilterMovie', "movName, '#', thName, '#', thStreet, '#', thCity, '#', thState, '#', thZipcode, '#', 
comName, '#', movPlayDate, '#', movReleaseDate");

-- [step #22: screen 20a]
CALL customer_filter_mov('Spaceballs', 'ALL', '', '', '2000-01-01', null);
CALL magic44_check_step('22', 'CosFilterMovie', "movName, '#', thName, '#', thStreet, '#', thCity, '#', thState, '#', thZipcode, '#', 
comName, '#', movPlayDate, '#', movReleaseDate");

-- [step #23: screen 20a]
CALL customer_filter_mov('ALL', 'EZ Theater Company', '', '', null, '2011-01-01');
CALL magic44_check_step('23', 'CosFilterMovie', "movName, '#', thName, '#', thStreet, '#', thCity, '#', thState, '#', thZipcode, '#', 
comName, '#', movPlayDate, '#', movReleaseDate");

-- [step #24: screen 21]
CALL customer_view_history('georgep');
CALL magic44_check_step('24', 'CosViewHistory', "movName, '#', thName, '#', comName, '#', creditCardNum, '#', movPlayDate");

-- [step #25: screen 21]
CALL customer_view_history('calcultron');
CALL magic44_check_step('25', 'CosViewHistory', "movName, '#', thName, '#', comName, '#', creditCardNum, '#', movPlayDate");

-- [step #26: screen 22a]
CALL user_filter_th('ALL', '4400 Theater Company', '', 'CA');
CALL magic44_check_step('26', 'UserFilterTh', "thName, '#', thStreet, '#', thCity, '#', thState, '#', thZipcode, '#', comName");

-- [step #27: screen 22a]
CALL user_filter_th('ML Movies', 'EZ Theater Company', '', '');
CALL magic44_check_step('27', 'UserFilterTh', "thName, '#', thStreet, '#', thCity, '#', thState, '#', thZipcode, '#', comName");

-- [step #28: screen 1]
CALL user_login('calcwizard', 222222222);
CALL magic44_check_step('28', 'UserLogin', "username, '#', status, '#', isCustomer, '#', isAdmin, '#', isManager");

-- [step #29: screen 1]
CALL user_login('gdanger', 555555555);
CALL magic44_check_step('29', 'UserLogin', "username, '#', status, '#', isCustomer, '#', isAdmin, '#', isManager");

-- [step #30: screen 1]
CALL user_login('imbatman', 666666666);
CALL magic44_check_step('30', 'UserLogin', "username, '#', status, '#', isCustomer, '#', isAdmin, '#', isManager");

-- The next eighteen (18) steps of this script [step #31 through step #48] are
-- designed to test the modifications made by your insert, update and delete queries
-- to ensure that the database state is being updated properly.  We confirm/validate
-- that the state was updated correctly by referencing the earlier select queries. 
-- [step #31: screen 3] (insert, update and delete queries)
CALL user_register('flinstone4', 111111111, 'Fred', 'Flintstone');

-- [step #32: screen 4a]
CALL customer_only_register('rubble3', 222222222, 'Betty', 'Rubble');

-- [step #33: screen 5]
CALL manager_only_register('b_allen', 333333333, 'Barry', 'Allen', 'Awesome Theater Company', '4 Flash Lane', 'Star City', 'GA', 30311);

-- [step #34: screen 6a]
CALL manager_customer_register('wonderwoman', 555555555, 'Diana', 'Prince', 'AI Theater Company', '10 Lasso Lane', 'Elysian Fields', 'CA', 90654);

-- [step #35: screen 13c] (view impacts of user additions)
CALL admin_filter_user('', 'ALL', '', '');
CALL magic44_check_step('35', 'AdFilterUser', "username, '#', creditCardCount, '#', userType, '#', status");

-- [step #36: screen 13a]
CALL admin_approve_user('clarinetbeast');

-- [step #37: screen 13b]
CALL admin_decline_user('smith_j');

-- [step #38: screen 13c] (view impacts of status changes)
CALL admin_filter_user('', 'ALL', '', '');
CALL magic44_check_step('38', 'AdFilterUser', "username, '#', creditCardCount, '#', userType, '#', status");

-- [step #39: screen 15]
CALL admin_create_theater('Perimeter Cinema', '4400 Theater Company', '1 Roundabout Circle', 'Waco', 'TX', 90467, 2, 'manager1');

-- [step #40: screen 22a] (view impacts of newly added theater)
CALL user_filter_th('ALL', 'ALL', '', '');
CALL magic44_check_step('40', 'UserFilterTh', "thName, '#', thStreet, '#', thCity, '#', thState, '#', thZipcode, '#', comName");

-- [step #41: screen 17]
CALL admin_create_mov('Doctor Strange', 115, '2016-10-20');

-- [step #42: screen 18] (view impacts of newly added movie)
CALL manager_filter_th('imbatman', '', null, null, null, null, null, null, False);
CALL magic44_check_step('42', 'ManFilterTh', "movName, '#', movDuration, '#', movReleaseDate, '#', movPlayDate");

-- [step #43: screen 19]
CALL manager_schedule_mov('calcultron', 'Spaceballs', '1987-06-24', '2019-12-06');

-- [step #44: screen 18] (view impacts of newly scheduled movie)
CALL manager_filter_th('calcultron', '', null, null, null, null, null, null, False);
CALL magic44_check_step('44', 'ManFilterTh', "movName, '#', movDuration, '#', movReleaseDate, '#', movPlayDate");

-- [step #45: screen 20b]
CALL customer_view_mov('111111111', 'Spaceballs', '1987-06-24', 'ML Movies', 'AI Theater Company', '2023-01-23');

-- [step #46: screen 21] (view impacts of recently viewed movie)
CALL customer_view_history('georgep');
CALL magic44_check_step('46', 'CosViewHistory', "movName, '#', thName, '#', comName, '#', creditCardNum, '#', movPlayDate");

-- [step #47: screen 22b]
CALL user_visit_th('ABC Theater', 'Awesome Theater Company', '2019-12-24', 'ghcghc');

-- [step #48: screen 23] (view impacts of recently visited theater)
CALL user_filter_visitHistory('ghcghc', null, null);
CALL magic44_check_step('48', 'UserVisitHistory', "thName, '#', thStreet, '#', thCity, '#', thState, '#', thZipcode, '#', comName, '#', visitDate");

-- The final fifteen (15) steps of this script [step #49 through step #63] are
-- designed to test the handling of logical constraints.  This is done mainly by
-- attempting insert, update and delete queries that should not be permitted, and
-- then confirming/validating that the database state was not updated in an
-- incorrect manner by referencing the earlier select queries. 
-- [step #49: screen 4b] (logical constraint handling)
CALL customer_add_creditcard('georgep', '1234123412341234');

-- [step #50: screen 4b]
CALL customer_add_creditcard('calcultron', '987654321');

-- [step #51: screen 13b]
CALL admin_decline_user('entropyRox');

-- [step #52: screen 13c] (ensure improper credit cards and status changes are refused)
CALL admin_filter_user('', 'ALL', '', '');
CALL magic44_check_step('52', 'AdFilterUser', "username, '#', creditCardCount, '#', userType, '#', status");

-- [step #53: screen 15]
CALL admin_create_theater('Overload Cinema', '4400 Theater Company', '1 Main Street', 'Atlanta', 'GA', 30332, 8, 'manager2');

-- [step #54: screen 22a] (ensure improper theater is not created (manager must belong to appropriate company))
CALL user_filter_th('ALL', 'ALL', '', '');
CALL magic44_check_step('54', 'UserFilterTh', "thName, '#', thStreet, '#', thCity, '#', thState, '#', thZipcode, '#', comName");

-- [step #55: screen 19]
CALL manager_schedule_mov('imbatman', 'Spaceballs', '1987-06-24', '1987-06-23');

-- [step #56: screen 20a] (ensure movie was not scheduled before release date)
CALL customer_filter_mov('ALL', 'ALL', '', '', null, null);
CALL magic44_check_step('56', 'CosFilterMovie', "movName, '#', thName, '#', thStreet, '#', thCity, '#', thState, '#', thZipcode, '#', 
comName, '#', movPlayDate, '#', movReleaseDate");

-- [step #57: screen 19]
CALL manager_schedule_mov('imbatman', 'The First Pokemon Movie', '1988-07-19', '2010-04-02');

-- [step #58: screen 19]
CALL manager_schedule_mov('imbatman', 'Georgia Tech The Movie', '1985-08-13', '2010-04-02');

-- [step #59: screen 20b]
CALL customer_view_mov('1111111111111100', 'Spaceballs', '1987-06-24', 'ML Movies', 'AI Theater Company', '2010-04-02');

-- [step #60: screen 20b]
CALL customer_view_mov('1111111111111111', 'The First Pokemon Movie', '1988-07-19', 'ML Movies', 'AI Theater Company', '2010-04-02');

-- [step #61: screen 20b]
CALL customer_view_mov('1111111111111100', 'Georgia Tech The Movie', '1985-08-13', 'ML Movies', 'AI Theater Company', '2010-04-02');

-- [step #62: screen 20a] (ensure customer is not able to view more than three movies per day)
CALL customer_filter_mov('ALL', 'ALL', '', '', null, null);
CALL magic44_check_step('62', 'CosFilterMovie', "movName, '#', thName, '#', thStreet, '#', thCity, '#', thState, '#', thZipcode, '#', 
comName, '#', movPlayDate, '#', movReleaseDate");

-- [step #63: screen 21]
CALL customer_view_history('georgep');
CALL magic44_check_step('63', 'CosViewHistory', "movName, '#', thName, '#', comName, '#', creditCardNum, '#', movPlayDate");

-- The following commands clean up the environment and remove data structures that
-- are no longer needed.  We deliberately leave the intermediate tables that were
-- created during testing to support later analysis/troubleshooting as needed.
DROP PROCEDURE IF EXISTS magic44_check_step;
DROP TABLE IF EXISTS magic44_table1, magic44_table10, magic44_table11, magic44_table12, magic44_table13, magic44_table14;
DROP TABLE IF EXISTS magic44_table15, magic44_table16, magic44_table17, magic44_table18, magic44_table19;
DROP TABLE IF EXISTS magic44_table2, magic44_table20, magic44_table21, magic44_table22, magic44_table23, magic44_table24;
DROP TABLE IF EXISTS magic44_table25, magic44_table26, magic44_table27, magic44_table28, magic44_table29;
DROP TABLE IF EXISTS magic44_table3, magic44_table30, magic44_table35, magic44_table38;
DROP TABLE IF EXISTS magic44_table4, magic44_table40, magic44_table42, magic44_table44, magic44_table46, magic44_table48;
DROP TABLE IF EXISTS magic44_table5, magic44_table52, magic44_table54, magic44_table56;
DROP TABLE IF EXISTS magic44_table6, magic44_table62, magic44_table63; 
DROP TABLE IF EXISTS magic44_table7, magic44_table8, magic44_table9;
