variable "environment" {
  description = "The environment to deploy to"
  default     = "dev"
}

variable "resource_group_name" {
  default     = "ivicamaticrg2"
  description = "Details of the resource group"
  sensitive   = false
}


variable "location" {
  default     = "uksouth"
  description = "Details of the resource group"
  sensitive   = false
}

variable "cloudflare_api_token" {
  default = ""
}

variable "cloudflare_zone_id" {
  default = ""
}
  