resource "aws_security_group" "alb_security_group" {
  name        = "alb_security_group"
  description = "Security group for web application load balancer from internet"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    } 

    ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # "-1" allows all protocols for egress traffic
    cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "int_security_group" {
  name        = "int_security_group"
  description = "Security group for Internal subnet instances"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.dmz1_cidr, var.dmz2_cidr]
    }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # "-1" allows all protocols for egress traffic
    cidr_blocks = ["0.0.0.0/0"]
    }
}   

resource "aws_security_group" "ssm_security_group" {
    name        = "ssm_security_group"
    description = "Security group for SSM VPC endpoint"
    vpc_id      = aws_vpc.my_vpc.id
    
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        security_groups = [aws_security_group.int_security_group.id,aws_security_group.web_instance_security_group.id]
        }
    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1" # "-1" allows all protocols for egress traffic
        cidr_blocks = ["0.0.0.0/0"]
        }
}

resource "aws_security_group" "web_instance_security_group" {
  name        = "web_instance_security_group"
  description = "Security group for web server instances from ALB"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
    } 

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
    }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # "-1" allows all protocols for egress traffic
    cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "rds_security_group" {
  name        = "rds_security_group"
  description = "Security group for RDS instance from internal subnet"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.int_security_group.id]
    } 

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # "-1" allows all protocols for egress traffic
    cidr_blocks = ["0.0.0.0/0"]
  
    }
}