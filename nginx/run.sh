#!/usr/bin/env bash

FRONTENDS=""

# Loop until we've found all the linked upstream servers.
for (( i=1; ; i++ )); do
    addr_var=SERVER${i}_PORT_5000_TCP_ADDR
    port_var=SERVER${i}_PORT_5000_TCP_PORT
    addr="${!addr_var}"
    port="${!port_var}"

    if [ -z $addr ]; then
        break
    fi

    FRONTENDS+="server $addr:$port;"
done

# Write Nginx config file.
cat > /etc/nginx/nginx.conf << EOL
daemon off;

events {
    worker_connections 1024;
}

http {
    # App servers.
    upstream frontends { $FRONTENDS }

    server {
        listen 80;

        # Pass requests to servers via reverse proxy.
        location / {
            proxy_pass http://frontends;
            proxy_pass_header Server;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Scheme \$scheme;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_redirect off;
        }
    }
}
EOL

# Run Nginx.
service nginx start
