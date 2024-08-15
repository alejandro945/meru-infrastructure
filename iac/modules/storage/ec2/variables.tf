variable "ami_id" {
  description = "ID de la AMI para la instancia EC2"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Nombre del par de claves SSH"
  type        = string
}

variable "subnet_id" {
  description = "ID de la subred donde se desplegará la instancia"
  type        = string
}

variable "security_group_id" {
  description = "ID del grupo de seguridad asociado a la instancia"
  type        = string
}

variable "instance_name" {
  description = "Nombre de la instancia EC2"
  type        = string
}

variable "tags" {
  description = "Etiquetas adicionales para la instancia"
  type        = map(string)
  default     = {}
}
