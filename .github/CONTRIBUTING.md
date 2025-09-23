# Contributing Guidelines

## Development Workflow

### Branch Strategy
- `master`: Production-ready code
- `develop`: Development branch for feature integration
- Feature branches: Create from `develop` with format `feature/description`

### Environment Stages
1. DEV: Initial development and testing
2. QA: Quality assurance validation
3. PROD: Production deployment

### SQL Development Guidelines

#### File Naming
- Use lowercase with underscores
- Include version numbers for migrations
- Prefix with object type
```sql
V001_create_customer_table.sql
V002_add_email_to_customer.sql
create_sales_summary_view.sql
```

#### SQL Best Practices
1. Always use `!set variable_substitution=true;` at the start of SQL files
2. Use environment variables:
   ```sql
   USE ROLE &SNOWSQL_ENVVAR_ROLE;
   USE DATABASE &SNOWSQL_ENVVAR_DB;
   USE WAREHOUSE &SNOWSQL_ENVVAR_WH;
   USE SCHEMA &SNOWSQL_ENVVAR_SCHEMA;
   ```
3. Make scripts idempotent using `IF NOT EXISTS`
4. Include proper comments and documentation

### Pull Request Process
1. Create feature branch from `develop`
2. Implement changes following SQL guidelines
3. Test in DEV environment
4. Submit PR to `develop`
5. Await review and CI/CD pipeline completion
6. Merge after approval

### CI/CD Pipeline
The repository uses GitHub Actions for automated deployment:
- SQL linting with SQLFluff
- Automatic deployment to DEV on merge to `develop`
- Staged deployment to QA and PROD on merge to `master`

## Repository Structure
```
├── .github/
│   └── workflows/          # GitHub Actions workflows
├── bootstrap/             # Environment setup scripts
│   ├── DEV.sql
│   ├── QA.sql
│   └── PROD.sql
└── sql/                  # SQL deployment scripts
    ├── 00_setup.sql     # Initial setup and permissions
    └── test_deployment.sql  # Sample deployment script
```

## Environment Variables
Required secrets in GitHub:
- `SNOWFLAKE_ACCOUNT`: Your Snowflake account identifier
- `SNOWFLAKE_USERNAME`: Deployment user with appropriate permissions
- `SNOWFLAKE_PASSWORD`: User password

## Testing
1. Local Testing:
   ```bash
   snowsql -c dev -f your_script.sql --variable SNOWSQL_ENVVAR_ROLE=DEV_ROLE
   ```
2. Automated Testing:
   - SQLFluff validation
   - Development environment deployment

## Questions?
Contact the repository maintainers for additional guidance.