-- ================================
-- Checking 'silver.crm_cust_info'
-- ================================

-- CHECK FOR DUBLICATE AND NULL PK
SELECT
cst_id,
count(*)

FROM silver.crm_cust_info
GROUP BY cst_id 
HAVING count(*) >1 or cst_id= null


-- check for unwanted space in string values
SELECT
cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

-- Data Standardization and Consistency
SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info

SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info
-- ================================
-- Checking 'silver.crm_prd_info'
-- ================================

-- CHECK FOR DUBLICATE AND NULL PK
SELECT
prd_id,
count(*)
FROM silver.crm_prd_info
GROUP BY  prd_id
HAVING count(*) >1 or prd_id IS null
-- check for unwanted space in string values
SELECT
prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)
-- Data Standardization and Consistency
SELECT DISTINCT prd_line
from silver.crm_prd_info
-- check for NULL or negative Numbers in prd_cost
SELECT
prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 or prd_cost IS null
-- check for invalid date order 
-- the solution is derive the end date from the start date 
select*
from silver.crm_prd_info
where prd_end_dt<prd_start_dt
-- ==================================
-- Checking 'silver.crm_sales_details'
-- ==================================
-- Check for invalid date 
SELECT sls_order_dt
FROM bronze.crm_sales_details
where sls_order_dt<=0 OR len(sls_order_dt)!=8 or
sls_order_dt>20500101
--Check for the invalid date orders 
SELECT
*
FROM bronze.crm_sales_details
where sls_order_dt >sls_ship_dt or sls_ship_dt> sls_due_dt
-- Check for sales = quantity *price and 
-- (all this must not be negative ,zeros,null)
SELECT 
sls_sales as old,
sls_quantity,
case when  sls_sales is null or sls_sales <=0 OR sls_sales!=abs(sls_price)* sls_quantity
	then abs(sls_price)* sls_quantity
	else sls_sales
end as sls_sales,

case when sls_price is null or sls_price<=0
	THEN sls_sales/NULLif(sls_quantity,0)
	else sls_price
end as  sls_price
FROM bronze.crm_sales_details
WHERE  sls_sales!=sls_price*sls_quantity 
or sls_quantity is null or sls_price is null or sls_sales is null
or sls_quantity <=0 or sls_price  <=0  or sls_sales  <=0 
-- ==================================
-- Checking 'silver.erp_cust_az12'
-- ==================================
-- identify out of range dates 
Select distinct 
bdate
from bronze.erp_cust_az12
where bdate<'1924-01-01' or bdate > getdate()
-- Data Standardization and Consistency
select distinct gen
from bronze.erp_cust_az12
-- ==================================
-- Checking 'silver.erp_loc_a101'
-- ==================================

-- Data Standardization and Consistency
select distinct cntry
from bronze.erp_loc_a101
-- ==================================
-- Checking 'silver.erp_px_cat_g1v2'
-- ==================================
-- check for unwanted spaces 
SELECT * from bronze.erp_px_cat_g1v2
where trim (cat)!=cat or subcat!=trim(subcat) or maintenance!=trim(maintenance)
-- Data Standardization and Consistency
SELECT DISTINCT maintenance from bronze.erp_px_cat_g1v2
SELECT DISTINCT cat from bronze.erp_px_cat_g1v2
SELECT DISTINCT subcat from bronze.erp_px_cat_g1v2
