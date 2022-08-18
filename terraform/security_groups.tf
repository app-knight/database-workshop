data "aws_vpc" "default_vpc_data" {
    default = true
}


resource "aws_security_group" "cicd_workshop_server" {
  name        = "cicd_workshop_server"
  description = "Security group for ci_cd workshop web server"
  vpc_id      = data.aws_vpc.default_vpc_data.id


  tags = {
    Name = "cicd_workshop_server"
  }
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cicd_workshop_server.id
}

resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  from_port         = 5000
  to_port           = 5000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cicd_workshop_server.id
}

resource "aws_security_group_rule" "allow_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cicd_workshop_server.id
}