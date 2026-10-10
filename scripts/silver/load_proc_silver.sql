/*
======================================================
Stored Procedure:
Load Silver Layer from Bronze 
======================================================
Script Purpose:
This stored procedure performs the ETL (Extract, Transform, Load) process to populate the 'silver' schema tables from the 'bronze' schema.
Truncates Silver tables.
Inserts transformed and cleansed data from Bronze into Silver tables.
*/


-- ================================
-- crm_cust_info
-- ================================
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN 
    TRUNCATE TABLE silver.crm_cust_info
    INSERT INTO silver.crm_cust_info(
    cst_id ,
    cst_key ,
    cst_firstname ,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date)
    SELECT 
    cst_id ,
    cst_key ,
    TRIM(cst_firstname) as cst_firstname ,--  TRIM  to remove space from string values
    TRIM(cst_lastname) as cst_lastname,
    case when UPPER(TRIM(cst_marital_status))='S'then 'Single'
	    when UPPER(TRIM(cst_marital_status))='M'then 'Married'
	    else 'n/a'
    END cst_marital_status,

    case when UPPER(TRIM(cst_gndr))='M'then 'Male'
	    when UPPER(TRIM(cst_gndr))='F'then 'Female'
	    else 'n/a'
    END cst_gndr,
    cst_create_date
    FROM
    (

    SELECT *,
    ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date desc )  AS flag_last

    FROM bronze.crm_cust_info
    where cst_id is not null
    )t where flag_last =1
    -- =================================
    -- crm_prd_info
    -- =================================
    TRUNCATE TABLE silver.crm_prd_info
    INSERT INTO silver.crm_prd_info (
        prd_id ,
        cat_id ,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line ,
        prd_start_dt ,
        prd_end_dt
    )
    SELECT 
        prd_id,
        REPLACE(SUBSTRING(prd_key,1,5),'-','_') as cat_id,-- REPLACE IS FOR REPALCE '-' with '_' BECOUSE IN ERP use '-' NOT '_'
        SUBSTRING(prd_key,7,len(prd_key)) as prd_key,
        prd_nm,
        ISNULL(prd_cost,0) as prd_cost,
        CASE UPPER(TRIM(prd_line)) 
            when 'M' THEN 'Mountain'
            when 'S' THEN 'Sport'
            when 'R' THEN 'Road'
            when 'T' THEN 'Touring'
            ELSE 'n/a'
        END AS prd_line,
        cast(prd_start_dt as DATE) AS prd_start_dt,
        cast(lead(prd_start_dt) over (PARTITION BY  prd_key ORDER BY prd_start_dt)as date) as prd_end_dt
    FROM bronze.crm_prd_info
    -- =================================
    -- crm_sales_details
    -- =================================
    TRUNCATE TABLE silver.crm_sales_details
    INSERT INTO silver.crm_sales_details (
        sls_ord_num ,
        sls_prd_key ,
        sls_cust_id ,
        sls_order_dt,
        sls_ship_dt ,
        sls_due_dt,
        sls_sales,
        sls_quantity,
        sls_price
    )
    SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    case when sls_order_dt =0 or len(sls_order_dt)!=8 then null 
         else cast(cast(sls_order_dt as VARCHAR)as date)
    END sls_order_dt,
    case when sls_ship_dt =0 or len(sls_ship_dt)!=8 then null 
         else cast(cast(sls_ship_dt as VARCHAR)as date)
    END sls_ship_dt,
    case when sls_due_dt =0 or len(sls_due_dt)!=8 then null 
         else cast(cast(sls_due_dt as VARCHAR)as date)
    END sls_due_dt,
    case when  sls_sales is null or sls_sales <=0 OR sls_sales!=abs(sls_price)* sls_quantity
	    then abs(sls_price)* sls_quantity
	    else sls_sales
    end as sls_sales,
    sls_quantity,
    case when sls_price is null or sls_price<=0
	    THEN sls_sales/NULLif(sls_quantity,0)
	    else sls_price
    end as  sls_price
    FROM bronze.crm_sales_details

    -- =================================
    -- erp_cust_az12
    -- =================================
    TRUNCATE TABLE silver.erp_cust_az12
    INSERT INTO silver.erp_cust_az12 (
        cid ,
        bdate,
        gen
    )
    SELECT 
    CASE WHEN cid like 'NAS%' THEN SUBSTRING(cid,4,len(cid))
        else cid
    end cid,
    case when bdate > getdate() then NULL 
        ELSE bdate
    end as bdate,

    case when upper(trim(gen)) in ('F','FEMALE') then 'Female'
         when upper(trim(gen)) in ('M','MALE') then 'Male'
         else 'n/a'
    end as gen
    FROM bronze.erp_cust_az12
    -- =================================
    -- erp_loc_a101
    -- =================================
    TRUNCATE TABLE silver.erp_loc_a101
    insert into silver.erp_loc_a101(
    cid,
    cntry
    )
    SELECT 
    REPLACE(cid,'-','') cid ,
    CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
        WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
        WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
        ELSE TRIM(cntry)
    END AS cntry
    from bronze.erp_loc_a101
    
    -- ==================================
    -- 'erp_px_cat_g1v2'
    -- ==================================
    TRUNCATE TABLE silver.erp_px_cat_g1v2
    insert into silver.erp_px_cat_g1v2(
        id ,
        cat ,
        subcat,
        maintenance
    )
    select 
        id ,
        cat ,
        subcat,
        maintenance
    from bronze.erp_px_cat_g1v2
END 
