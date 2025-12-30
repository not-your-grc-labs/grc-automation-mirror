package plan
import rego.v1

# Control: CLOUD.PROD.NO_PUBLIC_RESOURCES
# Intent: Prevent public exposure of production resources

deny contains msg if {
	r 	:= input.resources[_]
	r.env 	== "prod"
	r.public == true
	msg 	:= sprintf(
		"CLOUD.PROD.NO_PUBLIC_RESOURCES: prod resource %v (%v) must not be public",[r.name, r.type]
	)
}
