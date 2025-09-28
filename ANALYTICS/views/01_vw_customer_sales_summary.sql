!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Use ANALYTICS schema
USE SCHEMA ANALYTICS;

-- Create customer sales summary view
CREATE OR REPLACE VIEW vw_customer_sales_summary AS
SELECT 
    dc.customer_id,
    dc.customer_key,
    dc.first_name,
    dc.last_name,
    dc.customer_segment,
    COUNT(fs.sales_id) AS total_orders,
    SUM(fs.quantity) AS total_quantity,
    SUM(fs.total_amount) AS total_sales_amount,
    SUM(fs.net_amount) AS total_net_amount,
    AVG(fs.total_amount) AS avg_order_value,
    MIN(fs.order_date) AS first_order_date,
    MAX(fs.order_date) AS last_order_date,
    DATEDIFF('day', MIN(fs.order_date), MAX(fs.order_date)) AS customer_lifetime_days
FROM dim_customer dc
LEFT JOIN fact_sales fs ON dc.customer_id = fs.customer_id
WHERE dc.is_active = TRUE
GROUP BY 
    dc.customer_id, dc.customer_key, dc.first_name, 
    dc.last_name, dc.customer_segment
COMMENT = 'Customer sales summary view for analytics dashboards';