!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Use RAW schema
USE SCHEMA RAW;

-- Create internal stage for raw data ingestion
CREATE STAGE IF NOT EXISTS RAW_DATA_STAGE
    FILE_FORMAT = (FORMAT_NAME = 'RAW_CSV_FORMAT')
    DIRECTORY = (ENABLE = TRUE)
COMMENT = 'Internal stage for raw data file ingestion';

-- Create external stage for S3 data ingestion (template)
-- CREATE OR REPLACE STAGE S3_RAW_DATA_STAGE
--     URL = 's3://your-bucket-name/raw-data/'
--     CREDENTIALS = (AWS_KEY_ID = 'your-access-key-id' AWS_SECRET_KEY = 'your-secret-access-key')
--     FILE_FORMAT = (FORMAT_NAME = 'RAW_CSV_FORMAT')
-- COMMENT = 'S3 stage for raw data ingestion';

-- Create stage for error handling and rejected records
CREATE STAGE IF NOT EXISTS RAW_ERROR_STAGE
    FILE_FORMAT = (FORMAT_NAME = 'RAW_CSV_FORMAT')
    DIRECTORY = (ENABLE = TRUE)
COMMENT = 'Stage for storing rejected and error records';