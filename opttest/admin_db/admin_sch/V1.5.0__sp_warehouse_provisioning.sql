use role sysadmin;
use database admin_db;
/*
* create warehouse and assign access roles
*/
create or replace procedure admin_db.admin_sch.sp_warehouse_provisioning(
	wh_name varchar,
	wh_size varchar,
	wh_type varchar default 'STANDARD'
)
returns varchar
language sql
execute as owner
as
$$
declare
ops_role varchar default 'wh_' || wh_name || '_ops';
    usage_role varchar default 'wh_' || wh_name || '_use';
    current_wh_name varchar;
begin
    current_wh_name := (select current_warehouse()); --save since snowflake sets usage to the new one

    create or replace warehouse identifier(:wh_name)
        warehouse_size = :wh_size
        auto_resume = TRUE
        auto_suspend = 60
        enable_query_acceleration = FALSE
        warehouse_type = :wh_type
        min_cluster_count = 1
        max_cluster_count = 3
        scaling_policy = STANDARD
        initially_suspended = TRUE
    ;

    if (current_wh_name is not null) then
	    -- this is a bit nutty but you can't invoke "use" in a stored proc,
		-- so this is sets the warehouse back without actually re-creating it
        create warehouse if not exists identifier(:current_wh_name);
    end if;

    --
    -- create the access roles
    --
    create role if not exists identifier(:ops_role);
    grant all on warehouse identifier(:wh_name) to role identifier(:ops_role);
    create role if not exists identifier(:usage_role);
    grant usage on warehouse identifier(:wh_name) to role identifier(:usage_role);
    --
    -- assign roles to sysops so environment tier can grant
    --
	grant ownership on role identifier(:ops_role) to role sysops;
	grant ownership on role identifier(:usage_role) to role sysops;

end;
$$;

grant usage on procedure admin_db.admin_sch.sp_warehouse_provisioning(varchar, varchar, varchar) to role sysops;