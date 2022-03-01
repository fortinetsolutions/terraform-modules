Content-Type: multipart/mixed; boundary="===============0086047718136476635=="
MIME-Version: 1.0

--===============0086047718136476635==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="config"

config system global
set hostname ${fgt_id}
set admintimeout 60
end
config system admin
edit "admin"
set password ${fgt_admin_password}
set gui-default-dashboard-template "minimal"
set gui-ignore-release-overview-version "7.0.0"
next
end
config system interface
edit port1
set alias public
set mode static
set ip ${Port1IP} ${public_subnet_mask}
set allowaccess ping https ssh fgfm
set mtu-override enable
set mtu 9001
next
edit port2
set alias private
set mode static
set ip ${Port2IP} ${private_subnet_mask}
set allowaccess ping fgfm
set mtu-override enable
set mtu 9001
next
edit ${fortigate_vpn_tunnel_name}
set vdom "root"
set type tunnel
set snmp-index 7
set interface "port1"
next
end
config firewall address
edit "${fortigate_vpn_tunnel_name}_local"
set member "${fortigate_vpn_tunnel_name}_local_subnet_1"
set comment "VPN: ${fortigate_vpn_tunnel_name}"
set allow-routing enable
next
edit "${fortigate_vpn_tunnel_name}_remote"
set member "${fortigate_vpn_tunnel_name}_remote_subnet_1"
set comment "VPN: ${fortigate_vpn_tunnel_name}"
set allow-routing enable
next
end
config firewall addrgrp
edit "${fortigate_vpn_tunnel_name}_local"
set member "${fortigate_vpn_tunnel_name}_local_subnet_1"
set comment "VPN: ${fortigate_vpn_tunnel_name}"
set allow-routing enable
next
edit "${fortigate_vpn_tunnel_name}_remote"
set member "${fortigate_vpn_tunnel_name}_remote_subnet_1"
set comment "VPN: ${fortigate_vpn_tunnel_name}"
set allow-routing enable
next
end
config vpn ipsec phase1-interface
edit ${fortigate_vpn_tunnel_name}
set interface "port1"
set ike-version 2
set peertype any
set net-device disable
set proposal aes128-sha256 aes256-sha256 aes128-sha1 aes256-sha1
set comments "VPN: ${fortigate_vpn_tunnel_name}"
set nattraversal disable
set remote-gw ${swan_vpn_public_ip}
set psksecret ${swan_vpn_psk}
next
end
config vpn ipsec phase2-interface
edit ${fortigate_vpn_tunnel_name}
set phase1name ${fortigate_vpn_tunnel_name}
set proposal aes128-sha1 aes256-sha1 aes128-sha256 aes256-sha256 aes128gcm aes256gcm chacha20poly1305
set pfs disable
set comments "VPN: ${fortigate_vpn_tunnel_name}"
set src-addr-type name
set dst-addr-type name
set src-name "${fortigate_vpn_tunnel_name}_local"
set dst-name "${fortigate_vpn_tunnel_name}_remote"
next
end
config router static
edit 1
set device port1
set gateway ${PublicSubnetRouterIP}
next
edit 2
set device port2
set dst ${PrivateSubnet}
set gateway ${PrivateSubnetRouterIP}
next
edit 3
set device
set comment "VPN: ${fortigate_vpn_tunnel_name}"
set dstaddr "${fortigate_vpn_tunnel_name}_remote"
next
edit 4
set distance 254
set comment "VPN: ${fortigate_vpn_tunnel_name}"
set blackhole enable
set dstaddr "${fortigate_vpn_tunnel_name}_remote"
next
end
config firewall policy
edit 0
set name "vpn_${fortigate_vpn_tunnel_name}_local_0"
set srcintf "port2"
set dstintf ${fortigate_vpn_tunnel_name}
set action accept
set srcaddr "${fortigate_vpn_tunnel_name}_local"
set dstaddr "${fortigate_vpn_tunnel_name}_remote"
set schedule "always"
set service "ALL"
set comments "VPN: ${fortigate_vpn_tunnel_name}"
next
edit 0
set name "vpn_${fortigate_vpn_tunnel_name}_remote_0"
set srcintf ${fortigate_vpn_tunnel_name}
set dstintf "port2"
set action accept
set srcaddr "${fortigate_vpn_tunnel_name}_remote"
set dstaddr "${fortigate_vpn_tunnel_name}_local"
set schedule "always"
set service "ALL"
set comments "VPN: ${fortigate_vpn_tunnel_name}"
next
end

--===============0086047718136476635==--