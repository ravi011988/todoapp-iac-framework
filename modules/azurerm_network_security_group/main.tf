resource "azurerm_network_security_group" "nsg" {
    for_each = var.nsg
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.rg_name
  tags = each.value.tags

  security_rule {
  name                       = "Allow-SSH-HTTP"
  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_ranges    = ["22", "80"]
  source_address_prefix      = "10.0.1.0/24"
  destination_address_prefix = "*"
  }
}