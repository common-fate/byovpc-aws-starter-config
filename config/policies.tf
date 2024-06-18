resource "commonfate_policyset" "default" {
  id   = "default"
  text = file("policies/default.cedar")
}