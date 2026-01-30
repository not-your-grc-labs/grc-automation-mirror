package network_access_control
import rego.v1

############################
# Helpers
############################

# Bucket is explicitly intended to be public
is_public_bucket(b) if {
  tags := b.change.after.tags
  tags.public_facing == "true"
}

# Find the matching Public Access Block resource
# (assumes same Terraform resource name for bucket and PAB)
pab_for_bucket(b) = pab if {
  pab := input.resource_changes[_]
  pab.type == "aws_s3_bucket_public_access_block"
  pab.name == b.name
  pab.change.after != null
}

# Public Access Block is fully locked down
pab_fully_enabled(pab) if {
  a := pab.change.after
  a.block_public_acls
  a.ignore_public_acls
  a.block_public_policy
  a.restrict_public_buckets
}

############################
# Controls
############################

# Non-public buckets must define a Public Access Block
deny contains msg if {
  b := input.resource_changes[_]
  b.type == "aws_s3_bucket"
  b.change.after != null

  not is_public_bucket(b)
  not pab_for_bucket(b)

  msg := sprintf(
    "%s: non-public S3 bucket must define aws_s3_bucket_public_access_block",
    [b.address]
  )
}

# Non-public buckets must have all PAB flags set to true
deny contains msg if {
  b := input.resource_changes[_]
  b.type == "aws_s3_bucket"
  b.change.after != null

  not is_public_bucket(b)

  pab := pab_for_bucket(b)
  not pab_fully_enabled(pab)

  msg := sprintf(
    "%s: non-public S3 bucket must have all Public Access Block settings set to true",
    [b.address]
  )
}
