variable "attempt_restart" {
  type        = string
  description = "Should this extension attempt a restart of the VM? This is recommended"
}

variable "domain_admin_password" {
  type        = string
  description = "The domain admin password who has permission or delegation to perform the domain join"
}

variable "domain_admin_username" {
  type        = string
  description = "The domain admin username who has permission or delegation to perform the domain join"
  sensitive   = true
}

variable "domain_name" {
  type        = string
  description = "The domain name of the domain you are trying to join, e.g. libredevops.org"
}

variable "lookup_vm_id" {
  type        = string
  description = "If a data source should be called to get the VM Id for you"
  default     = false
}

variable "ou_path" {
  type        = string
  description = "The LDAP settings of the OU and groups of where you want this VM to be placed"
}

variable "rg_name" {
  description = "The name of the resource group, this module does not create a resource group, it is expecting the value of a resource group already exists"
  type        = string
  validation {
    condition     = length(var.rg_name) > 1 && length(var.rg_name) <= 24
    error_message = "Resource group name is not valid."
  }
}

variable "tags" {
  type        = map(string)
  description = "A map of the tags to use on the resources that are deployed with this module."

  default = {
    source = "terraform"
  }
}

variable "vm_id" {
  type        = string
  description = "The id of the virtual machine(s)"
}

variable "vm_name" {
  type        = string
  description = "If lookup_vm_id is true, VM name must be set and the VM name must be provider"
}
