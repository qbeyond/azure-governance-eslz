# Governance
locals {
  default_location              = "westeurope"
  fullname_customer             = ""
  shortname_msp                 = ""
  fullname_msp                  = ""
  subscription_ids_management   = []
  subscription_ids_identity     = []
  subscription_ids_connectivity = []
  subscription_ids_prd_azdevops = []
  subscription_ids_sandboxes    = []
  subscription_ids_legacy       = []
  subscription_ids_msp_lz_prd   = []
  subscription_ids_new          = []

  eslz_subs = flatten([local.subscription_ids_management, local.subscription_ids_identity, local.subscription_ids_connectivity, local.subscription_ids_prd_azdevops, local.subscription_ids_sandboxes])

  tags = merge(yamldecode(file("${path.root}/tags.yaml"))...)
}
