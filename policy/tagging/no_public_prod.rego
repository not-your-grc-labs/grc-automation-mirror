package tagging
import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "aws_rds_cluster"

  tags := object.get(rc.change.after, "tags_all", {})
  object.get(tags, "environment", "") == "prod"
  object.get(tags, "public_facing", "") == "true"

  msg := sprintf("%s is tagged public_facing=true in prod", [rc.address])
}

