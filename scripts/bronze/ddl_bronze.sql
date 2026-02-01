/*
============================================================================================
DDL Script: Create Bronze Tables
============================================================================================
Script Purpose:
    This Script creates tables in the 'bronze' schema, dropping existing tables
    if they already exist.
    Run this script to re-define the DDL structure of 'bronze' Tables
============================================================================================
*/

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

-- if table bronze.crm_cust_info is found in DB and not null and delete db
IF OBJECT_ID('bronze.crm_cust_info','U') IS NOT NULL
   DROP TABLE bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info(
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_material_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
);

IF OBJECT_ID('bronze.crm_prd_info','U') IS NOT NULL
   DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info(
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE
);

IF OBJECT_ID('bronze.crm_sales_details','U') IS NOT NULL
   DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details(
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
);

IF OBJECT_ID('bronze.erp_cust_az12','U') IS NOT NULL
   DROP TABLE bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12(
	cid NVARCHAR(50),
	bdate DATE,
	gen NVARCHAR(50)
);

IF OBJECT_ID('bronze.erp_loc_a101','U') IS NOT NULL
   DROP TABLE bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101(
	cid NVARCHAR(50),
	cntry NVARCHAR(50)
);

IF OBJECT_ID('bronze.erp_px_cat_g1v2','U') IS NOT NULL
   DROP TABLE bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2(
	id NVARCHAR(50),
	cat NVARCHAR(50),
	subcat NVARCHAR(50),
	maintenance NVARCHAR(50)
);



--19. LOAD SCRIPTS

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN

DECLARE @start_time DATETIME, @end_time DATETIME,@batch_start_time DATETIME,@batch_end_time DATETIME;
BEGIN TRY
	SET @batch_start_time = GETDATE();
	PRINT '================================================================';
	PRINT 'Loading Bronze Layer';
	PRINT '================================================================';


	PRINT '----------------------------------------------------------------';
	PRINT 'Loading CRM Tables';
	PRINT '----------------------------------------------------------------';

SET @start_time = GETDATE();
	PRINT '>> Trunacating Table : bronze.crm_cust_info' ;
	TRUNCATE TABLE bronze.crm_cust_info; --dropping data from table

	PRINT '>> Inserting Data into Table : bronze.crm_cust_info' ;
	BULK INSERT bronze.crm_cust_info
	FROM 'D:\Software\AI and ML\SQL\BARAA\Building a Modern Data Warehoue - Data Engineering Bootcamp Udemy\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.CSV'
	WITH (
		  FIRSTROW = 2,
		  FIELDTERMINATOR = ',',
		  TABLOCK
		  );
SET @end_time = GETDATE();
PRINT '>> Load Duration : '+CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
	--SELECT * FROM bronze.crm_cust_info;

	--SELECT COUNT(*) FROM bronze.crm_cust_info;


	--2.
	SET @start_time = GETDATE();
	PRINT '>> Trunacating Table : bronze.crm_prd_info' ;
	TRUNCATE TABLE bronze.crm_prd_info;

	PRINT '>> Inserting Data into Table : bronze.crm_prd_info' ;
	BULK INSERT bronze.crm_prd_info
	FROM 'D:\Software\AI and ML\SQL\BARAA\Building a Modern Data Warehoue - Data Engineering Bootcamp Udemy\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.CSV'
	WITH (
		  FIRSTROW = 2,
		  FIELDTERMINATOR = ',',
		  TABLOCK
		  );
SET @end_time = GETDATE();
PRINT '>> Load Duration : '+CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';

	--SELECT COUNT(*) FROM bronze.crm_prd_info;


	--3.
	SET @start_time = GETDATE();
	PRINT '>> Trunacating Table : bronze.crm_prd_info' ;
	TRUNCATE TABLE bronze.crm_prd_info;

	PRINT '>> Inserting Data into Table : bronze.crm_sales_details' ;
	BULK INSERT bronze.crm_sales_details
	FROM 'D:\Software\AI and ML\SQL\BARAA\Building a Modern Data Warehoue - Data Engineering Bootcamp Udemy\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.CSV'
	WITH (
		  FIRSTROW = 2,
		  FIELDTERMINATOR = ',',
		  TABLOCK
		  );

	--SELECT COUNT(*) FROM bronze.crm_sales_details;
SET @end_time = GETDATE();
PRINT '>> Load Duration : '+CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';

	PRINT '----------------------------------------------------------------';
	PRINT 'Loading ERP Tables';
	PRINT '----------------------------------------------------------------';

	--4 ERP
	SET @start_time = GETDATE();
	PRINT '>> Trunacating Table : bronze.erp_CUST_AZ12' ;
	TRUNCATE TABLE bronze.erp_CUST_AZ12;

	PRINT '>> Inserting Data into Table : bronze.erp_CUST_AZ12' ;
	BULK INSERT bronze.erp_CUST_AZ12
	FROM 'D:\Software\AI and ML\SQL\BARAA\Building a Modern Data Warehoue - Data Engineering Bootcamp Udemy\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.CSV'
	WITH (
		  FIRSTROW = 2,
		  FIELDTERMINATOR = ',',
		  TABLOCK
		  );
SET @end_time = GETDATE();
PRINT '>> Load Duration : '+CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';

	--SELECT COUNT(*) FROM bronze.erp_CUST_AZ12;

	--5
	SET @start_time = GETDATE();
	PRINT '>> Trunacating Table : bronze.erp_LOC_A101' ;
	TRUNCATE TABLE bronze.erp_LOC_A101;

	PRINT '>> Inserting Data into Table : bronze.erp_LOC_A101' ;
	BULK INSERT bronze.erp_LOC_A101
	FROM 'D:\Software\AI and ML\SQL\BARAA\Building a Modern Data Warehoue - Data Engineering Bootcamp Udemy\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.CSV'
	WITH (
		  FIRSTROW = 2,
		  FIELDTERMINATOR = ',',
		  TABLOCK
		  );
SET @end_time = GETDATE();
PRINT '>> Load Duration : '+CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';

	--SELECT COUNT(*) FROM bronze.erp_LOC_A101;


	--6
	SET @start_time = GETDATE();
	PRINT '>> Trunacating Table : bronze.erp_PX_CAT_G1V2' ;
	TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;

	PRINT '>> Inserting Data into Table : bronze.erp_PX_CAT_G1V2' ;
	BULK INSERT bronze.erp_PX_CAT_G1V2
	FROM 'D:\Software\AI and ML\SQL\BARAA\Building a Modern Data Warehoue - Data Engineering Bootcamp Udemy\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.CSV'
	WITH (
		  FIRSTROW = 2,
		  FIELDTERMINATOR = ',',
		  TABLOCK
		  );
SET @end_time = GETDATE();
PRINT '>> Load Duration : '+CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
SET @batch_end_time = GETDATE();
PRINT '>> Total Load Duration : '+ CAST(DATEDIFF(second, @batch_start_time,@batch_end_time) AS NVARCHAR) + ' seconds';
	--SELECT COUNT(*) FROM bronze.erp_PX_CAT_G1V2;

	END TRY
	BEGIN CATCH
	PRINT '=======================================================';
	PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
	PRINT 'Error Message' +ERROR_MESSAGE();
	PRINT 'Error Message' +CAST (ERROR_NUMBER() AS NVARCHAR);
	PRINT 'Error Message' +CAST (ERROR_STATE() AS NVARCHAR);
	PRINT '=======================================================';
	END CATCH

END

EXEC bronze.load_bronze
