!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Use REPORTING schema
USE SCHEMA REPORTING;

-- Create task for generating monthly reports
CREATE OR REPLACE TASK task_generate_monthly_reports
    WAREHOUSE = &SNOWSQL_ENVVAR_WH
    SCHEDULE = 'CRON 0 2 1 * * UTC' -- Run at 2 AM on the 1st of every month
AS
$$
BEGIN
    -- Generate monthly sales report for previous month
    INSERT INTO rpt_monthly_sales (
        year_month,
        sales_channel,
        region,
        total_orders,
        total_customers,
        total_revenue,
        total_quantity,
        avg_order_value,
        discount_percentage
    )
    SELECT 
        TO_VARCHAR(DATE_TRUNC('month', DATEADD('month', -1, CURRENT_DATE())), 'YYYY-MM') AS year_month,
        sales_channel,
        region,
        COUNT(sales_id) AS total_orders,
        COUNT(DISTINCT customer_id) AS total_customers,
        SUM(net_amount) AS total_revenue,
        SUM(quantity) AS total_quantity,
        AVG(total_amount) AS avg_order_value,
        ROUND((SUM(discount_amount) / NULLIF(SUM(total_amount), 0)) * 100, 2) AS discount_percentage
    FROM ANALYTICS.fact_sales
    WHERE DATE_TRUNC('month', order_date) = DATE_TRUNC('month', DATEADD('month', -1, CURRENT_DATE()))
    GROUP BY year_month, sales_channel, region;
END;
$$
COMMENT = 'Monthly task to generate sales reports';

-- Start the task (commented out for initial deployment)
-- ALTER TASK task_generate_monthly_reports RESUME;