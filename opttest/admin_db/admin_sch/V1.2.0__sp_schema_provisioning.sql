use role sysadmin;
use database admin_db;
/*
* create schema and assign access roles
*/
create or replace procedure admin_db.admin_sch.sp_schema_provisioning(
	db_name varchar,       -- database name for new schema
	schema_name varchar    -- schema name
)
returns varchar
language sql
execute as owner
as
$$
declare
qualified_schema varchar default db_name || '.' || schema_name;

begin
    --
    -- create schema (do not replace as that would drop objects)
    --
    create schema if not exists identifier(:qualified_schema);

    --
    -- create schema roles (requires sysops)
    --
    call admin_db.admin_sch.sp_create_schema_roles(:db_name, :schema_name);
    --
    -- perform grants (requires securityadmin)
    --
    call admin_db.admin_sch.sp_schema_roles(:db_name, :schema_name);

    --
    -- auxillary account-level permissions
    --
    call admin_db.admin_sch.sp_schema_aux_privs(:db_name, :schema_name);

    return ('Schema ' || qualified_schema || 'built successfully');
end;
$$;

grant usage on procedure admin_db.admin_sch.sp_schema_provisioning(varchar, varchar) to role sysops;