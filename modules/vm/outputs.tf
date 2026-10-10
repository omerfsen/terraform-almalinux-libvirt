output "name" {
  description = "Domain name."
  value       = libvirt_domain.vm.name
}

output "uuid" {
  description = "Domain UUID. Use it with `terraform import` to adopt an existing domain."
  value       = libvirt_domain.vm.uuid
}

output "mac" {
  description = "MAC address of the primary interface."
  value       = local.mac
}

output "ip" {
  description = "Configured static address, or null when the VM uses DHCP."
  value       = var.ip == null ? null : split("/", var.ip)[0]
}

output "root_volume_path" {
  description = "Host path of the root disk."
  value       = libvirt_volume.root.path
}
