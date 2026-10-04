/*

=========================================================
Create Database and Schemas

=========================================================

Script Purpose:

This script creates a new database named 'Datawarehouse' after checking if it already exists. 
If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas within 
the database: 'bronze', 'silver', and 'gold'

WARNING:

Running cript will drop the entire 'Datawarehouse' database if it exists.
All data in the database will be permanently deleted. Proceed with caution
and ensure you have proper backups before running this script.
*/

-- Create the 'Datawarehouse' database

CREATE DATABASE DataWarehouse;

USE DataWarehouse;


-- create Schemas
CREATE SCHEMA bronze;


CREATE SCHEMA silver;

CREATE SCHEMA gold;
