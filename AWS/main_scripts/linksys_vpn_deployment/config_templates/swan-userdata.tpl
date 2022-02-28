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
        uniqueids=yes
        strictcrlpolicy=no

# connection to amsterdam datacenter
conn fortigate-to-swan
	authby=secret
	left=%defaultroute
	leftid=${swan_vpn_public_ip}
	leftsubnet=${swan_protected_cidr}
	right=${fgt_vpn_public_ip}
	rightsubnet=${fortigate_protected_cidr}
	ike=aes256-sha2_256-modp1024!
	esp=aes256-sha2_256!
	keyingtries=0
	ikelifetime=1h
	lifetime=8h
	dpddelay=30
	dpdtimeout=120
	dpdaction=restart
	auto=start
VPN-CONFIG

#
# NAT the protected cidr range
#
sudo iptables -t nat -A POSTROUTING -s ${swan_protected_cidr} -d ${fortigate_protected_cidr} -J MASQUERADE

#
# set the strongswan service to start on boot
#
systemctl enable strongswan
