provider "aws" {
  region = "eu-west-1"
}

data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")
}

resource "aws_instance" "example" {
  ami           = "ami-00b1c9efd33fda707" # update with your preferred AMI ID
  instance_type = "t2.micro"
  user_data     = data.template_file.user_data.rendered

  tags = {
    Name = "terraform-example"
  }
}
