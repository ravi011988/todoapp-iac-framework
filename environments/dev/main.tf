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

module "compute" {
  depends_on = [ module.resource_group, module.network, module.public_ip ]
  source = "../../modules/azurerm_compute"
  vms = var.vms

}