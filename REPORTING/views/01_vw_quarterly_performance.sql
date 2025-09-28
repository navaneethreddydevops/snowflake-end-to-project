!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Use REPORTING schema
USE SCHEMA REPORTING;

-- Create quarterly performance view
CREATE OR REPLACE VIEW vw_quarterly_performance AS
WITH quarterly_data AS (
    SELECT 
        LEFT(year_month, 4) AS year,
        CASE 
            WHEN RIGHT(year_month, 2) IN ('01', '02', '03') THEN 'Q1'
            WHEN RIGHT(year_month, 2) IN ('04', '05', '06') THEN 'Q2'
            WHEN RIGHT(year_month, 2) IN ('07', '08', '09') THEN 'Q3'
            ELSE 'Q4'
        END AS quarter,
        sales_channel,
        region,
        SUM(total_orders) AS quarterly_orders,
        SUM(total_customers) AS quarterly_customers,
        SUM(total_revenue) AS quarterly_revenue,
        SUM(total_quantity) AS quarterly_quantity,
        AVG(avg_order_value) AS avg_quarterly_order_value
    FROM rpt_monthly_sales
    GROUP BY 1, 2, 3, 4
)
SELECT 
    year || '-' || quarter AS year_quarter,
    sales_channel,
    region,
    quarterly_orders,
    quarterly_customers,
    quarterly_revenue,
    quarterly_quantity,
    avg_quarterly_order_value,
    ROUND(quarterly_revenue / NULLIF(quarterly_orders, 0), 2) AS revenue_per_order,
    ROUND(quarterly_revenue / NULLIF(quarterly_customers, 0), 2) AS revenue_per_customer
FROM quarterly_data
ORDER BY year, quarter, sales_channel, region
COMMENT = 'Quarterly performance summary view for executive reporting';