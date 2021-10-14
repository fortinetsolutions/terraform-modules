#! /bin/bash
sudo mkdir -p /var/www/html
sudo echo "Welcome to TGW Attachment Routing Demo" > /var/www/html/demo.txt
sudo apt update
sudo apt -y install apache2
sudo ufw allow 'Apache'
sudo systemctl start apache2
sudo apt remove python python3.5 python3.6 python3.7 --yes
sudo apt install python3.7 python3.7-venv python3-pip --yes
sudo apt install -y lsb-release
sudo apt install -y software-properties-common
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt install -y terraform
