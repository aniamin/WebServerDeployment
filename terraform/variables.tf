variable access_key {
	default = "******"
}
variable secret_key {
	default = "*****"
}
variable aws_region {
	default = "eu-west-1"
}

variable vpc_name {
	default = "dubizzle-nowshad-sre"
}

variable app {
	default = "web"
}
variable web_server_env {
	default = "dev"
}
variable web_server_count {
	default = 1
}
variable web_server_size {
	default = "t2.medium"
}

variable jumpbox {
	default = "jumpbox"
}

variable jumpbox_server_env {
	default = "dev"
}
variable jumpbox_server_count {
	default = 1
}
variable jumpbox_server_size {
	default = "t2.small"
}
