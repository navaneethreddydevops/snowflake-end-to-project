-- This file handles environment setup and variable definitions
!set variable_substitution=true;

USE ROLE $SNOWSQL_ENVVAR_ROLE;
USE DATABASE $SNOWSQL_ENVVAR_DB;
USE WAREHOUSE $SNOWSQL_ENVVAR_WH;
USE SCHEMA $SNOWSQL_ENVVAR_SCHEMA;