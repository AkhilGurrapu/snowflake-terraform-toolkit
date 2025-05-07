# TODO: Currently only in prview mode.  In gap automation repo until the resource becomes stable.

# resource "snowflake_storage_integration" "integration" {
#   name    = var.name
#   comment = var.comment
#   type    = var.type
#   enabled = var.enabled
#   storage_allowed_locations = var.storage_allowed_locations
#   storage_provider         = var.storage_provider
#   storage_aws_external_id  = var.aws_external_id
#   storage_aws_iam_user_arn = var.aws_iam_user_arn
#   storage_aws_role_arn     = var.aws_role_arn
# }