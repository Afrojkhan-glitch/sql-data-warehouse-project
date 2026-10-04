USE datawarehouse;
-- Enable local file loading for the active session
SET GLOBAL local_infile = 1;

-- ============================================================================
-- BRONZE LAYER DATA INGESTION (APPEND ONLY)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Load CRM Customer Demographics
-- Source: /datasets/source_crm/cust_info.csv
-- ----------------------------------------------------------------------------
LOAD DATA LOCAL INFILE '/Users/afrojkhan/Desktop/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
INTO TABLE bronze.crm_cust_info
CHARACTER SET utf8mb4                  
FIELDS TERMINATED BY ','           
ENCLOSED BY '"'                        
LINES TERMINATED BY '\n'                 
IGNORE 1 LINES;                         


-- ----------------------------------------------------------------------------
-- 2. Load CRM Product Information
-- Source: /datasets/source_crm/prd_info.csv
-- ----------------------------------------------------------------------------
LOAD DATA LOCAL INFILE '/Users/afrojkhan/Desktop/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
INTO TABLE bronze.crm_prd_info
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


-- ----------------------------------------------------------------------------
-- 3. Load CRM Sales Details
-- Source: /datasets/source_crm/sales_details.csv
-- ----------------------------------------------------------------------------
LOAD DATA LOCAL INFILE '/Users/afrojkhan/Desktop/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
INTO TABLE bronze.crm_sales_details
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


-- ----------------------------------------------------------------------------
-- 4. Load ERP Customer Data
-- Source: /datasets/source_erp/CUST_AZ12.csv
-- ----------------------------------------------------------------------------
LOAD DATA LOCAL INFILE '/Users/afrojkhan/Desktop/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv'
INTO TABLE bronze.erp_cust_az12
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


-- ----------------------------------------------------------------------------
-- 5. Load ERP Location Data
-- Source: /datasets/source_erp/LOC_A101.csv
-- ----------------------------------------------------------------------------
LOAD DATA LOCAL INFILE '/Users/afrojkhan/Desktop/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv'
INTO TABLE bronze.erp_loc_a101
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


-- ----------------------------------------------------------------------------
-- 6. Load ERP Product Category Data
-- Source: /datasets/source_erp/PX_CAT_G1V2.csv
-- ----------------------------------------------------------------------------
LOAD DATA LOCAL INFILE '/Users/afrojkhan/Desktop/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv'
INTO TABLE bronze.erp_px_cat_g1v2
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


-- Disable local file loading after ingestion completes
SET GLOBAL local_infile = 0;
