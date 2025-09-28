!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Create ANALYTICS schema if not exists
CREATE SCHEMA IF NOT EXISTS ANALYTICS
    COMMENT = 'Analytics schema for dimensional tables and analytical views';

USE SCHEMA ANALYTICS;

-- Create dimension table for customer analytics
CREATE TABLE IF NOT EXISTS dim_customer (
    customer_id NUMBER(38,0) NOT NULL,
    customer_key VARCHAR(50) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255),
    phone VARCHAR(20),
    address VARCHAR(500),
    city VARCHAR(100),
    state VARCHAR(50),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    customer_segment VARCHAR(50),
    registration_date DATE,
    last_updated_date TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    is_active BOOLEAN DEFAULT TRUE,
    CONSTRAINT pk_dim_customer PRIMARY KEY (customer_id)
)
COMMENT = 'Customer dimension table for analytics';

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_dim_customer_key ON dim_customer(customer_key);
CREATE INDEX IF NOT EXISTS idx_dim_customer_segment ON dim_customer(customer_segment);
CREATE INDEX IF NOT EXISTS idx_dim_customer_email ON dim_customer(email);