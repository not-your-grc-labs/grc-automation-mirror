package assets
import rego.v1

deny contains msg if {
	not input.env
	msg := "env is missing"
}

deny contains msg if {
	input.env
	not allowed_env(input.env)
	msg := sprintf("env %v is not allowed", [input.env])
}

allowed_env(env) if {
  data.assets.allowed_envs[_] == env
}
