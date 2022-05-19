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

variable "ou_path" {
  type        = string
  description = "The LDAP settings of the OU and groups of where you want this VM to be placed"
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
  default     = null
}
