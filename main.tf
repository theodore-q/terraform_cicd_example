terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2"
    }
  }
}

provider "aws" {
  region = "eu-west-1" # your AWS region
}

resource "aws_s3_bucket" "b" {
  bucket = "unique-bucket-namezzyo123" # update this with your unique bucket name
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "null_resource" "archive" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "zip -r my_repo.zip ."
  }
}

resource "aws_s3_bucket_object" "object" {
  depends_on = [null_resource.archive]

  bucket = aws_s3_bucket.b.bucket
  key    = "my_repo.zip"
  source = "my_repo.zip"
  acl    = "private"
}

resource "aws_security_group" "example" {
  name        = "terraform_example_5"
  description = "An example security group"

  ingress {
    description = "Allow all inbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "example" {
  ami           = "ami-00b1c9efd33fda707" # update with your preferred AMI ID
  instance_type = "t2.micro"
  user_data     = data.template_file.user_data.rendered
  vpc_security_group_ids = [aws_security_group.example.id]

  tags = {
    Name = "terraform-example"
  }
}
data "template_file" "user_data" {
  template = <<-EOF
              #!/bin/bash
              touch /home/ec2-user/test.txt
            EOF
}