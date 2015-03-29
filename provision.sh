#!/usr/bin/env bash

# download the package lists from the repositories
apt-get update

# --- miscellaneous ----

apt-get install -y python-software-properties
apt-get install -y curl
apt-get install -y git-core
apt-get install -y screen

# --- node.js ---

# install node.js dependencies
apt-get install -y python g++ make

# add node.js repository
add-apt-repository ppa:chris-lea/node.js
apt-get update

# install packages
apt-get install -y nodejs

# Meteor

curl https://install.meteor.com | /bin/sh

apt-get install sshpass

npm install -g mup