#cloud-config
fqdn: ubuntu-east
repo_update: true
repo_upgrade: true
write_files:
    - path: /etc/cloud/cloud.cfg.d/99-custom-networking.cfg
      permissions: '0644'
      content: |
        network: {config: disabled}
    - path: /etc/netplan/my-new-config.yaml
      permissions: '0644'
      content: |
        network:
            version: 2
            ethernets:
                ens5:
                    dhcp4: true
                ens7:
                    dhcp4: false
                    addresses: [192.168.0.38/27]
                    routes:
                    - to: 192.168.0.128/25
                      via: 192.168.0.33
packages:
    - apache2
    - net-tools
runcmd:
    - [ sh, -c, "echo 'Welcome to TGW Attachment Routing Demo' > /var/www/html/demo.txt" ]
    - sudo ufw allow 'Apache'
    - sudo systemctl start apache2
    - rm /etc/netplan/50-cloud-init.yaml
    - mv /etc/netplan/my-new-config.yaml /etc/netplan/50-cloud-init.yaml
    - netplan generate
    - netplan apply
output : { all : '| tee -a /var/log/cloud-init-output.log' }