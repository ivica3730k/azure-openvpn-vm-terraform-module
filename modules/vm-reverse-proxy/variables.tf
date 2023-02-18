variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "reverse_proxy_entries" {
  type = list(object({
    name               = string
    domain_name        = string
    backend_ip_address = string
    backend_port       = number
    letsencrypt_email  = string
  }))
}

variable "vm_size" {
  default = "Standard_B1ls"
}