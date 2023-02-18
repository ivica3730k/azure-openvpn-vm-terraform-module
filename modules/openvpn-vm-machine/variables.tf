variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type = string
}
variable "ovpn_profiles_storage_account_name" {
  type = string
}

variable "users" {
  type = list(string)
}

variable "vm_size" {
  default = "Standard_B1ls"
}