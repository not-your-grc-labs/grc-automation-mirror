# should specify optional vs required

variable "region" {
  description = "AWS region"
  type        = string
}

variable "ami" {
  description = "Amazon machine image to use for ec2 instance"
  type        = string
}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
}

variable "MySessionManagerRole" {
  description = "IAM role for SSM"
  type        = string  
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "int1_cidr" {
  description = "Internal subnet CIDR block"
  type        = string  
}

variable "int2_cidr" {
  description = "Internal subnet2 CIDR block"
  type        = string
}

variable "dmz1_cidr" {
  description = "DMZ1 subnet CIDR block"
  type        = string
}

variable "dmz2_cidr" {
  description = "DMZ2 subnet CIDR block"
  type        = string
}

variable "ssm_profile" {
  description = "IAM instance profile for SSM"
  type        = string
}

variable "home_ip" {
  description = "Your home IP address for web access"
  type        = string
}


variable "rds_username" {
  description = "RDS master username"
  type        = string  
}

variable "rds_password" {
  description = "RDS master password"
  type        = string
  sensitive = true
}
