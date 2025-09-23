-- Change History Information
-- VERSION:      1.0.1
-- DESCRIPTION:  Test deployment creating sample tables
-- CREATED:      2025-09-23
-- AUTHOR:       DevOps Team

USE ROLE {{ ROLE }};
USE DATABASE {{ DATABASE }};
USE WAREHOUSE {{ WAREHOUSE }};
USE SCHEMA {{ SCHEMA }};

-- Create a test table
CREATE TABLE IF NOT EXISTS test_deployment (
    id INTEGER,
    test_name VARCHAR(50),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Insert a test record
INSERT INTO test_deployment (id, test_name)
VALUES (1, 'Initial Deployment Test');

DROP TABLE IF EXISTS test_deployment;