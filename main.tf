provider "aws" {
  region = "us-east-1"
}

data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")

  vars = {
    server_js    = file("${path.module}/server.js")
    package_json = file("${path.module}/package.json")
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0c94855ba95c574c8" # update with your preferred AMI ID
  instance_type = "t2.micro"
  user_data     = data.template_file.user_data.rendered

  tags = {
    Name = "terraform-example"
  }
}
