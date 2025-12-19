variable "rgs" {
  type = map(object({
    name       = string
    location   = string
    managed_by = string
    tags       = map(string)
  }))
}

variable "networks" {}
variable "public_ips" {}
variable "vms" {}
variable "sql_server" {}
variable "sql_db" {}
# variable "subnet_ids" {
#   type = map(string)
# }

# variable "pip_ids" {
#   type = map(string)
# }

# variable "key_vault_ids" {
#   type = map(string)
# }