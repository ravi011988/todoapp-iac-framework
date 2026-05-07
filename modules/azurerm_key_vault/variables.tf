variable "key_vaults" {
  description = "Map of Key Vaults to be created"
  type = map(object({
    kv_name     = string
    location    = string
    rg_name     = string
    enabled_for_disk_encryption  = optional(bool)
    soft_delete_retention_days    = optional(number)
    purge_protection_enabled      = optional(bool)
    sku_name                      = optional(string)
    public_network_access_enabled = optional(bool)

    access_policy = optional(object({
      tenant_id = optional(string)
      object_id = optional(string)

      key_permissions = optional(list(string))
      secret_permissions = optional(list(string))
      storage_permissions = optional(list(string))
      certificate_permissions = optional(list(string))
    }))

    network_rules = optional(object({
      default_action             = optional(string)
      bypass                     = optional(list(string))
      ip_rules                   = optional(list(string))
      virtual_network_subnet_ids = optional(list(string))
    }))

    tags = optional(map(string))
  }))
  default = {}
}
