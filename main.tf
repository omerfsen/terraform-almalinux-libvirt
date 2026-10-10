# The base image is fetched once and shared. Every VM's root disk is a
# copy-on-write overlay on it, so a second VM costs its own writes and not
# another copy of the image.
resource "libvirt_volume" "base" {
  name = var.image_name
  pool = var.pool

  # Set explicitly rather than left to Content-Length: the AlmaLinux mirrors
  # this URL redirects to do not always send one.
  capacity = var.image_capacity

  target = {
    format = { type = "qcow2" }
  }

  # 0.9.x uploads from a URL or a local path, so the image no longer has to be
  # downloaded onto the hypervisor by hand. Capacity comes from Content-Length,
  # or the file size, when it is not given.
  create = {
    content = { url = var.image_url }
  }
}

module "vm" {
  source   = "./modules/vm"
  for_each = var.vms

  name             = each.key
  pool             = var.pool
  base_volume_path = libvirt_volume.base.path

  memory      = coalesce(each.value.memory, var.default_memory)
  vcpu        = coalesce(each.value.vcpu, var.default_vcpu)
  disk_size   = coalesce(each.value.disk_size, var.default_disk_size)
  extra_disks = coalesce(each.value.extra_disks, [])
  network     = coalesce(each.value.network, var.default_network)
  autostart   = coalesce(each.value.autostart, false)

  # No coalesce on these two: null is a meaningful value (DHCP, and no route).
  ip      = each.value.ip
  gateway = each.value.ip == null ? null : try(coalesce(each.value.gateway, var.default_gateway), null)

  nameservers    = var.nameservers
  search_domains = var.search_domains

  users                    = var.users
  ssh_authorized_keys      = var.ssh_authorized_keys
  root_password_hash       = var.root_password_hash
  permit_root_ssh          = var.permit_root_ssh
  root_ssh_authorized_keys = var.root_ssh_authorized_keys

  timezone                = var.timezone
  packages                = var.packages
  package_upgrade         = var.package_upgrade
  selinux_mode            = var.selinux_mode
  nm_keyfiles             = var.nm_keyfiles
  harden_ssh              = var.harden_ssh
  console_show_ip         = var.console_show_ip
  primary_interface       = var.primary_interface
  include_default_user    = var.include_default_user
  ssh_password_auth       = var.ssh_password_auth
  rc_local_every_boot     = var.rc_local_every_boot
  reboot_after_first_boot = var.reboot_after_first_boot
  grub_serial_console     = var.grub_serial_console
  ipv6_disable            = var.ipv6_disable
  grub_cmdline_extra      = var.grub_cmdline_extra
  runcmd                  = var.runcmd

  cpu_mode         = var.cpu_mode
  machine_type     = var.machine_type
  firmware         = var.firmware
  tpm              = var.tpm
  graphics         = var.graphics
  qemu_agent       = var.qemu_agent
  shutdown_timeout = var.shutdown_timeout
}
