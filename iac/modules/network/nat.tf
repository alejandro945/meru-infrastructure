# Creating an Elastic IP for the NAT Gateway
resource "aws_eip" "elastic_ip" {
  count = length(aws_subnet.public)

  tags = merge(local.base_tags, {
    Name = "${local.name_prefix}eip"
    }
  )

  depends_on = [
    aws_route_table_association.public_ig
  ]
}

# Creating a NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  count = length(aws_subnet.public)

  # Allocating the Elastic IP to the NAT Gateway!
  allocation_id = aws_eip.elastic_ip[count.index].id
  # Associating it in the Public Subnet!
  subnet_id = aws_subnet.public[count.index].id

  tags = merge(local.base_tags, {
    Name = "${local.name_prefix}nat"
    }
  )

  depends_on = [
    aws_eip.elastic_ip
  ]
}


# Creating a Route Table for the Nat Gateway
resource "aws_route_table" "private" {
  count = length(aws_subnet.private)

  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }

  tags = merge(local.base_tags, {
    Name = "${local.name_prefix}route-table-nat"
    }
  )

  lifecycle {
    ignore_changes = [ route ]
  }

  depends_on = [
    aws_nat_gateway.nat_gateway
  ]
}


# Creating an Route Table Association of the NAT Gateway route 
# table with the Private Subnet!
resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  #  Private Subnet ID for adding this route table to the DHCP server of Private subnet!
  subnet_id = aws_subnet.private[count.index].id
  # Route Table ID
  route_table_id = aws_route_table.private[count.index].id

  depends_on = [
    aws_route_table.private
  ]
}