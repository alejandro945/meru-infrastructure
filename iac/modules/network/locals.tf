locals {
  name_prefix = "${var.project}-"
  base_tags = {
    project = var.project
  }
  az_list = [ for subnet in var.private_subnet_cidrs: 
    var.az_list[index(var.private_subnet_cidrs,subnet)] 
  ]
}

 