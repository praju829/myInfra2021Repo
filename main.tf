provider "aws" {
  region = var.aws_region
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_vpc" "main" {
  cidr_block = "172.16.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "main"
  }
}

#Create security group with firewall rules
resource "aws_security_group" "Terra-sg11" {
  name        = "${var.security_group}-${random_id.suffix.hex}"
  description = "security group for Ec2 instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 # outbound from jenkis server
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags= {
    Name = "${var.security_group}-${random_id.suffix.hex}"  
  }
}

resource "aws_instance" "myFirstInstance" {
  ami                    = var.ami_id
  key_name               = var.key_name
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.Terra-sg11.id]

  tags= {
    Name = var.tag_name
  }
}

# Create Elastic IP address
#resource "aws_eip" "myFirstInstance" {
 # vpc      = true
 # instance = aws_instance.myFirstInstance.id
#tags= {
  #  Name = "my_elastic_ip"
  #}
#}
