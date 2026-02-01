/*
========================================================================================
Create Databse and Schemas
========================================================================================
Script Puspose:
  This script creates a new database named 'DataWarehouse' after checking if it already exists.
  If the databade exists, it is dropped and recreated. Addtionallly, the script sets up three schemas
  withing the database: 'bronze','silver', and gold.

WARNING: 
  Running this script will drop the entire 'DataWarehouse' database if if exists.
  All data in the database will be permanently deleted. Proceed with caution 
  and ensure you have proper backups before running this script.
*/


USE master;

--Drop and recreate the'DataWarehouse' database
IF EXISTS(SELECT 1 FROM sys.databases WHERE name='DataWarehouse')
BEGIN 
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

--Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;

USE DataWarehouse;

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
