# defines values for variables in variables.tf

region = "eu-west-2"

ami= "ami-0971f6afca696ace6" # Amazon Linux 2023 AMI 2023.8.20250915.0 x86_64 HVM kernel-6.1
instance_type = "t2.micro"

MySessionManagerRole = "MySessionManagerRole"

vpc_cidr = "192.168.0.0/24"
int1_cidr = "192.168.0.0/26"
int2_cidr = "192.168.0.192/26"
dmz1_cidr = "192.168.0.64/26"
dmz2_cidr = "192.168.0.128/26"

ssm_profile = "MySessionManagerRole"

home_ip = "90.200.222.139/32"

rds_username = "andrew"
