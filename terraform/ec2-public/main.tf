data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["099720109477"]
}

resource "aws_instance" "instance" {
  instance_type = var.instance_type
  ami           = data.aws_ami.ubuntu.image_id
  subnet_id     = var.subnetID
  key_name      = var.key_name
  # vpc_security_group_ids = var.secGroupId
  associate_public_ip_address = var.associate_public_ip_address
  user_data = var.userData
  tags = {
    Name = var.public_ec2
  }
  vpc_security_group_ids = var.secGroupId
}