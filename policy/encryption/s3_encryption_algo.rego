package encryption
import rego.v1

# Allow-list of acceptable algorithms
allowed_algorithms := {"AES256", "aws:kms"}

# Helper: safely extract the sse_algorithm string from the encryption config resource
sse_algorithm(rc) = alg if {
  rc.type == "aws_s3_bucket_server_side_encryption_configuration"

  after := rc.change.after
  after != null

  rule0 := after.rule[0]
  apply0 := rule0.apply_server_side_encryption_by_default[0]

  alg := apply0.sse_algorithm
  alg != null
}
   

# Check for missing sse_algorithm
deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "aws_s3_bucket_server_side_encryption_configuration"
  
  not sse_algorithm(rc)
  msg := sprintf("%s: missing sse_algorithm in encryption configuration", [rc.address])
}

# algorithm not in allow-list
deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "aws_s3_bucket_server_side_encryption_configuration"
  alg := sse_algorithm(rc)

  not allowed_algorithms[alg]
  msg := sprintf("%s: unsupported sse_algorithm %q (allowed: AES256 or aws:kms)", [rc.address, alg])
}
