-- ================================================
-- MYSQL SECURITY SETUP FOR SUSTAINABILITY SURVEY
-- ================================================
-- Run this script as MySQL root user

-- 1. Create dedicated application user
CREATE USER IF NOT EXISTS 'sustainapp'@'localhost' IDENTIFIED BY 't2WcjaIcCKguLORtrnhg';

-- 2. Grant only necessary permissions (not full admin access)
GRANT SELECT, INSERT, UPDATE, DELETE ON sustainability_survey.* TO 'sustainapp'@'localhost';
GRANT CREATE, DROP, ALTER ON sustainability_survey.* TO 'sustainapp'@'localhost';

-- 3. Apply changes
FLUSH PRIVILEGES;

-- 4. Show created user
SELECT User, Host FROM mysql.user WHERE User = 'sustainapp';

-- 5. Test permissions
SHOW GRANTS FOR 'sustainapp'@'localhost';
EOF < /dev/null
