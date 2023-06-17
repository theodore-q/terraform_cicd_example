#!/bin/bash

# Update and install necessary packages
yum update -y
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
. ~/.nvm/nvm.sh
nvm install node

# Create app directory
mkdir ~/app && cd ~/app

# Create package.json
echo '{
  "name": "hello-world",
  "version": "1.0.0",
  "description": "Node.js on AWS EC2 with Express",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.16.4"
  }
}' > package.json

# Install express
npm install

# Create server.js
echo "const express = require('express')
const app = express()
const port = 3000

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`)
})" > server.js

# Start the app
nohup node server.js > output.log &
