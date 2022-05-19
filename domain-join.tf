data "azurerm_virtual_machine" "fetch_vm" {
  count               = var.lookup_vm_id == true && var.vm_id == null ? 1 : 0
  name                = var.vm_name
  resource_group_name = var.rg_name
}

resource "azurerm_virtual_machine_extension" "domain_join" {

  name                 = "ADDomainJoined"
  virtual_machine_id   = var.lookup_vm_id == true ? element(values(data.azurerm_virtual_machine.fetch_vm.*.id), 0) : var.vm_id
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