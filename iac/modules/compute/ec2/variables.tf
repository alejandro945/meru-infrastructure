variable "ami_id" {
  description = "AMI id for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "subnet_id" {
  description = "Subnet id where the instance will be deployed"
  type        = string
}

variable "security_group_id" {
  description = "Group ID of the security group"
  type        = string
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "user_data" {
  description = "User data para la instancia EC2"
  type        = string
}

