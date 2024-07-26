resource "aws_eip" "instance_eip" {
  domain = "vpc"
  instance = module.ec2_instance.id

  tags = {
    Name = "${terraform.workspace}-eip"
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name = "${terraform.workspace}-key"
  public_key = file(var.public_key_path)
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${terraform.workspace}-app-server"

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ssh-key.key_name
  monitoring             = false
  vpc_security_group_ids = [aws_security_group.app-server-sg.id]
  subnet_id              = module.subnet.subnet_id

  tags = merge({
    Name = "${terraform.workspace}-app-server"
    }, local.tags
  )
}