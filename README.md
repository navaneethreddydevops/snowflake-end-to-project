# Snowflake Environment Setup

This repository contains the setup for DEV and QA environments in Snowflake.

## Environment Access

### Development (DEV) Environment
- URL: `https://app.snowflake.com/xzqcbxw/qn65717/#/homepage`
- Purpose: For development and testing of new features
- Access: Limited to development team members

### QA Environment
- URL: `https://app.snowflake.com/rfzluua/hp50284/#/homepage`
- Purpose: For quality assurance and testing
- Access: Limited to QA team members and testers


### PROD Environment
- URL: `https://onsxlus-rq01472.snowflakecomputing.com`
- Purpose: Production environment for live data
- Access: Limited to authorized production support team members

## Environment Structure

### Development (DEV) Environment
- Warehouse: `DEV_WH` (X-Small, auto-suspend: 300s)
- Database: `DEV_DB`
- Schemas: 
  - `RAW`
  - `STAGE`
  - `CURATED`
- Role: `DEV_ROLE`

### QA Environment
- Warehouse: `QA_WH` (X-Small, auto-suspend: 300s)
- Database: `QA_DB`
- Schemas:
  - `RAW`
  - `STAGE`
  - `CURATED`
- Role: `QA_ROLE`

## Access Control
- Each environment has its dedicated role (`DEV_ROLE`, `QA_ROLE`)
- Roles have full access to their respective environments:
  - Warehouse usage
  - Database and schema access
  - Table operations (SELECT, INSERT, UPDATE, DELETE)
  - Future grants for new schemas and tables

## Best Practices
1. Always use the appropriate role for each environment
2. Keep environments synchronized in terms of schema structure
3. Test all changes in DEV before promoting to QA
4. Use separate warehouses for optimal resource management

## Getting Started
1. Connect to Snowflake using your credentials
2. Switch to the appropriate role:
   ```sql
   USE ROLE DEV_ROLE;  -- For development work
   USE ROLE QA_ROLE;   -- For QA work
   ```
3. Set the context:
   ```sql
   USE WAREHOUSE DEV_WH;  -- or QA_WH
   USE DATABASE DEV_DB;   -- or QA_DB
   ```