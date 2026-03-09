provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  for_each      = var.instance_configs
  ami           = each.value.ami
  instance_type = each.value.instance_type

    vpc_security_group_ids = [aws_security_group.ansibleSG[each.key].id]
    key_name = aws_key_pair.ansible-test-key[each.key].key_name
  tags = {
    name = each.value.name
    Role = each.key
  }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "inventory-bucket-09032026"

  tags = {
    name        = "My bucket"
    Environment = "test"
  }
}

resource "aws_security_group" "ansibleSG" {
    for_each = var.instance_configs
    name = "${each.key}-sg"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
     ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_key_pair" "ansible-test-key" {
    for_each = var.instance_configs
    key_name = "${each.key}-key"
    public_key = file(each.value.public_key_path)
}

terraform {
  backend "s3" {
    bucket = "inventory-bucket-09032026"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}