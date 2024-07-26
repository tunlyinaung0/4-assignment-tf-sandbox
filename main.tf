resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${terraform.workspace}-vpc"
  }
}

module "subnet" {
  source = "./modules/subnet"
  vpc_id = aws_vpc.vpc.id
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone = var.availability_zone
}

resource "aws_security_group" "app-server-sg" {
  name = "${terraform.workspace}-app-server-sg"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${terraform.workspace}-app-server-sg"
  }
}