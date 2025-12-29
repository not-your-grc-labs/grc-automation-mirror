package user

default allow := false

allow := true if count(deny) == 0

deny contains msg if {
  not input.user
  not input.users
  not input.resources
  msg := "input.user is missing"
}

deny contains msg if {
  input.user
  input.user != "alice"
  msg := sprintf("user must be alice, got %v", [input.user])
}

deny contains msg if {
  input.users
  u := input.users[_]
  u.role != "admin"
  msg := sprintf("user %v is not admin", [u.name])
}

