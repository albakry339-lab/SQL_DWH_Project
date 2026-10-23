----------------------------------------------------------------------------------------------------
-- 1. Linking Customers
----------------------------------------------------------------------------------------------------
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS firstname,
    ci.cst_lastname AS lastname,
    ci.cst_marital_status AS marital_status,
    CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr ELSE COALESCE(ca.gen, 'n/a') END AS new_gen,
    ci.cst_create_date AS create_date,
    ca.bdate AS birth_date,
    la.cntry AS country
FROM [silver].[crm_cust_info] ci
LEFT JOIN [silver].[erp_cust_az12] ca
    ON ci.cst_key = ca.cid
LEFT JOIN [silver].[erp_loc_a101] la
    ON ci.cst_key = la.cid
GO


----------------------------------------------------------------------------------------------------
-- 2. Linking Product 
----------------------------------------------------------------------------------------------------
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pa.prd_key, pa.prd_start_dt) AS surrogate_key,
    pa.prd_id AS product_id,
    pa.prd_key AS product_key,
    pa.cat_id AS category_id,
    pa.prd_nm AS product_name,
    pa.prd_cost AS product_cost,
    pa.prd_line AS product_line,
    pa.prd_start_dt AS product_start_date,
    px.cat AS categories,
    px.subcat AS subcategory,
    px.maintenance
FROM silver.crm_prd_info AS pa
LEFT JOIN silver.erp_px_cat_g1v2 AS px
    ON pa.cat_id = px.id   -- تم التصحيح هنا لربط الـ cat_id مع الـ id
WHERE pa.prd_end_dt IS NULL;
GO

SELECT * FROM gold.dim_products;


----------------------------------------------------------------------------------------------------
-- 3. Linking Sales 
----------------------------------------------------------------------------------------------------
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num AS order_number,
    CX.customer_key,  
    PR.surrogate_key AS product_key,  
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS ship_date,
    sd.sls_due_dt AS due_date,
    sd.sls_sales AS sales,
    sd.sls_quantity AS quantity,
    sd.sls_price AS price
FROM silver.crm_sales_details AS sd
LEFT JOIN gold.dim_customers AS CX  
    ON sd.sls_cust_id = CX.customer_id
LEFT JOIN gold.dim_products AS PR   
    ON sd.sls_prd_key = PR.product_key
GO

