USE ROLE sysadmin;

CREATE DATABASE IF NOT EXISTS SNOWPRO_DE_COURSE;

CREATE SCHEMA IF NOT EXISTS HR;

CREATE OR REPLACE TABLE EMPLOYEE_ABSENCE (
    employee_number integer,
    employee_name varchar(100),
    gender varchar(10),
    city varchar(100),
    job_title varchar(100),
    department varchar(100),
    store_location varchar(100),
    business_unit varchar(100),
    division varchar(100),
    age integer,
    length_of_service integer,
    hours_absent integer
);


CREATE OR REPLACE TABLE ENGAGEMENT_SURVEY (
    employee_id integer,
    employee_name varchar(100),
    gender varchar(10),
    age integer,
    department varchar(100),
    job_title varchar(100),
    satisfaction_score integer,
    work_life_balance_score integer,
    career_growth_opportunities_score integer,
    communication_score integer,
    teamwork_score integer,
);

CREATE STAGE HR_UPLOADS;