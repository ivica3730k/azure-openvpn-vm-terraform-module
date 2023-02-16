#!/bin/bash

ufw allow 1194/udp
# fix permissions
chmod -R 755 /etc/openvpn
# fix permissions in logs
chmod -R 755 /var/log/openvpn
# restart openvpn
systemctl restart openvpn@server