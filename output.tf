output "domain_join_id" {
  description = "The id of the domain join extension"
  value       = azurerm_virtual_machine_extension.domain_join.id
}

output "domain_join_name" {
  description = "The name of the domain join extension"
  value       = azurerm_virtual_machine_extension.domain_join.id
}

output "domain_join_settings" {
  description = "The domain join extension settings black"
  value       = azurerm_virtual_machine_extension.domain_join.settings
}
