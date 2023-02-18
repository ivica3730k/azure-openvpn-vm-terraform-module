#!/bin/bash

%{ for reverse_proxy_entry in reverse_proxy_entries ~}

# Create a file for the reverse proxy entry
cat > /etc/nginx/sites-available/${reverse_proxy_entry.name} <<EOL
server {
    listen 80;
    listen [::]:80;
    server_name ${reverse_proxy_entry.domain_name};
    location / {
        proxy_pass http://${reverse_proxy_entry.backend_ip_address}:${reverse_proxy_entry.backend_port};
    }
}
EOL

# Create a symbolic link to the file in the sites-enabled directory
ln -s /etc/nginx/sites-available/${reverse_proxy_entry.name} /etc/nginx/sites-enabled/

%{ endfor ~}

# Restart nginx
systemctl restart nginx