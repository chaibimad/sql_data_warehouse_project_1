/* 
=============================================================
DDL Script :create gold views
=============================================================
The script creates views for the gold layer in data warehouse
the gold layer is the final dimension and fact tables (star Schema)
 what i do :
	-- we observe that we have in one table have n/a or we have two different value and
	   in this case let do data integration
	-- Rename columns to friendly names 
	-- sort the columns into logical groups to improve readability
	
	-----------------------------------------------------
	USAGE:
	these views can be ready for analytics and reporting 
	-------------------------------------------------------
	=============================================================
*/
IF OBJECT_ID ('gold.dim_customers','V') IS NOT NULL
	DROP VIEW gold.dim_customers;
go 
create view gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER (order by cst_id) As customer_key,
	ci.cst_id AS customer_id ,
	ci.cst_key as customer_number,
	ci.cst_firstname as first_name,
	ci.cst_lastname  AS last_name,
	la.cntry as country,
	ci.cst_marital_status AS marital_status,
	case when ci.cst_gndr !='n/a'then ci.cst_gndr -- CRM is the master
			else coalesce(ca.gen,'n/a')
	END as gender,
	ca.bdate AS birthdate,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca 
	on  ci.cst_key=ca.cid 
left join silver.erp_loc_a101 la
	on ci.cst_key=la.cid
go


-- ======================================================================
IF OBJECT_ID ('gold.dim_products','V') IS NOT NULL
	DROP VIEW gold.dim_products;
go 
create view gold.dim_products AS
SELECT
	ROW_NUMBER() OVER (order by prd_start_dt,pn.prd_key) As product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
	ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL
GO 
-- ===============================================================
IF OBJECT_ID ('gold.fact_sales','V') IS NOT NULL
	DROP VIEW gold.fact_sales;
go 

CREATE VIEW gold.fact_sales as
SELECT
	sd.sls_ord_num AS order_number,
	pr.product_key,
	cu.customer_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS shipping_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales_amount,
	sd.sls_quantity AS quanity,
	sd.sls_price price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
	ON sd.sls_prd_key = pr.product_number
left join gold.dim_customers cu 
	on sd.sls_cust_id=cu.customer_id
Go 
