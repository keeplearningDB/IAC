variable "Access_Key"{
  description ="AWS ACCESS KEY"
type = string  
default ="AKIA4P73XVJL3EBTGXHR"
}

variable "Secret_Key"{
  description = "AWS Secret Key"
type = string
default ="0wvtp+V/F4vJaOgMwTGe5o9PQ5lQD+w19JWhxSsk"
}

variable "REGION"{
  description ="Home Region"
  type = string
  default = "eu-west-2"
}

variable "vpc_cidr" {
description = "CIDR for VPC"
type = string
default     = "10.0.0.0/16"
}

variable "nat_amis"{
  type = map
  default ={
  eu-west-1="ami-0ffea00000f287d30"
  eu-west-2="ami-0fbec3e0504ee1970"
  }
}

variable "web_instance_type" {
description = "Instance Type for web"
default     = "t2.micro"
}

variable "web_tags" {
type =map
default     = {
  Name = "WebServer"
}
}

variable "web_ec2_count"{
  default=2
}

variable "web_amis"{
  type =map
  default ={
  eu-west-1="ami-0ffea00000f287d30"
  eu-west-2="ami-0fbec3e0504ee1970"
  }
}


