resource "azurerm_storage_account" "stg" {
  for_each = var.stgs

  name                          = each.value.name
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  account_kind                  = lookup(each.value, "account_kind", "StorageV2")
  account_tier                  = each.value.account_tier
  account_replication_type      = each.value.account_replication_type
  provisioned_billing_model_version = lookup(each.value, "provisioned_billing_model_version", null)
  cross_tenant_replication_enabled  = lookup(each.value, "cross_tenant_replication_enabled", false)
  access_tier                   = lookup(each.value, "access_tier", "Hot")
  edge_zone                     = lookup(each.value, "edge_zone", null)
  https_traffic_only_enabled    = lookup(each.value, "https_traffic_only_enabled", true)
  min_tls_version               = lookup(each.value, "min_tls_version", "TLS1_2")
  allow_nested_items_to_be_public = lookup(each.value, "allow_nested_items_to_be_public", true)
  shared_access_key_enabled     = lookup(each.value, "shared_access_key_enabled", true)
  public_network_access_enabled = lookup(each.value, "public_network_access_enabled", true)
  default_to_oauth_authentication = lookup(each.value, "default_to_oauth_authentication", false)
  is_hns_enabled                = lookup(each.value, "is_hns_enabled", false)
  nfsv3_enabled                 = false
  large_file_share_enabled      = lookup(each.value, "large_file_share_enabled", false)
  local_user_enabled            = lookup(each.value, "local_user_enabled", true)
  infrastructure_encryption_enabled = lookup(each.value, "infrastructure_encryption_enabled", false)
  queue_encryption_key_type     = lookup(each.value, "queue_encryption_key_type", "Service")
  table_encryption_key_type     = lookup(each.value, "table_encryption_key_type", "Service")
  sftp_enabled                  = lookup(each.value, "sftp_enabled", false)
  dns_endpoint_type             = lookup(each.value, "dns_endpoint_type", "Standard")

  # ---- Safe Dynamic Blocks ---- #

  dynamic "custom_domain" {
    for_each = try(each.value.custom_domain != null ? [each.value.custom_domain] : [], [])
    content {
      name          = custom_domain.value.name
      use_subdomain = lookup(custom_domain.value, "use_subdomain", false)
    }
  }

  dynamic "customer_managed_key" {
    for_each = try(each.value.customer_managed_key != null ? [each.value.customer_managed_key] : [], [])
    content {
      key_vault_key_id          = customer_managed_key.value.key_vault_key_id
      user_assigned_identity_id = lookup(customer_managed_key.value, "user_assigned_identity_id", null)
    }
  }

  dynamic "identity" {
    for_each = try(each.value.identity != null ? [each.value.identity] : [], [])
    content {
      type         = identity.value.type
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  dynamic "network_rules" {
    for_each = try(each.value.network_rules != null ? [each.value.network_rules] : [], [])
    content {
      default_action             = "Allow"
      bypass                     = []
      ip_rules                   = []
      virtual_network_subnet_ids  = []

      dynamic "private_link_access" {
        for_each = try(network_rules.value.private_link_access != null ? [network_rules.value.private_link_access] : [], [])
        content {
          endpoint_resource_id = lookup(private_link_access.value, "endpoint_resource_id", null)
          endpoint_tenant_id   = lookup(private_link_access.value, "endpoint_tenant_id", null)
        }
      }
    }
  }

  dynamic "blob_properties" {
    for_each = try(each.value.blob_properties != null ? [each.value.blob_properties] : [], [])
    content {
      versioning_enabled = lookup(blob_properties.value, "versioning_enabled", false)

      dynamic "delete_retention_policy" {
        for_each = try(blob_properties.value.delete_retention_policy != null ? [blob_properties.value.delete_retention_policy] : [], [])
        content {
          days = lookup(delete_retention_policy.value, "days", 7)
        }
      }
    }
  }

  dynamic "static_website" {
    for_each = try(each.value.static_website != null ? [each.value.static_website] : [], [])
    content {
      index_document     = static_website.value.index_document
      error_404_document = static_website.value.error_404_document
    }
  }

  dynamic "routing" {
    for_each = try(each.value.routing != null ? [each.value.routing] : [], [])
    content {
      publish_internet_endpoints  = lookup(routing.value, "publish_internet_endpoints", false)
      publish_microsoft_endpoints = lookup(routing.value, "publish_microsoft_endpoints", false)
      choice                      = lookup(routing.value, "choice", "MicrosoftRouting")
    }
  }

  tags = each.value.tags
}
