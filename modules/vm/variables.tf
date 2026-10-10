# One VM. The root stack calls this module once per entry in its `vms` map,
# so everything here describes a single domain.

variable "name" {
  description = "Domain name and guest hostname."
  type        = string
}

variable "pool" {
  description = "Storage pool for this VM's disks and its cloud-init ISO."
  type        = string
}

variable "base_volume_path" {
  description = "Host path of the shared base image. The root disk is a copy-on-write overlay on it."
  type        = string
}

variable "memory" {
  description = "Guest memory, MiB."
  type        = number
}

variable "vcpu" {
  description = "Virtual CPUs."
  type        = number
}

variable "disk_size" {
  description = "Root disk size, GiB. Must be at least as large as the base image."
  type        = number
}

variable "extra_disks" {
  description = "Additional empty qcow2 disks, in GiB, attached as vdb, vdc, ..."
  type        = list(number)
}

variable "network" {
  description = "libvirt network to attach to."
  type        = string
}

variable "ip" {
  description = "IPv4 address with prefix, e.g. 192.168.122.240/24. Null means DHCP."
  type        = string
}

variable "gateway" {
  description = "Default route for a static address. Null writes no route."
  type        = string
}

variable "nameservers" {
  description = "DNS resolvers, used only with a static address."
  type        = list(string)
}

variable "search_domains" {
  description = "DNS search domains, used only with a static address."
  type        = list(string)
}

variable "autostart" {
  description = "Start this domain when the host boots."
  type        = bool
}

variable "users" {
  description = "Logins to create. See the root module for the shape."
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
  description = "SHA-512 crypt hash for root. Null leaves it locked."
  type        = string
  sensitive   = true
}

variable "permit_root_ssh" {
  description = "Whether sshd accepts root logins (keys only)."
  type        = bool
}

variable "root_ssh_authorized_keys" {
  description = "Keys for root."
  type        = list(string)
}

variable "timezone" {
  description = "IANA timezone name."
  type        = string
}

variable "packages" {
  description = "Packages cloud-init installs on first boot."
  type        = list(string)
}

variable "package_upgrade" {
  description = "Run a full package upgrade on first boot."
  type        = bool
}

variable "selinux_mode" {
  description = "enforcing, permissive or disabled."
  type        = string
}

variable "nm_keyfiles" {
  description = "Convert the rendered network config to NetworkManager keyfiles on first boot."
  type        = bool
}

variable "grub_serial_console" {
  description = "Send boot loader and kernel output to the serial port as well."
  type        = bool
}

variable "ipv6_disable" {
  description = "Add ipv6.disable=1 to the kernel command line."
  type        = bool
}

variable "grub_cmdline_extra" {
  description = "Extra kernel command-line arguments."
  type        = list(string)
}

variable "reboot_after_first_boot" {
  description = "Reboot once at the end of first boot, so grub and SELinux changes take effect."
  type        = bool
}

variable "include_default_user" {
  description = "Keep the cloud image's own user (almalinux, rocky) as well."
  type        = bool
}

variable "ssh_password_auth" {
  description = "Allow password logins over ssh."
  type        = bool
}

variable "rc_local_every_boot" {
  description = "Install the original's /etc/rc.d/rc.local, which re-runs on every boot."
  type        = bool
}

variable "console_show_ip" {
  description = "Print the guest IPv4 at the login prompt via /etc/issue and /etc/issue.net."
  type        = bool
}

variable "primary_interface" {
  description = "Interface name used in the issue files."
  type        = string
}

variable "harden_ssh" {
  description = "Apply the ssh-audit hardening (hardening_guides.html#rhel8) and regenerate host keys."
  type        = bool
}

variable "runcmd" {
  description = "Extra commands for the end of first boot."
  type        = list(string)
}

variable "cpu_mode" {
  description = "libvirt CPU mode."
  type        = string
}

variable "machine_type" {
  description = "QEMU machine type."
  type        = string
}

variable "firmware" {
  description = "bios or efi."
  type        = string
}

variable "tpm" {
  description = "Attach an emulated TPM 2.0."
  type        = bool
}

variable "graphics" {
  description = "spice, vnc or none."
  type        = string
}

variable "qemu_agent" {
  description = "Attach the guest agent channel."
  type        = bool
}

variable "shutdown_timeout" {
  description = "Seconds to wait for ACPI shutdown on destroy. 0 destroys immediately."
  type        = number
}
