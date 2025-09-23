-- Test deployment SQL file
-- Creates a test table in the environment

-- Create a test table
CREATE TABLE IF NOT EXISTS test_deployment (
    id INTEGER,
    test_name VARCHAR(50),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Insert a test record
INSERT INTO test_deployment (id, test_name)
VALUES (1, 'Initial Deployment Test');
