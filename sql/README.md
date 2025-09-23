# SQL Migration Scripts

This directory contains all the SQL migration scripts for the Snowflake project. The scripts are executed in order based on their version numbers using schemachange.

## Version Control Guidelines

### File Naming Convention
- All migration scripts must follow the naming pattern: `V[Version]__[Description].sql`
- Example: `V1.0.0__setup.sql`, `V1.0.1__create_tables.sql`
- Double underscore `__` is required between version and description
- Version numbers should follow semantic versioning (MAJOR.MINOR.PATCH)

### Script Headers
Each SQL file must include the following header:
```sql
-- Change History Information
-- VERSION:      [version number]
-- DESCRIPTION:  [brief description]
-- CREATED:      [creation date]
-- AUTHOR:       [author name/team]
```

### Using Variables
Schemachange supports variable substitution in SQL scripts using the following syntax:
```sql
USE ROLE {{ ROLE }};
USE DATABASE {{ DATABASE }};
USE WAREHOUSE {{ WAREHOUSE }};
USE SCHEMA {{ SCHEMA }};
```

Available variables:
- `{{ ROLE }}` - Target Snowflake role
- `{{ DATABASE }}` - Target database
- `{{ WAREHOUSE }}` - Target warehouse
- `{{ SCHEMA }}` - Target schema

These variables are passed to schemachange using the `--vars` parameter in the deployment workflow.

### Change History Table
Schemachange tracks all deployments in:
```sql
DATABASE.SCHEMACHANGE.CHANGE_HISTORY
```

### Current Scripts
1. `V1.0.0__setup.sql` - Initial environment setup and access management
2. `V1.0.1__test_deployment.sql` - Test deployment creating sample tables

## Best Practices
1. Always include proper comments in SQL scripts
2. Each script should be idempotent when possible
3. Use appropriate schema references
4. Include rollback scripts where applicable
5. Test scripts in lower environments first