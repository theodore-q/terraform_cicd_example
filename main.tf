provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c94855ba95c574c8" # update with your preferred AMI ID
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-example"
  }
}
