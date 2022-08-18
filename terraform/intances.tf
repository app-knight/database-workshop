data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "cicdworkshop_key" {
  key_name   = "cicdworkshop-key-ubuntu-key"
  public_key = file("~/.ssh/id_rsa.pub")
  }

resource "aws_instance" "web" {
  count         = 2
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  key_name = aws_key_pair.cicdworkshop_key.id

  vpc_security_group_ids = [
    aws_security_group.cicd_workshop_server.id
  ]

  tags = {
    Name = "DB_worshop-${count.index + 1}"
  }
}

resource "local_file" "inventory" {
  content = <<-DOC
    DB_worshop-1 ansible_host=${aws_instance.web[0].public_ip} private_ip=${aws_instance.web[0].private_ip} server_id=101
    DB_worshop-2 ansible_host=${aws_instance.web[1].public_ip} private_ip=${aws_instance.web[1].private_ip} server_id=102
    DOC
  filename = "../ansible/inventory"
}