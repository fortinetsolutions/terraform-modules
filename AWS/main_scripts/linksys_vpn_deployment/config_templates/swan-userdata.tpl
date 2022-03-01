#! /bin/bash
#
# upgrade and install required packages
#
apt update && apt-upgrade -y
apt install -y lsb-release net-tools
apt install -y strongswan

#
# set required sysctl options
#
cat >> /etc/sysctl.conf << EOF
echo net.ipv4.ip_forward = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
EOF
sysctl -p /etc/sysctl.conf

#
# Configure ipsec.secrets file
#
cat > /etc/ipsec.secrets << EOF
# source destination
${fgt_vpn_public_ip} ${swan_vpn_public_ip} : PSK "${swan_vpn_psk}"
EOF

#
# Configure ipsec.conf file
#
cat > /etc/ipsec.conf <<VPN-CONFIG
# basic configuration
config setup
        charondebug="all"

conn %default
	rekeymargin=1m
	keyingtries=3
	type=tunnel
	keyexchange=ikev2

conn swan-to-fortigate
	auto=add
	leftid=${swan_vpn_public_ip}
	leftsubnet=${swan_protected_cidr}
	leftauth=psk
	right=${fgt_vpn_public_ip}
	rightsubnet=${fortigate_protected_cidr}
	rightauth=psk
VPN-CONFIG

#
# NAT the protected cidr range
#
sudo iptables -t nat -A POSTROUTING -s ${swan_protected_cidr} -d ${fortigate_protected_cidr} -J MASQUERADE

#
# set the strongswan service to start on boot
#
systemctl enable strongswan
systemctl restart ipsec
