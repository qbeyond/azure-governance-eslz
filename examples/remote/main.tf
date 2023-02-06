module "azure_landing_zone" {
  source  = "qbeyond/governance-eslz/azurerm"
  version = "1.2.5"
  providers = {
    azurerm = azurerm
  }

  library_path = "${path.module}/archetype_lib"

  management_groups = {
    ## First(1) level MGs
    "new" = {
      display_name     = "New"
      subscription_ids = local.subscription_ids_new
    }
    "legacy" = {
      display_name     = "Legacy"
      subscription_ids = local.subscription_ids_legacy
    }
    "alz" = {
      display_name = "ALZ"
      archetype_id = "alz_root" # location where policies defined by file archetype_definition_<archetype_id>.json will be applied
    }

    ## Second(2) Level MGs
    "self-managed" = {
      display_name               = local.fullname_customer
      parent_management_group_id = "alz"
    }
    "msp" = {
      display_name               = local.fullname_msp
      parent_management_group_id = "alz"
    }
    "decommissioned" = {
      display_name               = "Decommissioned"
      parent_management_group_id = "alz"
    }

    ## Third(3) and fourth(4) level
    # Customer MGs third(3) level
    "sm-rd" = {
      display_name               = "R&D"
      parent_management_group_id = "self-managed"
      subscription_ids           = local.subscription_ids_sandboxes
    }
    "sm-lz" = {
      display_name               = "Landing Zones"
      parent_management_group_id = "self-managed"
    }
    # Customer MGs fourth(4) level
    "sm-lz-prd" = {
      display_name               = "PRD"
      parent_management_group_id = "sm-lz"
    }
    "sm-lz-qas" = {
      display_name               = "QAS"
      parent_management_group_id = "sm-lz"
    }
    "sm-lz-dev" = {
      display_name               = "DEV"
      parent_management_group_id = "sm-lz"
    }

    # MSP MGs third(3) level
    "msp-platform" = {
      display_name               = "Platform"
      parent_management_group_id = "msp"
    }
    "msp-lz" = {
      display_name               = "Landing Zones"
      parent_management_group_id = "msp"
    }
    # MSP MGs fourth(4) level
    "msp-platform-identity" = {
      display_name               = "Identity"
      parent_management_group_id = "msp-platform"
      subscription_ids           = [local.subscription_ids_identity]
    }
    "msp-platform-management" = {
      display_name               = "Management"
      parent_management_group_id = "msp-platform"
      subscription_ids           = [local.subscription_ids_management, local.subscription_ids_prd_azdevops]
    }
    "msp-platform-connectivity" = {
      display_name               = "Connectivity"
      parent_management_group_id = "msp-platform"
      subscription_ids           = [local.subscription_ids_connectivity]
    }

    "msp-lz-prd" = {
      display_name               = "PRD"
      parent_management_group_id = "msp-lz"
      subscription_ids           = local.subscription_ids_msp_lz_prd
    }
    "msp-lz-qas" = {
      display_name               = "QAS"
      parent_management_group_id = "msp-lz"
    }
    "msp-lz-dev" = {
      display_name               = "DEV"
      parent_management_group_id = "msp-lz"
    }
  }

  pim_enabled_groups = ["AMG_Root_Owner",
    "AMG_Root_READER",
    "AMG_Root_COSTMANAGEMENTREADER",
    "AMG_Root_IAC",
    #"<Policy Service Principal>",
    "AMG_${local.shortname_msp}_Platform_COP",
    "AMG_${local.shortname_msp}_Identity_COP",
    "AMG_${local.shortname_msp}_Identity_IAC",
    "AMG_${local.shortname_msp}_Connectivity_COP",
    "AMG_${local.shortname_msp}_Connectivity_IAC",
    "AMG_${local.shortname_msp}_Management_COP",
    "AMG_${local.shortname_msp}_Management_IAC",
    "AMG_${local.shortname_msp}_Prod_IAC",
    "AMG_${local.shortname_msp}_Test_IAC",
    "AMG_${local.shortname_msp}_Dev_IAC",
    "AMG_SMLandingZones_Reader",
    #"SUB_<Subscription Name>_OWNER", 
    #"SUB_<Subscription Name>_CONTRIBUTOR", 
    #"SUB_<Subscription Name>_READER", 
    "AMG_RnD_OWNER",
    "AMG_RnD_CONTRIBUTOR",
    "AMG_RnD_READER",
  "AMG_RnD_CostManagementReader"]

  group_assignments = {
    # Root
    "AMG_Root_Owner" = {
      "Owner" = ["root"]
    }

    "AMG_Root_READER" = {
      "Reader" = ["root"]
    }

    "AMG_Root_COSTMANAGEMENTREADER" = {
      "Cost Management Reader" = ["root"]
    }

    ### MSP MGs ###
    # Platform
    "AMG_${local.shortname_msp}_Platform_COP" = {
      "Reader"                      = ["mg:msp-platform"]
      "Virtual Machine Contributor" = ["mg:msp-platform"]
    }

    # Identity
    "AMG_${local.shortname_msp}_Identity_COP" = {
      "Reader"                      = ["mg:msp-platform-identity"]
      "Virtual Machine Contributor" = ["mg:msp-platform-identity"]
      #"<CustomRoles>" = ["mg:msp-platform-identity"]
    }

    "AMG_${local.shortname_msp}_Identity_IAC" = {
      "Contributor" = ["mg:msp-platform-identity"]
    }

    # Connectivity
    "AMG_${local.shortname_msp}_Connectivity_COP" = {
      "Reader"                      = ["mg:msp-platform-connectivity"]
      "Virtual Machine Contributor" = ["mg:msp-platform-connectivity"]
      #"<CustomRoles>" = ["mg:msp-platform-connectivity"]
    }

    "AMG_${local.shortname_msp}_Connectivity_IAC" = {
      "Contributor" = ["mg:msp-platform-connectivity"]
    }

    # Management
    "AMG_${local.shortname_msp}_Management_COP" = {
      "Reader"                      = ["mg:msp-platform-management"]
      "Virtual Machine Contributor" = ["mg:msp-platform-management"]
      #"<CustomRoles>" = ["mg:msp-platform-management"]
    }

    "AMG_${local.shortname_msp}_Management_IAC" = {
      "Contributor" = ["mg:msp-platform-management"]
    }

    # PRD
    "AMG_${local.shortname_msp}_Prod_IAC" = {
      "Contributor" = ["mg:msp-lz-prd"]
    }

    # QAS
    "AMG_${local.shortname_msp}_Test_IAC" = {
      "Contributor" = ["mg:msp-lz-qas"]
    }

    # TEST
    "AMG_${local.shortname_msp}_Dev_IAC" = {
      "Contributor" = ["mg:msp-lz-dev"]
    }

    ### Customer MGs ###
    # Customer Solutions
    "AMG_${local.shortname_msp}_Connectivity_IAC" = {
      "Network Contributor" = ["mg:self-managed"]
    }

    # Landing Zones
    "AMG_SMLandingZones_Reader" = {
      "Reader"                 = ["mg:sm-lz"]
      "Cost Management Reader" = ["mg:sm-lz"]
    }

    # Template per Subscription
    # # PRD
    # "SUB_<Subscription Name>_OWNER" = {
    #   "Owner"       = ["sub:<Subscription Id>"]
    # }
    #
    # "SUB_<Subscription Name>_CONTRIBUTOR" = {
    #   "Contributor" = ["sub:<Subscription Id>"]
    # }
    #
    # "SUB_<Subscription Name>_READER" = {
    #   "Reader"      = ["sub:<Subscription Id>"]
    # }

    # R&D
    "AMG_RnD_OWNER" = {
      "Owner" = ["mg:sm-rd"]
    }

    "AMG_RnD_CONTRIBUTOR" = {
      "Contributor" = ["mg:sm-rd"]
    }

    "AMG_RnD_READER" = {
      "Reader" = ["mg:sm-rd"]
    }

    "AMG_RnD_CostManagementReader" = {
      "Cost Management Reader" = ["mg:sm-rd"]
    }

  }
}
