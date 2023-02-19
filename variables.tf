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

variable "client_id" {
  default = ""
}

variable "client_secret" {
  default   = ""
  sensitive = true
}

variable "tenant_id" {
  default = ""
}


variable "subscription_id" {
  default = ""
}


variable "cloudflare_api_token" {
  default   = ""
  sensitive = true
}

variable "cloudflare_zone_id" {
  default = ""
}
  