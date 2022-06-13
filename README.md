<!-- BEGIN_TF_DOCS -->
# Configurable Azure Governance Module

This module is based on the Cloud Adoption Frameworks Enterprise Scale Landingzone.
You can customize the management group layout, assigned policies and AAD groups to create and assign.

Use the archetype\_lib folder in this repo to add custom archetypes, policy definitions and policy assignments.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 2.15.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.77.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~> 2.15.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2.77.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_governance_eslz"></a> [governance\_eslz](#module\_governance\_eslz) | git::https://github.com/Azure/terraform-azurerm-caf-enterprise-scale.git | v2.0.1 |

## Resources

| Name | Type |
|------|------|
| [azuread_application.apps](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_group.groups](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) | resource |
| [azuread_group_member.sp-assignments](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group_member) | resource |
| [azuread_service_principal.sp](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_role_assignment.role_assignments](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.subs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_group_assignments"></a> [group\_assignments](#input\_group\_assignments) | <pre>"<group_name>" = {<br>  service_principals = optional(list(string))    (list of service principals that should be added as members) <br>  "<role>"           = list(string)              (<role> must be a role_definition_name or role_definition_id from azure, every element must be a scope: "mg:<mg_id>", "sub:<subscription_id>", "root" for Tenant Root Group or a full scope ID)<br>}</pre> | `map(map(list(string)))` | `{}` | no |
| <a name="input_library_path"></a> [library\_path](#input\_library\_path) | If specified, sets the path to a custom library folder for archetype artefacts. | `string` | `""` | no |
| <a name="input_management_group_policy_assignment_parameter_override"></a> [management\_group\_policy\_assignment\_parameter\_override](#input\_management\_group\_policy\_assignment\_parameter\_override) | <pre>"<mg_id>" = {<br>  <policy_assignment> = {<br>    <parameter_name> = any  (<policy_assignment> and <parameter_name> must be the same as in built-in or custom policy assignment definitions)<br>  }<br>}</pre> | `any` | `{}` | no |
| <a name="input_management_groups"></a> [management\_groups](#input\_management\_groups) | <pre>"<mg_id>" = {<br>  display_name                 = string<br>  parent_management_group_id   = optional(string)       (Must be a <mg_id> of another MG)<br>  subscription_ids             = optional(list(string)) (List of subscription IDs that should be moved into that MG)<br>  archetype_id                 = optional(string)       (Name of an archetype as defined by CAF built-in or QBY archetype definitions)<br> }</pre> | <pre>map(object({<br>    display_name               = string<br>    parent_management_group_id = optional(string)<br>    subscription_ids           = optional(list(string))<br>    archetype_id               = optional(string)<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ad_groups"></a> [ad\_groups](#output\_ad\_groups) | All AAD Groups that have been created |
| <a name="output_applications"></a> [applications](#output\_applications) | All AAD Applications that have been created |
| <a name="output_caf_output"></a> [caf\_output](#output\_caf\_output) | Passed through output of the underlying CAF module |
| <a name="output_service_principals"></a> [service\_principals](#output\_service\_principals) | All service principals that have been created |
<!-- END_TF_DOCS -->