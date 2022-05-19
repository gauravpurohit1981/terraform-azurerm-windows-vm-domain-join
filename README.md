```hcl
module "rg" {
  source = "registry.terraform.io/libre-devops/rg/azurerm"

  rg_name  = "rg-${var.short}-${var.loc}-${terraform.workspace}-build" // rg-ldo-euw-dev-build
  location = local.location                                            // compares var.loc with the var.regions var to match a long-hand name, in this case, "euw", so "westeurope"
  tags     = local.tags

  #  lock_level = "CanNotDelete" // Do not set this value to skip lock
}

module "network" {
  source = "registry.terraform.io/libre-devops/network/azurerm"

  rg_name  = module.rg.rg_name // rg-ldo-euw-dev-build
  location = module.rg.rg_location
  tags     = local.tags

  vnet_name     = "vnet-${var.short}-${var.loc}-${terraform.workspace}-01" // vnet-ldo-euw-dev-01
  vnet_location = module.network.vnet_location

  address_space   = ["10.0.0.0/16"]
  subnet_prefixes = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names    = ["sn1-${module.network.vnet_name}", "sn2-${module.network.vnet_name}", "sn3-${module.network.vnet_name}"] //sn1-vnet-ldo-euw-dev-01
  subnet_service_endpoints = {
    "sn1-${module.network.vnet_name}" = ["Microsoft.Storage"] // Adds extra subnet endpoints to sn1-vnet-ldo-euw-dev-01
    "sn2-${module.network.vnet_name}" = ["Microsoft.Storage", "Microsoft.Sql"], // Adds extra subnet endpoints to sn2-vnet-ldo-euw-dev-01
    "sn3-${module.network.vnet_name}" = ["Microsoft.AzureActiveDirectory"] // Adds extra subnet endpoints to sn3-vnet-ldo-euw-dev-01
  }
}

// Default behaviour uses "registry.terraform.io/libre-devops/windows-os-plan-calculator/azurerm"
module "win_vm_simple" {
  source = "registry.terraform.io/libre-devops/windows-vm/azurerm"

  rg_name  = module.rg.rg_name
  location = module.rg.rg_location
  tags     = module.rg.rg_tags

  vm_amount          = 1
  vm_hostname        = "win${var.short}${var.loc}${terraform.workspace}" // winldoeuwdev01 & winldoeuwdev02 & winldoeuwdev03
  vm_size            = "Standard_B2ms"
  use_simple_image   = true
  vm_os_simple       = "WindowsServer2019"
  vm_os_disk_size_gb = "127"

  asg_name = "asg-${element(regexall("[a-z]+", element(module.win_vm_simple.vm_name, 0)), 0)}-${var.short}-${var.loc}-${terraform.workspace}-01" //asg-vmldoeuwdev-ldo-euw-dev-01 - Regex strips all numbers from string

  admin_username = "LibreDevOpsAdmin"
  admin_password = data.azurerm_key_vault_secret.mgmt_local_admin_pwd.value // Created with the Libre DevOps Terraform Pre-Requisite script

  subnet_id            = element(values(module.network.subnets_ids), 0) // Places in sn1-vnet-ldo-euw-dev-01
  availability_zone    = "alternate"                                    // If more than 1 VM exists, places them in alterate zones, 1, 2, 3 then resetting.  If you want HA, use an availability set.
  storage_account_type = "Standard_LRS"
  identity_type        = "SystemAssigned"
}

module "domain_join" {
  source = "registry.terraform.io/libre-devops/windows-vm-domain-join/azurerm"

  attempt_restart       = "true"
  domain_admin_password = data.azurerm_key_vault_secret.mgmt_local_admin_pwd.value
  domain_admin_username = "LibreDevOpsAdmin"
  domain_name           = "libredevops.org"
  ou_path               = "OU=${title(terraform.workspace)},OU=Customers,OU=Computers,DC=libredevops,DC=org"
  vm_id                 = element(values(module.win_vm_simple.vm_ids), 0)
  tags                  = module.rg.rg_tags
}

```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_virtual_machine_extension.domain_join](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine.fetch_vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_machine) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attempt_restart"></a> [attempt\_restart](#input\_attempt\_restart) | Should this extension attempt a restart of the VM? This is recommended | `string` | n/a | yes |
| <a name="input_domain_admin_password"></a> [domain\_admin\_password](#input\_domain\_admin\_password) | The domain admin password who has permission or delegation to perform the domain join | `string` | n/a | yes |
| <a name="input_domain_admin_username"></a> [domain\_admin\_username](#input\_domain\_admin\_username) | The domain admin username who has permission or delegation to perform the domain join | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name of the domain you are trying to join, e.g. libredevops.org | `string` | n/a | yes |
| <a name="input_lookup_vm_id"></a> [lookup\_vm\_id](#input\_lookup\_vm\_id) | If a data source should be called to get the VM Id for you | `string` | `false` | no |
| <a name="input_ou_path"></a> [ou\_path](#input\_ou\_path) | The LDAP settings of the OU and groups of where you want this VM to be placed | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | The name of the resource group, this module does not create a resource group, it is expecting the value of a resource group already exists | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of the tags to use on the resources that are deployed with this module. | `map(string)` | <pre>{<br>  "source": "terraform"<br>}</pre> | no |
| <a name="input_vm_id"></a> [vm\_id](#input\_vm\_id) | The id of the virtual machine(s) | `string` | n/a | yes |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | If lookup\_vm\_id is true, VM name must be set and the VM name must be provider | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domain_join_id"></a> [domain\_join\_id](#output\_domain\_join\_id) | The id of the domain join extension |
| <a name="output_domain_join_name"></a> [domain\_join\_name](#output\_domain\_join\_name) | The name of the domain join extension |
| <a name="output_domain_join_settings"></a> [domain\_join\_settings](#output\_domain\_join\_settings) | The domain join extension settings black |
