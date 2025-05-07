use role sysadmin;
use database admin_db;
/*
* create external stage
*/
create or replace procedure admin_db.admin_sch.sp_stage_provisioning (
    stg_name varchar,
    url varchar,     -- Fully qualified S3 address of top folder accessible to stage
    st_int varchar   -- Storage integration
)
returns varchar
language sql
execute as owner
as
$$
begin
    execute immediate
        'create or replace stage ' || stg_name || ' ' ||
            'url = ''' || url || ''' ' ||
            'storage_integration = ' || st_int || ' ' ||
            'directory = (refresh_on_create = false, auto_refresh = false)'
    ;
end;
$$;

grant usage on procedure admin_db.admin_sch.sp_stage_provisioning(varchar, varchar, varchar) to role sysops;
