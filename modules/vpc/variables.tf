variable "vpc_cidr_notation" {
  type = string
  description = "Ip range for the cidr"
  default = "10.5.0.0/16"
}

variable "project" {
  default = "toast"
}

variable "environment" {
    type = string
    description = "Environment"
    default = "Dev"
}


variable "region" {
    default = "us-east-1"
}

variable "public_subnet" {
  default = "10.5.5.0/24"
}

variable "public_subet_2" {
  default = "10.5.10.0/24"
}


variable "private_subnet"{
  default = "10.5.20.0/24"
    
}

variable "private_subnet_2"{
   default = "10.5.30.0/24"
    
}

variable "private_data"{
  default = "10.5.40.0/24"

}

variable "private_data_2"{
     default = "10.5.50.0/24"
}