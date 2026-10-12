/* NOTE : Purpose: Automates the extraction and loading (EL) process for the Bronze layer in the Data Warehouse, handling 6 source tables from CRM and ERP datasets.

Core Mechanisms:

Data Ingestion: Uses TRUNCATE TABLE to clear existing data followed by BULK INSERT to ingest raw CSV files efficiently from the local filesystem.

Performance Tracking: Implements DATETIME variables combined with GETDATE() and DATEDIFF() to measure and print the exact execution duration for each individual table load as well as the full batch load.

Error Handling: Wrapped in a robust TRY...CATCH block to gracefully capture unexpected errors, prevent system disruption, and output error numbers for troubleshooting */
create or alter procedure bronze.load_bronze as 
begin
declare @start_time DATETIME,@end_time DATETIME,@batch_start_time DATETIME,@batch_end_time DATETIME ;
begin try 
print '----------------------------------------' 
set @batch_start_time = getdate();
print 'Loading Bronze Layer'
print 'Loading CRM Tables'
set @start_time = getdate();
TRUNCATE TABLE bronze.crm_cust_info;
BULK INSERT bronze.crm_cust_info
FROM 'C:\Users\Abood\Desktop\Oracle\SQL with Baraa\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
set @end_time = getdate();
print 'load duration' + cast(datediff(second,@start_time,@end_time) as nvarchar);
-- ===========================================
--  CRM
-- ===========================================
set @start_time = getdate();
TRUNCATE TABLE bronze.crm_prd_info;
BULK INSERT bronze.crm_prd_info
FROM 'C:\Users\Abood\Desktop\Oracle\SQL with Baraa\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
set @end_time = getdate();
print 'load duration' + cast(datediff(second,@start_time,@end_time) as nvarchar);
-- ===========================================
--  CRM
-- ===========================================
set @start_time = getdate();
TRUNCATE TABLE bronze.crm_sales_details;
BULK INSERT bronze.crm_sales_details
FROM 'C:\Users\Abood\Desktop\Oracle\SQL with Baraa\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
set @end_time = getdate();
print 'load duration' + cast(datediff(second,@start_time,@end_time) as nvarchar);
print '---------------------------------------'
print 'print Loading ERP Table'
-- ===========================================
--  ERP
-- ===========================================
set @start_time = getdate();
TRUNCATE TABLE bronze.erp_loc_a101;
BULK INSERT bronze.erp_loc_a101
FROM 'C:\Users\Abood\Desktop\Oracle\SQL with Baraa\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
set @end_time = getdate();
print 'load duration' + cast(datediff(second,@start_time,@end_time) as nvarchar);
-- ===========================================
--  ERP
-- ===========================================
set @start_time = getdate();
TRUNCATE TABLE bronze.erp_cust_az12;
BULK INSERT bronze.erp_cust_az12
FROM 'C:\Users\Abood\Desktop\Oracle\SQL with Baraa\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
set @end_time = getdate();
print 'load duration' + cast(datediff(second,@start_time,@end_time) as nvarchar);
-- ===========================================
--  ERP
-- ===========================================
set @start_time = getdate();
TRUNCATE TABLE bronze.erp_px_cat_g1v2;
BULK INSERT bronze.erp_px_cat_g1v2
FROM 'C:\Users\Abood\Desktop\Oracle\SQL with Baraa\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
set @end_time = getdate();
print 'load duration' + cast(datediff(second,@start_time,@end_time) as nvarchar);
set @batch_end_time = getdate();
print 'Full load duration' + cast(datediff(second,@batch_start_time,@batch_end_time) as nvarchar);
end try 
begin catch
print 'error message' + cast(error_number() as nvarchar )
END CATCH 
end 

exec bronze.load_bronze
