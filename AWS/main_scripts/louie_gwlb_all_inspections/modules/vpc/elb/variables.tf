
variable "region" {}
variable "elb_type" {}
variable "elb_internal" {}
variable "elb_listner_port" {}
variable "web_app1_name" {
  default = ""
}
variable "web_app2_name" {
  default = ""
}
variable "elb_app1_targetgroup_port" {
  default = ""
}
variable "elb_app2_targetgroup_port" {
  default = ""
}
variable "vpc_id" {}
variable "subnet1_id" {}
variable "subnet2_id" {}
variable "instance1_id" {}
variable "instance2_id" {}
variable "tag_name_prefix" {}
variable "tag_name_unique" {}