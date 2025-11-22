/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the '02_silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after loading the Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking "02_silver".crm_cust_info
-- ====================================================================

-- Check for NULLs or Duplicates in Primary Key
SELECT 
    cst_id,
    COUNT(*) 
FROM "02_silver".crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for Unwanted Spaces
SELECT 
    cst_key
FROM "02_silver".crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Data Standardization & Consistency
SELECT DISTINCT 
    cst_marital_status 
FROM "02_silver".crm_cust_info;

-- ====================================================================
-- Checking "02_silver".crm_prd_info
-- ====================================================================

-- Check for NULLs or Duplicates in Primary Key
SELECT 
    prd_id,
    COUNT(*)
FROM "02_silver".crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for Unwanted Spaces
SELECT 
    prd_nm
FROM "02_silver".crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for NULLs or Negative Cost
SELECT 
    prd_cost
FROM "02_silver".crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Standardization
SELECT DISTINCT 
    prd_line
FROM "02_silver".crm_prd_info;

-- Check Invalid Date Orders
SELECT 
    *
FROM "02_silver".crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- ====================================================================
-- Checking "02_silver".crm_sales_details
-- ====================================================================

-- Invalid Date Orders
SELECT 
    *
FROM "02_silver".crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
   OR sls_order_dt > sls_due_dt;

-- Sales Consistency
SELECT DISTINCT 
    sls_sales,
    sls_quantity,
    sls_price
FROM "02_silver".crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- ====================================================================
-- Checking "02_silver".erp_cust_az12
-- ====================================================================

-- Out-of-Range Birthdates
SELECT DISTINCT 
    bdate
FROM "02_silver".erp_cust_az12
WHERE bdate < DATE '1924-01-01'
   OR bdate > CURRENT_DATE;

-- Standardization Check
SELECT DISTINCT 
    gen
FROM "02_silver".erp_cust_az12;

-- ====================================================================
-- Checking "02_silver".erp_loc_a101
-- ====================================================================

SELECT DISTINCT 
    cntry
FROM "02_silver".erp_loc_a101
ORDER BY cntry;

-- ====================================================================
-- Checking "02_silver".erp_px_cat_g1v2
-- ====================================================================

-- Trim Check
SELECT 
    *
FROM "02_silver".erp_px_cat_g1v2
WHERE cat != TRIM(cat)
   OR subcat != TRIM(subcat)
   OR maintenance != TRIM(maintenance);

-- Standardization Check
SELECT DISTINCT 
    maintenance
FROM "02_silver".erp_px_cat_g1v2;
