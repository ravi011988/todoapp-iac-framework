data "azurerm_mssql_server" "existing_sql" {
  for_each = var.sql_db

  name                = each.value.sql_server_name
  resource_group_name = each.value.rg_name
}

resource "azurerm_mssql_database" "sql_db" {
  for_each = var.sql_db

  name      = each.value.sql_db_name

  # ✅ yahin se server_id milegi
  server_id = data.azurerm_mssql_server.existing_sql[each.key].id

  collation   = each.value.collation
  max_size_gb = each.value.max_size_gb
  sku_name    = each.value.sku_name
  tags        = each.value.tags

  zone_redundant = false
  read_scale     = false
}


# resource "azurerm_mssql_database" "sql_db" {
#   name           = "app-db"
#   server_id     = azurerm_mssql_server.sql.id
#   collation     = "SQL_Latin1_General_CP1_CI_AS"
#   max_size_gb   = 10
#   sku_name      = "Basic"

#   zone_redundant = false
#   read_scale     = false

#   tags = {
#     environment = "prod"
#     owner       = "devops"
#   }
# }
