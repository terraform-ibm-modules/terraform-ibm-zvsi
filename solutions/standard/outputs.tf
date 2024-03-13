##############################################################################
# Output Variables
##############################################################################


output "config" {
  description = "Output configuration as encoded JSON"
  value       = module.landing-zone.config
}
