use role sysadmin;
use database admin_db;
/*
* create integration and assign access roles
*/
CREATE OR REPLACE PROCEDURE sp_create_integration(
  integration_sql  VARCHAR,  -- full CREATE [OR REPLACE] … INTEGRATION … statement
  integration_name VARCHAR   -- the integration's name (e.g. 'MY_S3_INT')
)
RETURNS VARCHAR
LANGUAGE SQL
EXECUTE AS OWNER
AS
$$
DECLARE
  ops_role VARCHAR DEFAULT 'int_' || integration_name || '_ops';
  usage_role VARCHAR DEFAULT 'int_' || integration_name || '_use';
BEGIN
  -- create or replace the integration
  EXECUTE IMMEDIATE integration_sql;

  -- create the ops role
  EXECUTE IMMEDIATE 
    'CREATE ROLE IF NOT EXISTS ' || ops_role;

  -- create the usage role
  EXECUTE IMMEDIATE 
    'CREATE ROLE IF NOT EXISTS ' || usage_role;

  -- grant all on integration to ops role
  EXECUTE IMMEDIATE 
    'GRANT ALL ON INTEGRATION ' || integration_name || ' TO ROLE ' || ops_role;

  -- grant usage on the integration to usage role
  EXECUTE IMMEDIATE 
    'GRANT USAGE ON INTEGRATION ' || integration_name || ' TO ROLE ' || usage_role;

  -- assign roles to sysops so environment tier can grant
  EXECUTE IMMEDIATE 
    'GRANT OWNERSHIP ON ROLE ' || ops_role || ' TO ROLE SYSOPS';
  EXECUTE IMMEDIATE 
    'GRANT OWNERSHIP ON ROLE ' || usage_role || ' TO ROLE SYSOPS';

  RETURN 'SUCCESS: ' || integration_name;
END;
$$;

GRANT USAGE ON PROCEDURE sp_create_integration(VARCHAR, VARCHAR)
  TO ROLE SYSOPS;
