-- Test deployment SQL file
-- Creates a test table in the DEV environment
-- Variables will be substituted during deployment:
--   env_db: Target database
--   env_wh: Target warehouse
--   env_schema: Target schema

!set variable_substitution=true;

USE ROLE DEV_ROLE;
USE DATABASE IDENTIFIER(:env_db);
USE WAREHOUSE IDENTIFIER(:env_wh);
USE SCHEMA IDENTIFIER(:env_schema);

-- Create a test table
CREATE TABLE IF NOT EXISTS test_deployment (
    id INTEGER,
    test_name VARCHAR(50),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Insert a test record
INSERT INTO test_deployment (id, test_name)
VALUES (1, 'Initial Deployment Test');