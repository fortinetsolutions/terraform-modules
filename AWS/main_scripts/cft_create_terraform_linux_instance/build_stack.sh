#!/usr/bin/env bash

source $(dirname $0)/stack_parameters.sh

pause=15

usage()
{
cat << EOF
usage: $0 options

This script will deploy a series of cloudformation templates that build and protect a workload

OPTIONS:
   -k pause for keyboard input
   -p pause value between AWS queries
EOF
}

while getopts kp: OPTION
do
     case $OPTION in
         k)
             KI_SPECIFIED=true
             ;;
         p)
             PAUSE_SPECIFIED=true
             PAUSE_VALUE=$OPTARG
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

if [ "$PAUSE_SPECIFIED" == true ]
then
    pause=$PAUSE_VALUE
fi

if [ "$KI_SPECIFIED" == true ]
then
    keypress_loop=true
else
    keypress_loop=false
fi
while [ $keypress_loop == true ]
do
    echo
    read -t 1 -n 10000 discard
    read -n1 -r -p "Press enter to deploy base vpc..." keypress
    if [[ "$keypress" == "" ]]
    then
        keypress_loop=false
    fi
done

if [ "${KI_SPECIFIED}" == true ]
then
    echo "Deploying "$stack1" Template and the script will pause when the create-stack is complete"
else
    echo "Deploying "$stack1" Template"
fi


#
# deploy the stack if it doesn't already exist
#
count=`aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE --output text --region "$region" |grep "$stack1" |wc -l`
if [ "${count}" -eq "0" ]
then
    aws cloudformation create-stack --stack-name "$stack1" --output text --region "$region" --template-body file://NewVPC_BaseSetup_Single.yaml \
        --parameters ParameterKey=VPCCIDR,ParameterValue="$vpc_cidr" \
         ParameterKey=Public1Subnet,ParameterValue="$subnet_cidr" \
         ParameterKey=AZForSubnet1,ParameterValue="$aws_az" > /dev/null
fi

#
# Wait for template above to CREATE_COMPLETE
#
for (( c=1; c<=50; c++ ))
do
    count=`aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE --output text --region "$region" |grep "$stack1" |wc -l`
    if [ "${count}" -ne "0" ]
    then
        break
    fi
    sleep $pause
done

#
# Pull the outputs from the first template as environment variables that are used in the second and third templates
#
tfile=$(mktemp /tmp/foostack1.XXXXXXXXX)
aws cloudformation describe-stacks --output text --region "$region" --stack-name "$stack1" --query 'Stacks[*].Outputs[*].{KEY:OutputKey,Value:OutputValue}' > $tfile
VPC=`cat $tfile|grep ^VPCID|cut -f2 -d$'\t'`
SUBNET=`cat $tfile|grep ^SubnetID|cut -f2 -d$'\t'`
if [ -f $tfile ]
then
    rm -f $tfile
fi

echo
echo "Created VPC = $VPC"
echo "Subnet 1 = $SUBNET"
echo

if [ "$KI_SPECIFIED" == true ]
then
    keypress_loop=true
else
    keypress_loop=false
fi
while [ $keypress_loop == true ]
do
    read -t 1 -n 10000 discard
    read -n1 -r -p "Press enter to deploy linux instance..." keypress
    if [[ "$keypress" == "" ]]
    then
        keypress_loop=false
    fi
done

if [ "${KI_SPECIFIED}" == true ]
then
    echo "Deploying "$stack2" Template and the script will pause when the create-stack is complete"
else
    echo "Deploying "$stack2" Template"
fi

#
# Now deploy linux web server instances in the private subnets on top of the existing VPC
#
count=`aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE --output text --region "$region" |grep "$stack2" |wc -l`
if [ "${count}" -eq "0" ]
then
    aws cloudformation create-stack --stack-name "$stack2" --output text --region "$region" --capabilities CAPABILITY_IAM \
        --template-body file://ExistingVPC_LinuxInstance.yaml \
        --parameters    ParameterKey=VPCID,ParameterValue="$VPC" \
                    ParameterKey=Public1Subnet,ParameterValue="$SUBNET" \
                    ParameterKey=KeyPair,ParameterValue="$key" \
                    ParameterKey=InstanceType,ParameterValue="$linux_instance_type" \
                    ParameterKey=CIDRForInstanceAccess,ParameterValue="$access" \
                    ParameterKey=AZForInstance1,ParameterValue="$aws_az" >/dev/null
fi

#
# Wait for template above to CREATE_COMPLETE
#
if [ "${KI_SPECIFIED}" == true ]
then
    for (( c=1; c<=50; c++ ))
    do
        count=`aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE --output text --region "$region" |grep "$stack2" |wc -l`
        if [ "${count}" -ne "0" ]
        then
            break
        fi
        sleep $pause
    done
fi

tfile=$(mktemp /tmp/foostack5.XXXXXXXXX)
aws cloudformation describe-stacks --stack-name "$stack2" --output text --region "$region" \
    --query 'Stacks[*].Outputs[*].{KEY:OutputKey,Value:OutputValue}' > $tfile
wl1=`cat $tfile|grep ^LinuxInstanceID|cut -f2 -d$'\t'`
wl1_ip=`cat $tfile|grep ^LinuxInstanceIP|cut -f2 -d$'\t'`
if [ -f $tfile ]
then
    rm -f $tfile
fi

echo
echo "Linux instance ID = $wl1"
echo "Linux Public IP Address = $wl1_ip"
echo

#
# End of the script
#
