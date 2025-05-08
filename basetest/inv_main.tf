module "db_from_share_sp_global_ext" {
    source = "./modules/shares/database"

    database_name = "SP_GLOBAL_EXT"
    share_name    = "SPGLOBALXPRESSCLOUD.SPGLOBALXPRESSCLOUD_AWS_US_EAST_1.XF_RGAREINSURANCECOMPANY"
    comment       = "Database created from SPGLOBALXPRESSCLOUD share XF_RGAREINSURANCECOMPANY"
    grant_imported_privileges_to_role = "edp_inv_xpressfeed_viewer" // Ensure this role exists

    # depends_on = [module.name_of_role_creation_module_for_edp_inv_xpressfeed_viewer]
}

module "db_from_share_sp_global_ext" {
    source = "./modules/shares/database"

    database_name = "SP_GLOBAL_EXT"
    share_name    = "SPGLOBALXPRESSCLOUD.SPGLOBALXPRESSCLOUD_AWS_US_EAST_1.XF_RGAREINSURANCECOMPANY"
    comment       = "Database created from SPGLOBALXPRESSCLOUD share XF_RGAREINSURANCECOMPANY"
    grant_imported_privileges_to_role = "edp_inv_xpressfeed_viewer" // Ensure this role exists

    # depends_on = [module.name_of_role_creation_module_for_edp_inv_xpressfeed_viewer]
}