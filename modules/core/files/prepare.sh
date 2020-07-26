#!/bin/sh
domain=$1
subdomain=$2
mkdir -p /etc/nginx/sites-available/$domain /var/log/nginx/$subdomain.$domain
file="/etc/nginx/sites-enabled/10-$subdomain.$domain"
if [ -h "$file" ]; then
    unlink $file
fi