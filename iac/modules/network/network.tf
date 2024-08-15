# This file contains the code for creating the VPC, Subnets, Internet Gateway, NAT Gateway, Route Tables, etc.

# Creating a VPC
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = merge(local.base_tags, {
    Name = "${local.name_prefix}vpc"
    }
  )
}

resource "aws_vpc_dhcp_options" "this" {
  domain_name_servers  = ["AmazonProvidedDNS"]

  tags = {
    Name = "${local.name_prefix}dhcp-options"
  }
}

# These subnets host public resources.  HTTP servers, etc live here
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = var.az_list[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.base_tags, {
    Name                     = "${local.name_prefix}public-${count.index + 1}"
    "kubernetes.io/role/elb" = "1"
    }
  )
}


# These subnets host private resources.  App servers, etc live here
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(var.private_subnet_cidrs, count.index)
  availability_zone       = var.az_list[count.index]
  map_public_ip_on_launch = false

  tags = merge(local.base_tags, {
    Name                              = "${local.name_prefix}private-${count.index + 1}"
    Tier                              = "private"
    "kubernetes.io/role/internal-elb" = "1"
    }
  )
}

