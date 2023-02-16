#!/bin/bash
%{ for u in users ~}
MENU_OPTION="1" CLIENT="ovpn-${u}" PASS="1" ./openvpn-install.sh
%{ endfor }

cat >upload_ovpn_files.py <<EOL
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
    if filename.endswith(".ovpn"):
        # Create a blob client using the filename as the blob name
        blob_client = container_client.get_blob_client(filename)
        with open("/root/" + filename, "rb") as data:
            # Upload the contents of the file to the blob
            blob_client.upload_blob(data, overwrite=True)
            print("Uploaded file: " + filename)
            # Delete the file
            os.remove("/root/" + filename)
EOL

chmod +x upload_ovpn_files.py
python3 upload_ovpn_files.py
