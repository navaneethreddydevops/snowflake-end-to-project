!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Use RAW schema
USE SCHEMA RAW;

-- Create raw orders table
CREATE TABLE IF NOT EXISTS raw_orders (
    order_id NUMBER(38,0) NOT NULL,
    customer_id NUMBER(38,0) NOT NULL,
    order_date DATE NOT NULL,
    order_status VARCHAR(50),
    total_amount NUMBER(12,2) NOT NULL,
    currency_code VARCHAR(3) DEFAULT 'USD',
    payment_method VARCHAR(50),
    shipping_address VARCHAR(500),
    billing_address VARCHAR(500),
    sales_channel VARCHAR(50),
    sales_rep_id NUMBER(38,0),
    region VARCHAR(100),
    source_system VARCHAR(50) DEFAULT 'ERP',
    ingestion_timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    file_name VARCHAR(255),
    row_number NUMBER(38,0),
    CONSTRAINT pk_raw_orders PRIMARY KEY (order_id)
)
COMMENT = 'Raw order data from source systems';