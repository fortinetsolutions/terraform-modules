#! /bin/bash
echo "Welcome to TGW Attachment Routing Demo" > /var/www/html/demo.txt
sudo apt update
sudo apt -y install apache2
sudo ufw allow 'Apache'
sudo systemctl start apache2
