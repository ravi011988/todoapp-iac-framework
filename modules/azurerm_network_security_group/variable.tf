variable "nsg" {
  type = map(object({
    name = string
    location = string
    rg_name = string
    tags = optional(map(string))
      }))
}