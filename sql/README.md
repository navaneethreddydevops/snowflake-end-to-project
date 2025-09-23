# SQL Scripts

This directory contains all the SQL scripts that will be deployed to Snowflake environments.

## Directory Structure
```
sql/
├── tables/          # Table creation scripts
├── views/           # View creation scripts
├── procedures/      # Stored procedures
└── migrations/      # Schema migration scripts
```

## Naming Convention
Follow these naming conventions for SQL scripts:
- Use lowercase with underscores
- Include version numbers for migrations
- Prefix with type of object being created/modified

Examples:
```
V001_create_customer_table.sql
V002_add_email_to_customer.sql
create_sales_summary_view.sql
sp_process_daily_sales.sql
```

## Best Practices
1. Always include proper comments in SQL scripts
2. Each script should be idempotent when possible
3. Use appropriate schema references
4. Include rollback scripts where applicable
5. Test scripts in lower environments first