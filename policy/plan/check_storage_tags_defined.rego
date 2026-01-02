package plan
import rego.v1

# Intent: Ensure all tags are defined for storing data - applies to storage resources only (e.g., S3 buckets, EBS volumes, Databases and Instance).

storage_types := {
    "aws_s3_bucket",
    "aws_ebs_volume",
    "aws_db_instance",
    "aws_rds_cluster",
    "aws_instance"
}

env_tags := {
    "prod",
    "dev",
    "test"
}

public_facing_tags := {
    "public_facing",
    "not_public_facing"
}

# Empty tags
deny contains msg if {
    r := input.resource_changes[_]
    r.type in storage_types
    tags := object.get(r.change.after, "tags_all", {})

    count(tags) == 0
    msg := sprintf("Missing tags for %v (%v)", [r.address, r.type])
}

# Environment tags defined
deny contains msg if {
    r := input.resource_changes[_]
    r.type in storage_types
    tags := object.get(r.change.after, "tags_all", {})
    
    count(tags) > 0
    not object.get(tags,"environment","") in env_tags
    msg := sprintf("Environment tag not defined or invalid for %v (%v)", [r.address, r.type])
}

# Public facing tags defined
deny contains msg if {
    r := input.resource_changes[_]
    r.type in storage_types
    tags := object.get(r.change.after, "tags_all", {})

    count(tags) > 0
    not object.get(tags,"public_facing","") in public_facing_tags
    msg := sprintf("Public facing tag not defined or invalid for %v (%v)", [r.address, r.type])
}