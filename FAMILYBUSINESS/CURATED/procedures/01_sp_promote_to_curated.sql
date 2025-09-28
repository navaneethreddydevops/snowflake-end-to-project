!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Use CURATED schema
USE SCHEMA CURATED;

-- Create stored procedure for promoting staging data to curated
CREATE OR REPLACE PROCEDURE sp_promote_to_curated()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    LET result STRING := '';
    LET customer_count NUMBER := 0;
    LET order_count NUMBER := 0;
    
    -- Promote customer data from staging to curated
    MERGE INTO customers AS target
    USING (
        SELECT 
            customer_id,
            customer_key,
            first_name,
            last_name,
            full_name,
            email,
            email_domain,
            phone_cleaned AS phone,
            address,
            city,
            state,
            country,
            postal_code,
            customer_segment,
            CASE 
                WHEN customer_age_days <= 90 THEN 'BRONZE'
                WHEN customer_age_days <= 365 THEN 'SILVER'
                WHEN customer_age_days <= 1095 THEN 'GOLD'
                ELSE 'PLATINUM'
            END AS customer_tier,
            registration_date,
            customer_age_days,
            is_active,
            CURRENT_TIMESTAMP() AS updated_timestamp
        FROM STAGING.stg_customers
        WHERE data_quality_score >= 0.7 -- Only promote high quality records
    ) AS source ON target.customer_id = source.customer_id
    WHEN MATCHED THEN
        UPDATE SET
            customer_key = source.customer_key,
            first_name = source.first_name,
            last_name = source.last_name,
            full_name = source.full_name,
            email = source.email,
            email_domain = source.email_domain,
            phone = source.phone,
            address = source.address,
            city = source.city,
            state = source.state,
            country = source.country,
            postal_code = source.postal_code,
            customer_segment = source.customer_segment,
            customer_tier = source.customer_tier,
            customer_age_days = source.customer_age_days,
            is_active = source.is_active,
            updated_timestamp = source.updated_timestamp
    WHEN NOT MATCHED THEN
        INSERT (
            customer_id, customer_key, first_name, last_name, full_name,
            email, email_domain, phone, address, city, state, country,
            postal_code, customer_segment, customer_tier, registration_date,
            customer_age_days, is_active, updated_timestamp
        ) VALUES (
            source.customer_id, source.customer_key, source.first_name, 
            source.last_name, source.full_name, source.email, source.email_domain,
            source.phone, source.address, source.city, source.state, source.country,
            source.postal_code, source.customer_segment, source.customer_tier, 
            source.registration_date, source.customer_age_days, source.is_active,
            source.updated_timestamp
        );
    
    customer_count := (SELECT COUNT(*) FROM customers);
    
    -- Promote order data from staging to curated with sequence numbers
    MERGE INTO orders AS target
    USING (
        SELECT 
            so.order_id,
            so.customer_id,
            so.order_date,
            so.order_status_cleaned AS order_status,
            so.total_amount,
            so.currency_code,
            so.payment_method_cleaned AS payment_method,
            so.shipping_address,
            so.billing_address,
            so.sales_channel_cleaned AS sales_channel,
            so.sales_rep_id,
            so.region_cleaned AS region,
            so.order_year,
            so.order_month,
            so.order_quarter,
            so.order_day_of_week,
            so.is_weekend,
            LAG(so.order_date) OVER (PARTITION BY so.customer_id ORDER BY so.order_date) AS prev_order_date,
            ROW_NUMBER() OVER (PARTITION BY so.customer_id ORDER BY so.order_date) AS order_sequence_number,
            CURRENT_TIMESTAMP() AS updated_timestamp
        FROM STAGING.stg_orders so
        WHERE so.data_quality_score >= 0.8 -- Only promote high quality records
    ) AS source ON target.order_id = source.order_id
    WHEN MATCHED THEN
        UPDATE SET
            customer_id = source.customer_id,
            order_date = source.order_date,
            order_status = source.order_status,
            total_amount = source.total_amount,
            currency_code = source.currency_code,
            payment_method = source.payment_method,
            shipping_address = source.shipping_address,
            billing_address = source.billing_address,
            sales_channel = source.sales_channel,
            sales_rep_id = source.sales_rep_id,
            region = source.region,
            order_year = source.order_year,
            order_month = source.order_month,
            order_quarter = source.order_quarter,
            order_day_of_week = source.order_day_of_week,
            is_weekend = source.is_weekend,
            days_since_last_order = COALESCE(DATEDIFF('day', source.prev_order_date, source.order_date), 0),
            is_first_order = (source.order_sequence_number = 1),
            order_sequence_number = source.order_sequence_number,
            updated_timestamp = source.updated_timestamp
    WHEN NOT MATCHED THEN
        INSERT (
            order_id, customer_id, order_date, order_status, total_amount,
            currency_code, payment_method, shipping_address, billing_address,
            sales_channel, sales_rep_id, region, order_year, order_month,
            order_quarter, order_day_of_week, is_weekend, days_since_last_order,
            is_first_order, order_sequence_number, updated_timestamp
        ) VALUES (
            source.order_id, source.customer_id, source.order_date, source.order_status,
            source.total_amount, source.currency_code, source.payment_method,
            source.shipping_address, source.billing_address, source.sales_channel,
            source.sales_rep_id, source.region, source.order_year, source.order_month,
            source.order_quarter, source.order_day_of_week, source.is_weekend,
            COALESCE(DATEDIFF('day', source.prev_order_date, source.order_date), 0),
            (source.order_sequence_number = 1), source.order_sequence_number,
            source.updated_timestamp
        );
    
    order_count := (SELECT COUNT(*) FROM orders);
    
    result := 'Successfully promoted data to curated: ' || customer_count || ' customers, ' || order_count || ' orders';
    
    RETURN result;
END;
$$
COMMENT = 'Promote high-quality staging data to curated layer';