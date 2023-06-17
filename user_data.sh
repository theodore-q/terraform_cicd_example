#!/bin/bash

# Update and install necessary packages
yum update -y
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# Export NVM_DIR to make sure we're using the correct one
export NVM_DIR="/root/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Install node using nvm
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
