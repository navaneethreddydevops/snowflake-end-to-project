!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Create RAW schema if not exists
CREATE SCHEMA IF NOT EXISTS RAW
    COMMENT = 'Raw data schema for ingested source data';

USE SCHEMA RAW;

-- Create raw customers table
CREATE TABLE IF NOT EXISTS raw_customers (
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
    is_active BOOLEAN DEFAULT TRUE,
    source_system VARCHAR(50) DEFAULT 'CRM',
    ingestion_timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    file_name VARCHAR(255),
    row_number NUMBER(38,0),
    CONSTRAINT pk_raw_customers PRIMARY KEY (customer_id)
)
COMMENT = 'Raw customer data from source systems';