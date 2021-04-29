locals {
  az_names = "${data.aws_availability_zones.azone.names}"
pub_sub_ids ="${aws_subnet.Public_Subnet.*.id}"
}

resource "aws_subnet" "Public_Subnet" {
count		 = "${length(local.az_names)}"
vpc_id    	 ="${aws_vpc.MYVPC.id}"
cidr_block	 ="${cidrsubnet(var.vpc_cidr,8,count.index)}" 
availability_zone ="${local.az_names[count.index]}"
map_public_ip_on_launch=true
  tags = {
    Name = "PublicSubnet-${count.index +1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.MYVPC.id

  tags = {
    Name = "Internet Gateway"
  }
}

resource "aws_default_route_table" "Route_Table" {
  default_route_table_id = aws_vpc.MYVPC.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Route_Table"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
count = "${length(local.az_names)}"
  subnet_id      = "${aws_subnet.Public_Subnet.*.id[count.index]}"
  route_table_id = "${aws_default_route_table.Route_Table.id}"
}

resource "aws_subnet" "Private_Subnet" {
count = "${length(slice(local.az_names,0,2))}"
vpc_id     = "${aws_vpc.MYVPC.id}"
cidr_block = "${cidrsubnet(var.vpc_cidr,8,count.index + length(local.az_names))}"
availability_zone ="${local.az_names[count.index]}"

  tags = {
    Name = "PrivateSubnet-${count.index +1}"
  }
}

resource "aws_instance" "nat" {
  ami           = "${var.nat_amis[var.REGION]}"
  instance_type = "t2.micro"
 subnet_id ="${aws_subnet.Public_Subnet.*.id[0]}"
 source_dest_check= false
vpc_security_group_ids = ["${aws_security_group.nat_sg.id}"]
  tags = {
    Name = "Nat_Instance"
  }
}

resource "aws_default_route_table" "Private_Route_Table" {
  default_route_table_id = aws_vpc.MYVPC.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    instance_id= "${aws_instance.nat.id}"
  }

  tags = {
    Name = "Private_Route_Table"
  }
}

resource "aws_route_table_association" "private_route_association" {
count = "${length(slice(local.az_names,0,2))}"
  subnet_id      = "${aws_subnet.Private_Subnet.*.id[count.index]}"
  route_table_id = "${aws_default_route_table.Private_Route_Table.id}"
}

resource "aws_security_group" "nat_sg" {
  name        = "nat_sg"
  description = "Allow traffic for private subnet"
  vpc_id      = aws_vpc.MYVPC.id

    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


