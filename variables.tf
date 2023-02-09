variable "environment" {
  description = "The environment to deploy to"
  default     = "dev"
}

variable "resource_group_name" {
  default     = "ivicamaticrg"
  description = "Details of the resource group"
  sensitive   = false
}


variable "resource_group_location" {
  default     = "uksouth"
  description = "Details of the resource group"
  sensitive   = false
}