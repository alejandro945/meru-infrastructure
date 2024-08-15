provider "aws" {
  region = var.region
}

module "security_group" {
  source               = "./modules/security_group"
  security_group_name  = var.security_group_name
  vpc_id               = var.vpc_id
  allowed_ssh_cidrs    = var.allowed_ssh_cidrs
  allowed_http_cidrs   = var.allowed_http_cidrs
  tags                 = var.tags
}

module "ec2_instance" {
  source            = "./modules/ec2_instance"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  subnet_id         = var.subnet_id
  security_group_id = module.security_group.security_group_id
  instance_name     = var.instance_name
  tags              = var.tags
}

output "instance_public_ip" {
  value = module.ec2_instance.public_ip
}

output "instance_id" {
  value = module.ec2_instance.instance_id
}
