data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon Linux
}
resource "aws_key_pair" "key" {
  key_name   = "aws_key"
  public_key = file("./modules/ec2/aws-key.pub")
}

# locals {
#   vars = {
#     db_address = var.db_address
#   }
# }

resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.key.key_name
  subnet_id                   = var.subnet
  vpc_security_group_ids      = [var.sg]
  associate_public_ip_address = true
  user_data = templatefile("./modules/ec2/install_webserver.sh",{add_db = var.db_add})
  # user_data                   = file("./modules/ec2/install_webserver.sh")

  tags = {
    Name = "Terraform Web EC2 Instance"
  }
}