variable "warehouses" {
  type = map(object({
    size                        = string
    auto_suspend                = number
    auto_resume                 = bool
    initially_suspended         = bool
    scaling_policy              = string
    max_cluster_count           = number
    min_cluster_count           = number
    enable_query_acceleration   = bool
    comment                     = string
  }))
}