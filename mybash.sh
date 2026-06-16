

# Start a site
site-on() {
    sudo ln -sf /etc/nginx/sites-available/$1 /etc/nginx/sites-enabled/
    sudo nginx -t && sudo nginx -s reload
}

# Stop a site
site-off() {
    sudo rm /etc/nginx/sites-enabled/$1
    sudo nginx -t && sudo nginx -s reload
}

