### Variables for resource group ###
variable "resource_group_name" {
  default     = "ivicamaticrg" # this gets suffixed with the environment as it must be unique on whole Azure 
  description = "Details of the resource group"
  sensitive   = false
}


variable "resource_group_location" {
  default     = "uksouth"
  description = "Details of the resource group"
  sensitive   = false
}