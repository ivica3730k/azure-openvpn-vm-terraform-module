#!/bin/bash

# make a for loop from number 0 to 10

MENU_OPTION="1" CLIENT="ovpn-profile-1" PASS="1" ./openvpn-install.sh
MENU_OPTION="1" CLIENT="ovpn-profile-2" PASS="1" ./openvpn-install.sh
MENU_OPTION="1" CLIENT="ovpn-profile-3" PASS="1" ./openvpn-install.sh

# log storage_container_connection_string
echo "storage_container_connection_string: ${storage_container_connection_string}"

# log storage_container_name
echo "storage_container_name: ${storage_container_name}"

# get the home directory of the current user

cat > upload_ovpn_files.py << EOL
import os
import sys
from azure.storage.blob import BlobServiceClient, BlobClient, ContainerClient

# Get the connection string and container name from the command line arguments
connection_string = """${storage_container_connection_string}"""
container_name = """${storage_container_name}"""

# Use the BlobServiceClient to create a client for the container
blob_service_client = BlobServiceClient.from_connection_string(connection_string)
container_client = blob_service_client.get_container_client(container_name)

# Loop through all files in the current directory
for filename in os.listdir("/root"):
    print(filename)
    if filename.endswith(".ovpn"):
        # Create a blob client using the filename as the blob name
        blob_client = container_client.get_blob_client(filename)
        with open("/root/" + filename, "rb") as data:
            # Upload the contents of the file to the blob
            blob_client.upload_blob(data)
            print("Uploaded file: " + filename)
EOL

# Make the file executable
chmod +x upload_ovpn_files.py


python3 upload_ovpn_files.py
sleep 60