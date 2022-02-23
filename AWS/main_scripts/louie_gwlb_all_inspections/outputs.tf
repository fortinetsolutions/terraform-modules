output "fgt_login_info" {
  value = <<-FGTLOGIN
  # fgt username: admin
  # fgt initial password: instance-id of the fgt
  # fgt1 login url: https://${module.fgcp-ha.fgt1_eip_public_ip}
  # fgt2 login url: https://${module.fgcp-ha.fgt2_eip_public_ip}
  FGTLOGIN
}

output "public_nlb_test_urls" {
  value = <<-NLBURL
  # nlb app1 url - provides fixed content from the spoke1 web servers through the security stack
  http://${element(module.spoke1-vpc-public-nlb.nlb_dns, 0)}/app1/index.html
  # nlb app2 url - provides fixed content from the spoke2 web servers through the security stack
  http://${element(module.spoke2-vpc-public-nlb.nlb_dns, 0)}/app2/index.html
  NLBURL
}

output "web_server_login_info" {
  value = <<-WEBLOGIN
  # spoke1_web1 SSH info: ssh -i ${var.keypair} ubuntu@${module.spoke1-web1.web_eip}
  # spoke1_web2 SSH info: ssh -i ${var.keypair} ubuntu@${module.spoke1-web2.web_eip}
  # spoke2_web1 SSH info: ssh -i ${var.keypair} ubuntu@${module.spoke2-web1.web_eip}
  # spoke2_web2 SSH info: ssh -i ${var.keypair} ubuntu@${module.spoke2-web2.web_eip}
  WEBLOGIN
}

output "tgw_info" {
  value = <<-TGWINFO
  # tgw id: ${module.transit-gw.tgw_id}
  # tgw spoke route table id: ${module.transit-gw.tgw_spoke_route_table_id}
  # tgw security route table id: ${module.transit-gw.tgw_security_route_table_id}
  TGWINFO
}

output "gwlb_info" {
  value = <<-GWLBINFO
  # gwlb arn_suffix: ${element(module.security-vpc-gwlb.gwlb_arn_suffix, 0)}
  # gwlb service_name : ${module.security-vpc-gwlb.gwlb_endpoint_service_name}
  # gwlb service_type : ${module.security-vpc-gwlb.gwlb_endpoint_service_type}
  # gwlb gwlb_ip1 : ${element(module.security-vpc-gwlb.gwlb_ip1, 0)}
  # gwlb gwlb_ip2 : ${element(module.security-vpc-gwlb.gwlb_ip2, 0)}
  GWLBINFO
}