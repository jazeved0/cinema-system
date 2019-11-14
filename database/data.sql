USE `Team20`;
SET FOREIGN_KEY_CHECKS = 0; 

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES 
    ('calcultron','Approved','77C9749B451AB8C713C48037DDFBB2C4','Dwight','Schrute'),
    ('calcultron2','Approved','8792B8CF71D27DC96173B2AC79B96E0D','Jim','Halpert'),
    ('calcwizard','Approved','0D777E9E30B918E9034AB610712C90CF','Issac','Newton'),
    ('clarinetbeast','Declined','C8C605999F3D8352D7BB792CF3FDB25B','Squidward','Tentacles'),
    ('cool_class4400','Approved','77C9749B451AB8C713C48037DDFBB2C4','A. TA','Washere'),
    ('DNAhelix','Approved','CA94EFE2A58C27168EDF3D35102DBB6D','Rosalind','Franklin'),
    ('does2Much','Approved','00CEDCF91BEFFA9EE69F6CFE23A4602D','Carl','Gauss'),
    ('eeqmcsquare','Approved','7C5858F7FCF63EC268F42565BE3ABB95','Albert','Einstein'),
    ('entropyRox','Approved','C8C605999F3D8352D7BB792CF3FDB25B','Claude','Shannon'),
    ('fatherAI','Approved','0D777E9E30B918E9034AB610712C90CF','Alan','Turing'),
    ('fullMetal','Approved','D009D70AE4164E8989725E828DB8C7C2','Edward','Elric'),
    ('gdanger','Declined','3665A76E271ADA5A75368B99F774E404','Gary','Danger'),
    ('georgep','Approved','BBB8AAE57C104CDA40C93843AD5E6DB8','George P.','Burdell'),
    ('ghcghc','Approved','9F0863DD5F0256B0F586A7B523F8CFE8','Grace','Hopper'),
    ('ilikemoney$$','Approved','7C5858F7FCF63EC268F42565BE3ABB95','Eugene','Krabs'),
    ('imbatman','Approved','9F0863DD5F0256B0F586A7B523F8CFE8','Bruce','Wayne'),
    ('imready','Approved','CA94EFE2A58C27168EDF3D35102DBB6D','Spongebob','Squarepants'),
    ('isthisthekrustykrab','Approved','134FB0BF3BDD54EE9098F4CBC4351B9A','Patrick','Star'),
    ('manager1','Approved','E58CCE4FAB03D2AEA056398750DEE16B','Manager','One'),
    ('manager2','Approved','BA9485F02FC98CDBD2EDADB0AA8F6390','Manager','Two'),
    ('manager3','Approved','6E4FB18B49AA3219BEF65195DAC7BE8C','Three','Three'),
    ('manager4','Approved','D61DFEE83AA2A6F9E32F268D60E789F5','Four','Four'),
    ('notFullMetal','Approved','D009D70AE4164E8989725E828DB8C7C2','Alphonse','Elric'),
    ('programerAAL','Approved','BA9485F02FC98CDBD2EDADB0AA8F6390','Ada','Lovelace'),
    ('radioactivePoRa','Approved','E5D4B739DB1226088177E6F8B70C3A6F','Marie','Curie'),
    ('RitzLover28','Approved','8792B8CF71D27DC96173B2AC79B96E0D','Abby','Normal'),
    ('smith_j','Pending','77C9749B451AB8C713C48037DDFBB2C4','John','Smith'),
    ('texasStarKarate','Declined','7C5858F7FCF63EC268F42565BE3ABB95','Sandy','Cheeks'),
    ('thePiGuy3.14','Approved','E11170B8CBD2D74102651CB967FA28E5','Archimedes','Syracuse'),
    ('theScienceGuy','Approved','C8C605999F3D8352D7BB792CF3FDB25B','Bill','Nye');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

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
INSERT INTO `company` VALUES 
    ('4400 Theater Company'),
    ('AI Theater Company'),
    ('Awesome Theater Company'),
    ('EZ Theater Company');
/*!40000 ALTER TABLE `company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `creditcard`
--

LOCK TABLES `creditcard` WRITE;
/*!40000 ALTER TABLE `creditcard` DISABLE KEYS */;
INSERT INTO `creditcard` VALUES
    ('1111111111000000','calcultron'),
    ('1111111100000000','calcultron2'),
    ('1111111110000000','calcultron2'),
    ('1111111111100000','calcwizard'),
    ('2222222222000000','cool_class4400'),
    ('2220000000000000','DNAhelix'),
    ('2222222200000000','does2Much'),
    ('2222222222222200','eeqmcsquare'),
    ('2222222222200000','entropyRox'),
    ('2222222222220000','entropyRox'),
    ('1100000000000000','fullMetal'),
    ('1111111111110000','georgep'),
    ('1111111111111000','georgep'),
    ('1111111111111100','georgep'),
    ('1111111111111110','georgep'),
    ('1111111111111111','georgep'),
    ('2222222222222220','ilikemoney$$'),
    ('2222222222222222','ilikemoney$$'),
    ('9000000000000000','ilikemoney$$'),
    ('1111110000000000','imready'),
    ('1110000000000000','isthisthekrustykrab'),
    ('1111000000000000','isthisthekrustykrab'),
    ('1111100000000000','isthisthekrustykrab'),
    ('1000000000000000','notFullMetal'),
    ('2222222000000000','programerAAL'),
    ('3333333333333300','RitzLover28'),
    ('2222222220000000','thePiGuy3.14'),
    ('2222222222222000','theScienceGuy');
/*!40000 ALTER TABLE `creditcard` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES
    ('calcultron'),
    ('calcultron2'),
    ('calcwizard'),
    ('clarinetbeast'),
    ('cool_class4400'),
    ('DNAhelix'),
    ('does2Much'),
    ('eeqmcsquare'),
    ('entropyRox'),
    ('fullMetal'),
    ('georgep'),
    ('ilikemoney$$'),
    ('imready'),
    ('isthisthekrustykrab'),
    ('notFullMetal'),
    ('programerAAL'),
    ('RitzLover28'),
    ('thePiGuy3.14'),
    ('theScienceGuy');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES
    ('calcultron'),
    ('cool_class4400'),
    ('entropyRox'),
    ('fatherAI'),
    ('georgep'),
    ('ghcghc'),
    ('imbatman'),
    ('manager1'),
    ('manager2'),
    ('manager3'),
    ('manager4'),
    ('radioactivePoRa');
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `manager`
--

LOCK TABLES `manager` WRITE;
/*!40000 ALTER TABLE `manager` DISABLE KEYS */;
INSERT INTO `manager` VALUES
    ('calcultron','GA','Atlanta','30308','123 Peachtree St','EZ Theater Company'),
    ('entropyRox','CA','San Francisco','94016','200 Cool Place','4400 Theater Company'),
    ('fatherAI','NY','New York','10001','456 Main St','EZ Theater Company'),
    ('georgep','WA','Seattle','98105','10 Pearl Dr','4400 Theater Company'),
    ('ghcghc','KS','Pallet Town','31415','100 Pi St','AI Theater Company'),
    ('imbatman','TX','Austin','78653','800 Color Dr','Awesome Theater Company'),
    ('manager1','GA','Atlanta','30332','123 Ferst Drive','4400 Theater Company'),
    ('manager2','GA','Atlanta','30332','456 Ferst Drive','AI Theater Company'),
    ('manager3','GA','Atlanta','30332','789 Ferst Drive','4400 Theater Company'),
    ('manager4','GA','Atlanta','30332','000 Ferst Drive','4400 Theater Company'),
    ('radioactivePoRa','CA','Sunnyvale','94088','100 Blu St','4400 Theater Company');
/*!40000 ALTER TABLE `manager` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `movie`
--

LOCK TABLES `movie` WRITE;
/*!40000 ALTER TABLE `movie` DISABLE KEYS */;
INSERT INTO `movie` VALUES
    ('4400 The Movie','2019-08-12',130),
    ('Avengers: Endgame','2019-04-26',181),
    ('Calculus Returns: A ML Story','2019-09-19',314),
    ('George P Burdell\'s Life Story','1927-08-12',100),
    ('Georgia Tech The Movie','1985-08-13',100),
    ('How to Train Your Dragon','2010-03-21',98),
    ('Spaceballs','1987-06-24',96),
    ('Spider-Man: Into the Spider-Verse','2018-12-01',117),
    ('The First Pokemon Movie','1998-07-19',75),
    ('The King\'s Speech','2010-11-26',119);
/*!40000 ALTER TABLE `movie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `movieplay`
--

LOCK TABLES `movieplay` WRITE;
/*!40000 ALTER TABLE `movieplay` DISABLE KEYS */;
INSERT INTO `movieplay` VALUES
    ('2019-08-12','4400 The Movie','2019-08-12','Star Movies','EZ Theater Company'),
    ('2019-09-12','4400 The Movie','2019-08-12','Cinema Star','4400 Theater Company'),
    ('2019-10-12','4400 The Movie','2019-08-12','ABC Theater','Awesome Theater Company'),
    ('2019-10-10','Calculus Returns: A ML Story','2019-09-19','ML Movies','AI Theater Company'),
    ('2019-12-30','Calculus Returns: A ML Story','2019-09-19','ML Movies','AI Theater Company'),
    ('2010-05-20','George P Burdell\'s Life Story','1927-08-12','Cinema Star','4400 Theater Company'),
    ('2019-07-14','George P Burdell\'s Life Story','1927-08-12','Main Movies','EZ Theater Company'),
    ('2019-10-22','George P Burdell\'s Life Story','1927-08-12','Main Movies','EZ Theater Company'),
    ('1985-08-13','Georgia Tech The Movie','1985-08-13','ABC Theater','Awesome Theater Company'),
    ('2019-09-30','Georgia Tech The Movie','1985-08-13','Cinema Star','4400 Theater Company'),
    ('2010-03-22','How to Train Your Dragon','2010-03-21','Main Movies','EZ Theater Company'),
    ('2010-03-23','How to Train Your Dragon','2010-03-21','Main Movies','EZ Theater Company'),
    ('2010-03-25','How to Train Your Dragon','2010-03-21','Star Movies','EZ Theater Company'),
    ('2010-04-02','How to Train Your Dragon','2010-03-21','Cinema Star','4400 Theater Company'),
    ('1999-06-24','Spaceballs','1987-06-24','Main Movies','EZ Theater Company'),
    ('2000-02-02','Spaceballs','1987-06-24','Cinema Star','4400 Theater Company'),
    ('2010-04-02','Spaceballs','1987-06-24','ML Movies','AI Theater Company'),
    ('2023-01-23','Spaceballs','1987-06-24','ML Movies','AI Theater Company'),
    ('2019-09-30','Spider-Man: Into the Spider-Verse','2018-12-01','ML Movies','AI Theater Company'),
    ('2018-07-19','The First Pokemon Movie','1998-07-19','ABC Theater','Awesome Theater Company'),
    ('2019-12-20','The King\'s Speech','2010-11-26','Cinema Star','4400 Theater Company'),
    ('2019-12-20','The King\'s Speech','2010-11-26','Main Movies','EZ Theater Company');
/*!40000 ALTER TABLE `movieplay` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `theater`
--

LOCK TABLES `theater` WRITE;
/*!40000 ALTER TABLE `theater` DISABLE KEYS */;
INSERT INTO `theater` VALUES
    ('ABC Theater','Awesome Theater Company','TX','Austin','73301',5,'imbatman','880 Color Dr'),
    ('Cinema Star','4400 Theater Company','CA','San Francisco','94016',4,'entropyRox','100 Cool Place'),
    ('Jonathan\'s Movies','4400 Theater Company','WA','Seattle','98101',2,'georgep','67 Pearl Dr'),
    ('Main Movies','EZ Theater Company','NY','New York','10001',3,'fatherAI','123 Main St'),
    ('ML Movies','AI Theater Company','KS','Pallet Town','31415',3,'ghcghc','314 Pi St'),
    ('Star Movies','4400 Theater Company','CA','Boulder','80301',5,'radioactivePoRa','4400 Rocks Ave'),
    ('Star Movies','EZ Theater Company','GA','Atlanta','30332',2,'calcultron','745 GT St');
/*!40000 ALTER TABLE `theater` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `used`
--

LOCK TABLES `used` WRITE;
/*!40000 ALTER TABLE `used` DISABLE KEYS */;
INSERT INTO `used` VALUES
    ('1111111111111111','2010-03-22','How to Train Your Dragon','2010-03-21','Main Movies','EZ Theater Company'),
    ('1111111111111111','2010-03-23','How to Train Your Dragon','2010-03-21','Main Movies','EZ Theater Company'),
    ('1111111111111100','2010-03-25','How to Train Your Dragon','2010-03-21','Star Movies','EZ Theater Company'),
    ('1111111111111111','2010-04-02','How to Train Your Dragon','2010-03-21','Cinema Star','4400 Theater Company');
/*!40000 ALTER TABLE `used` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `visit`
--

LOCK TABLES `visit` WRITE;
/*!40000 ALTER TABLE `visit` DISABLE KEYS */;
INSERT INTO `visit` VALUES
    (1,'2010-03-22','georgep','Main Movies','EZ Theater Company'),
    (2,'2010-03-22','calcwizard','Main Movies','EZ Theater Company'),
    (3,'2010-03-25','calcwizard','Star Movies','EZ Theater Company'),
    (4,'2010-03-25','imready','Star Movies','EZ Theater Company'),
    (5,'2010-03-20','calcwizard','ML Movies','AI Theater Company');
/*!40000 ALTER TABLE `visit` ENABLE KEYS */;
UNLOCK TABLES;

SET FOREIGN_KEY_CHECKS = 1;
