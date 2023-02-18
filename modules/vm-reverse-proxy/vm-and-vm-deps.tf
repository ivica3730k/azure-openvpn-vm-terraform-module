resource "random_string" "random_string" {
  length  = 16
  special = false
}

resource "azurerm_public_ip" "machine_public_ip" {
  name                = "reverse-proxy-virtual-machine-public-ip-${random_string.random_string.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}



resource "azurerm_network_interface" "machine_nic" {
  name                = "reverse-proxy-machine-nic-${random_string.random_string.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  # enable_accelerated_networking = "true"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.machine_public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "virtual_machine" {
  # TODO: OpenVPN should be installed on this machine and user profile should be created
  admin_username                  = "azureuser"
  allow_extension_operations      = "true"
  computer_name                   = "reverse-proxy-virtual-machine-${random_string.random_string.result}"
  disable_password_authentication = "true"
  encryption_at_host_enabled      = "false"
  extensions_time_budget          = "PT1H30M"
  location                        = var.location
  max_bid_price                   = "-1"
  name                            = "reverse-proxy-virtual-machine-${random_string.random_string.result}"
  network_interface_ids           = [azurerm_network_interface.machine_nic.id]
  priority                        = "Regular"
  provision_vm_agent              = "true"
  resource_group_name             = var.resource_group_name
  secure_boot_enabled             = "false"
  size                            = var.vm_size

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching                   = "ReadWrite"
    disk_size_gb              = "30"
    storage_account_type      = "Premium_LRS"
    write_accelerator_enabled = "false"
  }

  patch_mode = "ImageDefault"




  source_image_reference {
    offer     = "0001-com-ubuntu-server-focal"
    publisher = "Canonical"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }



  vtpm_enabled = "false"
  custom_data  = data.template_cloudinit_config.virtual_machine_init.rendered


}

# output the public IP address of the VM
output "virtual_machine_public_ip" {
  description = "IP address of the Reverse Proxy VM"
  value       = azurerm_linux_virtual_machine.virtual_machine.public_ip_address
}