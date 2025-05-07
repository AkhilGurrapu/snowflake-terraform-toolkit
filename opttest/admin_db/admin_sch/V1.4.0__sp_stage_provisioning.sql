--
-- this is necessary because securityadmin doesn't have access to admin_db
--
use role futureops;
drop procedure if exists admin_db.admin_sch.sp_schema_roles(varchar, varchar);
use role sysadmin;
use database admin_db;
--
-- Create schema level access roles
-- This proc must run as securityadmin to perform future grants - ownership changed at bottom
--
create or replace procedure admin_db.admin_sch.sp_schema_roles(
	db_name varchar,       -- database name for new schema
	schema_name varchar    -- schema name
)
/*
* Assigns privileges to schema roles for a new schema in an EDP team space
*   Ref: allows references to tables and views for cross-schema views
*   View: allows read-only access to views
*   Read: allows read-only access to tables and views
*   Write: general CRUD access to most objects; owns tables, view, sequences
*   Create: CRUD access to nearly all objects
*   Schadmin: Pretty much everything except ownership of the schema
*/
returns varchar
language sql
execute as owner
as
$$
declare
qualified_schema varchar default db_name || '.' || schema_name;
	role_qualifier varchar default db_name || '_' || schema_name;

	ref_role varchar default qualified_schema || '_ref';
	view_role varchar default qualified_schema || '_view';
	read_role varchar default qualified_schema || '_read';
	write_role varchar default qualified_schema || '_write';
	create_role varchar default qualified_schema || '_create';
	schadmin_role varchar default qualified_schema || '_schadmin';
begin

--
-- ref
--
    grant usage on schema identifier(:qualified_schema) to database role identifier(:ref_role);

    grant references on all tables in schema identifier(:qualified_schema) to database role identifier(:ref_role);
    grant references on all views in schema identifier(:qualified_schema) to database role identifier(:ref_role);

    grant references on future tables in schema identifier(:qualified_schema) to database role identifier(:ref_role);
    grant references on future views in schema identifier(:qualified_schema) to database role identifier(:ref_role);

--
-- view
--
    grant usage on schema identifier(:qualified_schema) to database role identifier(:view_role);

    grant references on all tables in schema identifier(:qualified_schema) to database role identifier(:view_role);
    grant select on all views in schema identifier(:qualified_schema) to database role identifier(:view_role);

    grant references on future tables in schema identifier(:qualified_schema) to database role identifier(:view_role);
    grant select on future views in schema identifier(:qualified_schema) to database role identifier(:view_role);

--
-- read
--
    grant usage on schema identifier(:qualified_schema) to database role identifier(:read_role);

    grant select on all tables in schema identifier(:qualified_schema) to database role identifier(:read_role);
    grant select on all views in schema identifier(:qualified_schema) to database role identifier(:read_role);

    grant select on future tables in schema identifier(:qualified_schema) to database role identifier(:read_role);
    grant select on future views in schema identifier(:qualified_schema) to database role identifier(:read_role);

--
-- write
--
    grant usage on schema identifier(:qualified_schema) to database role identifier(:write_role);
    grant monitor on schema identifier(:qualified_schema) to database role identifier(:write_role);
    grant create table on schema identifier(:qualified_schema) to database role identifier(:write_role);
    grant create temporary table on schema identifier(:qualified_schema) to database role identifier(:write_role);
    grant create view on schema identifier(:qualified_schema) to database role identifier(:write_role);
    grant create procedure on schema identifier(:qualified_schema) to database role identifier(:write_role);
    grant create sequence on schema identifier(:qualified_schema) to database role identifier(:write_role);
    grant create function on schema identifier(:qualified_schema) to database role identifier(:write_role);
    grant create streamlit on schema identifier(:qualified_schema) to database role identifier(:write_role);
    grant create task on schema identifier(:qualified_schema) to database role identifier(:write_role);

    grant ownership on all tables in schema identifier(:qualified_schema) to database role identifier(:write_role) copy current grants;
    grant ownership on all views in schema identifier(:qualified_schema) to database role identifier(:write_role) copy current grants;
    grant all on all external tables in schema identifier(:qualified_schema) to database role identifier(:write_role);
    grant usage on all stages in schema identifier(:qualified_schema) to database role identifier(:write_role);

    grant ownership on future tables in schema identifier(:qualified_schema) to database role identifier(:write_role) copy current grants;
    grant ownership on future views in schema identifier(:qualified_schema) to database role identifier(:write_role) copy current grants;
    grant all on future external tables in schema identifier(:qualified_schema) to database role identifier(:write_role);
    grant usage on future stages in schema identifier(:qualified_schema) to database role identifier(:write_role);

--
-- create
--
    grant database role identifier(:write_role) to database role identifier(:create_role);

    grant create file format on schema identifier(:qualified_schema) to database role identifier(:create_role);
    grant create masking policy on schema identifier(:qualified_schema) to database role identifier(:create_role);
    grant create pipe on schema identifier(:qualified_schema) to database role identifier(:create_role);
    grant create row access policy on schema identifier(:qualified_schema) to database role identifier(:create_role);
    grant create stage on schema identifier(:qualified_schema) to database role identifier(:create_role);
    grant create tag on schema identifier(:qualified_schema) to database role identifier(:create_role);

    grant ownership on all external tables in schema identifier(:qualified_schema) to database role identifier(:create_role) copy current grants;
    grant ownership on all streams in schema identifier(:qualified_schema) to database role identifier(:create_role) copy current grants;

    grant ownership on future external tables in schema identifier(:qualified_schema) to database role identifier(:create_role) copy current grants;
    grant ownership on future file formats in schema identifier(:qualified_schema) to database role identifier(:create_role) copy current grants;
    grant ownership on future streams in schema identifier(:qualified_schema) to database role identifier(:create_role) copy current grants;

--
-- schadmin
--
    grant database role identifier(:create_role) to database role identifier(:schadmin_role);

    grant all on schema identifier(:qualified_schema) to database role identifier(:schadmin_role);


return ('Roles for schema ' || qualified_schema || ' assigned');
end;
$$;

grant usage on procedure admin_db.admin_sch.sp_schema_roles(varchar, varchar) to role sysops;
use role futureops;
grant ownership on procedure admin_db.admin_sch.sp_schema_roles(varchar, varchar) to role futureops copy current grants;