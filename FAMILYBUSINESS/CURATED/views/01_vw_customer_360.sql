!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Use CURATED schema
USE SCHEMA CURATED;

-- Create comprehensive customer 360 view
CREATE OR REPLACE VIEW vw_customer_360 AS
WITH customer_metrics AS (
    SELECT 
        c.customer_id,
        COUNT(o.order_id) AS total_orders,
        SUM(o.total_amount) AS lifetime_value,
        MAX(o.order_date) AS last_order_date,
        AVG(o.total_amount) AS avg_order_value,
        MIN(o.order_date) AS first_order_date,
        DATEDIFF('day', MIN(o.order_date), MAX(o.order_date)) AS customer_lifetime_days,
        DATEDIFF('day', MAX(o.order_date), CURRENT_DATE()) AS days_since_last_order
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
),
customer_360 AS (
    SELECT 
        c.customer_id,
        c.customer_key,
        c.full_name,
        c.email,
        c.customer_segment,
        c.customer_tier,
        c.registration_date,
        c.customer_age_days,
        c.is_active,
        -- Order metrics
        COALESCE(cm.total_orders, 0) AS total_orders,
        COALESCE(cm.lifetime_value, 0) AS lifetime_value,
        cm.last_order_date,
        COALESCE(cm.avg_order_value, 0) AS avg_order_value,
        cm.first_order_date,
        COALESCE(cm.customer_lifetime_days, 0) AS customer_lifetime_days,
        COALESCE(cm.days_since_last_order, 9999) AS days_since_last_order,
        -- Geographic info
        c.city,
        c.state,
        c.country,
        -- Contact preferences
        c.preferred_channel,
        c.email_domain,
        -- Calculated fields
        CASE 
            WHEN c.customer_age_days <= 30 THEN 'NEW'
            WHEN c.customer_age_days <= 365 THEN 'ACTIVE'
            WHEN c.customer_age_days <= 1095 THEN 'ESTABLISHED'
            ELSE 'VETERAN'
        END AS customer_lifecycle_stage,
        CASE 
            WHEN c.email_domain LIKE '%.edu' THEN 'EDUCATION'
            WHEN c.email_domain LIKE '%.gov' THEN 'GOVERNMENT'
            WHEN c.email_domain IN ('gmail.com', 'yahoo.com', 'outlook.com', 'hotmail.com') THEN 'PERSONAL'
            ELSE 'BUSINESS'
        END AS email_category,
        CASE 
            WHEN COALESCE(cm.days_since_last_order, 9999) <= 30 THEN 'ACTIVE'
            WHEN COALESCE(cm.days_since_last_order, 9999) <= 90 THEN 'DORMANT'
            WHEN COALESCE(cm.days_since_last_order, 9999) <= 365 THEN 'LAPSED'
            ELSE 'CHURNED'
        END AS customer_status
    FROM customers c
    LEFT JOIN customer_metrics cm ON c.customer_id = cm.customer_id
)
SELECT * FROM customer_360
COMMENT = 'Comprehensive 360-degree view of customer data for business users';