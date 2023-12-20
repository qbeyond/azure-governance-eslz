variable "management_groups" {
  type = map(object({
    display_name               = string
    parent_management_group_id = optional(string)
    subscription_ids           = optional(list(string))
    archetype_id               = optional(string)
  }))
  description = <<-DOC
  ```
   "<mg_id>" = {
    display_name                 = string
    parent_management_group_id   = optional(string)       (Must be a <mg_id> of another MG)
    subscription_ids             = optional(list(string)) (List of subscription IDs that should be moved into that MG)
    archetype_id                 = optional(string)       (Name of an archetype as defined by CAF built-in or QBY archetype definitions)
   }
  ```
  DOC
  default = {}

  validation {
    condition = length(compact([for k, mg in var.management_groups: mg.archetype_id == "qby_root" ? k : ""])) == 1 || length(compact([for k, mg in var.management_groups: mg.archetype_id])) == 0
    error_message = "Management groups must have exactly one qby_root archetype or none at all."
  }
}


variable "group_assignments" {
  type = map(map(list(string)))
  description = <<-DOC
  ```
  "<group_name>" = {
    service_principals = optional(list(string))    (list of service principals that should be added as members) 
    "<role>"           = list(string)              (<role> must be a role_definition_name or role_definition_id from azure, every element must be a scope: "mg:<mg_id>", "sub:<subscription_id>", "root" for Tenant Root Group or a full scope ID)
}
  ```
  DOC
  default = {}
}

variable "pim_enabled_groups" {
  type = list(string)
  description = <<-DOC
  ```
  pim_enabled_groups = ["groupA", "groupB"]     (sets the value of assignable_to_role to true)
  ```
  DOC
  default = []
}

variable "management_group_policy_assignment_parameter_override" {
  type = any
  description = <<-DOC
  ```
  "<mg_id>" = {
    <policy_assignment> = {
      <parameter_name> = any  (<policy_assignment> and <parameter_name> must be the same as in built-in or custom policy assignment definitions)
    }
  }
  ```
  DOC
  default = {}
}

variable "library_path" {
  type        = string
  description = "If specified, sets the path to a custom library folder for archetype artefacts."
  default     = ""
}

variable "template_file_variables" {
  type        = any
  description = "If specified, provides the ability to define custom template variables used when reading in template files from the built-in and custom library_path."
  default     = {}
}

variable "default_location" {
  type        = string
  description = "Must be specified, e.g `eastus`. Will set the Azure region in which region bound resources will be deployed. Please see: https://azure.microsoft.com/en-gb/global-infrastructure/geographies/"
}
