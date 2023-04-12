resource "aws_instance" "web" {
  ami           = "ami-06e46074ae430fba6"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.pub_lb.id
  vpc_security_group_ids = [aws_security_group.lb.id]

  tags = {
    Name = "demoEC2"
  }
}
resource "aws_ebs_volume" "vol_lb" {
  availability_zone = "us-east-1b"
  size              = 8

  tags = {
    Name = "vol_EC2"
  }
}

resource "aws_volume_attachment" "vol_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.vol_lb.id
  instance_id = aws_instance.web.id
}

resource "aws_security_group" "lb" {
  name        = "demo_sg"
  vpc_id      = aws_vpc.lb.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "demo_sg"
  }
}

