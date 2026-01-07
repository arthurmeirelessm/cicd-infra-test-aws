output "connection_arn" {
  description = "ARN da conexão CodeStar"
  value       = aws_codestarconnections_connection.this.arn
}
