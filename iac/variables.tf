variable "region" {
  description = "Cloud region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
    description = "Name of the project"
    type        = string
    default = "meru"
}

variable "cird_block_vpc" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "az_list" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
    description = "CIDR blocks for the public subnets"
    type        = list(string)
}

variable "private_subnet_cidrs" {
    description = "CIDR blocks for the private subnets"
    type        = list(string)
}

variable "allowed_ssh_cidrs" {
    description = "CIDR blocks allowed for SSH"
    type        = list(string)
}

variable "allowed_http_cidrs" {
    description = "CIDR blocks allowed for HTTP"
    type        = list(string)
}

variable "ami_id" {
  description = "AMI ID for the instance"
  type        = string
  default = "ami-04a81a99f5ec58529"
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "ID of the subnet"
  type        = string
}

variable "security_group_name" {
  description = "Security group name"
  type        = string
  default     = "ssh-http-sg"
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed for SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_http_cidrs" {
  description = "CIDR blocks allowed for HTTP"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Additional tags for the compute instance"
  type        = map(string)
  default     = {}
}

variable "instances" {
  description = "List names for the EC2 instances"
  type        = map(object({
    name = string
    instance_type = string
    security_group_name = string
  }))
  default     = {
    "bastion" = {
      name = "bastion"
      instance_type = "t2.micro"
    }
  }
}

variable "key_pair_name" {
  description = "key_pair_name"
  type        = string
  default = "meru-key-pair"
}

variable "file_name" {
  description = "Name of the key pair"
  type        = string
  default = "tf_key"
}
