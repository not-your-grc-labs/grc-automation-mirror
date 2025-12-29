# should specify optional vs required

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "ami" {
  description = "Amazon machine image to use for ec2 instance"
  type        = string
  default     = "ami-0971f6afca696ace6" # Amazon Linux 2023 AMI 2023.8.20250915.0 x86_64 HVM kernel-6.1
}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "MySessionManagerRole" {
  description = "IAM role for SSM"
  type        = string
  default     = "MySessionManagerRole"
  
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "192.168.0.0/24"
}

variable "int1_cidr" {
  description = "Internal subnet CIDR block"
  type        = string
  default     = "192.168.0.0/26"
  
}

variable "int2_cidr" {
  description = "Internal subnet2 CIDR block"
  type        = string
  default     = "192.168.0.192/26"

}

variable "dmz1_cidr" {
  description = "DMZ1 subnet CIDR block"
  type        = string
  default     = "192.168.0.64/26"

}

variable "dmz2_cidr" {
  description = "DMZ2 subnet CIDR block"
  type        = string
  default     = "192.168.0.128/26"

}

variable "ssm_profile" {
  description = "IAM instance profile for SSM"
  type        = string
  default     = "MySessionManagerRole" 
}

variable "home_ip" {
  description = "Your home IP address for web access"
  type        = string
  default     = "104.28.86.111/32"
}

variable "rds_username" {
  description = "RDS master username"
  type        = string
  default     = "andrew"
  
}

variable "rds_password" {
  description = "RDS master password"
  type        = string
  sensitive = true
}
