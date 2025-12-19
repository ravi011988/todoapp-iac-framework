data "azurerm_key_vault" "existing_kv" {
  name                = "kv-todoapp-01"
  resource_group_name = "rg_backend"
}

data "azurerm_key_vault_secret" "vm_username" {
  name         = "vm-username"
  key_vault_id = data.azurerm_key_vault.existing_kv.id
}

data "azurerm_key_vault_secret" "vm_password" {
  name         = "vm-password"
  key_vault_id = data.azurerm_key_vault.existing_kv.id
}

resource "azurerm_network_interface" "nic" {
  for_each            = var.vms
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          =  data.azurerm_public_ip.pip[each.key].id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each                        = var.vms
  name                            = each.value.vm_name
  resource_group_name             = each.value.rg_name
  location                        = each.value.location
  size                            = each.value.size

  # ✅ FIXED LINES
  admin_username = data.azurerm_key_vault_secret.vm_username.value
  admin_password = data.azurerm_key_vault_secret.vm_password.value

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer     = each.value.source_image_reference.offer
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }

}


