--
-- Derived attributes for User such as CC Count & Type string
--

DROP VIEW IF EXISTS `UserDerived`;
CREATE VIEW `UserDerived` AS
    SELECT user.*,
        IFNULL(COUNT(creditcard.Owner), 0) AS CreditCardCount,
        CASE WHEN EXISTS (
                SELECT admin.Username FROM admin
                WHERE admin.Username = user.Username
            ) AND EXISTS (
                SELECT customer.Username FROM customer
                WHERE customer.Username = user.Username
            ) THEN 'CustomerAdmin'
        WHEN EXISTS (
                SELECT admin.Username FROM admin
                WHERE admin.Username = user.Username
            ) AND NOT EXISTS (
                SELECT customer.Username FROM customer
                WHERE customer.Username = user.Username
            ) THEN 'Admin'
        WHEN EXISTS (
                SELECT manager.Username FROM manager
                WHERE manager.Username = user.Username
            ) AND EXISTS (
                SELECT customer.Username FROM customer
                WHERE customer.Username = user.Username
            ) THEN 'CustomerManager'
        WHEN EXISTS (
                SELECT manager.Username FROM manager
                WHERE manager.Username = user.Username
            ) AND NOT EXISTS (
                SELECT customer.Username FROM customer
                WHERE customer.Username = user.Username
            ) THEN 'Manager'
        WHEN EXISTS (
                SELECT customer.Username FROM customer
                WHERE customer.Username = user.Username
            ) THEN 'Customer'
        ELSE 'User' END AS userType
    FROM user LEFT JOIN creditcard ON user.Username = creditcard.Owner
    GROUP BY user.Username;
