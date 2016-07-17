resource "aws_security_group" "web_sg" {
    name = "${var.name}-${var.environment}-web"
    description = "Security Group ${var.name}-${var.environment}"
    vpc_id = "${var.vpc_id}"
    tags {
      Name = "${var.name}-${var.environment}-web"
      environment =  "${var.environment}"
    }
    
    // allow traffic for TCP 22
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        self = true
    }
    
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["172.32.0.0/16"]
    }

    // allow traffic for TCP 80
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["172.32.0.0/16"]
    }

    // allow traffic for TCP 443
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["172.32.0.0/16"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }  
}

output "web_sg_id" {
  value = "${aws_security_group.web_sg.id}"
}