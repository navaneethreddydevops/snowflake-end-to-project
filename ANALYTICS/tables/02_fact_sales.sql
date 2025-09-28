!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Use ANALYTICS schema
USE SCHEMA ANALYTICS;

-- Create fact table for sales analytics
CREATE TABLE IF NOT EXISTS fact_sales (
    sales_id NUMBER(38,0) NOT NULL,
    customer_id NUMBER(38,0) NOT NULL,
    product_id NUMBER(38,0) NOT NULL,
    order_date DATE NOT NULL,
    quantity NUMBER(10,2) NOT NULL,
    unit_price NUMBER(10,2) NOT NULL,
    total_amount NUMBER(12,2) NOT NULL,
    discount_amount NUMBER(10,2) DEFAULT 0,
    tax_amount NUMBER(10,2) DEFAULT 0,
    net_amount NUMBER(12,2) NOT NULL,
    sales_channel VARCHAR(50),
    sales_rep_id NUMBER(38,0),
    region VARCHAR(100),
    created_timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    CONSTRAINT pk_fact_sales PRIMARY KEY (sales_id)
)
COMMENT = 'Sales fact table for analytics and reporting';

-- Create indexes for analytical queries
CREATE INDEX IF NOT EXISTS idx_fact_sales_customer ON fact_sales(customer_id);
CREATE INDEX IF NOT EXISTS idx_fact_sales_product ON fact_sales(product_id);
CREATE INDEX IF NOT EXISTS idx_fact_sales_date ON fact_sales(order_date);
CREATE INDEX IF NOT EXISTS idx_fact_sales_channel ON fact_sales(sales_channel);