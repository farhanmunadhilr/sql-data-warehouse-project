/* ============================================================================
Quality Checks for 03_gold
Validate integrity, consistency, and referential relationships
============================================================================ */

-- ====================================================================
-- Check Uniqueness of Customer Key in 03_gold.dim_customers
-- Expectation: No results
-- ====================================================================
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM "03_gold".dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;



-- ====================================================================
-- Check Uniqueness of Product Key in 03_gold.dim_products
-- Expectation: No results
-- ====================================================================
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM "03_gold".dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;



-- ====================================================================
-- Check Fact–Dimension Connectivity in 03_gold.fact_sales
-- Expectation: No rows (all keys match)
-- ====================================================================
SELECT 
    f.*,
    c.customer_key,
    p.product_key
FROM "03_gold".fact_sales f
LEFT JOIN "03_gold".dim_customers c
    ON c.customer_key = f.customer_key
LEFT JOIN "03_gold".dim_products p
    ON p.product_key = f.product_key
WHERE c.customer_key IS NULL
   OR p.product_key IS NULL;
