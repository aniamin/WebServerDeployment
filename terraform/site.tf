# Provider spcific
provider "aws" {
	access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.aws_region}"
}

# Variables for VPC module
module "vpc_subnets" {
	source = "./modules/vpc_subnets"
	name = "${var.vpc_name}"
	environment = "${var.web_server_env}"
	enable_dns_support = true
	enable_dns_hostnames = true
	vpc_cidr = "172.32.0.0/16"
    public_subnets_cidr = "172.32.0.0/24"
    private_subnets_cidr = "172.32.10.0/24"
    azs    = "eu-west-1a,eu-west-1b"
}

module "elb_sg" {
	source = "./modules/elb_sg"
	name = "elb-nowshad-sre"
	environment = "${var.web_server_env}"
	vpc_id = "${module.vpc_subnets.vpc_id}"
}

module "ssh_sg" {
	source = "./modules/ssh_sg"
	name = "jumpbox-nowshad-sre"
	environment = "${var.jumpbox_server_env}"
	vpc_id = "${module.vpc_subnets.vpc_id}"
	source_cidr_block = "0.0.0.0/0"
}

module "web_sg" {
	source = "./modules/web_sg"
	name = "web-nowshad-sre"
	environment = "${var.web_server_env}"
	vpc_id = "${module.vpc_subnets.vpc_id}"
	source_cidr_block = "${module.elb_sg.elb_sg_id}"
}

module "ec2key" {
	source = "./modules/ec2key"
	key_name = "dubizzle"
	public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCcdidoEMYunlC/MLczt+iWKZl7lLu8MaBAD0bQLb1sIVxzO05QJG8ItgJbhGtZXP2wMnElQQB8KjIO33i56UHA67dE45c1ODPRY3nhgUFSmIQfvuxH7ddljMMzK6FOm2EKnz+FPKp6zjDqN1h2/YzN4Dvgjq0WdlzJ/OtFlYr7upqAlxNJ+0jZH3jTRUOuSHNX6XZKMxfdebIYVdfkxkKiu1i6bd3UHvkpIgPcUqM0FXW9SKU3ycR0M1DePPkCxuVq2WbTtdq2wRqDvTOzfECL76U3WUdhgQvW4vjx6QYrzYLhN0l224I4fzNoYGmc3RZJP+s+AhW7QzWllVY3ekC/"
}

module "jumbox" {
	source = "./modules/ec2"
	name = "jumbox-nowshad-sre"
	environment = "${var.jumpbox_server_env}"
	server_role = "jumpbox"
	ami_id = "ami-14913f63"
	key_name = "${module.ec2key.ec2key_name}"
	count = "${var.jumpbox_server_count}"
	security_group_id = "${module.ssh_sg.ssh_sg_id}"
	subnet_id = "${module.vpc_subnets.public_subnets_id}"
	instance_type = "${var.jumpbox_server_size}"
	user_data = "#!/bin/bash\nyum -y update"
}

module "web" {
	source = "./modules/ec2"
	name = "web-nowshad-sre"
	environment = "${var.web_server_env}"
	server_role = "webapp"
	ami_id = "ami-f95ef58a"
	key_name = "${module.ec2key.ec2key_name}"
	count = "${var.web_server_count}"
	security_group_id = "${module.web_sg.web_sg_id}"
	subnet_id = "${module.vpc_subnets.private_subnets_id}"
	instance_type = "${var.web_server_size}"
	user_data = "#!/bin/bash\napt-get -y update"
}

module "elb" {
	source = "./modules/elb"
	name = "elb-nowshad-sre"
	environment = "${var.web_server_env}"
	security_groups = "${module.elb_sg.elb_sg_id}"
	availability_zones = "us-east-1a,us-east-1b"
	subnets = "${module.vpc_subnets.public_subnets_id}"
	instance_id = "${module.web.ec2_id}"
}
