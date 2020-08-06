upstream backend {
    server ${gitlab_ip}:80;
}

map $http_upgrade $connection_upgrade {
    default upgrade;
    '' close;
}

server {
    listen 80;
    server_name ${subdomain}.${domain};
    return 301 https://${subdomain}.${domain}$request_uri;
}

server {
    server_name ${subdomain}.${domain};
    listen 443 ssl;

    include snippets/ssl-_.${domain}.conf;
    include snippets/ssl-params.conf;

    access_log /var/log/nginx/${subdomain}.${domain}/access.log;
    error_log /var/log/nginx/${subdomain}.${domain}/error.log;

    root /var/www/brvy.space/code;

    location / {
        try_files $uri @proxy;
    }

    location @proxy {
        proxy_set_header X_FORWARDED_PROTO https;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Url-Scheme $scheme;
        proxy_set_header Host $host;
        proxy_set_header Authorization $http_authorization;
        proxy_redirect off;
        proxy_pass http://backend;
    }
}