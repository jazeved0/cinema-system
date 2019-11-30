CREATE DATABASE IF NOT EXISTS `Team20`;
USE `Team20`;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `Company`;
CREATE TABLE `Company` (`Name` varchar(240), PRIMARY KEY (`Name`));

DROP TABLE IF EXISTS `Movie`;
CREATE TABLE `Movie` (
  `Name` varchar(240) NOT NULL,
  `ReleaseDate` date NOT NULL,
  `Duration` int unsigned NOT NULL,
  PRIMARY KEY (`Name`, `ReleaseDate`)
);

DROP TABLE IF EXISTS `User`;
CREATE TABLE `User` (
  `Username` varchar(240) NOT NULL,
  `Status` char(8) NOT NULL CHECK (
    `Status` IN ('Pending', 'Declined', 'Approved')
  ) DEFAULT 'Pending',
  -- 32-character hex string hash
  `Password` char(32) NOT NULL,
  `Firstname` varchar(240) NOT NULL,
  `Lastname` varchar(240) NOT NULL,
  PRIMARY KEY (`Username`)
);

DROP TABLE IF EXISTS `Employee`;
CREATE TABLE `Employee` (
  `Username` varchar(240) NOT NULL,
  PRIMARY KEY (`Username`),
  CONSTRAINT FOREIGN KEY (`Username`)
    REFERENCES `User` (`Username`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `Customer`;
CREATE TABLE `Customer` (
  `Username` varchar(240) NOT NULL,
  PRIMARY KEY (`Username`),
  CONSTRAINT FOREIGN KEY (`Username`)
    REFERENCES `User` (`Username`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `Admin`;
CREATE TABLE `Admin` (
  `Username` varchar(240) NOT NULL,
  PRIMARY KEY (`Username`),
  CONSTRAINT FOREIGN KEY (`Username`)
    REFERENCES `Employee` (`Username`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `Manager`;
CREATE TABLE `Manager` (
  `Username` varchar(240) NOT NULL,
  `State` char(2) NOT NULL,
  `City` varchar(240) NOT NULL,
  `Zipcode` char(5) NOT NULL,
  `Street` varchar(240) NOT NULl,
  `CompanyName` varchar(240),
  PRIMARY KEY (`Username`),
  CONSTRAINT UNIQUE (`State`, `City`, `Zipcode`, `Street`),
  CONSTRAINT FOREIGN KEY (`Username`)
    REFERENCES `Employee` (`Username`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT FOREIGN KEY (`CompanyName`)
    REFERENCES `Company` (`Name`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `CreditCard`;
CREATE TABLE `CreditCard` (
  `CreditCardNum` char(16) NOT NULL,
  `Owner` varchar(240) NOT NULL,
  PRIMARY KEY (`CreditCardNum`),
  CONSTRAINT FOREIGN KEY (`Owner`)
    REFERENCES `Customer` (`Username`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `Theater`;
CREATE TABLE `Theater` (
  `TheaterName` varchar(240) NOT NULL,
  /* partial key */
  `CompanyName` varchar(240) NOT NULL,
  /* partial key */
  `State` char(2) NOT NULL,
  `City` varchar(240) NOT NULL,
  `Zipcode` char(5) NOT NULL,
  `Capacity` int unsigned NOT NULL,
  `Manager` varchar(240),
  `Street` varchar(240) NOT NULL,
  /* full participation */
  PRIMARY KEY (`TheaterName`, `CompanyName`),
  CONSTRAINT FOREIGN KEY (`CompanyName`)
    REFERENCES `Company` (`Name`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT FOREIGN KEY (`Manager`)
    REFERENCES `Manager` (`Username`)
    ON DELETE SET NULL
    ON UPDATE CASCADE

);

DROP TABLE IF EXISTS `MoviePlay`;
CREATE TABLE `MoviePlay` (
  `Date` date NOT NULL,
  `MovieName` varchar(240) NOT NULL,
  `ReleaseDate` date NOT NULL,
  `TheaterName` varchar(240) NOT NULL,
  `CompanyName` varchar(240) NOT NULL,
  PRIMARY KEY (
    `Date`,
    `MovieName`,
    `ReleaseDate`,
    `TheaterName`,
    `CompanyName`
  ),
  CONSTRAINT FOREIGN KEY (`MovieName`, `ReleaseDate`)
    REFERENCES `Movie` (`Name`, `ReleaseDate`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT FOREIGN KEY (`TheaterName`, `CompanyName`)
    REFERENCES `Theater` (`TheaterName`, `CompanyName`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `Visit`;
CREATE TABLE `Visit` (
  `ID` int AUTO_INCREMENT NOT NULL,
  `Date` date NOT NULL,
  `Username` varchar(240) NOT NULL,
  `TheaterName` varchar(240) NOT NULL,
  `CompanyName` varchar(240) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT FOREIGN KEY (`Username`)
    REFERENCES `User`(`Username`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT FOREIGN KEY (`TheaterName`, `CompanyName`)
    REFERENCES `Theater`(`TheaterName`, `CompanyName`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `Used`;
CREATE TABLE `Used` (
  `CreditCardNum` char(16) NOT NULL,
  `PlayDate` date NOT NULL,
  `MovieName` varchar(240) NOT NULL,
  `ReleaseDate` date NOT NULL,
  `TheaterName` varchar(240) NOT NULL,
  `CompanyName` varchar(240) NOT NULL,
  PRIMARY KEY (
    `CreditCardNum`,
    `PlayDate`,
    `MovieName`,
    `ReleaseDate`,
    `TheaterName`,
    `CompanyName`
  ),
  CONSTRAINT FOREIGN KEY (`CreditCardNum`)
    REFERENCES `CreditCard` (`CreditCardNum`)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
  CONSTRAINT FOREIGN KEY (
    `PlayDate`,
    `MovieName`,
    `ReleaseDate`,
    `TheaterName`,
    `CompanyName`
  )
    REFERENCES `MoviePlay` (
      `Date`,
      `MovieName`,
      `ReleaseDate`,
      `TheaterName`,
      `CompanyName`
    )
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
INSERT INTO `user` VALUES
    ('calcultron',          'Approved', '77C9749B451AB8C713C48037DDFBB2C4', 'Dwight',     'Schrute'),
    ('calcultron2',         'Approved', '8792B8CF71D27DC96173B2AC79B96E0D', 'Jim',        'Halpert'),
    ('calcwizard',          'Approved', '0D777E9E30B918E9034AB610712C90CF', 'Issac',      'Newton'),
    ('clarinetbeast',       'Declined', 'C8C605999F3D8352D7BB792CF3FDB25B', 'Squidward',  'Tentacles'),
    ('cool_class4400',      'Approved', '77C9749B451AB8C713C48037DDFBB2C4', 'A. TA',      'Washere'),
    ('DNAhelix',            'Approved', 'CA94EFE2A58C27168EDF3D35102DBB6D', 'Rosalind',   'Franklin'),
    ('does2Much',           'Approved', '00CEDCF91BEFFA9EE69F6CFE23A4602D', 'Carl',       'Gauss'),
    ('eeqmcsquare',         'Approved', '7C5858F7FCF63EC268F42565BE3ABB95', 'Albert',     'Einstein'),
    ('entropyRox',          'Approved', 'C8C605999F3D8352D7BB792CF3FDB25B', 'Claude',     'Shannon'),
    ('fatherAI',            'Approved', '0D777E9E30B918E9034AB610712C90CF', 'Alan',       'Turing'),
    ('fullMetal',           'Approved', 'D009D70AE4164E8989725E828DB8C7C2', 'Edward',     'Elric'),
    ('gdanger',             'Declined', '3665A76E271ADA5A75368B99F774E404', 'Gary',       'Danger'),
    ('georgep',             'Approved', 'BBB8AAE57C104CDA40C93843AD5E6DB8', 'George P.',  'Burdell'),
    ('ghcghc',              'Approved', '9F0863DD5F0256B0F586A7B523F8CFE8', 'Grace',      'Hopper'),
    ('ilikemoney$$',        'Approved', '7C5858F7FCF63EC268F42565BE3ABB95', 'Eugene',     'Krabs'),
    ('imbatman',            'Approved', '9F0863DD5F0256B0F586A7B523F8CFE8', 'Bruce',      'Wayne'),
    ('imready',             'Approved', 'CA94EFE2A58C27168EDF3D35102DBB6D', 'Spongebob',  'Squarepants'),
    ('isthisthekrustykrab', 'Approved', '134FB0BF3BDD54EE9098F4CBC4351B9A', 'Patrick',    'Star'),
    ('manager1',            'Approved', 'E58CCE4FAB03D2AEA056398750DEE16B', 'Manager',    'One'),
    ('manager2',            'Approved', 'BA9485F02FC98CDBD2EDADB0AA8F6390', 'Manager',    'Two'),
    ('manager3',            'Approved', '6E4FB18B49AA3219BEF65195DAC7BE8C', 'Three',      'Three'),
    ('manager4',            'Approved', 'D61DFEE83AA2A6F9E32F268D60E789F5', 'Four',       'Four'),
    ('notFullMetal',        'Approved', 'D009D70AE4164E8989725E828DB8C7C2', 'Alphonse',   'Elric'),
    ('programerAAL',        'Approved', 'BA9485F02FC98CDBD2EDADB0AA8F6390', 'Ada',        'Lovelace'),
    ('radioactivePoRa',     'Approved', 'E5D4B739DB1226088177E6F8B70C3A6F', 'Marie',      'Curie'),
    ('RitzLover28',         'Approved', '8792B8CF71D27DC96173B2AC79B96E0D', 'Abby',       'Normal'),
    ('smith_j',             'Pending',  '77C9749B451AB8C713C48037DDFBB2C4', 'John',       'Smith'),
    ('texasStarKarate',     'Declined', '7C5858F7FCF63EC268F42565BE3ABB95', 'Sandy',      'Cheeks'),
    ('thePiGuy3.14',        'Approved', 'E11170B8CBD2D74102651CB967FA28E5', 'Archimedes', 'Syracuse'),
    ('theScienceGuy',       'Approved', 'C8C605999F3D8352D7BB792CF3FDB25B', 'Bill',       'Nye');
UNLOCK TABLES;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
INSERT INTO `admin` VALUES ('cool_class4400');
UNLOCK TABLES;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
INSERT INTO `company` VALUES
    ('4400 Theater Company'),
    ('AI Theater Company'),
    ('Awesome Theater Company'),
    ('EZ Theater Company');
UNLOCK TABLES;

--
-- Dumping data for table `creditcard`
--

LOCK TABLES `creditcard` WRITE;
INSERT INTO `creditcard` VALUES
    ('1111111111000000', 'calcultron'),
    ('1111111100000000', 'calcultron2'),
    ('1111111110000000', 'calcultron2'),
    ('1111111111100000', 'calcwizard'),
    ('2222222222000000', 'cool_class4400'),
    ('2220000000000000', 'DNAhelix'),
    ('2222222200000000', 'does2Much'),
    ('2222222222222200', 'eeqmcsquare'),
    ('2222222222200000', 'entropyRox'),
    ('2222222222220000', 'entropyRox'),
    ('1100000000000000', 'fullMetal'),
    ('1111111111110000', 'georgep'),
    ('1111111111111000', 'georgep'),
    ('1111111111111100', 'georgep'),
    ('1111111111111110', 'georgep'),
    ('1111111111111111', 'georgep'),
    ('2222222222222220', 'ilikemoney$$'),
    ('2222222222222222', 'ilikemoney$$'),
    ('9000000000000000', 'ilikemoney$$'),
    ('1111110000000000', 'imready'),
    ('1110000000000000', 'isthisthekrustykrab'),
    ('1111000000000000', 'isthisthekrustykrab'),
    ('1111100000000000', 'isthisthekrustykrab'),
    ('1000000000000000', 'notFullMetal'),
    ('2222222000000000', 'programerAAL'),
    ('3333333333333300', 'RitzLover28'),
    ('2222222220000000', 'thePiGuy3.14'),
    ('2222222222222000', 'theScienceGuy');
UNLOCK TABLES;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
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
UNLOCK TABLES;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
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
UNLOCK TABLES;

--
-- Dumping data for table `manager`
--

LOCK TABLES `manager` WRITE;
INSERT INTO `manager` VALUES
    ('calcultron',      'GA','Atlanta',       '30308', '123 Peachtree St', 'EZ Theater Company'),
    ('entropyRox',      'CA','San Francisco', '94016', '200 Cool Place',   '4400 Theater Company'),
    ('fatherAI',        'NY','New York',      '10001', '456 Main St',      'EZ Theater Company'),
    ('georgep',         'WA','Seattle',       '98105', '10 Pearl Dr',      '4400 Theater Company'),
    ('ghcghc',          'KS','Pallet Town',   '31415', '100 Pi St',        'AI Theater Company'),
    ('imbatman',        'TX','Austin',        '78653', '800 Color Dr',     'Awesome Theater Company'),
    ('manager1',        'GA','Atlanta',       '30332', '123 Ferst Drive',  '4400 Theater Company'),
    ('manager2',        'GA','Atlanta',       '30332', '456 Ferst Drive',  'AI Theater Company'),
    ('manager3',        'GA','Atlanta',       '30332', '789 Ferst Drive',  '4400 Theater Company'),
    ('manager4',        'GA','Atlanta',       '30332', '000 Ferst Drive',  '4400 Theater Company'),
    ('radioactivePoRa', 'CA','Sunnyvale',     '94088', '100 Blu St',       '4400 Theater Company');
UNLOCK TABLES;

--
-- Dumping data for table `movie`
--

LOCK TABLES `movie` WRITE;
INSERT INTO `movie` VALUES
    ('4400 The Movie',                    '2019-08-12', 130),
    ('Avengers: Endgame',                 '2019-04-26', 181),
    ('Calculus Returns: A ML Story',      '2019-09-19', 314),
    ('George P Burdell\'s Life Story',    '1927-08-12', 100),
    ('Georgia Tech The Movie',            '1985-08-13', 100),
    ('How to Train Your Dragon',          '2010-03-21', 98),
    ('Spaceballs',                        '1987-06-24', 96),
    ('Spider-Man: Into the Spider-Verse', '2018-12-01', 117),
    ('The First Pokemon Movie',           '1998-07-19', 75),
    ('The King\'s Speech',                '2010-11-26', 119);
UNLOCK TABLES;

--
-- Dumping data for table `movieplay`
--

LOCK TABLES `movieplay` WRITE;
INSERT INTO `movieplay` VALUES
    ('2019-08-12', '4400 The Movie',                    '2019-08-12', 'Star Movies', 'EZ Theater Company'),
    ('2019-09-12', '4400 The Movie',                    '2019-08-12', 'Cinema Star', '4400 Theater Company'),
    ('2019-10-12', '4400 The Movie',                    '2019-08-12', 'ABC Theater', 'Awesome Theater Company'),
    ('2019-10-10', 'Calculus Returns: A ML Story',      '2019-09-19', 'ML Movies',   'AI Theater Company'),
    ('2019-12-30', 'Calculus Returns: A ML Story',      '2019-09-19', 'ML Movies',   'AI Theater Company'),
    ('2010-05-20', 'George P Burdell\'s Life Story',    '1927-08-12', 'Cinema Star', '4400 Theater Company'),
    ('2019-07-14', 'George P Burdell\'s Life Story',    '1927-08-12', 'Main Movies', 'EZ Theater Company'),
    ('2019-10-22', 'George P Burdell\'s Life Story',    '1927-08-12', 'Main Movies', 'EZ Theater Company'),
    ('1985-08-13', 'Georgia Tech The Movie',            '1985-08-13', 'ABC Theater', 'Awesome Theater Company'),
    ('2019-09-30', 'Georgia Tech The Movie',            '1985-08-13', 'Cinema Star', '4400 Theater Company'),
    ('2010-03-22', 'How to Train Your Dragon',          '2010-03-21', 'Main Movies', 'EZ Theater Company'),
    ('2010-03-23', 'How to Train Your Dragon',          '2010-03-21', 'Main Movies', 'EZ Theater Company'),
    ('2010-03-25', 'How to Train Your Dragon',          '2010-03-21', 'Star Movies', 'EZ Theater Company'),
    ('2010-04-02', 'How to Train Your Dragon',          '2010-03-21', 'Cinema Star', '4400 Theater Company'),
    ('1999-06-24', 'Spaceballs',                        '1987-06-24', 'Main Movies', 'EZ Theater Company'),
    ('2000-02-02', 'Spaceballs',                        '1987-06-24', 'Cinema Star', '4400 Theater Company'),
    ('2010-04-02', 'Spaceballs',                        '1987-06-24', 'ML Movies',   'AI Theater Company'),
    ('2023-01-23', 'Spaceballs',                        '1987-06-24', 'ML Movies',   'AI Theater Company'),
    ('2019-09-30', 'Spider-Man: Into the Spider-Verse', '2018-12-01', 'ML Movies',   'AI Theater Company'),
    ('2018-07-19', 'The First Pokemon Movie',           '1998-07-19', 'ABC Theater', 'Awesome Theater Company'),
    ('2019-12-20', 'The King\'s Speech',                '2010-11-26', 'Cinema Star', '4400 Theater Company'),
    ('2019-12-20', 'The King\'s Speech',                '2010-11-26', 'Main Movies', 'EZ Theater Company');
UNLOCK TABLES;

--
-- Dumping data for table `theater`
--

LOCK TABLES `theater` WRITE;
INSERT INTO `theater` VALUES
    ('ABC Theater',        'Awesome Theater Company', 'TX', 'Austin',        '73301', 5, 'imbatman',        '880 Color Dr'),
    ('Cinema Star',        '4400 Theater Company',    'CA', 'San Francisco', '94016', 4, 'entropyRox',      '100 Cool Place'),
    ('Jonathan\'s Movies', '4400 Theater Company',    'WA', 'Seattle',       '98101', 2, 'georgep',         '67 Pearl Dr'),
    ('Main Movies',        'EZ Theater Company',      'NY', 'New York',      '10001', 3, 'fatherAI',        '123 Main St'),
    ('ML Movies',          'AI Theater Company',      'KS', 'Pallet Town',   '31415', 3, 'ghcghc',          '314 Pi St'),
    ('Star Movies',        '4400 Theater Company',    'CA', 'Boulder',       '80301', 5, 'radioactivePoRa', '4400 Rocks Ave'),
    ('Star Movies',        'EZ Theater Company',      'GA', 'Atlanta',       '30332', 2, 'calcultron',      '745 GT St');
UNLOCK TABLES;

--
-- Dumping data for table `used`
--

LOCK TABLES `used` WRITE;
INSERT INTO `used` VALUES
    ('1111111111111111', '2010-03-22', 'How to Train Your Dragon', '2010-03-21', 'Main Movies', 'EZ Theater Company'),
    ('1111111111111111', '2010-03-23', 'How to Train Your Dragon', '2010-03-21', 'Main Movies', 'EZ Theater Company'),
    ('1111111111111100', '2010-03-25', 'How to Train Your Dragon', '2010-03-21', 'Star Movies', 'EZ Theater Company'),
    ('1111111111111111', '2010-04-02', 'How to Train Your Dragon', '2010-03-21', 'Cinema Star', '4400 Theater Company');
UNLOCK TABLES;

--
-- Dumping data for table `visit`
--

LOCK TABLES `visit` WRITE;
INSERT INTO `visit` VALUES
    (1, '2010-03-22', 'georgep',    'Main Movies', 'EZ Theater Company'),
    (2, '2010-03-22', 'calcwizard', 'Main Movies', 'EZ Theater Company'),
    (3, '2010-03-25', 'calcwizard', 'Star Movies', 'EZ Theater Company'),
    (4, '2010-03-25', 'imready',    'Star Movies', 'EZ Theater Company'),
    (5, '2010-03-20', 'calcwizard', 'ML Movies',   'AI Theater Company');
UNLOCK TABLES;

SET FOREIGN_KEY_CHECKS = 1;

--
-- Derived attributes for User such as CC Count & Type string
--

DROP VIEW IF EXISTS `UserDerived`;
CREATE VIEW `UserDerived` AS
    SELECT Username, Status, Password, Firstname, Lastname,
    -- CC Count
    IFNULL(COUNT(creditcard.Owner), 0) AS CreditCardCount,
    -- User type assignment
    CASE
        WHEN NOT admin     IS NULL AND NOT customer IS NULL THEN 'CustomerAdmin'
        WHEN NOT admin     IS NULL AND     customer IS NULL THEN 'Admin'
        WHEN NOT manager   IS NULL AND NOT customer IS NULL THEN 'CustomerManager'
        WHEN NOT manager   IS NULL AND     customer IS NULL THEN 'Manager'
        WHEN NOT customer  IS NULL                          THEN 'Customer'
        ELSE                                                     'User'
    -- Temporary tagged table
    END AS UserType FROM (
        SELECT *
        FROM user
        LEFT JOIN (SELECT admin.Username    as admin    FROM admin)    AS t1 ON Username = admin
        LEFT JOIN (SELECT customer.Username as customer FROM customer) AS t2 ON Username = customer
        LEFT JOIN (SELECT manager.Username  as manager  FROM manager)  AS t3 ON Username = manager
    ) as t2
    LEFT JOIN creditcard ON Username = Owner
    GROUP BY t2.Username;

--
-- Derived attributes for Comapany such as cities covered, number of theaters, and number of employees
--

DROP VIEW IF EXISTS `CompanyDerived`;
CREATE VIEW `CompanyDerived` AS
    SELECT Name, (
        -- Select number of distinct city, state pairs
        SELECT COUNT(*) FROM (
            SELECT *
            FROM theater
            WHERE CompanyName = Name
            GROUP BY State, City
        ) AS T1
    ) AS NumCityCover, (
        -- Select number of theaters
        SELECT COUNT(*)
        FROM theater
        WHERE CompanyName = Name
    ) AS NumTheater, (
        -- Select number of employees (managers)
        SELECT COUNT(*)
        FROM manager
        WHERE CompanyName = Name
    ) AS NumEmployee
    FROM company;

