resource "aws_vpc" "MYVPC" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "default"

  tags = {
    Name = "Learning VPC"
    Environment ="${terraform.workspace}"
  }
}


