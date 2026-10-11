--cheking  for any duplicates that introduced by the join logic 
SELECT cst_id,count(*) from(
	SELECT 
	ci.cst_id,
	ci.cst_key,
	ci.cst_firstname,
	ci.cst_lastname,
	ci.cst_marital_status,
	ci.cst_gndr,
	ci.cst_create_date,
	ca.bdate,
	ca.gen,
	la.cntry
	FROM silver.crm_cust_info ci
	LEFT JOIN silver.erp_cust_az12 ca 
	on  ci.cst_key=ca.cid 
	left join silver.erp_loc_a101 la
	on ci.cst_key=la.cid
)t group by cst_id 
having count(*)>1
-- nooo duplicates
-- in our table we have tow collumes for gender 
-- we observe that we have in one table have n/a or we have two different value and in this case let do data integration  
SELECT DISTINCT
	ci.cst_gndr,
	ca.gen,
	case when ci.cst_gndr !='n/a'then ci.cst_gndr -- CRM is the master
		else coalesce(ca.gen,'n/a')
	END as new_gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca 
on  ci.cst_key=ca.cid 
left join silver.erp_loc_a101 la
on ci.cst_key=la.cid
ORDER BY  1,2
