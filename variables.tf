# Every value lives in terraform.tfvars; nothing here carries a default, so a
# missing setting fails at plan time instead of silently taking a value that
# was buried in the code.

variable "libvirt_uri" {
  description = "libvirt connection URI. qemu+ssh://user@host/system for a remote hypervisor."
  type        = string
}

variable "pool" {
  description = "Storage pool for the base image, the VM disks and the cloud-init ISOs."
  type        = string
}

variable "image_url" {
  description = <<-EOT
    Where to fetch the AlmaLinux cloud image from. The provider uploads it into
    the pool, so an https:// URL or a local path both work. Fetched once; every
    VM gets a thin overlay on top of it.
  EOT
  type        = string
}

variable "image_name" {
  description = "Volume name for the shared base image inside the pool."
  type        = string
}

variable "image_capacity" {
  description = <<-EOT
    Virtual size of the base image, in bytes. Normally the provider reads this
    from the upload's Content-Length, but repo.almalinux.org redirects to
    mirrors that do not send one, and the upload then fails with "Volume
    capacity is required when the upload source does not provide
    Content-Length". Read it off an image with:
      qemu-img info <file> | grep 'virtual size'
  EOT
  type        = number
}

variable "vms" {
  description = <<-EOT
    The VMs to create, keyed by name. The key becomes the domain name and the
    guest hostname. Anything left out of an entry falls back to the matching
    `default_*` value.
  EOT
  type = map(object({
    memory      = optional(number)
    vcpu        = optional(number)
    disk_size   = optional(number)
    ip          = optional(string)
    gateway     = optional(string)
    network     = optional(string)
    extra_disks = optional(list(number))
    autostart   = optional(bool)
  }))

  validation {
    condition     = alltrue([for k, _ in var.vms : can(regex("^[A-Za-z0-9._-]+$", k))])
    error_message = "VM names become libvirt domain names and guest hostnames: letters, digits, dot, dash and underscore only."
  }

  validation {
    condition     = alltrue([for _, v in var.vms : v.ip == null || can(cidrnetmask(v.ip))])
    error_message = "vms[*].ip must carry a prefix, for example 192.168.122.240/24."
  }
}

variable "default_memory" {
  description = "Guest memory in MiB for any VM that does not set its own."
  type        = number
}

variable "default_vcpu" {
  description = "Virtual CPUs for any VM that does not set its own."
  type        = number
}

variable "default_disk_size" {
  description = "Root disk in GiB for any VM that does not set its own."
  type        = number
}

variable "default_network" {
  description = "libvirt network for any VM that does not name one."
  type        = string
}

variable "default_gateway" {
  description = "Default route for a VM that sets `ip` without its own `gateway`. Null writes none."
  type        = string
}

variable "nameservers" {
  description = "DNS resolvers written into guests that use a static address."
  type        = list(string)
}

variable "search_domains" {
  description = "DNS search domains written into guests that use a static address."
  type        = list(string)
}

variable "users" {
  description = <<-EOT
    Logins to create.
      sudo           passwordless sudo            (default true)
      shell                                       (default /bin/bash)
      groups                                      (default ["adm","wheel"])
      password_hash  SHA-512 crypt, from `mkpasswd -m sha-512`.
                     Null locks the password, leaving key-only login.
  EOT
  type = list(object({
    name                = string
    sudo                = optional(bool, true)
    shell               = optional(string, "/bin/bash")
    groups              = optional(list(string), ["adm", "wheel"])
    password_hash       = optional(string)
    ssh_authorized_keys = optional(list(string), [])
  }))
  sensitive = true
}

variable "ssh_authorized_keys" {
  description = "Keys added to every user, on top of that user's own list."
  type        = list(string)
}

variable "root_password_hash" {
  description = "SHA-512 crypt hash for root. Null leaves root locked, as the cloud image ships it."
  type        = string
  sensitive   = true
}

variable "permit_root_ssh" {
  description = "Whether sshd accepts root logins. Keys only; password auth stays off either way."
  type        = bool
}

variable "root_ssh_authorized_keys" {
  description = "Keys for root. Only reachable when permit_root_ssh is true."
  type        = list(string)
}

variable "timezone" {
  description = "Guest timezone, IANA name."
  type        = string
}

variable "packages" {
  description = "Packages cloud-init installs on first boot."
  type        = list(string)
}

variable "package_upgrade" {
  description = "Run a full package upgrade on first boot. Adds minutes."
  type        = bool
}

variable "selinux_mode" {
  description = "enforcing, permissive or disabled. Anything but enforcing costs one extra reboot."
  type        = string
  validation {
    condition     = contains(["enforcing", "permissive", "disabled"], var.selinux_mode)
    error_message = "selinux_mode must be enforcing, permissive or disabled."
  }
}

variable "nm_keyfiles" {
  description = <<-EOT
    Convert the network config cloud-init renders into NetworkManager keyfiles
    on first boot, with `nmcli connection migrate`.

    On EL9, cloud-init selects the `sysconfig` renderer and writes
    /etc/sysconfig/network-scripts/ifcfg-eth0 - the same legacy file this repo
    used to hand-write. The renderer itself cannot be changed from user-data,
    because it is chosen in the init-local stage before user-data merges, so
    the file is converted after the fact instead. Verified on AlmaLinux 9.8
    with NetworkManager 1.54: the ifcfg file is removed and the address is
    kept. A no-op on EL10, which has no network-scripts to begin with.
  EOT
  type        = bool
}

variable "grub_serial_console" {
  description = <<-EOT
    Put the boot loader and the kernel on the serial port as well as the
    console, so `virsh console` shows the whole boot. This is what the old
    repo's GRUB_TERMINAL / GRUB_SERIAL_COMMAND lines did.
  EOT
  type        = bool
}

variable "ipv6_disable" {
  description = "Add ipv6.disable=1 to the kernel command line, as the old repo did."
  type        = bool
}

variable "grub_cmdline_extra" {
  description = <<-EOT
    Extra kernel command-line arguments, appended to whatever the serial and
    ipv6 options add. Note `crashkernel=auto` from the old repo is obsolete:
    EL9 ignores it.
  EOT
  type        = list(string)
}

variable "reboot_after_first_boot" {
  description = <<-EOT
    Reboot once at the end of first boot. The old repo always did this, from
    its run-once rc.local script, because grub and SELinux changes need it.
    Not needed when `selinux_mode` is enforcing and no grub option is set.
  EOT
  type        = bool
}

variable "include_default_user" {
  description = <<-EOT
    Keep the cloud image's own user (almalinux, rocky) alongside the ones in
    `users`. The original did this with a bare `- default`; dropping it removes
    the documented fallback login.
  EOT
  type        = bool
}

variable "ssh_password_auth" {
  description = <<-EOT
    Allow password logins over ssh. The original set this true; it defaults to
    false here, which is the one security default deliberately changed from the
    original. Key-only login is unaffected either way.
  EOT
  type        = bool
}

variable "rc_local_every_boot" {
  description = <<-EOT
    Install the original's /etc/rc.d/rc.local, which runs on EVERY boot and
    re-runs grub2-mkconfig, a full package upgrade, and the ssh host key
    regeneration. Note the consequence: the host keys change on every reboot,
    so known_hosts breaks each time. Off by default because that reads as a
    mistake in the original rather than an intent.
  EOT
  type        = bool
}

variable "console_show_ip" {
  description = <<-EOT
    Print the guest's IPv4 address at the login prompt, by writing /etc/issue
    and /etc/issue.net with agetty's \4{iface} escape. The Rocky repo did
    this; the AlmaLinux one did not.
  EOT
  type        = bool
}

variable "primary_interface" {
  description = "Interface name agetty reads the address from, for the issue files."
  type        = string
}

variable "harden_ssh" {
  description = "Apply the ssh-audit hardening (hardening_guides.html#rhel8) and regenerate the host keys the image shipped with."
  type        = bool
}

variable "runcmd" {
  description = "Extra shell commands for the end of first boot."
  type        = list(string)
}

variable "cpu_mode" {
  description = "libvirt CPU mode. host-passthrough blocks live migration between unlike hosts."
  type        = string
}

variable "machine_type" {
  description = "QEMU machine type. q35 is current; pc is legacy i440fx."
  type        = string
}

variable "firmware" {
  description = "bios or efi. efi needs OVMF on the hypervisor."
  type        = string
  validation {
    condition     = contains(["bios", "efi"], var.firmware)
    error_message = "firmware must be bios or efi."
  }
}

variable "tpm" {
  description = "Attach an emulated TPM 2.0. Needs swtpm on the hypervisor."
  type        = bool
}

variable "graphics" {
  description = "spice, vnc or none. none leaves only the serial console."
  type        = string
  validation {
    condition     = contains(["spice", "vnc", "none"], var.graphics)
    error_message = "graphics must be spice, vnc or none."
  }
}

variable "qemu_agent" {
  description = "Attach the guest agent channel. Required for the ip_addresses output."
  type        = bool
}

variable "shutdown_timeout" {
  description = "Seconds to wait for an ACPI shutdown on destroy before forcing it off."
  type        = number
}
