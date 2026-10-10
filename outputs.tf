locals {
  # The login name is not the secret in `users` - the password hash is - so
  # unwrap just the name, or every output touching it has to be marked
  # sensitive and stops being copy-pasteable.
  # nonsensitive() wraps the whole conditional: the length() test reads the
  # sensitive variable too, so unwrapping only the name leaves the result tainted.
  primary_user = nonsensitive(length(var.users) > 0 ? var.users[0].name : "root")
}

output "vms" {
  description = "Name, UUID, MAC, configured address and root disk path for each VM."
  value = {
    for name, m in module.vm : name => {
      uuid             = m.uuid
      mac              = m.mac
      ip               = m.ip
      root_volume_path = m.root_volume_path
    }
  }
}

output "ssh" {
  description = "Ready-to-paste ssh commands. DHCP guests resolve through ip_addresses instead."
  value = {
    for name, m in module.vm : name => m.ip == null
    ? "ssh ${local.primary_user}@<see ip_addresses>"
    : "ssh ${local.primary_user}@${m.ip}"
  }
}

output "console" {
  description = "Attach to a guest's serial console."
  value       = { for name, _ in var.vms : name => "virsh --connect ${var.libvirt_uri} console ${name}" }
}

output "ip_addresses" {
  description = <<-EOT
    IPv4 addresses libvirt reports per VM, from the DHCP leases or the guest
    agent. Empty until the guest is up, so a fresh apply may need one
    `terraform refresh` before these fill in.
  EOT
  value = {
    for name, d in data.libvirt_domain_interface_addresses.vm : name => flatten([
      for iface in d.interfaces : [
        for a in iface.addrs : a.addr if a.type == "ipv4"
      ]
    ])
  }
}

# `any` asks the DHCP leases and the guest agent, so this still answers for a
# DHCP guest with no agent installed.
data "libvirt_domain_interface_addresses" "vm" {
  for_each = var.vms
  domain   = module.vm[each.key].uuid
  source   = "any"
}
