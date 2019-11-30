USE `Team20`;

--
-- Screen 1: User login
--

DROP procedure IF EXISTS `user_login`;
DELIMITER $$
CREATE PROCEDURE `user_login`(
    IN `i_username` varchar(240),
    IN `i_password` varchar(240)
)
BEGIN
    DROP TABLE IF EXISTS UserLogin;
    CREATE TABLE UserLogin
        SELECT user.Username, Status, Password, case WHEN EXISTS (
            SELECT customer.Username FROM customer
            WHERE customer.Username = user.Username
        ) THEN 1 ELSE 0 END AS isCustomer, case WHEN EXISTS (
            SELECT admin.Username FROM admin
            WHERE admin.Username = user.Username
        ) THEN 1 ELSE 0 END AS isAdmin, case WHEN EXISTS (
            SELECT manager.Username FROM manager
            WHERE manager.Username = user.Username
        ) THEN 1 ELSE 0 END AS isManager from user
        WHERE Username = i_username AND Password = MD5(i_password);
END$$
DELIMITER ;

--
-- [PROVIDED] Screen 3: User register
--

DROP PROCEDURE IF EXISTS `user_register`;
DELIMITER $$
CREATE PROCEDURE `user_register` (
    IN i_username varchar(240),
    IN i_password varchar(240),
    IN i_firstname varchar(240),
    IN i_lastname varchar(240)
)
BEGIN
    INSERT INTO user (username, password, firstname, lastname)
    VALUES (i_username, MD5(i_password), i_firstname, i_lastname);
END$$
DELIMITER ;

--
-- Screen 4: Customer-only register
--

DROP PROCEDURE IF EXISTS `customer_only_register`;
DELIMITER $$
CREATE PROCEDURE `customer_only_register` (
    IN i_username varchar(240),
    IN i_password varchar(240),
    IN i_firstname varchar(240),
    IN i_lastname varchar(240)
)
BEGIN
    INSERT INTO user (username, password, firstname, lastname)
    VALUES (i_username, MD5(i_password), i_firstname, i_lastname);
    INSERT INTO customer (username)
    VALUES (i_username);
END$$
DELIMITER ;

--
-- Screen 4: Customer add credit card
--

DROP PROCEDURE IF EXISTS `customer_add_creditcard`;
DELIMITER $$
CREATE PROCEDURE `customer_add_creditcard` (
    IN i_username varchar(240),
    IN i_creditCardNum char(16)
)
BEGIN
    IF EXISTS (
        SELECT Username from UserDerived
        WHERE Username = i_username AND CreditCardCount >= 5
    ) THEN SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot add another credit card';
    ELSEIF CHAR_LENGTH(i_creditCardNum) != 16 THEN SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Credit card must be 16 characters long';
    ELSE
      INSERT INTO creditcard (owner, creditcardnum)
      VALUES (i_username, i_creditCardNum);
    END IF;
END$$
DELIMITER ;

--
-- Screen 5: Manager-only register
--

DROP PROCEDURE IF EXISTS `manager_only_register`;
DELIMITER $$
CREATE PROCEDURE `manager_only_register` (
    IN i_username varchar(240),
    IN i_password varchar(240),
    IN i_firstname varchar(240),
    IN i_lastname varchar(240),
    IN i_comName varchar(240),
    IN i_empStreet varchar(240),
    IN i_empCity varchar(240),
    IN i_empState char(2),
    IN i_empZipcode char(5)
)
BEGIN
    INSERT INTO user (username, password, firstname, lastname)
    VALUES (i_username, MD5(i_password), i_firstname, i_lastname);
    INSERT INTO employee (username)
    VALUES (i_username);
    INSERT INTO manager (username, state, city, zipcode, street, companyname)
    VALUES (i_username, i_empState, i_empCity, i_empZipcode, i_empStreet, i_comName);
END$$
DELIMITER ;

--
-- Screen 6: Manager-Customer register
--

DROP PROCEDURE IF EXISTS `manager_customer_register`;
DELIMITER $$
CREATE PROCEDURE `manager_customer_register` (
    IN i_username varchar(240),
    IN i_password varchar(240),
    IN i_firstname varchar(240),
    IN i_lastname varchar(240),
    IN i_comName varchar(240),
    IN i_empStreet varchar(240),
    IN i_empCity varchar(240),
    IN i_empState char(2),
    IN i_empZipcode char(5)
)
BEGIN
    INSERT INTO user (username, password, firstname, lastname)
    VALUES (i_username, MD5(i_password), i_firstname, i_lastname);
    INSERT INTO employee (username)
    VALUES (i_username);
    INSERT INTO manager (username, state, city, zipcode, street, companyname)
    VALUES (i_username, i_empState, i_empCity, i_empZipcode, i_empStreet, i_comName);
    INSERT INTO customer (username)
    VALUES (i_username);
END$$
DELIMITER ;

--
-- Screen 6: Manager-Customer add credit card
--

DROP PROCEDURE IF EXISTS `manager_customer_add_creditcard`;
DELIMITER $$
CREATE PROCEDURE `manager_customer_add_creditcard` (
    IN i_username varchar(240),
    IN i_creditCardNum char(16)
)
BEGIN
    INSERT INTO creditcard (owner, creditcardnum)
    VALUES (i_username, i_creditCardNum);
END$$
DELIMITER ;

--
-- Screen 13: Admin approve user
--

DROP PROCEDURE IF EXISTS `admin_approve_user`;
DELIMITER $$
CREATE PROCEDURE `admin_approve_user` (
    IN i_username varchar(240)
)
BEGIN
    IF NOT EXISTS (
        SELECT Username from user WHERE Username = i_username
    ) THEN SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User does not exist';
    ELSEIF EXISTS (
        SELECT Status from user
        WHERE Username = i_username and Status = "Approved"
    ) THEN SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Can not approve already approved user';
    ELSE
        UPDATE user
        SET Status = "Approved"
        WHERE Username = i_username;
    END IF;
END$$
DELIMITER ;

--
-- Screen 13: Admin decline user
--

DROP PROCEDURE IF EXISTS `admin_decline_user`;
DELIMITER $$
CREATE PROCEDURE `admin_decline_user` (
    IN i_username varchar(240)
)
BEGIN
    IF NOT EXISTS (
        SELECT Username from user WHERE Username = i_username
    ) THEN SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User does not exist';
    ELSEIF EXISTS (
        SELECT Status from user
        WHERE Username = i_username and Status = "Approved"
    ) THEN SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Can not decline already approved user';
    ELSEIF EXISTS (
        SELECT Status from user
        WHERE Username = i_username and Status = "Declined"
    ) THEN SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Can not decline already declined user';
    ELSE
        UPDATE user
        SET Status = "Declined"
        WHERE Username = i_username;
    END IF;
END$$
DELIMITER ;

--
-- Screen 13: Admin filter user
--

DROP PROCEDURE IF EXISTS `admin_filter_user`;
DELIMITER $$
CREATE PROCEDURE `admin_filter_user` (
    IN i_username varchar(240),
    IN i_status char(8),
    IN i_sortBy varchar(15),
    IN i_sortDirection char(4)

)
BEGIN
    -- i_status has implicit 'ALL' possibility
    IF NOT (
        i_status = 'Pending'
        OR i_status = 'Approved'
        OR i_status = 'Declined'
        OR i_status = 'ALL'
    ) THEN SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid status filter provided';
    -- i_sortDirection has default value 'DESC' if '' supplied
    ELSEIF NOT (
        i_sortDirection = 'ASC'
        OR i_sortDirection = 'DESC'
        OR i_sortDirection = ''
    ) THEN SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid sort direction provided';
    -- i_sortBy has default value 'username' if '' supplied
    ELSEIF NOT (
        i_sortBy = 'username'
        OR i_sortBy = 'creditCardCount'
        OR i_sortBy = 'userType'
        OR i_sortBy = 'status'
        OR i_sortBy = ''
    ) THEN SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid sort by column provided';
    ELSE
        BEGIN
            -- Resolve defaults
            SET @sort_column    = CASE WHEN i_sortBy        = '' THEN 'username' ELSE i_sortBy        END;
            SET @sort_direction = CASE WHEN i_sortDirection = '' THEN 'DESC'     ELSE i_sortDirection END;
            -- Create temporary table to store filtered values
            DROP TABLE IF EXISTS UserFilterTemp;
            CREATE TABLE UserFilterTemp
                SELECT username, creditCardCount, userType, status FROM UserDerived
                -- Perform filter on username parameter
                WHERE (UPPER(Username) <=> UPPER(i_username)) or i_username = ""
                -- Perform status filter (if applicable)
                AND CASE WHEN i_status <> 'ALL' THEN status = i_status ELSE TRUE END;
            DROP TABLE IF EXISTS AdFilterUser;
            -- Build dynamic sort query
            SET @query = CONCAT(
                "CREATE TABLE AdFilterUser "
                "SELECT * FROM UserFilterTemp ORDER BY UserFilterTemp.",
                @sort_column,
                " ",
                @sort_direction
            );
            PREPARE stmt FROM @query;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
        END;
    END IF;
END$$
DELIMITER ;

--
-- Screen 14: Admin filter company
--

DROP PROCEDURE IF EXISTS `admin_filter_company`;
DELIMITER $$
CREATE PROCEDURE `admin_filter_company` (
    IN i_comName varchar(240),
    IN i_minCity int unsigned,
    IN i_maxCity int unsigned,
    IN i_minTheater int unsigned,
    IN i_maxTheater int unsigned,
    IN i_minEmployee int unsigned,
    IN i_maxEmployee int unsigned,
    IN i_sortBy varchar(12),
    IN i_sortDirection char(4)
)
BEGIN
    -- i_sortDirection has default value 'DESC' if '' supplied
    IF NOT (
        i_sortDirection = 'ASC'
        OR i_sortDirection = 'DESC'
        OR i_sortDirection = ''
    ) THEN SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid sort direction provided';
    -- i_sortBy has default value 'comName' if '' supplied
    ELSEIF NOT (
        i_sortBy = 'comName'
        OR i_sortBy = 'numCityCover'
        OR i_sortBy = 'numTheater'
        OR i_sortBy = 'numEmployee'
        OR i_sortBy = ''
    ) THEN SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid sort by column provided';
    ELSE
        BEGIN
            -- Resolve defaults
            SET @sort_column    = CASE WHEN i_sortBy        = '' THEN 'comName' ELSE i_sortBy        END;
            SET @sort_direction = CASE WHEN i_sortDirection = '' THEN 'DESC'    ELSE i_sortDirection END;
            -- Create temporary table to store filtered values
            DROP TABLE IF EXISTS CompanyFilterTemp;
            CREATE TABLE CompanyFilterTemp
                SELECT Name AS comName, numCityCover, numTheater, numEmployee FROM CompanyDerived
                -- Perform filter on company name parameter
                WHERE (i_comName <=> '' OR UPPER(Name) <=> UPPER(i_comName) OR i_comName = 'ALL')
                -- Perform min/max city filter
                AND (i_minCity     IS NULL OR numCityCover >= i_minCity)
                AND (i_maxCity     IS NULL OR numCityCover <= i_maxCity)
                -- Perform min/max employee filter
                AND (i_minTheater  IS NULL OR numTheater   >= i_minTheater)
                AND (i_maxTheater  IS NULL OR numTheater   <= i_maxTheater)
                -- Perform min/max theater filter
                AND (i_minEmployee IS NULL OR numEmployee  >= i_minEmployee)
                AND (i_maxEmployee IS NULL OR numEmployee  <= i_maxEmployee);
            DROP TABLE IF EXISTS AdFilterCom;
            -- Build dynamic sort query
            SET @query = CONCAT(
                "CREATE TABLE AdFilterCom ",
                "SELECT * FROM CompanyFilterTemp ORDER BY CompanyFilterTemp.",
                @sort_column,
                " ",
                @sort_direction
            );
            PREPARE stmt FROM @query;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
        END;
    END IF;
END$$
DELIMITER ;

--
-- Screen 15: Admin create theater
--

DROP PROCEDURE IF EXISTS `admin_create_theater`;
DELIMITER $$
CREATE PROCEDURE `admin_create_theater` (
    IN i_thName varchar(240),
    IN i_comName varchar(240),
    IN i_thStreet varchar(240),
    IN i_thCity varchar(240),
    IN i_thState char(2),
    IN i_thZipcode char(5),
    IN i_capacity int unsigned,
    IN i_managerUsername varchar(240)
)
BEGIN
    IF NOT EXISTS (
        SELECT Name from company
        INNER JOIN manager ON manager.CompanyName = company.Name
        WHERE manager.CompanyName = i_comName
        AND manager.Username = i_managerUsername
    ) THEN SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Manager must work for company';
    ELSE
      INSERT INTO theater (
          TheaterName, CompanyName, State,
          City, Zipcode, Street, Capacity, Manager
      ) VALUES (
          i_thName, i_comName, i_thState, i_thCity,
          i_thZipcode, i_thStreet, i_capacity,
          i_managerUsername
      );
    END IF;
END$$
DELIMITER ;

--
-- Screen 16: Admin view company detail (Employee)
--

DROP PROCEDURE IF EXISTS `admin_view_comDetail_emp`;
DELIMITER $$
CREATE PROCEDURE `admin_view_comDetail_emp` (
    IN i_comName varchar(240)
)
BEGIN
    DROP TABLE IF EXISTS AdComDetailEmp;
    CREATE TABLE AdComDetailEmp
        SELECT user.Firstname as empFirstname, user.Lastname as empLastname FROM manager
        INNER JOIN user ON manager.Username = user.Username
        WHERE CompanyName <=> i_comName;
END$$
DELIMITER ;

--
-- Screen 16: Admin view company detail (Theater)
--

DROP PROCEDURE IF EXISTS `admin_view_comDetail_th`;
DELIMITER $$
CREATE PROCEDURE `admin_view_comDetail_th` (
    IN i_comName varchar(240)
)
BEGIN
    DROP TABLE IF EXISTS AdComDetailTh;
    CREATE TABLE AdComDetailTh
        SELECT TheaterName as thName,
            Manager as thManagerUsername,
            City as thCity,
            State as thState,
            Capacity as thCapacity
        FROM theater
        WHERE CompanyName <=> i_comName;
END$$
DELIMITER ;

--
-- Screen 17: Admin create movie
--

DROP PROCEDURE IF EXISTS `admin_create_mov`;
DELIMITER $$
CREATE PROCEDURE `admin_create_mov` (
    IN i_movName varchar(240),
    IN i_movDuration int unsigned,
    IN i_movReleaseDate date
)
BEGIN
    INSERT INTO movie (Name, ReleaseDate, Duration)
    VALUES (i_movName, i_movReleaseDate, i_movDuration);
END$$
DELIMITER ;

--
-- Screen 18: Manager filter theater
--

DROP PROCEDURE IF EXISTS `manager_filter_th`;
DELIMITER $$
CREATE PROCEDURE `manager_filter_th` (
    IN i_manUsername varchar(240),
    IN i_movName varchar(240),
    IN i_minMovDuration int unsigned,
    IN i_maxMovDuration int unsigned,
    IN i_minMovReleaseDate date,
    IN i_maxMovReleaseDate date,
    IN i_minMovPlayDate date,
    IN i_maxMovPlayDate date,
    IN i_includeNotPlayed boolean
)
BEGIN
    DROP TABLE IF EXISTS ManFilterTh;
    CREATE TABLE ManFilterTh
        SELECT movie.Name AS movName, movie.Duration as movDuration,
            movie.ReleaseDate AS movReleaseDate, t1.Date as movPlayDate
        FROM (
          SELECT movieplay.*
          FROM movieplay
          LEFT JOIN theater ON movieplay.TheaterName = theater.TheaterName AND movieplay.CompanyName = theater.CompanyName
          WHERE i_manUsername = theater.Manager
        ) AS t1
        RIGHT JOIN movie ON t1.MovieName = movie.Name
        -- Perform movie name filter
        WHERE ((movie.Name LIKE CONCAT("%", i_movName, "%")) OR i_movName = '')
        -- Perform movie duration filter
        AND (i_minMovDuration     IS NULL OR movie.Duration    >= i_minMovDuration)
        AND (i_maxMovDuration     IS NULL OR movie.Duration    <= i_maxMovDuration)
        -- Perform movie release date filter
        AND (i_minMovReleaseDate  IS NULL OR movie.ReleaseDate >= i_minMovReleaseDate)
        AND (i_maxMovReleaseDate  IS NULL OR movie.ReleaseDate <= i_maxMovReleaseDate)
        -- Perform movie play date filter
        AND (i_minMovPlayDate     IS NULL OR t1.Date           >= i_minMovPlayDate)
        AND (i_maxMovPlayDate     IS NULL OR t1.Date           <= i_maxMovPlayDate)
        -- Perform include not played
        AND (i_includeNotPlayed is NOT TRUE OR (i_includeNotPlayed is TRUE AND t1.Date is NULL));
END$$
DELIMITER ;

--
-- Screen 19: Manager schedule movie
--

DROP PROCEDURE IF EXISTS `manager_schedule_mov`;
DELIMITER $$
CREATE PROCEDURE `manager_schedule_mov` (
    IN i_manUsername varchar(240),
    IN i_movName varchar(240),
    IN i_movReleaseDate date,
    IN i_movPlayDate date
)
BEGIN
    -- Find theater/company of manager
    SET @theater_name = (SELECT TheaterName FROM Theater WHERE Manager = i_manUsername);
    SET @company_name = (SELECT CompanyName FROM Theater WHERE Manager = i_manUsername);
    -- Add new MoviePlay row
    INSERT INTO movieplay (Date, MovieName, ReleaseDate, TheaterName, CompanyName)
    VALUES (i_movPlayDate, i_movName, i_movReleaseDate, @theater_name, @company_name );
END$$
DELIMITER ;

--
-- Screen 20: Customer filter movie
--

DROP PROCEDURE IF EXISTS `customer_filter_mov`;
DELIMITER $$
CREATE PROCEDURE `customer_filter_mov` (
    IN i_movName varchar(240),
    IN i_comName varchar(240),
    IN i_city varchar(240),
    IN i_state varchar(3),
    IN i_minMovPlayDate date,
    IN i_maxMovPlayDate date
)
BEGIN
    DROP TABLE IF EXISTS CosFilterMovie;
    CREATE TABLE CosFilterMovie
        SELECT movieplay.MovieName AS movName,
            movieplay.TheaterName as thName,
            Street AS thStreet,
            City AS thCity,
            State AS thState,
            Zipcode AS thZipcode,
            movieplay.CompanyName AS comName,
            movieplay.Date AS movPlayDate,
            movieplay.ReleaseDate AS movReleaseDate
        FROM movieplay
        LEFT OUTER JOIN theater ON movieplay.TheaterName = theater.TheaterName
            AND movieplay.CompanyName = theater.CompanyName
        -- Perform simple filters
        WHERE (i_movName = '' OR movieplay.MovieName   <=> i_movName OR i_movName = 'ALL')
        AND (i_comName   = '' OR movieplay.CompanyName <=> i_comName OR i_comName = 'ALL')
        AND (i_city      = '' OR City                  <=> i_city OR i_city = 'ALL')
        -- State can be '' or 'ALL' to indicate no filter
        AND (i_state = '' OR i_state = 'ALL' OR State <=> i_state)
        -- Perform min/max movie play date filters
        AND (i_minMovPlayDate IS NULL OR movieplay.Date >= i_minMovPlayDate)
        AND (i_maxMovPlayDate IS NULL OR movieplay.Date <= i_maxMovPlayDate);
END$$
DELIMITER ;

--
-- Screen 20: Customer view movie
--

DROP PROCEDURE IF EXISTS `customer_view_mov`;
DELIMITER $$
CREATE PROCEDURE `customer_view_mov` (
    IN i_creditCardNum char(16),
    IN i_movName varchar(240),
    IN i_movReleaseDate date,
    IN i_thName varchar(240),
    IN i_comName varchar(240),
    IN i_movPlayDate date
)
BEGIN
    INSERT INTO used (
        CreditCardNum, PlayDate, MovieName,
        ReleaseDate, TheaterName, CompanyName
    ) VALUES (
        i_creditCardNum, i_movPlayDate, i_movName,
        i_movReleaseDate, i_thName, i_comName
    );
END$$
DELIMITER ;

--
-- Screen 21: Customer view history
--

DROP PROCEDURE IF EXISTS `customer_view_history`;
DELIMITER $$
CREATE PROCEDURE `customer_view_history` (
    IN i_cusUsername varchar(240)
)
BEGIN
    DROP TABLE IF EXISTS CosViewHistory;
    CREATE TABLE CosViewHistory
        SELECT MovieName AS movName,
            TheaterName AS thName,
            CompanyName AS comName,
            creditCardNum,
            PlayDate AS movPlayDate
        FROM used NATURAL JOIN CreditCard
        WHERE Owner = i_cusUsername;
END$$
DELIMITER ;

--
-- [PROVIDED] Screen 22: User filter theater
--

DROP PROCEDURE IF EXISTS `user_filter_th`;
DELIMITER $$
CREATE PROCEDURE `user_filter_th` (
    IN i_thName VARCHAR(240),
    IN i_comName VARCHAR(240),
    IN i_city VARCHAR(240),
    IN i_state CHAR(3)
)
BEGIN
    DROP TABLE IF EXISTS UserFilterTh;
    CREATE TABLE UserFilterTh
        SELECT TheaterName as thName, Street as thStreet, City as thCity, State as thState, Zipcode as thZipcode, CompanyName as comName
        FROM Theater
        WHERE
            (TheaterName = i_thName OR i_thName = "ALL") AND
            (CompanyName = i_comName OR i_comName = "ALL") AND
            (City = i_city OR i_city = "") AND
            (State = i_state OR i_state = "ALL");
END$$
DELIMITER ;

--
-- [PROVIDED] Screen 22: User visit theater
--

DROP PROCEDURE IF EXISTS `user_visit_th`;
DELIMITER $$
CREATE PROCEDURE `user_visit_th` (
    IN i_thName VARCHAR(240),
    IN i_comName VARCHAR(240),
    IN i_visitDate DATE,
    IN i_username VARCHAR(240)
)
BEGIN
    INSERT INTO visit (TheaterName, CompanyName, Date, Username)
    VALUES (i_thName, i_comName, i_visitDate, i_username);
END$$
DELIMITER ;

--
-- [PROVIDED] Screen 23: User filter visit history
--

DROP PROCEDURE IF EXISTS `user_filter_visitHistory`;
DELIMITER $$
CREATE PROCEDURE `user_filter_visitHistory` (
    IN i_username VARCHAR(240),
    IN i_minVisitDate DATE,
    IN i_maxVisitDate DATE
)
BEGIN
    DROP TABLE IF EXISTS UserVisitHistory;
    CREATE TABLE UserVisitHistory
        SELECT TheaterName as thName, Street as thStreet, City as thCity, State as thState, Zipcode as thZipcode, CompanyName as comName, Date as visitDate
        FROM visit NATURAL JOIN Theater
        WHERE
            (username = i_username) AND
            (i_minVisitDate IS NULL OR Date >= i_minVisitDate) AND
            (i_maxVisitDate IS NULL OR Date <= i_maxVisitDate);
END$$
DELIMITER ;
