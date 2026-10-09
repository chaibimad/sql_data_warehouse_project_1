
/*
====================================================
create database 'datawarehouse' and Schemas
====================================================
The script creates a new database named ‘DataWarehouse’
and makes sure it does not already exist (if it does, it is dropped and recreated).
It also creates three schemas within the database: ‘bronze’, ‘silver’, and ‘gold’.
*/


USE master;
GO
--drop and receate the 'Datawarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name='DataWarehouse')
BEGIN 
     ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
     DROP DATABASE DataWarehouse;
END;
GO
--Create DataWarehouse database
CREATE DATABASE DataWarehouse;
GO
USE DataWarehouse;
GO
-- create schemas ('bronze' ,'silver', 'gold')
Create SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO 
CREATE SCHEMA gold;
go
