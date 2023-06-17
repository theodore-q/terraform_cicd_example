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
  name        = "terraform_example_6"
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

              set -e

              echo "🚀 Starting setup..."

              # Update system packages
              echo "📦 Updating system packages..."
              yum update -y
              yum install -y unzip

              # Install Node.js via NVM
              echo "📥 Installing Node.js..."
              curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
              export NVM_DIR="/root/.nvm"
              [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
              nvm install node
              export PATH="/root/.nvm/versions/node/$(nvm version)/bin:$PATH"

              # Install the AWS CLI
              echo "📥 Installing AWS CLI..."
              curl "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              sudo ./aws/install
              export PATH="$PATH:/usr/local/bin/aws"

              # Create app directory
              echo "📂 Creating app directory..."
              mkdir /home/ec2-user/app && cd /home/ec2-user/app

              # Download and unzip the archive from S3
              echo "📥 Downloading and unzipping app from S3..."
              aws s3 cp s3://unique-bucket-namezzyo12/my_repo.zip my_repo.zip
              unzip my_repo.zip

              # Install npm packages
              echo "📥 Installing npm packages..."
              npm install

              # Start the app
              echo "🚀 Starting the app..."
              nohup node server.js > output.log &

              echo "🎉 Setup complete!"
            EOF
}