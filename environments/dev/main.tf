module "resource_group" {
  source = "../../modules/azurerm_resource_group"
  rgs    = var.rgs
}

module "network" {
  depends_on = [ module.resource_group ]
  source   = "../../modules/azurerm_networking"
  networks = var.networks
}

module "public_ip" {
  depends_on = [ module.resource_group ]
  source     = "../../modules/azurerm_public_ip"
  public_ips = var.public_ips
}

module "compute" {
  depends_on = [ module.resource_group, module.network, module.public_ip ]
  source = "../../modules/azurerm_compute"
  vms = var.vms
}

module "nsg" {
  depends_on = [ module.resource_group ]
  source = "../../modules/azurerm_network_security_group"
  nsg = var.nsg
}

locals {
  nic_ids = values(module.nic.nic_ids)
}

resource "azurerm_network_interface_security_group_association" "nic_nsg_assoc" {
  for_each = toset(local.nic_ids)

  network_interface_id      = each.value
  network_security_group_id = module.nsg.nsg_ids["nsg1"]
}


module "sql_server" {
  depends_on = [ module.resource_group ]
  source          = "../../modules/azurerm_sql_server"
  sql_server = var.sql_server
}

module "sql_database" {
  depends_on = [ module.resource_group, module.sql_server ]
  source = "../../modules/azurerm_sql_database"
  sql_db           = var.sql_db
}

module "KV" {
  depends_on = [ module.resource_group ]
  source = "../../modules/azurerm_key_vault"
  key_vaults = var.kv
}