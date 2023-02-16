resource "azurerm_storage_account" "ovpn_profiles_storage_account" {
  name                     = var.ovpn_profiles_storage_account_name
  location                 = var.resource_group_location
  resource_group_name      = var.resource_group_name
  access_tier              = "Cool"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
  account_tier             = "Standard"
}

resource "azurerm_storage_container" "ovpn_profiles_storage_container" {
  container_access_type = "private"
  name                  = "ovpn-profiles"
  storage_account_name  = azurerm_storage_account.ovpn_profiles_storage_account.name
}