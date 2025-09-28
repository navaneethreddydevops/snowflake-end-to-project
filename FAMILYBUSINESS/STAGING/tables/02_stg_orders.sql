!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Use STAGING schema
USE SCHEMA STAGING;

-- Create staging orders table with enhanced data processing
CREATE TABLE IF NOT EXISTS stg_orders (
    order_id NUMBER(38,0) NOT NULL,
    customer_id NUMBER(38,0) NOT NULL,
    order_date DATE NOT NULL,
    order_status VARCHAR(50),
    order_status_cleaned VARCHAR(50),
    total_amount NUMBER(12,2) NOT NULL,
    currency_code VARCHAR(3) DEFAULT 'USD',
    payment_method VARCHAR(50),
    payment_method_cleaned VARCHAR(50),
    shipping_address VARCHAR(500),
    billing_address VARCHAR(500),
    sales_channel VARCHAR(50),
    sales_channel_cleaned VARCHAR(50),
    sales_rep_id NUMBER(38,0),
    region VARCHAR(100),
    region_cleaned VARCHAR(100),
    order_year NUMBER(4,0),
    order_month NUMBER(2,0),
    order_quarter NUMBER(1,0),
    order_day_of_week VARCHAR(10),
    is_weekend BOOLEAN,
    data_quality_score NUMBER(3,2) DEFAULT 1.00,
    data_quality_flags VARCHAR(500),
    processed_timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    source_system VARCHAR(50),
    CONSTRAINT pk_stg_orders PRIMARY KEY (order_id)
)
COMMENT = 'Staging order data with enhanced processing and date dimensions';