output "caf_output" {
    value = module.governance_eslz
    description = "Passed through output of the underlying CAF module"
}

output "ad_groups" {
    value = azuread_group.groups
    description = "All AAD Groups that have been created"
}

output "service_principals" {
    value = azuread_service_principal.sp
    description = "All service principals that have been created"
}
    
output "applications" {
    value = azuread_application.apps
    description = "All AAD Applications that have been created"
}
