!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Create CURATED schema if not exists
CREATE SCHEMA IF NOT EXISTS CURATED
    COMMENT = 'Curated schema for business-ready, high-quality data';

USE SCHEMA CURATED;

-- Create curated customers table
CREATE TABLE IF NOT EXISTS customers (
    customer_id NUMBER(38,0) NOT NULL,
    customer_key VARCHAR(50) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    full_name VARCHAR(200),
    email VARCHAR(255),
    email_domain VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(500),
    city VARCHAR(100),
    state VARCHAR(50),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    customer_segment VARCHAR(50),
    customer_tier VARCHAR(20),
    registration_date DATE,
    customer_age_days NUMBER(38,0),
    is_active BOOLEAN DEFAULT TRUE,
    lifetime_value NUMBER(12,2) DEFAULT 0,
    total_orders NUMBER(38,0) DEFAULT 0,
    last_order_date DATE,
    preferred_channel VARCHAR(50),
    created_timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    CONSTRAINT pk_customers PRIMARY KEY (customer_id),
    CONSTRAINT uk_customer_key UNIQUE (customer_key),
    CONSTRAINT uk_customer_email UNIQUE (email)
)
COMMENT = 'Curated customer master data for business consumption';

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_customers_segment ON customers(customer_segment);
CREATE INDEX IF NOT EXISTS idx_customers_tier ON customers(customer_tier);
CREATE INDEX IF NOT EXISTS idx_customers_email_domain ON customers(email_domain);
CREATE INDEX IF NOT EXISTS idx_customers_registration ON customers(registration_date);