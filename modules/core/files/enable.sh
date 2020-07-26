#!/bin/sh
domain=$1
subdomain=$2
ln -s /etc/nginx/sites-available/$domain/$subdomain /etc/nginx/sites-enabled/10-$subdomain.$domain
nginx -t
if [ $? == "0" ]; then
    systemctl restart nginx
fi