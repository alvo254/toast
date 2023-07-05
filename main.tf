terraform {
	required_providers {
		aws = {
			source = "hashicorp/aws"
		}
	}
}

provider "aws" {
	region = "us-east-1"
	profile = "default"
}

module "vpc" {
  source = "./modules/vpc"
  
}

resource "aws_instance" "alvo-toast" {
  ami = "ami-0e58f89e91723af4c"
  instance_type = "t2.micro"
  //This is interpolation or directive
  key_name = "${aws_key_pair.deployer.key_name}"
  vpc_security_group_ids = [aws_security_group.alvo-toast.id]
#   user_data = data.template_file.user_data.rendered

  tags = {
	Name = "alvin-toast"
  }
}

resource "aws_security_group" "alvo-toast" {
  name        = "alvo-toast"
  description = "my security group"
  vpc_id      = module.vpc.vpc_id

  ingress = [ 
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
      ipv6_cidr_blocks = []

  },
  {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      //The /32 means use a single ip
      cidr_blocks      = ["105.163.1.236/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
  }
  ]

  egress = [
    {
      description      = "outgoing traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false

  }
  ]

  tags = {
    Name = "allow_tls"
  }
}