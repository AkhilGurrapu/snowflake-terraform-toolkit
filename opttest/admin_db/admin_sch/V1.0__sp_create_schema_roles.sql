
use role futureops;
drop procedure if exists admin_db.admin_sch.sp_create_schema_roles(varchar, varchar);
use role sysadmin;
use database admin_db;
--
-- Create schema level access roles
-- This routine runs as sysops so all object-level ROLES (not ojbects) are owned by the environment tier
--
create or replace procedure admin_db.admin_sch.sp_create_schema_roles(
	db_name varchar,       -- database name for new schema
	schema_name varchar    -- schema name
)
/*
* Creates schema roles for a new schema in an EDP team space
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
--
-- these will go away, but we need to maintain them during the transition
--
	legacy_ref_role varchar default role_qualifier || '_ref';
	legacy_view_role varchar default role_qualifier || '_view';
	legacy_read_role varchar default role_qualifier || '_read';
	legacy_write_role varchar default role_qualifier || '_write';
	legacy_create_role varchar default role_qualifier || '_create';
	legacy_schadmin_role varchar default role_qualifier || '_schadmin';
begin
--
-- first drop any existing roles to avoid problems with grant transfer
-- this will tempoarily grant all existing objects to the owner role (presumed sysops)
-- drop in descending order to avoid cascades
--
drop role if exists identifier(:legacy_schadmin_role);
drop role if exists identifier(:legacy_create_role);
drop role if exists identifier(:legacy_write_role);
drop role if exists identifier(:legacy_read_role);
drop role if exists identifier(:legacy_view_role);
drop role if exists identifier(:legacy_ref_role);

drop database role if exists identifier(:schadmin_role);
	drop database role if exists identifier(:create_role);
	drop database role if exists identifier(:write_role);
	drop database role if exists identifier(:read_role);
	drop database role if exists identifier(:view_role);
	drop database role if exists identifier(:ref_role);

--
-- create new roles
--
    create database role identifier(:ref_role)
        comment = "reference to tables and views to allow cross-schema views";
    create database role identifier(:view_role)
        comment = "reference to tables and select on views";
    create database role identifier(:read_role)
        comment = "read access to tables and views";
    create database role identifier(:write_role)
        comment = "full CRUD access to most objects";
    create database role identifier(:create_role)
        comment = "write plus ownership of external tables, file formats, streams, stages";
    create database role identifier(:schadmin_role)
        comment = "create plus all other schema privileges";
--
-- assign to legacy roles (short term, but keeps things from breaking while we convert all existing schemas)
--
create role identifier(:legacy_schadmin_role);
create role identifier(:legacy_create_role);
create role identifier(:legacy_write_role);
create role identifier(:legacy_read_role);
create role identifier(:legacy_view_role);
create role identifier(:legacy_ref_role);

grant database role identifier(:ref_role) to role identifier(:legacy_ref_role);
	grant database role identifier(:view_role) to role identifier(:legacy_view_role);
	grant database role identifier(:read_role) to role identifier(:legacy_read_role);
	grant database role identifier(:write_role) to role identifier(:legacy_write_role);
	grant database role identifier(:create_role) to role identifier(:legacy_create_role);
	grant database role identifier(:schadmin_role) to role identifier(:legacy_schadmin_role);
--
-- change ownership for object roles so sysops can assign as needed
--
	grant ownership on database role identifier(:ref_role) to role sysops copy current grants;
	grant ownership on database role identifier(:view_role) to role sysops copy current grants;
	grant ownership on database role identifier(:read_role) to role sysops copy current grants;
	grant ownership on database role identifier(:write_role) to role sysops copy current grants;
	grant ownership on database role identifier(:create_role) to role sysops copy current grants;
	grant ownership on database role identifier(:schadmin_role) to role sysops copy current grants;

	grant ownership on role identifier(:legacy_ref_role) to role sysops copy current grants;
	grant ownership on role identifier(:legacy_view_role) to role sysops copy current grants;
	grant ownership on role identifier(:legacy_read_role) to role sysops copy current grants;
	grant ownership on role identifier(:legacy_write_role) to role sysops copy current grants;
	grant ownership on role identifier(:legacy_create_role) to role sysops copy current grants;
	grant ownership on role identifier(:legacy_schadmin_role) to role sysops copy current grants;

return ('Roles for schema ' || qualified_schema || ' created');
end;
$$;
grant usage on procedure admin_db.admin_sch.sp_create_schema_roles(varchar, varchar) to role sysops;
use role futureops;
grant ownership on procedure admin_db.admin_sch.sp_create_schema_roles(varchar, varchar) to role futureops copy current grants;