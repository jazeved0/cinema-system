--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES ('cool_class4400');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
INSERT INTO `company` VALUES ('4400 Theater Company'),('AI Theater Company'),('Awesome Theater Company'),('EZ Theater Company');
/*!40000 ALTER TABLE `company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `creditcard`
--

LOCK TABLES `creditcard` WRITE;
/*!40000 ALTER TABLE `creditcard` DISABLE KEYS */;
INSERT INTO `creditcard` VALUES ('1111111111000000','calcultron'),('1111111100000000','calcultron2'),('1111111110000000','calcultron2'),('1111111111100000','calcwizard'),('2222222222000000','cool_class4400'),('2220000000000000','DNAhelix'),('2222222200000000','does2Much'),('2222222222222200','eeqmcsquare'),('2222222222200000','entropyRox'),('2222222222220000','entropyRox'),('1100000000000000','fullMetal'),('1111111111110000','georgep'),('1111111111111000','georgep'),('1111111111111100','georgep'),('1111111111111110','georgep'),('1111111111111111','georgep'),('2222222222222220','ilikemoney$$'),('2222222222222222','ilikemoney$$'),('9000000000000000','ilikemoney$$'),('1111110000000000','imready'),('1110000000000000','isthisthekrustykrab'),('1111000000000000','isthisthekrustykrab'),('1111100000000000','isthisthekrustykrab'),('1000000000000000','notFullMetal'),('2222222000000000','programerAAL'),('3333333333333300','RitzLover28'),('2222222220000000','thePiGuy3.14'),('2222222222222000','theScienceGuy');
/*!40000 ALTER TABLE `creditcard` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES ('calcultron'),('calcultron2'),('calcwizard'),('clarinetbeast'),('cool_class4400'),('DNAhelix'),('does2Much'),('eeqmcsquare'),('entropyRox'),('fullMetal'),('georgep'),('ilikemoney$$'),('imready'),('isthisthekrustykrab'),('notFullMetal'),('programerAAL'),('RitzLover28'),('thePiGuy3.14'),('theScienceGuy');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES ('calcultron'),('cool_class4400'),('entropyRox'),('fatherAI'),('georgep'),('ghcghc'),('imbatman'),('manager1'),('manager2'),('manager3'),('manager4'),('radioactivePoRa');
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `manager`
--

LOCK TABLES `manager` WRITE;
/*!40000 ALTER TABLE `manager` DISABLE KEYS */;
INSERT INTO `manager` VALUES ('calcultron','GA','Atlanta','30308','123 Peachtree St','EZ Theater Company'),('entropyRox','CA','San Francisco','94016','200 Cool Place','4400 Theater Company'),('fatherAI','NY','New York','10001','456 Main St','EZ Theater Company'),('georgep','WA','Seattle','98105','10 Pearl Dr','4400 Theater Company'),('ghcghc','KS','Pallet Town','31415','100 Pi St','AI Theater Company'),('imbatman','TX','Austin','78653','800 Color Dr','Awesome Theater Company'),('manager1','GA','Atlanta','30332','123 Ferst Drive','4400 Theater Company'),('manager2','GA','Atlanta','30332','456 Ferst Drive','AI Theater Company'),('manager3','GA','Atlanta','30332','789 Ferst Drive','4400 Theater Company'),('manager4','GA','Atlanta','30332','000 Ferst Drive','4400 Theater Company'),('radioactivePoRa','CA','Sunnyvale','94088','100 Blu St','4400 Theater Company');
/*!40000 ALTER TABLE `manager` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `movie`
--

LOCK TABLES `movie` WRITE;
/*!40000 ALTER TABLE `movie` DISABLE KEYS */;
INSERT INTO `movie` VALUES ('4400 The Movie','2019-08-12',130),('Avengers: Endgame','2019-04-26',181),('Calculus Returns: A ML Story','2019-09-19',314),('George P Burdell\'s Life Story','1927-08-12',100),('Georgia Tech The Movie','1985-08-13',100),('How to Train Your Dragon','2010-03-21',98),('Spaceballs','1987-06-24',96),('Spider-Man: Into the Spider-Verse','2018-12-01',117),('The First Pokemon Movie','1998-07-19',75),('The King\'s Speech','2010-11-26',119);
/*!40000 ALTER TABLE `movie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `movieplay`
--

LOCK TABLES `movieplay` WRITE;
/*!40000 ALTER TABLE `movieplay` DISABLE KEYS */;
INSERT INTO `movieplay` VALUES ('2019-08-12','4400 The Movie','2019-08-12','Star Movies','EZ Theater Company'),('2019-09-12','4400 The Movie','2019-08-12','Cinema Star','4400 Theater Company'),('2019-10-12','4400 The Movie','2019-08-12','ABC Theater','Awesome Theater Company'),('2019-10-10','Calculus Returns: A ML Story','2019-09-19','ML Movies','AI Theater Company'),('2019-12-30','Calculus Returns: A ML Story','2019-09-19','ML Movies','AI Theater Company'),('2010-05-20','George P Burdell\'s Life Story','1927-08-12','Cinema Star','4400 Theater Company'),('2019-07-14','George P Burdell\'s Life Story','1927-08-12','Main Movies','EZ Theater Company'),('2019-10-22','George P Burdell\'s Life Story','1927-08-12','Main Movies','EZ Theater Company'),('1985-08-13','Georgia Tech The Movie','1985-08-13','ABC Theater','Awesome Theater Company'),('2019-09-30','Georgia Tech The Movie','1985-08-13','Cinema Star','4400 Theater Company'),('2010-03-22','How to Train Your Dragon','2010-03-21','Main Movies','EZ Theater Company'),('2010-03-23','How to Train Your Dragon','2010-03-21','Main Movies','EZ Theater Company'),('2010-03-25','How to Train Your Dragon','2010-03-21','Star Movies','EZ Theater Company'),('2010-04-02','How to Train Your Dragon','2010-03-21','Cinema Star','4400 Theater Company'),('1999-06-24','Spaceballs','1987-06-24','Main Movies','EZ Theater Company'),('2000-02-02','Spaceballs','1987-06-24','Cinema Star','4400 Theater Company'),('2010-04-02','Spaceballs','1987-06-24','ML Movies','AI Theater Company'),('2023-01-23','Spaceballs','1987-06-24','ML Movies','AI Theater Company'),('2019-09-30','Spider-Man: Into the Spider-Verse','2018-12-01','ML Movies','AI Theater Company'),('2018-07-19','The First Pokemon Movie','1998-07-19','ABC Theater','Awesome Theater Company'),('2019-12-20','The King\'s Speech','2010-11-26','Cinema Star','4400 Theater Company'),('2019-12-20','The King\'s Speech','2010-11-26','Main Movies','EZ Theater Company');
/*!40000 ALTER TABLE `movieplay` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `theater`
--

LOCK TABLES `theater` WRITE;
/*!40000 ALTER TABLE `theater` DISABLE KEYS */;
INSERT INTO `theater` VALUES ('ABC Theater','Awesome Theater Company','TX','Austin','73301',5,'imbatman','880 Color Dr'),('Cinema Star','4400 Theater Company','CA','San Francisco','94016',4,'entropyRox','100 Cool Place'),('Jonathan\'s Movies','4400 Theater Company','WA','Seattle','98101',2,'georgep','67 Pearl Dr'),('Main Movies','EZ Theater Company','NY','New York','10001',3,'fatherAI','123 Main St'),('ML Movies','AI Theater Company','KS','Pallet Town','31415',3,'ghcghc','314 Pi St'),('Star Movies','4400 Theater Company','CA','Boulder','80301',5,'radioactivePoRa','4400 Rocks Ave'),('Star Movies','EZ Theater Company','GA','Atlanta','30332',2,'calcultron','745 GT St');
/*!40000 ALTER TABLE `theater` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `used`
--

LOCK TABLES `used` WRITE;
/*!40000 ALTER TABLE `used` DISABLE KEYS */;
INSERT INTO `used` VALUES ('1111111111111111','2010-03-22','How to Train Your Dragon','2010-03-21','Main Movies','EZ Theater Company'),('1111111111111111','2010-03-23','How to Train Your Dragon','2010-03-21','Main Movies','EZ Theater Company'),('1111111111111100','2010-03-25','How to Train Your Dragon','2010-03-21','Star Movies','EZ Theater Company'),('1111111111111111','2010-04-02','How to Train Your Dragon','2010-03-21','Cinema Star','4400 Theater Company');
/*!40000 ALTER TABLE `used` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('calcultron','Approved','333333333','Dwight','Schrute'),('calcultron2','Approved','444444444','Jim','Halpert'),('calcwizard','Approved','222222222','Issac','Newton'),('clarinetbeast','Declined','999999999','Squidward','Tentacles'),('cool_class4400','Approved','333333333','A. TA','Washere'),('DNAhelix','Approved','777777777','Rosalind','Franklin'),('does2Much','Approved','1212121212','Carl','Gauss'),('eeqmcsquare','Approved','111111110','Albert','Einstein'),('entropyRox','Approved','999999999','Claude','Shannon'),('fatherAI','Approved','222222222','Alan','Turing'),('fullMetal','Approved','111111100','Edward','Elric'),('gdanger','Declined','555555555','Gary','Danger'),('georgep','Approved','111111111','George P.','Burdell'),('ghcghc','Approved','666666666','Grace','Hopper'),('ilikemoney$$','Approved','111111110','Eugene','Krabs'),('imbatman','Approved','666666666','Bruce','Wayne'),('imready','Approved','777777777','Spongebob','Squarepants'),('isthisthekrustykrab','Approved','888888888','Patrick','Star'),('manager1','Approved','1122112211','Manager','One'),('manager2','Approved','3131313131','Manager','Two'),('manager3','Approved','8787878787','Three','Three'),('manager4','Approved','5755555555','Four','Four'),('notFullMetal','Approved','111111100','Alphonse','Elric'),('programerAAL','Approved','3131313131','Ada','Lovelace'),('radioactivePoRa','Approved','1313131313','Marie','Curie'),('RitzLover28','Approved','444444444','Abby','Normal'),('smith_j','Pending','333333333','John','Smith'),('texasStarKarate','Declined','111111110','Sandy','Cheeks'),('thePiGuy3.14','Approved','1111111111','Archimedes','Syracuse'),('theScienceGuy','Approved','999999999','Bill','Nye');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `visit`
--

LOCK TABLES `visit` WRITE;
/*!40000 ALTER TABLE `visit` DISABLE KEYS */;
INSERT INTO `visit` VALUES (1,'2010-03-22','georgep','Main Movies','EZ Theater Company'),(2,'2010-03-22','calcwizard','Main Movies','EZ Theater Company'),(3,'2010-03-25','calcwizard','Star Movies','EZ Theater Company'),(4,'2010-03-25','imready','Star Movies','EZ Theater Company'),(5,'2010-03-20','calcwizard','ML Movies','AI Theater Company');
/*!40000 ALTER TABLE `visit` ENABLE KEYS */;
UNLOCK TABLES;
