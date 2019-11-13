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
    SELECT user.Username, Status, Password, case WHEN EXISTS (
        SELECT employee.Username FROM employee
        WHERE employee.Username = user.Username
    ) THEN 1 ELSE 0 END AS isEmployee, case WHEN EXISTS (
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
    INSERT INTO creditcard (owner, creditcardnum)
    VALUES (i_username, i_creditCardNum);
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
    CASE
        WHEN NOT EXISTS (
            SELECT Username from user WHERE Username = i_username
        ) THEN SELECT 'User does not exist' as '';
        WHEN EXISTS (
            SELECT Status from user
            WHERE Username = i_username and Status = "Approved"
        ) THEN SELECT 'Can not approve already approved user' as '';
        ELSE UPDATE user
        SET Status = "Approved"
        WHERE Username = i_username;
    END CASE;
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
    CASE
        WHEN NOT EXISTS (
            SELECT Username from user WHERE Username = i_username
        ) THEN SELECT 'User does not exist' as '';
        WHEN EXISTS (
            SELECT Status from user
            WHERE Username = i_username and Status = "Approved"
        ) THEN SELECT 'Can not decline already approved user' as '';
        WHEN EXISTS (
            SELECT Status from user
            WHERE Username = i_username and Status = "Declined"
        ) THEN SELECT 'Can not decline already declined user' as '';
        ELSE UPDATE user
        SET Status = "Declined"
        WHERE Username = i_username;
    END CASE;
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
    IN i_sortDirection char(4),
    IN i_sortBy varchar(15)
)
BEGIN
    CASE
        -- i_status has implicit 'ALL' possibility
        WHEN NOT (
            i_status = 'Pending'
            OR i_status = 'Approved'
            OR i_status = 'Declined'
            OR i_status = 'ALL'
        ) THEN SELECT 'Invalid status filter provided' as '';
        -- i_sortDirection has default value 'DESC' if '' supplied
        WHEN NOT (
            i_sortDirection = 'ASC'
            OR i_sortDirection = 'DESC'
            OR i_sortDirection = ''
        ) THEN SELECT 'Invalid sort direction provided' as '';
        -- i_sortBy has default value 'username' if '' supplied
        WHEN NOT (
            i_sortBy = 'username'
            OR i_sortBy = 'creditCardCount'
            OR i_sortBy = 'userType'
            OR i_sortBy = 'status'
            OR i_sortBy = ''
        ) THEN SELECT 'Invalid sort by column provided' as '';
        ELSE
            BEGIN
                -- Create temporary table to store calculated column data for each user
                DROP TABLE IF EXISTS UserFilterTemp;
                CREATE TABLE UserFilterTemp
                    SELECT username, status, creditCardCount, userType FROM UserDerived
                    -- Perform fuzzy filter on username parameter
                    HAVING UPPER(Username) LIKE CONCAT('%', UPPER(i_username), '%')
                    -- Perform status filter (if applicable)
                    AND CASE WHEN i_status <> 'ALL' THEN Status = i_status ELSE TRUE END;
                -- Resolve defaults
                SET @sort_column = CASE WHEN i_sortBy = '' THEN 'username' ELSE i_sortBy END;
                SET @sort_direction = CASE WHEN i_sortDirection = '' THEN 'DESC' ELSE i_sortDirection END;
                -- Build dynamic sort query
                SET @query = CONCAT(
                    "SELECT * FROM UserFilterTemp ORDER BY UserFilterTemp.",
                    @sort_column,
                    " ", 
                    @sort_direction
                );
                PREPARE stmt3 FROM @query;
                EXECUTE stmt3;
                DEALLOCATE PREPARE stmt3;
            END;
    END CASE;
END$$
DELIMITER ;

--
-- Screen 14: Admin filter company
--

DROP PROCEDURE IF EXISTS `admin_filter_company`;
DELIMITER $$
CREATE PROCEDURE `admin_filter_company` ()
BEGIN
    -- TODO Implement
    SELECT * FROM user;
END$$
DELIMITER ;

--
-- Screen 15: Admin create theater
--

DROP PROCEDURE IF EXISTS `admin_create_theater`;
DELIMITER $$
CREATE PROCEDURE `admin_create_theater` ()
BEGIN
    -- TODO Implement
    SELECT * FROM user;
END$$
DELIMITER ;

--
-- Screen 16: Admin view company detail (Employee)
--

DROP PROCEDURE IF EXISTS `admin_view_comDetail_emp`;
DELIMITER $$
CREATE PROCEDURE `admin_view_comDetail_emp` ()
BEGIN
    -- TODO Implement
    SELECT * FROM user;
END$$
DELIMITER ;

--
-- Screen 16: Admin view company detail (Theater)
--

DROP PROCEDURE IF EXISTS `admin_view_comDetail_th`;
DELIMITER $$
CREATE PROCEDURE `admin_view_comDetail_th` ()
BEGIN
    -- TODO Implement
    SELECT * FROM user;
END$$
DELIMITER ;

--
-- Screen 17: Admin create movie
--

DROP PROCEDURE IF EXISTS `admin_create_mov`;
DELIMITER $$
CREATE PROCEDURE `admin_create_mov` ()
BEGIN
    -- TODO Implement
    SELECT * FROM user;
END$$
DELIMITER ;

--
-- Screen 18: Manager filter theater
--

DROP PROCEDURE IF EXISTS `manager_filter_th`;
DELIMITER $$
CREATE PROCEDURE `manager_filter_th` ()
BEGIN
    -- TODO Implement
    SELECT * FROM user;
END$$
DELIMITER ;

--
-- Screen 19: Manager schedule movie
--

DROP PROCEDURE IF EXISTS `manager_schedule_mov`;
DELIMITER $$
CREATE PROCEDURE `manager_schedule_mov` ()
BEGIN
    -- TODO Implement
    SELECT * FROM user;
END$$
DELIMITER ;

--
-- Screen 20: Customer filter movie
--

DROP PROCEDURE IF EXISTS `customer_filter_mov`;
DELIMITER $$
CREATE PROCEDURE `customer_filter_mov` ()
BEGIN
    -- TODO Implement
    SELECT * FROM user;
END$$
DELIMITER ;

--
-- Screen 20: Customer view movie
--

DROP PROCEDURE IF EXISTS `customer_view_mov`;
DELIMITER $$
CREATE PROCEDURE `customer_view_mov` ()
BEGIN
    -- TODO Implement
    SELECT * FROM user;
END$$
DELIMITER ;

--
-- Screen 21: Customer view history
--

DROP PROCEDURE IF EXISTS `customer_view_history`;
DELIMITER $$
CREATE PROCEDURE `customer_view_history` ()
BEGIN
    -- TODO Implement
    SELECT * FROM user;
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
    IN i_state CHAR(2)
)
BEGIN
    DROP TABLE IF EXISTS UserFilterTh;
    CREATE TABLE UserFilterTh
    SELECT thName, thStreet, thCity, thState, thZipcode, comName 
    FROM Theater
    WHERE 
        (thName = i_thName OR i_thName = "ALL") AND
        (comName = i_comName OR i_comName = "ALL") AND
        (thCity = i_city OR i_city = "") AND
        (thState = i_state OR i_state = "ALL");
END$$
DELIMITER ;

--
-- [PROVIDED] Screen 22: User visit theater
--

DROP PROCEDURE IF EXISTS `user_visit_th`;
DELIMITER $$
CREATE PROCEDURE `user_visit_th` (
    IN i_thName VARCHAR(50),
    IN i_comName VARCHAR(50),
    IN i_visitDate DATE,
    IN i_username VARCHAR(50)
)
BEGIN
    INSERT INTO UserVisitTheater (thName, comName, visitDate, username)
    VALUES (i_thName, i_comName, i_visitDate, i_username);
END$$
DELIMITER ;

--
-- [PROVIDED] Screen 23: User filter visit history
--

DROP PROCEDURE IF EXISTS `user_filter_visitHistory`;
DELIMITER $$
CREATE PROCEDURE `user_filter_visitHistory` (
    IN i_username VARCHAR(50), 
    IN i_minVisitDate DATE,
    IN i_maxVisitDate DATE
)
BEGIN
    DROP TABLE IF EXISTS UserVisitHistory;
    CREATE TABLE UserVisitHistory
    SELECT thName, thStreet, thCity, thState, thZipcode, comName, visitDate
    FROM UserVisitTheater
        NATURAL JOIN
        Theater
    WHERE
        (username = i_username) AND
        (i_minVisitDate IS NULL OR visitDate >= i_minVisitDate) AND
        (i_maxVisitDate IS NULL OR visitDate <= i_maxVisitDate);
END$$
DELIMITER ;
