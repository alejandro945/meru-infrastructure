variable "security_group_name" {
  description = "Nombre del grupo de seguridad"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks permitidos para acceso SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_http_cidrs" {
  description = "CIDR blocks permitidos para acceso HTTP"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Etiquetas adicionales para el grupo de seguridad"
  type        = map(string)
  default     = {}
}
