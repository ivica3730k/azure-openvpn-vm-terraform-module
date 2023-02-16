#!/bin/bash

# get ovpn-install script
curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
chmod +x openvpn-install.sh

# run ovpn-install script
AUTO_INSTALL=y ./openvpn-install.sh
