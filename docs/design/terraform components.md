**GRC Automation Lab – Terraform Components**


#providers.tf
Purpose: Define AWS provider settings such as region and profile.
Includes: provider "aws" block, profile name, region, authentication.

#versions.tf
Purpose: Lock Terraform and provider versions.
Includes required_version and required_providers blocks.

##variables.tf##
Purpose: Define input parameters used throughout the configuration.
Must understand—controls behaviour of the whole lab.
Examples: vpc_cidr, subnet CIDRs, instance types, DB credentials, region.

##outputs.tf##
Purpose: Print useful resource information after apply.
Examples: VPC ID, subnet IDs, ALLB DNS name, DB endpoint, SG IDs.

##network.tf##
Purpose: Core network structure.
Includes: VPC, public/DMZ subnets, internal/private subnets, IGW.

##routing.tf##
Purpose: Routing and connectivity.
Includes: Elastic IP, NAT Gateway, public + private route tables, route associations.

##security-groups.tf##
Purpose: Network security access control.
Includes: ALB SG (from internet), Web SG (from ALB), DB SG (from Web).

##ec2-web.tf##
Purpose: Application layer compute.
Includes: Two EC2 instances, SG attachments, subnets, AMI, user_data, tags.

##alb.tf##
Purpose: Load balancing.
Includes: ALB, target group, listener.

##rds.tf##
Purpose: Database layer.
Includes: DB subnet group (private subnets), RDS instance, SG.

##ssm-and-endpoints.tf##
Purpose: Optional Phase 2 management improvements.
Includes: SSM role + instance profile, VPC endpoints for SSM/EC2 messages.
