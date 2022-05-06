# Input
locals {
    # Prepare input parameters for the underlying caf module
    caf_input = {for k, mg in var.management_groups: k => {
        display_name = mg.display_name
        parent_management_group_id = coalesce(mg.parent_management_group_id, data.azurerm_client_config.current.tenant_id)
        subscription_ids = coalesce(mg.subscription_ids, [])
        archetype_config = {
            archetype_id = coalesce(mg.archetype_id, "default_empty")
            parameters = lookup(var.management_group_policy_assignment_parameter_override, k, {})
            access_control = {}
    }}}
    root_mgs = compact([for k, mg in var.management_groups: mg.archetype_id == "root" ? k : ""])
    caf_root_id = length(local.root_mgs) == 1 ? local.root_mgs[0] : "es"

    # Get all needed role assignments from nested map
    group_role_assignments = merge(flatten([
        for group, assignments in var.group_assignments: [
            for role, scopes in assignments: role != "service_principals" ? {
                for scope in scopes: "${group}_${role}_${scope}" => {
                    scope = coalesce(
                        scope == "root" ? format("/providers/Microsoft.Management/managementGroups/%s", data.azurerm_client_config.current.tenant_id) : null,
                        can(regex("^mg:.*$", scope)) ? format("/providers/Microsoft.Management/managementGroups/%s", trimprefix(scope, "mg:")) : null,
                        can(regex("^sub:.*$", scope)) ? format("/subscriptions/%s", trimprefix(scope, "sub:")) : null,
                        scope
                    )
                    role_definition_name = can(regex("((\\w|\\d){8}-((\\w|\\d){4}-){3}(\\w|\\d){12}$)", role)) ? null : role
                    role_definition_id   = can(regex("((\\w|\\d){8}-((\\w|\\d){4}-){3}(\\w|\\d){12}$)", role)) ? format("/providers/Microsoft.Authorization/roleDefinitions/%s", basename(role)) : null
                    principal = group
    }}:{}]])...)

    # Prepare service principals and their group memberships
    new_service_principals = toset(flatten([
        for group, assignments in var.group_assignments: [
            lookup(assignments, "service_principals", [])
    ]]))
    service_principal_assignments = merge(flatten([
        for group, type in var.group_assignments: {
            for principal in lookup(type, "service_principals", []): "${group}_${principal}" => {
                group = group
                service_principal = principal
    }}])...)

    # Prepare subscription role assignments
    sub_ids = toset(flatten([for key, mg in local.caf_input: mg.subscription_ids]))

    group_desc = {
        for group, assignments in var.group_assignments: group => flatten([
            for role, scopes in assignments: role != "service_principals" ? [
                "%{for scope in scopes ~}${role}_${scope} %{endfor~}"
    ]:[]])}
}
