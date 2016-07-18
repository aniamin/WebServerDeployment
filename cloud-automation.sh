#!/bin/bash

if [ "$#" -ne 8 ]; then
  echo "Usage: cloud-automation.sh <app> <web_server_environment> <web_num_servers> <web_server_size> <jumpserver> <jumpserver_server_environment> <jumpbox_num_servers> <jumpbox_server_size>" >&2
  exit 1
fi

if [ -n "$1" ]; then
	if ! [ -z "$1" ]; then
		APP_NAME="$1"
	else
		echo >&2 'Please provide a valid App Name'
		exit 1
	fi
fi

if [ -n "$2" ]; then
	if [[ "$2" =~ ^(dev|production|staging)$ ]]; then
		WEB_AWS_ENV="$2"
	else
		echo >&2 'Please provide a valid env'
		exit 1
	fi
fi

if [ -n "$3" ]; then
	if [[ "$3" =~ ^[0-9]+$ ]]; then
		WEB_NUMBER_OF_SERVERS="$3"
	else
		echo >&2 'Please provide a valid number to launch valid number of instance'
		exit 1
	fi
fi

# Just allowing user to launch t2 Type of instances
if [ -n "$4" ]; then
	if [[ "$4" =~ ^(t2.nano|t2.micro|t2.small|t2.medium|t2.large)$ ]]; then
		WEB_SERVER_SIZE="$4"
	else
		echo >&2 'Only Allowed to launch T2 type server'
		exit 1
	fi
fi

if [ -n "$5" ]; then
	if ! [ -z "$5" ]; then
		JUMPBOX_APP_NAME="$1"
	else
		echo >&2 'Please provide a valid JUMPBOX Name'
		exit 1
	fi
fi

if [ -n "$6" ]; then
	if [[ "$6" =~ ^(dev|production|staging)$ ]]; then
		JUMPBOX_AWS_ENV="$6"
	else
		echo >&2 'Please provide a valid JUMPBOX env'
		exit 1
	fi
fi

if [ -n "$7" ]; then
	if [[ "$7" =~ ^[0-9]+$ ]]; then
		JUMPBOX_NUMBER_OF_SERVERS="$7"
	else
		echo >&2 'Please provide a valid number to launch valid number of JUMPBOX instance'
		exit 1
	fi
fi

# Just allowing user to launch t2 Type of instances
if [ -n "$8" ]; then
	if [[ "$8" =~ ^(t2.nano|t2.micro|t2.small|t2.medium|t2.large)$ ]]; then
		JUMPBOX_SERVER_SIZE="$8"
	else
		echo >&2 'Only Allowed to launch T2 type  JUMPBOX server'
		exit 1
	fi
fi

echo $APP_NAME
echo $WEB_AWS_ENV
echo $WEB_NUMBER_OF_SERVERS
echo $WEB_SERVER_SIZE
echo $JUMPBOX_APP_NAME
echo $JUMPBOX_AWS_ENV
echo $JUMPBOX_NUMBER_OF_SERVERS
echo $JUMPBOX_SERVER_SIZE

cd terraform
export PATH=/usr/local/terraform/bin:/Users/newscred/Sites/terraform/:$PATH
terraform get

terraform plan \
-var app=$APP_NAME \
-var web_server_env=$WEB_AWS_ENV \
-var web_server_count=$WEB_NUMBER_OF_SERVERS \
-var web_server_size=$WEB_SERVER_SIZE \
-var jumpbox=$JUMPBOX_APP_NAME \
-var jumpbox_server_env=$JUMPBOX_AWS_ENV \
-var jumpbox_server_count=$JUMPBOX_NUMBER_OF_SERVERS \
-var jumpbox_server_size=$JUMPBOX_SERVER_SIZE

terraform apply \
-var app=$APP_NAME \
-var web_server_env=$WEB_AWS_ENV \
-var web_server_count=$WEB_NUMBER_OF_SERVERS \
-var web_server_size=$WEB_SERVER_SIZE \
-var jumpbox=$JUMPBOX_APP_NAME \
-var jumpbox_server_env=$JUMPBOX_AWS_ENV \
-var jumpbox_server_count=$JUMPBOX_NUMBER_OF_SERVERS \
-var jumpbox_server_size=$JUMPBOX_SERVER_SIZE

ELB_DNS=$(terraform output elb_dns_name)
