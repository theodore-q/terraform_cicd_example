#!/bin/bash

# Update and install necessary packages
yum update -y
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
. ~/.nvm/nvm.sh
nvm install node

# Create app directory
mkdir ~/app && cd ~/app

# Create package.json
echo '${package_json}' > package.json

# Install express
npm install

# Create server.js
echo "${server_js}" > server.js

# Start the app
nohup node server.js > output.log &
