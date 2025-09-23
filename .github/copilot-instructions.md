# GitHub Custom Instructions

## About this Project
This is a Snowflake environment management project that uses GitHub Actions for automated CI/CD deployments. The project manages DEV, QA, and PROD environments in Snowflake through automated pipelines.

## Project Structure
```
├── .github/
│   ├── workflows/
│   │   ├── snowflake-deploy-dev.yml     # DEV deployment workflow
│   │   └── snowflake-qa-prod-deploy.yml # QA and PROD deployment workflow
├── bootstrap/                           # Environment setup scripts
│   ├── DEV.sql
│   ├── QA.sql
│   └── PROD.sql
└── sql/                                # SQL deployment scripts
    ├── 00_setup.sql                    # Initial setup and permissions
    ├── grant_access.sql                # Access management
    └── test_deployment.sql             # Sample deployment script
```

## Environment Configuration

### Development (DEV)
- Database: `DEV_DB`
- Warehouse: `DEV_WH`
- Role: `DEV_ROLE`
- Schema: `PUBLIC`

### QA
- Database: `QA_DB`
- Warehouse: `QA_WH`
- Role: `QA_ROLE`
- Schema: `PUBLIC`

### Production (PROD)
- Database: `PROD_DB`
- Warehouse: `PROD_WH`
- Role: `PROD_ROLE`
- Schema: `PUBLIC`

## CI/CD Pipeline Configuration

### Required Secrets
- `SNOWFLAKE_ACCOUNT`
- `SNOWFLAKE_USERNAME`
- `SNOWFLAKE_PASSWORD`

### Deployment Process
1. SQL files are validated using SQLFluff
2. Files are deployed in alphabetical order
3. Environment variables are substituted during deployment

### Branch Strategy
- `master`: Production deployments
- `develop`: Development work
- Feature branches: `feature/*`

## SQL Guidelines
1. Include variable substitution header:
```sql
!set variable_substitution=true;
```

2. Use environment variables:
```sql
USE ROLE &SNOWSQL_ENVVAR_ROLE;
USE DATABASE &SNOWSQL_ENVVAR_DB;
USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;
```

3. Make scripts idempotent using `IF EXISTS/IF NOT EXISTS`

## Pull Request Templates
When creating pull requests:
1. Specify target environment
2. Include SQL script testing results
3. Reference any related issues
4. List changes and impacts

## Issue Labels
- `environment/dev`
- `environment/qa`
- `environment/prod`
- `type/feature`
- `type/bugfix`
- `type/schema-change`

## Code Review Guidelines
1. Check SQL best practices
2. Verify environment variable usage
3. Ensure idempotent operations
4. Validate permissions and grants