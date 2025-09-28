!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Use RAW schema
USE SCHEMA RAW;

-- Create external stage for S3 data ingestion
CREATE OR REPLACE STAGE s3_raw_data_stage
    URL = 's3://your-bucket-name/raw-data/'
    CREDENTIALS = (AWS_KEY_ID = 'your-access-key-id' AWS_SECRET_KEY = 'your-secret-access-key')
    FILE_FORMAT = csv_format
    COMMENT = 'S3 stage for raw data ingestion';

-- Create internal stage for temporary data processing
CREATE OR REPLACE STAGE internal_raw_stage
    FILE_FORMAT = csv_format
    COMMENT = 'Internal stage for raw data processing';

-- Create stage for error handling and rejected records
CREATE OR REPLACE STAGE error_stage
    FILE_FORMAT = csv_format
    COMMENT = 'Stage for storing rejected and error records';