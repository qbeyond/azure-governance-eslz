# Governance
locals {
  default_location  = "westeurope"
  fullname_customer = ""
  shortname_msp     = ""
  fullname_msp      = ""
  management        = ""
  identity          = ""
  connectivity      = ""
  prd_azdevops      = ""
  sandboxes         = []
  legacy_subs       = []
  msp-lz-prd        = []
  new               = []

  eslz_subs = flatten([local.management, local.identity, local.connectivity, local.prd_azdevops, local.sandboxes])

  tags = merge(yamldecode(file("${path.root}/tags.yaml"))...)
}
