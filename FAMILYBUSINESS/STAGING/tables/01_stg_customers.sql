!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Create STAGING schema if not exists
CREATE SCHEMA IF NOT EXISTS STAGING
    COMMENT = 'Staging schema for cleaned and transformed data';

USE SCHEMA STAGING;

-- Create staging customers table with data quality checks
CREATE TABLE IF NOT EXISTS stg_customers (
    customer_id NUMBER(38,0) NOT NULL,
    customer_key VARCHAR(50) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    full_name VARCHAR(200),
    email VARCHAR(255),
    email_domain VARCHAR(100),
    phone VARCHAR(20),
    phone_cleaned VARCHAR(20),
    address VARCHAR(500),
    city VARCHAR(100),
    state VARCHAR(50),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    customer_segment VARCHAR(50),
    registration_date DATE,
    customer_age_days NUMBER(38,0),
    is_active BOOLEAN DEFAULT TRUE,
    data_quality_score NUMBER(3,2) DEFAULT 1.00,
    data_quality_flags VARCHAR(500),
    processed_timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    source_system VARCHAR(50),
    CONSTRAINT pk_stg_customers PRIMARY KEY (customer_id)
)
COMMENT = 'Staging customer data with data quality enhancements';