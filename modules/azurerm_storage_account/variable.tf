variable "stgs" {
  description = "Map of storage accounts to be created"
  type = map(object({
    name                          = string
    resource_group_name           = string
    location                      = string
    account_kind                  = optional(string)
    account_tier                  = string
    account_replication_type      = string
    provisioned_billing_model_version = optional(string)
    cross_tenant_replication_enabled  = optional(bool)
    access_tier                   = optional(string)
    edge_zone                     = optional(string)
    https_traffic_only_enabled    = optional(bool)
    min_tls_version               = optional(string)
    allow_nested_items_to_be_public = optional(bool)
    shared_access_key_enabled     = optional(bool)
    public_network_access_enabled = optional(bool)
    default_to_oauth_authentication = optional(bool)
    is_hns_enabled                = optional(bool)
    nfsv3_enabled                 = optional(bool)
    large_file_share_enabled      = optional(bool)
    local_user_enabled            = optional(bool)
    infrastructure_encryption_enabled = optional(bool)
    queue_encryption_key_type     = optional(string)
    table_encryption_key_type     = optional(string)
    sftp_enabled                  = optional(bool)
    dns_endpoint_type             = optional(string)

    custom_domain = optional(object({
      name          = string
      use_subdomain = optional(bool)
    }))

    customer_managed_key = optional(object({
      key_vault_key_id          = string
      user_assigned_identity_id = optional(string)
    }))

    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))

    network_rules = optional(object({
      default_action             = string
      bypass                     = optional(list(string))
      ip_rules                   = optional(list(string))
      virtual_network_subnet_ids  = optional(list(string))
      private_link_access = optional(object({
        endpoint_resource_id = optional(string)
        endpoint_tenant_id   = optional(string)
      }))
    }))

    blob_properties = optional(object({
      versioning_enabled = optional(bool)
      delete_retention_policy = optional(object({
        days = optional(number)
      }))
    }))

    static_website = optional(object({
      index_document     = string
      error_404_document = string
    }))

    routing = optional(object({
      publish_internet_endpoints  = optional(bool)
      publish_microsoft_endpoints = optional(bool)
      choice                      = optional(string)
    }))

    tags = optional(map(string))
  }))
}
