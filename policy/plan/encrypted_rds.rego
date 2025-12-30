package plan
import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "aws_rds_cluster"

  #action := rc.change.actions[_]
  #action != "no-op"

  after := rc.change.after
  after.storage_encrypted == false

  msg := sprintf("RDS cluster %s must have storage_encrypted = true", [rc.address])
}
