#!/usr/bin/env bash

stack_prefix=terraform-linux-dev
stack1=$stack_prefix-base
stack2=$stack_prefix-linux

region=us-west-2
aws_az=us-west-2a

vpc_cidr="10.0.0.0/16"
subnet_cidr="10.0.0.0/24"
linux_instance_type=c4.large
key=mdw-key-oregon
access="0.0.0.0/0"
