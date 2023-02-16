resource "azurerm_virtual_network" "default-virtual-network" {
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.rg.location
  name                = "default_virtual_network"
  resource_group_name = azurerm_resource_group.rg.name
}


resource "azurerm_subnet" "default-subnet" {
  name                 = "default_subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.default-virtual-network.name
  address_prefixes     = ["10.0.0.0/16"]
}

module "openvpn-vm-machine" {
  source                             = "./modules/openvpn-vm-machine"
  resource_group_name                = azurerm_resource_group.rg.name
  resource_group_location            = azurerm_resource_group.rg.location
  subnet_id                          = azurerm_subnet.default-subnet.id
  ovpn_profiles_storage_account_name = "ovpnprofilesivicamatic"
  users                              = ["ivicamatic-laptop", "ivicamatic-desktop", "ivicamatic-mobile"]
}


output "openvpn-machine-ip" {
  value = module.openvpn-vm-machine.openvpn_virtual_machine_public_ip
}


resource "azurerm_network_security_group" "default-security-group" {
  location            = azurerm_resource_group.rg.location
  name                = "default-security-group"
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    access                     = "Allow"
    destination_address_prefix = "*"
    destination_port_range     = "1194"
    direction                  = "Inbound"
    name                       = "AllowTagCustom1194Inbound"
    priority                   = "101"
    protocol                   = "Udp"
    source_address_prefix      = "Internet"
    source_port_range          = "*"
  }
  # allow ssh
  security_rule {
    access                     = "Allow"
    destination_address_prefix = "*"
    destination_port_range     = "22"
    direction                  = "Inbound"
    name                       = "AllowTagCustom22Inbound"
    priority                   = "102"
    protocol                   = "Tcp"
    source_address_prefix      = "Internet"
    source_port_range          = "*"
  }

}

# associate the security group with the default subnet
resource "azurerm_subnet_network_security_group_association" "default-subnet-security-group-association" {
  subnet_id                 = azurerm_subnet.default-subnet.id
  network_security_group_id = azurerm_network_security_group.default-security-group.id
}

