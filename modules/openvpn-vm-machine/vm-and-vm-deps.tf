resource "azurerm_public_ip" "openvpn_machine_public_ip" {
  name = "openvpn_machine_public_ip"
  # location            = azurerm_resource_group.rg.location
  location = var.resource_group_location
  #resource_group_name = azurerm_resource_group.rg.name
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "openvpn_machine_nic" {
  name                = "openvpn_machine_nic"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  # enable_accelerated_networking = "true"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.openvpn_machine_public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "openvpn_virtual_machine" {
  # TODO: OpenVPN should be installed on this machine and user profile should be created
  admin_username                  = "azureuser"
  allow_extension_operations      = "true"
  computer_name                   = "openvpn-virtual-machine"
  disable_password_authentication = "true"
  encryption_at_host_enabled      = "false"
  extensions_time_budget          = "PT1H30M"
  location                        = var.resource_group_location
  max_bid_price                   = "-1"
  name                            = "openvpn_virtual_machine"
  network_interface_ids           = [azurerm_network_interface.openvpn_machine_nic.id]
  priority                        = "Regular"
  provision_vm_agent              = "true"
  resource_group_name             = var.resource_group_name
  secure_boot_enabled             = "false"
  size                            = "Standard_B1ls"
  # size                           = "Standard_F2s"

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
  custom_data  = data.template_cloudinit_config.openvpn_virtual_machine_init.rendered

  depends_on = [
    azurerm_storage_account.ovpn_profiles_storage_account,
    azurerm_storage_container.ovpn_profiles_storage_container
  ]
}

# output the public IP address of the VM
output "openvpn_virtual_machine_public_ip" {
  description = "IP address of the OpenVPN VM"
  value       = azurerm_linux_virtual_machine.openvpn_virtual_machine.public_ip_address
}