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

variable "domains" {
  type = "list"
  default = ["front", "back"]
}

variable "ssh_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "ports" {
  default = ["80", "443", "8080", "8443"]
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "us-east-1"
}

resource "aws_key_pair" "key" {
  key_name = "seckey"
  public_key = "${file("${var.ssh_key_path}")}"
}

resource "aws_security_group" "secgroup" {
  name = "security"
}

resource "aws_security_group_rule" "allow_out" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.secgroup.id}"
}

resource "aws_security_group_rule" "allow_in" {
  count = "${length(var.ports)}"

  type = "ingress"
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  from_port = "${element(var.ports, count.index)}"
  to_port = "${element(var.ports, count.index)}"

  security_group_id = "${aws_security_group.secgroup.id}"
}

resource "aws_instance" "tfcourse" {
  count = "${length(var.domains)}" 
  ami = "ami-0ac019f4fcb7cb7e6" 
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.key.key_name}"
  security_groups = ["${aws_security_group.secgroup.name}"] 
  
  tags {
    Name = "${element(var.domains, count.index)}.syb.devops.srwx.net"
  }
}

resource "aws_route53_record" "dnsrecords" {
  count = "${length(var.domains)}"
  zone_id = "${var.zone_id}"
  name = "${element(var.domains, count.index)}.syb.devops.srwx.net"
  type = "A"
  ttl = "300"
  records = ["${element(aws_instance.tfcourse.*.public_ip, count.index)}"]
}
