resource "aws_route_table" "int_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  # No default route for internal route table
}

resource "aws_route_table" "dmz_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name        = "MyIGW"
    Network     = "External"
    Owner       = "Andrew"
    "Managed by" = "Terraform"
  }
}