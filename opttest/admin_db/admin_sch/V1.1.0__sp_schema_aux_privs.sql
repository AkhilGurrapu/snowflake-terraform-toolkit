use role sysadmin;
use database admin_db;
--
-- add (or revoke) schema privileges unique to this account
--
create or replace procedure admin_db.admin_sch.sp_schema_aux_privs(
	db_name varchar,       -- database name for new schema
	schema_name varchar    -- schema name
)
returns varchar
language sql
execute as owner
as
$$ß
begin
    return ('No auxillary privs for this account');
end;
$$;

grant usage on procedure admin_db.admin_sch.sp_schema_aux_privs(varchar, varchar) to role sysops;