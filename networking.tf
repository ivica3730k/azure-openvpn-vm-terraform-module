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
  source                  = "./openvpn-vm-machine"
  resource_group_name     = azurerm_resource_group.rg.name
  resource_group_location = azurerm_resource_group.rg.location
  subnet_id               = azurerm_subnet.default-subnet.id
}