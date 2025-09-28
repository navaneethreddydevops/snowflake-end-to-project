!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Use CURATED schema
USE SCHEMA CURATED;

-- Create curated orders table
CREATE TABLE IF NOT EXISTS orders (
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
    order_year NUMBER(4,0),
    order_month NUMBER(2,0),
    order_quarter NUMBER(1,0),
    order_day_of_week VARCHAR(10),
    is_weekend BOOLEAN,
    days_since_last_order NUMBER(38,0),
    is_first_order BOOLEAN DEFAULT FALSE,
    order_sequence_number NUMBER(38,0),
    created_timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    CONSTRAINT pk_orders PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
)
COMMENT = 'Curated order data for business consumption and analytics';

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_orders_customer ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_date ON orders(order_date);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(order_status);
CREATE INDEX IF NOT EXISTS idx_orders_channel ON orders(sales_channel);
CREATE INDEX IF NOT EXISTS idx_orders_region ON orders(region);