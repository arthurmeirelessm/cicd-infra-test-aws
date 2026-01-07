variable "role_name" {
  type = string
}

variable "assume_role_policy" {
  type = string
}

variable "inline_policies" {
  description = "Mapa de policies inline (name => policy_json)"
  type        = map(string)
  default     = {}
}
