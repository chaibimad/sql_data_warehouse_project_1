/*
=================================================================================================================
-- Stored Procedure :load Bronze layer from Source 
=================================================================================================================
The script contains a stored procedure that loads data into the ‘bronze’ schema from external CSV files. 
It do the following actions:

Truncates the bronze tables before loading data.
Uses the 'BULK INSERT' command to load data from CSV files into the bronze tables.
Uses 'TRY...CATCH' to ensure error handling and data integrity.

Note: 
     BULK INSERT loads all the data in one go, which is different from a regular INSERT.”
Usage example:
      EXEC bronze.load_bronze
====================================================================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    BEGIN TRY
        PRINT '======== Loading Bronze Layer ========';
        print '>>Loading CRM Tables';

        TRUNCATE TABLE bronze.crm_cust_info;

        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\imadc\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW =2,
            FIELDTERMINATOR=',',
            TABLOCK
        );

        TRUNCATE TABLE bronze.crm_cust_info;

        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\imadc\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW =2,
            FIELDTERMINATOR=',',
            TABLOCK
        );


        TRUNCATE TABLE bronze.crm_sales_details;

        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\imadc\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW =2,
            FIELDTERMINATOR=',',
            TABLOCK
        );
        print '>>Loading ERP Tables';

        TRUNCATE TABLE bronze.erp_cust_az12;

        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\imadc\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp/cust_az12.csv'
        WITH (
            FIRSTROW =2,
            FIELDTERMINATOR=',',
            TABLOCK
        );


        TRUNCATE TABLE bronze.erp_loc_a101;

        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\imadc\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp/loc_a101.csv'
        WITH (
            FIRSTROW =2,
            FIELDTERMINATOR=',',
            TABLOCK
        );

        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\imadc\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp/px_cat_g1v2.csv'
        WITH (
            FIRSTROW =2,
            FIELDTERMINATOR=',',
            TABLOCK
        );
    END TRY 
    BEGIN CATCH 
        PRINT '============================================'
        PRINT '  ERROR OCCURED DURING LOADING BRONZE LAYER'
        PRINT '  ERROR MESSAGE'+ error_message();
        PRINT '============================================'

    END CATCH 
END
