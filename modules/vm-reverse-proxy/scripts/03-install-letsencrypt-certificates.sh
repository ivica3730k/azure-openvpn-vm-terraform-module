#!/bin/bash

%{ for reverse_proxy_entry in reverse_proxy_entries ~}
echo "Installing certificate for ${reverse_proxy_entry.domain_name} using email ${reverse_proxy_entry.letsencrypt_email}"
certbot --nginx -d ${reverse_proxy_entry.domain_name} --agree-tos --non-interactive --email ${reverse_proxy_entry.letsencrypt_email}
%{ endfor ~}