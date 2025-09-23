-- Test deployment SQL file
-- Creates a test table in the DEV environment

USE DATABASE &env_db;
USE WAREHOUSE &env_wh;
USE SCHEMA &env_schema;

-- Create a test table
CREATE TABLE IF NOT EXISTS test_deployment (
    id INTEGER,
    test_name VARCHAR(50),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Insert a test record
INSERT INTO test_deployment (id, test_name)
VALUES (1, 'Initial Deployment Test');