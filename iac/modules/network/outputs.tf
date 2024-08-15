output "vpc_id" {
  value = "${aws_vpc.this.id}"
}

output "vpc_cidr_block" {
  value = aws_vpc.this.cidr_block
}

output "private_nets" {
  value = aws_subnet.private[*].id
}

output "public_nets" {
  value = aws_subnet.public[*].id
}

output "private_tables" {
  value = aws_route_table.private[*].id
}

output "public_tables" {
  value = aws_route_table.public_ig[*].id
}

output "private_subnet_cidrs" {
  value = var.private_subnet_cidrs
}

output "public_subnet_cidrs" {
  value = var.public_subnet_cidrs
}

output "az_list" {
  value = local.az_list
}