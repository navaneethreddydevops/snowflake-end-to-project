-- This file handles environment setup and variable definitions
!set variable_substitution=true;

USE ROLE &{env_role};
USE DATABASE &{env_db};
USE WAREHOUSE &{env_wh};
USE SCHEMA &{env_schema};