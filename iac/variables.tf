variable "region" {
  description = "Región AWS"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "ID de la AMI"
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
  description = "ID de la subred"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "security_group_name" {
  description = "Nombre del grupo de seguridad"
  type        = string
  default     = "ssh-http-sg"
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks permitidos para SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_http_cidrs" {
  description = "CIDR blocks permitidos para HTTP"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "instance_name" {
  description = "Nombre de la instancia EC2"
  type        = string
}

variable "tags" {
  description = "Etiquetas adicionales"
  type        = map(string)
  default     = {}
}
