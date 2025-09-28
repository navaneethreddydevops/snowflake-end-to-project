!set variable_substitution=true;

USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;

-- Create REPORTING schema if not exists
CREATE SCHEMA IF NOT EXISTS REPORTING
    COMMENT = 'Reporting schema for business reports and dashboards';

USE SCHEMA REPORTING;

-- Create monthly sales report table
CREATE TABLE IF NOT EXISTS rpt_monthly_sales (
    report_id NUMBER(38,0) AUTOINCREMENT,
    year_month VARCHAR(7) NOT NULL, -- Format: YYYY-MM
    sales_channel VARCHAR(50),
    region VARCHAR(100),
    total_orders NUMBER(38,0) NOT NULL,
    total_customers NUMBER(38,0) NOT NULL,
    total_revenue NUMBER(15,2) NOT NULL,
    total_quantity NUMBER(15,2) NOT NULL,
    avg_order_value NUMBER(10,2) NOT NULL,
    discount_percentage NUMBER(5,2) DEFAULT 0,
    created_date DATE DEFAULT CURRENT_DATE(),
    created_timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    CONSTRAINT pk_rpt_monthly_sales PRIMARY KEY (report_id),
    CONSTRAINT uk_monthly_sales UNIQUE (year_month, sales_channel, region)
)
COMMENT = 'Monthly sales summary report table';

-- Create indexes for reporting queries
CREATE INDEX IF NOT EXISTS idx_rpt_monthly_sales_period ON rpt_monthly_sales(year_month);
CREATE INDEX IF NOT EXISTS idx_rpt_monthly_sales_channel ON rpt_monthly_sales(sales_channel);