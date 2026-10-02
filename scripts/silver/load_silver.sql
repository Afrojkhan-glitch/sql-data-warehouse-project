/*
===========================================================================
Stored Procedure: Load silver Layer(Bronze -> Silver)
===========================================================================
Script Purpose:
    This stored procedure performs the ETL(Extract, Trandform, Load) process to
    populate the 'silver' schema tables from the 'bronze' schema.
Action Performed:
 - Truncate Silver Tales.
 - Inserts transformed and cleaned data from Bronze into Silver Tables

Parameters:
   None,
   This stored procedure does not accept any parameters or return any values.
  
*/
SELECT'----------------------------------------------------------------';
SELECT 'ERP Table';
SELECT'----------------------------------------------------------------';


SELECT 'Truncating Table silver.crm_cust_info';
TRUNCATE TABLE silver.crm_cust_info;
SELECT 'Inserting Data into: silver_crm_cust_info';
INSERT INTO silver.crm_cust_info(
cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date)
SELECT
cst_id,cst_key,
trim(cst_firstname) AS cst_firstname,
trim(cst_lastname) AS cst_lastname,
CASE
	WHEN upper(cst_marital_status)='M' THEN 'Married'
    WHEN upper(cst_marital_status)='S' THEN 'Single'
    ELSE 'n/a'
    END AS cst_marital_status,
CASE
	WHEN upper(cst_gndr)='F' THEN 'Female' 
    WHEN upper(cst_gndr)='M' THEN 'Male'
    ELSE 'n/a'
    END AS cst_gndr,
cst_create_date
FROM (
SELECT * ,
ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag
FROM bronze.crm_cust_info 
WHERE cst_id IS NOT NULL)t 
WHERE flag =1 AND cst_id !=0;

SELECT 'Truncating Table silver.crm_prd_info';
TRUNCATE TABLE silver.crm_prd_info;
SELECT 'Inserting Data into: silver_crm_prd_info';
INSERT INTO silver.crm_prd_info(
prd_id,
cat_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt)
SELECT prd_id,
REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
SUBSTRING(prd_key,7) AS prd_key,
prd_nm,
IFNULL(prd_cost,0) AS prd_cost,
CASE
	WHEN upper(TRIM(prd_line))='M' THEN 'Mountain'
    WHEN upper(TRIM(prd_line))='R' THEN 'Road'
    WHEN upper(TRIM(prd_line))='S' THEN 'Other Sales'
    WHEN upper(TRIM(prd_line))='T' THEN 'Touring'
    ELSE 'n/a'
    END prd_line,
CAST(prd_start_dt AS DATE) AS prd_start_dt,
CAST(DATE_SUB(
        LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt ASC),
        INTERVAL 1 DAY
    ) AS DATE) AS prd_end_dt
FROM bronze.crm_prd_info;

SELECT 'Truncating Table silver.crm_sales_details ';
TRUNCATE TABLE silver.crm_sales_details;
SELECT 'Inserting Data into: silver_crm_sales_details';
INSERT INTO silver.crm_sales_details(
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price)
SELECT 
sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE
	WHEN sls_order_dt = 0 or length(sls_order_dt)!=8 THEN NULL 
    ELSE CAST(CAST(sls_order_dt AS CHAR)AS DATE)
    END AS sls_order_dt,
CASE
	WHEN sls_ship_dt = 0 or length(sls_ship_dt)!=8 THEN NULL 
    ELSE CAST(CAST(sls_ship_dt AS CHAR)AS DATE)
    END AS sls_ship_dt,
CASE
	WHEN sls_due_dt = 0 or length(sls_due_dt)!=8 THEN NULL 
    ELSE CAST(CAST(sls_due_dt AS CHAR)AS DATE)
    END AS sls_due_dt,
CASE 
	WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price)
    THEN sls_quantity * ABS(sls_price)
    ELSE sls_sales
    END AS sls_sales,
sls_quantity,
CASE 
	WHEN sls_price IS NULL OR sls_price <=0 
    THEN sls_price / NULLIF(sls_quantity,0)
    ELSE sls_price
    END AS sls_price 
FROM bronze.crm_sales_details;

SELECT'----------------------------------------------------------------';
SELECT 'ERP Table';
SELECT'----------------------------------------------------------------';

SELECT 'Truncating Table silver.erp_cust_az12';
TRUNCATE TABLE silver.erp_cust_az12;
SELECT 'Inserting Data into: silver_erp_cust_az12';
INSERT INTO silver.erp_cust_az12(
cid,
bdate,
gen)
SELECT
CASE 
	WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4)
    ELSE cid
    END AS cid,
CASE 
	WHEN bdate>CURDATE() THEN NULL
    ELSE bdate
    END AS bdate,
CASE 
    WHEN UPPER(TRIM(REPLACE(REPLACE(gen, '\r', ''), '\n', ''))) IN ('F', 'FEMALE') THEN 'Female'
    WHEN UPPER(TRIM(REPLACE(REPLACE(gen, '\r', ''), '\n', ''))) IN ('M', 'MALE') THEN 'Male'
    ELSE 'n/a'
END AS gen
FROM bronze.erp_cust_az12;

SELECT 'Truncating Table silver.erp_loc_a101 ';
TRUNCATE TABLE silver.erp_loc_a101;
SELECT 'Inserting Data into: silver_erp_loc_a101';
INSERT INTO silver.erp_loc_a101(
cid,
cntry)
SELECT 
REPLACE(cid,'-','') AS cid,
CASE 
	WHEN TRIM(cntry) = 'DE' THEN 'Germany'
    WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
    WHEN TRIM(cntry)='' OR TRIM(cntry) IS NULL THEN 'n/a'
    ELSE TRIM(cntry)
    END AS cntry
FROM  bronze.erp_loc_a101;

SELECT 'Truncating Table silver.erp_px_cat_g1v2 ';
TRUNCATE TABLE silver.erp_px_cat_g1v2;
SELECT 'Inserting Data into: silver_erp_px_cat_g1v2';
INSERT INTO silver.erp_px_cat_g1v2(
id,
cat,
subcat,
maintenance)
SELECT 
id,cat,subcat,maintenance
FROM bronze.erp_px_cat_g1v2;
