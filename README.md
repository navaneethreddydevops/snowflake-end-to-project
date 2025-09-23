# Snowflake Environment Setup

This repository manages Snowflake environments through automated CI/CD pipelines using GitHub Actions.

## Quick Start

### Prerequisites
- SnowSQL CLI v1.4.5 or higher
- Access to Snowflake environments
- GitHub repository access with appropriate permissions

### Local Development
1. Clone the repository:
   ```bash
   git clone https://github.com/navaneethreddydevops/snowflake-end-to-project.git
   cd snowflake-end-to-project
   ```

2. Create a new feature branch:
   ```bash
   git checkout develop
   git checkout -b feature/your-feature
   ```

3. Test locally:
   ```bash
   snowsql -c dev -f sql/your_script.sql \
     --variable SNOWSQL_ENVVAR_ROLE=DEV_ROLE \
     --variable SNOWSQL_ENVVAR_DB=DEV_DB \
     --variable SNOWSQL_ENVVAR_WH=DEV_WH \
     --variable SNOWSQL_ENVVAR_SCHEMA=PUBLIC
   ```

## Environment Details

### Development (DEV)
- Database: `DEV_DB`
- Warehouse: `DEV_WH`
- Role: `DEV_ROLE`
- Schema: `PUBLIC`

## Deployment Process

### Automated Deployments
1. Push to `develop` triggers:
   - SQL linting
   - DEV environment deployment
2. All SQL files are executed in sequence:
   - `00_setup.sql` (sets up permissions)
   - Remaining SQL files in alphabetical order

### Manual Deployment
```bash
# Deploy setup script
snowsql -c dev -f sql/00_setup.sql \
  --variable SNOWSQL_ENVVAR_ROLE=DEV_ROLE \
  --variable SNOWSQL_ENVVAR_DB=DEV_DB \
  --variable SNOWSQL_ENVVAR_WH=DEV_WH \
  --variable SNOWSQL_ENVVAR_SCHEMA=PUBLIC

# Deploy other scripts
snowsql -c dev -f sql/your_script.sql \
  --variable SNOWSQL_ENVVAR_ROLE=DEV_ROLE \
  --variable SNOWSQL_ENVVAR_DB=DEV_DB \
  --variable SNOWSQL_ENVVAR_WH=DEV_WH \
  --variable SNOWSQL_ENVVAR_SCHEMA=PUBLIC
```

## SQL Scripts

### 00_setup.sql
- Sets up initial permissions
- Creates required objects if they don't exist
- Grants necessary privileges to DEV_ROLE

### test_deployment.sql
- Creates a sample table
- Demonstrates proper SQL script structure
- Shows variable substitution usage

## Contributing
See [Contributing Guidelines](.github/CONTRIBUTING.md) for detailed information.

## Security
- Environment credentials stored as GitHub Secrets
- Role-based access control
- Automated deployment uses dedicated service account

## Troubleshooting

### Common Issues
1. Variable substitution errors:
   - Ensure `!set variable_substitution=true;` is at the start of SQL files
   - Use `&` prefix for variables in SQL files
   - Pass variables using `--variable` flag

2. Permission errors:
   - Verify `00_setup.sql` has executed successfully
   - Check role permissions in Snowflake
   - Ensure deployment user has appropriate access

## Support
Contact repository maintainers for assistance with setup or deployment issues.

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