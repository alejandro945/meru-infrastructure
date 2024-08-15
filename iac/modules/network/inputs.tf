variable "project" {
  description = "Project that owns the resource"
  type        = string
  nullable = false
}

variable "cidr_block" {
  description = "Networ range"
  type        = string
  nullable = false
}

variable "az_list" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = []
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "cluster_name" {
  description = "value of the cluster prefix name"
  type        = string
  default     = "ScaleMicrogrids-stg"
}