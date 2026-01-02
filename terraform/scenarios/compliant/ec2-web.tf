resource "aws_instance" "web_server1" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.dmz_subnet1.id
  vpc_security_group_ids = [aws_security_group.web_instance_security_group.id]
  iam_instance_profile = var.ssm_profile
  user_data = <<-EOF
    #!/bin/bash
    yum - update -y
    yum install -y httpd
    systemctl enable httpd
    systemctl start httpd

    echo "Hello from GRC lab 1" > /var/www/html/index.html
    EOF

    tags = {
      environment = "prod"
      public_facing = true
      owner = "Andrew"
      managed_by = "Terraform"
      }
  }

  resource "aws_instance" "web_server2" {
  ami = var.ami
  instance_type             = var.instance_type
  subnet_id                 = aws_subnet.dmz_subnet2.id
  vpc_security_group_ids    = [aws_security_group.web_instance_security_group.id]
  iam_instance_profile  = var.ssm_profile
  user_data = <<-EOF
    #!/bin/bash
    yum - update -y
    yum install -y httpd
    systemctl enable httpd
    systemctl start httpd

    echo "Hello from GRC lab 2" > /var/www/html/index.html
    EOF

    tags = {
      environment = "dev"
      public_facing = true
      owner = "Andrew"
      managed_by = "Terraform"
      }
  }
