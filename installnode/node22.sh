#!/bin/bash


apt update -y
apt install git curl -y
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
apt-get install -y nodejs
npm install -g npm@latest
echo ""
echo "Node v22 berhasil di install..."
