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
