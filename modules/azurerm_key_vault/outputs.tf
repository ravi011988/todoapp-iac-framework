output "key_vault_ids" {
  description = "Map of Key Vault resource IDs"
  value = {
    for k, kv in azurerm_key_vault.kv : k => kv.id
  }
}

output "key_vault_names" {
  description = "Map of Key Vault names"
  value = {
    for k, kv in azurerm_key_vault.kv : k => kv.name
  }
}

output "key_vault_uris" {
  description = "Map of Key Vault URIs"
  value = {
    for k, kv in azurerm_key_vault.kv : k => kv.vault_uri
  }
}
