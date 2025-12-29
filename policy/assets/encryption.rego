package assets

deny contains msg if {
	input.env == "prod"
	input.encryption == false
	msg := sprintf("prod asset %v must have encryption enabled", [input.name])
}
