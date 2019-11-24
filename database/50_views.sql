--USE Team20;

--
-- Derived attributes for User such as CC Count & Type string
--

DROP VIEW IF EXISTS UserDerived;
CREATE VIEW UserDerived AS
    SELECT Username, Status, Password, Firstname, Lastname,
    -- CC Count
    COALESCE(COUNT(creditcard.Owner), 0) AS CreditCardCount,
    NOT admin IS NULL AS IsAdmin,
    NOT manager IS NULL AS IsManager,
    NOT customer IS NULL AS IsCustomer,
    -- User type assignment
    CASE
        WHEN NOT admin     IS NULL AND NOT customer IS NULL THEN 'CustomerAdmin'
        WHEN NOT admin     IS NULL AND     customer IS NULL THEN 'Admin'
        WHEN NOT manager   IS NULL AND NOT customer IS NULL THEN 'CustomerManager'
        WHEN NOT manager   IS NULL AND     customer IS NULL THEN 'Manager'
        WHEN NOT customer  IS NULL                          THEN 'Customer'
        ELSE                                                     'User'
    END AS UserType
    -- Temporary tagged table
    FROM (
        SELECT *
        FROM "User"
        LEFT JOIN (SELECT admin.Username    as admin    FROM admin)    AS t1 ON Username = admin
        LEFT JOIN (SELECT customer.Username as customer FROM customer) AS t2 ON Username = customer
        LEFT JOIN (SELECT manager.Username  as manager  FROM manager)  AS t3 ON Username = manager
    ) as t2
    LEFT JOIN creditcard ON Username = Owner
    GROUP BY t2.Username, t2.Status, t2.Password, t2.Firstname, t2.Lastname, t2.admin, t2.customer, t2.manager;

--
-- Derived attributes for Comapany such as cities covered, number of theaters, and number of employees
--

DROP VIEW IF EXISTS CompanyDerived;
CREATE VIEW CompanyDerived AS
    SELECT Name, (
        -- Select number of distinct city, state pairs
        SELECT COUNT(*) FROM (
            SELECT *
            FROM theater
            WHERE CompanyName = Name
            GROUP BY State, City, theater.theatername, theater.companyname
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
