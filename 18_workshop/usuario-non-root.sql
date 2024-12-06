DROP DATABASE IF EXISTS donaton;
CREATE DATABASE IF NOT EXISTS donaton;

DROP USER IF EXISTS "non_root"@"%";
CREATE USER "non_root"@"%" IDENTIFIED BY "pass_123";
GRANT ALL PRIVILEGES ON donaton.* TO "non_root"@"%" WITH GRANT OPTION;
GRANT SUPER ON *.* TO "non_root"@"%" WITH GRANT OPTION;