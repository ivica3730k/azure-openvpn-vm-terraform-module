#!/bin/bash
apt update -y
apt upgrade -y

# install pip3 for python3
apt install python3-pip -y

python3 -m pip install --upgrade pip
apt install nginx -y
ufw allow 80
ufw allow 443

# instal certbot for nginx
apt install certbot python3-certbot-nginx -y
