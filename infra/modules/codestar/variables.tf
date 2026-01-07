variable "connection_name" {
  description = "Nome da conexão CodeStar"
  type        = string
}

variable "provider_type" {
  description = "Tipo de provedor (GitHub, GitHubEnterpriseServer, Bitbucket)"
  type        = string
  default     = "GitHub"
}
