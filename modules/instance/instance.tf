resource "aws_instance" "my-inst" {
    ami = var.ami
    instance_type = var.instance
    key_name = "Cloudops"
    subnet_id = var.subnet
  
}

resource "aws_security_group" "my-sg" {
    name = "my-sg"
    description = "my-sg"
    vpc_id = var.vpc
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}

