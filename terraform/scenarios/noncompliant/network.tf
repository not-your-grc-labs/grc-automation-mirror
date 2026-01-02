resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = {
    Name = "MyVPC"
    Network     = "Internal,External"
    Owner       = "Andrew"
    "Managed by" = "Terraform"
  }
}

resource "aws_subnet" "int_subnet1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.int1_cidr
  availability_zone       = "eu-west-2c"
  map_public_ip_on_launch = false
  tags = {
    Name        = "Int Subnet 1"
    Network     = "Internal1"
    Owner       = "Andrew"
    "Managed by" = "Terraform"
  }
}

resource "aws_subnet" "int_subnet2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.int2_cidr
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = false
  tags = {
    Name        = "Int Subnet2"
    Network     = "Internal2"
    Owner       = "Andrew"
    "Managed by" = "Terraform"
  }
}

resource "aws_route_table_association" "int_subnet_association" {
  subnet_id      = aws_subnet.int_subnet1.id
  route_table_id = aws_route_table.int_route_table.id
  
}

resource "aws_route_table_association" "int_subnet2_association" {
  subnet_id      = aws_subnet.int_subnet2.id
  route_table_id = aws_route_table.int_route_table.id
}

resource "aws_subnet" "dmz_subnet1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.dmz1_cidr
  availability_zone       = "eu-west-2c"
  map_public_ip_on_launch = true
  tags = {
    Name        = "DMZ1 Subnet"
    Network     = "DMZ1"
    Owner       = "Andrew"
    "Managed by" = "Terraform"
  }
}
resource "aws_route_table_association" "dmz_subnet1_association" {
  subnet_id      = aws_subnet.dmz_subnet1.id
  route_table_id = aws_route_table.dmz_route_table.id
}

resource "aws_subnet" "dmz_subnet2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.dmz2_cidr
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name        = "DMZ2 Subnet"
    Network     = "DMZ2"
    Owner       = "Andrew"
    "Managed by" = "Terraform"
  }
}

resource "aws_route_table_association" "dmz_subnet2_association" {
  subnet_id      = aws_subnet.dmz_subnet2.id
  route_table_id = aws_route_table.dmz_route_table.id
}

##define endpoints for ssm connection from internal (as no route to Internet)
locals {
  ssm_services = [
    "com.amazonaws.${var.region}.ssm",
    "com.amazonaws.${var.region}.ssmmessages",
    "com.amazonaws.${var.region}.ec2messages",
  ]
}

resource "aws_vpc_endpoint" "ssm" {
  for_each         = toset(local.ssm_services)
  vpc_id           = aws_vpc.my_vpc.id
  service_name     = each.value
  vpc_endpoint_type = "Interface"
  subnet_ids         = [aws_subnet.int_subnet1.id, aws_subnet.int_subnet2.id]
  security_group_ids = [aws_security_group.ssm_security_group.id]
  private_dns_enabled = true
}
