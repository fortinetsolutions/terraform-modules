Content-Type: multipart/mixed; boundary="===============0086047718136476635=="
MIME-Version: 1.0

--===============0086047718136476635==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="config"

config system global
set hostname fgt-1
set admintimeout 60
end

config system "admin"
edit admin
set password ${fortigate_admin_password}
set force-password-change disable
set gui-default-dashboard-template "minimal"
set gui-ignore-release-overview-version "7.0.0"
next
end

config system interface
edit "port1"
set vdom "root"
set mode dhcp
set allowaccess ping https ssh http fgfm
set type physical
set mtu-override enable
set mtu 9001
next
end

config system geneve
edit "gwlb1-az1"
set interface "port1"
set type ppp
set remote-ip ${gwlb_ip1}
next
edit "gwlb1-az2"
set interface "port1"
set type ppp
set remote-ip ${gwlb_ip2}
next
end

config system zone
edit "gwlb1-tunnels"
set interface "gwlb1-az1" "gwlb1-az2"
next
end

config router static
edit 1
set distance 5
set priority 100
set device "gwlb1-az1"
next
edit 2
set distance 5
set priority 100
set device "gwlb1-az2"
next
end

config router policy
edit 1
set input-device "gwlb1-az1"
set dst "10.0.0.0/255.0.0.0" "17.16.0.0/255.255.240.0" "192.168.0.0/255.255.0.0"
set output-device "gwlb1-az1"
next
edit 2
set input-device "gwlb1-az1"
set src "10.0.0.0/255.0.0.0" "17.16.0.0/255.255.240.0" "192.168.0.0/255.255.0.0"
set output-device "gwlb1-az1"
next
edit 3
set input-device "gwlb1-az2"
set dst "10.0.0.0/255.0.0.0" "172.16.0.0/255.255.240.0" "192.168.0.0/255.255.0.0"
set output-device "gwlb1-az2"
next
edit 4
set input-device "gwlb1-az2"
set src "10.0.0.0/255.0.0.0" "172.16.0.0/255.255.240.0" "192.168.0.0/255.255.0.0"
set output-device "gwlb1-az2"
next
end

config firewall address
edit "10.0.0.0/8"
set subnet 10.0.0.0 255.0.0.0
next
edit "172.16.0.0/20"
set subnet 172.16.0.0 255.255.240.0
next
edit "192.168.0.0/16"
set subnet 192.168.0.0 255.255.0.0
next
edit "UnitedStates"
set type geography
set country "US"
next
edit "UnitedStatesIslands"
set type geography
set country "UM"
next
edit "Canada"
set type geography
set country "CA"
next
end

config firewall addrgrp
edit "rfc-1918-subnets"
set member "10.0.0.0/8" "172.16.0.0/20" "192.168.0.0/16"
next
edit "NorthAmerica"
set member "Canada" "UnitedStates" "UnitedStatesIslands"
next
end

config firewall policy
edit 1
set name "egress"
set srcintf "gwlb1-tunnels"
set dstintf "port1"
set srcaddr "rfc-1918-subnets"
set dstaddr "NorthAmerica"
set action accept
set schedule "always"
set service "ALL"
set logtraffic all
set nat enable
next
edit 2
set name "ingress"
set srcintf "gwlb1-tunnels"
set dstintf "gwlb1-tunnels"
set srcaddr "NorthAmerica"
set dstaddr "rfc-1918-subnets"
set action accept
set schedule "always"
set service "ALL"
set logtraffic all
next
edit 3
set name "egress-hairpin"
set srcintf "gwlb1-tunnels"
set dstintf "gwlb1-tunnels"
set srcaddr "rfc-1918-subnets"
set dstaddr "NorthAmerica"
set action accept
set schedule "always"
set service "ALL"
set logtraffic all
next
edit 4
set name "east-west"
set srcintf "gwlb1-tunnels"
set dstintf "gwlb1-tunnels"
set srcaddr "rfc-1918-subnets"
set dstaddr "rfc-1918-subnets"
set action accept
set schedule "always"
set service "ALL"
set logtraffic all
next
end

--===============0086047718136476635==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="license"

${fgt1_byol_license}

--===============0086047718136476635==--