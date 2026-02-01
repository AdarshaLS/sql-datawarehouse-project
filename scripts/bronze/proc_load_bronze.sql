/*
=====================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
=====================================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
      - Truncates the bronze tables before loading data.
      - Used the 'BULK INSERT' command to load data from csv files to bronze tables.

Parameters:
  None.
 This stored procedure does not accept any parameters or return any values.

Usage Example:
  EXEC bronze.load_bronze;
=====================================================================================
*/

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
