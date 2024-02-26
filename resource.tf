resource "azurerm_virtual_network" "vnet-demo-v1" {
  name                = "Vnet-demo-v1"
  location            = "japaneast"
  resource_group_name = "tatsukoni-test-v2"
  address_space       = ["10.0.0.0/16"]
  subnet {
    name           = "default"
    address_prefix = "10.0.0.0/24"
  }
  tags = {
    "Name" = "Vnet-demo-v1"
  }
}
