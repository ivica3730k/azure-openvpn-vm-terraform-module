#!/bin/bash
apt update -y
apt upgrade -y

# install pip3 for python3
apt install python3-pip -y

python3 -m pip install --upgrade pip

# install azure-storage-blob using pip3
python3 -m pip install azure-storage-blob

