
resource "azurerm_virtual_machine_extension" "domain_join" {

  name                 = "ADDomainJoined"
  virtual_machine_id   = var.vm_id
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  lifecycle {
    prevent_destroy = true
  }
  settings           = <<SETTINGS
      {
      "Name": "${var.domain_name}",
      "OUPath": "${var.ou_path}",
      "User": "${var.domain_admin_username}@${var.domain_name}",
      "Restart": "${lower(var.attempt_restart)}",
      "Options": "3"
      }
  SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
  {
  "Password": "${var.domain_admin_password}"
  }
  PROTECTED_SETTINGS

  tags = var.tags
}