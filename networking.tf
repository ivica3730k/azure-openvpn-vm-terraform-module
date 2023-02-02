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


resource "azurerm_network_security_group" "default-security-group" {
  location            = azurerm_resource_group.rg.location
  name                = "default-security-group"
  resource_group_name = azurerm_resource_group.rg.name
  security_rule {
    access                     = "Allow"
    description                = "Allow SSH"
    destination_address_prefix = "*"
    destination_port_range     = "22"
    direction                  = "Inbound"
    name                       = "AllowSSH"
    priority                   = 100
    protocol                   = "Tcp"
    source_address_prefix      = "Internet"
    source_port_range          = "*"
  }

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

}

# associate the security group with the default subnet
resource "azurerm_subnet_network_security_group_association" "default-subnet-security-group-association" {
  subnet_id                 = azurerm_subnet.default-subnet.id
  network_security_group_id = azurerm_network_security_group.default-security-group.id
}


module "openvpn-vm-machine" {
  source                  = "./openvpn-vm-machine"
  resource_group_name     = azurerm_resource_group.rg.name
  resource_group_location = azurerm_resource_group.rg.location
  subnet_id               = azurerm_subnet.default-subnet.id
}
