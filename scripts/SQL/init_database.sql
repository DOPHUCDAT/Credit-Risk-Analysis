
USE master;
GO

-- Drop and recreate the 'Credit_Risk' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Credit_Risk')
BEGIN
    ALTER DATABASE Credit_Risk SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Credit_Risk;
END;
GO

-- Create the 'Credit_Risk' database
CREATE DATABASE Credit_Risk;
GO

USE Credit_Risk;
GO

