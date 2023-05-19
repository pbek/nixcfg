#!/usr/bin/env bash

set -e

# TODO: store that file as agix secret
# TODO: doesn't seem to work yet
source .pia.env

# TODO: jump to the right directory first
cd ../vendor/pia

# https://github.com/pia-foss/manual-connections
sudo VPN_PROTOCOL=wireguard DISABLE_IPV6=yes DIP_TOKEN=no AUTOCONNECT=true PIA_PF=false PIA_DNS=false ./run_setup.sh
