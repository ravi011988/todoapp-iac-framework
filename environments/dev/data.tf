data "azurerm_subnet" "frontend" {
  name                 = "frontend-subnet"
  virtual_network_name = "vnet-todoapp-01"
  resource_group_name  = "rg-todoapp"
}

data "azurerm_subnet" "backend" {
  name                 = "backend-subnet"
  virtual_network_name = "vnet-todoapp-01"
  resource_group_name  = "rg-todoapp"
}