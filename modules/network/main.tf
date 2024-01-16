resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "Terraform VPC"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
  count             = var.az_count
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.${10 + count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "Terraform Public ${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_subnet" "private_web" {
  count             = var.az_count
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.${20 + count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "Terraform Private Web ${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_subnet" "private_db" {
  count             = var.az_count
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.${30 + count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "Terraform Private DB ${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Terraform Internet Gateway"
  }
}

# resource "aws_eip" "nat_eip" {
#   domain = "vpc"

#   tags = {
#     Name = "Terraform EIP for NAT Gateway"
#   }
# }

# resource "aws_nat_gateway" "natgw" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = aws_subnet.public.0.id

#   tags = {
#     Name = "Terraform NAT Gateway"
#   }

#   # To ensure proper ordering, it is recommended to add an explicit dependency
#   # on the Internet Gateway for the VPC.
#   depends_on = [aws_internet_gateway.igw]
# }

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  tags = {
    Name = "Terraform Public Route Table"
  }
}

resource "aws_route_table_association" "rta_public" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.vpc.id

  # route {
  #   cidr_block = "0.0.0.0/0"
  #   gateway_id = aws_nat_gateway.natgw.id
  # }

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  tags = {
    Name = "Terraform Private Route Table"
  }
}

resource "aws_route_table_association" "rta_private_web" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.private_web.*.id, count.index)
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_route_table_association" "rta_private_db" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.private_db.*.id, count.index)
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_security_group" "private_web_sg" {
  name        = "Private Web Server SG"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform Private Web Server SG"
  }
}

resource "aws_security_group" "private_db_sg" {
  name        = "Private DB SG"
  description = "Allow MySQL inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "Access DB from Web Server"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.private_web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform Private DB SG"
  }
}