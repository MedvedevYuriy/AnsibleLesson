variable "zone_id" {
  type = "string"
  default = "ZUYOKXBWM9MWO"
}

variable "aws_access_key" {
  default = ""
}

variable "aws_secret_key" {
  default = ""
}

variable "ssh_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "us-east-1"
}

resource "aws_security_group" "dm_zone" {
  name = "dm_zone"
}

resource "aws_security_group_rule" "allow_icmp_out" {
  type            = "egress"
  from_port = -1
  to_port = -1
  protocol = "-1"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.dm_zone.id}"
}

resource "aws_security_group_rule" "allow_icmp_in" {
  type            = "ingress"
  from_port = -1
  to_port = -1
  protocol = "-1"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.dm_zone.id}"
}

resource "aws_key_pair" "key" {
  key_name = "seckey"
  public_key = "${file("${var.ssh_key_path}")}"
}

resource "aws_instance" "testmachine" {
  ami = "ami-0ac019f4fcb7cb7e6" 
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.key.key_name}"
  security_groups = ["${aws_security_group.dm_zone.name}"]
  
  tags {
    Name = "test"
  }
}

resource "aws_route53_record" "testdns" {
  zone_id = "${var.zone_id}"
  name = "test.syb.srwx.net"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.testmachine.public_ip}"]
}
