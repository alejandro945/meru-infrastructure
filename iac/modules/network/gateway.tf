# Creating an Internet Gateway for the VPC
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.base_tags, {
    Name = "${local.name_prefix}ig"
    }
  )

  depends_on = [
    aws_vpc.this,
    aws_subnet.public,
    aws_subnet.private
  ]
}


# Creating an Route Table for the public subnet
resource "aws_route_table" "public_ig" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  # route {
  #   cidr_block = "10.0.0.0/16"
  #   vpc_peering_connection_id = "pcx-0bd09787212fb4947"
  # }

  tags = merge(local.base_tags, {
    Name = "${local.name_prefix}route-table-ig"
    }
  )

  lifecycle {
    ignore_changes = [ route ]
  }

  depends_on = [
    aws_vpc.this,
    aws_subnet.public,
    aws_internet_gateway.this
  ]
}

# Creating a resource for the Route Table Association
resource "aws_route_table_association" "public_ig" {
  count = length(aws_subnet.public)

  # Public Subnet ID
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_ig.id

  depends_on = [
    aws_vpc.this,
    aws_subnet.public
  ]
}