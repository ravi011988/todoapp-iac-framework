variable "sql_server" {
  type = map(object({
    sql_server_name      = string
    rg_name              = string
    location             = string
    version              = string
    admin_username       = string
    admin_password       = string
    minimum_tls_version  = string

    tags = optional(map(string))
  }))
}
