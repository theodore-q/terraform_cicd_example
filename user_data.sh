data "template_file" "user_data" {
  template = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y unzip
              curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
              export NVM_DIR="/root/.nvm"
              [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
              nvm install node

              # Install the AWS CLI
              curl "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              sudo ./aws/install

              # Create app directory
              mkdir ~/app && cd ~/app

              # Download and unzip the archive from S3
              aws s3 cp s3://my-bucket/my_repo.zip my_repo.zip
              unzip my_repo.zip

              # Install npm packages
              npm install

              # Start the app
              nohup node server.js > output.log &
            EOF
}
