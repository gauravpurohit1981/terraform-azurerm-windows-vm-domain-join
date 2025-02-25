variable "short" {
  description = "This is passed as an environment variable, it is for a shorthand name for the environment, for example hello-world = hw"
  type        = string
  default     = "sunaj"
}

variable "env" {
  description = "This is passed as an environment variable, it is for the shorthand environment tag for resource.  For example, production = prod"
  type        = string
  default     = "dev"
}

variable "loc" {
  description = "The shorthand name of the Azure location, for example, for UK South, use uks.  For UK West, use ukw. Normally passed as TF_VAR in pipeline"
  type        = string
  default     = "uks"
}

variable "Regions" {
  type = map(string)
  default = {
    uks = "UK South"
    ukw = "UK West"
    eus = "East US"
    euw = "West Europe"
  }
  description = "Converts shorthand name to longhand name via lookup on map list"
}
variable "vmname" {
  description = "virtual machine name"
  type        = string
  default     = "sunaj-webserver01"
}

locals {
  location = lookup(var.Regions, var.loc, "UK South")
}
