package plan
import rego.v1

# Intent: Ensure all tags are defined for storing data - applies to storage resources only (e.g., S3 buckets, EBS volumes, Databases and Instance).

deny contains msg if {
    r := input.resource_changes[_]
    tags := r.change.after.tags

    tags == null
    msg := sprintf("Missing (null) tags for %v (%v)", [r.address, r.type])
}

deny contains msg if {
    r := input.resource_changes[_]
    tags := r.change.after.tags

    count(tags) == 0
    msg := sprintf("Missing (empty) tags for %v (%v)", [r.address, r.type])
}
