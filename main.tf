provider "aws" {
  region = "eu-west-1"
}

resource "null_resource" "archive" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "zip -r my_repo.zip ."
  }
}

resource "aws_s3_bucket" "b" {
  bucket = "my-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.b.bucket
  key    = "my_repo.zip"
  source = "my_repo.zip"
  acl    = "private"
}



resource "aws_security_group" "example" {
  name        = "example"
  description = "Example security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
