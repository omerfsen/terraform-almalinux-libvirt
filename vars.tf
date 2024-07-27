# VM name
variable "alma9_name" {
}

# Qcow2 volume name
variable "alma9_volume_name" {
}

# Pool to locate VM
variable "alma9_volume_pool" {
}

variable "alma9_volume_size" {
}

# Volume format .. Qcow2
variable "alma9_volume_format" {
}

# Which Pool to located cloud-init.iso
variable "alma9_cloudinit_pool" {
}

# Qcow2 cloud-init location
variable "alma9_cloudinit_disk" {
}

# alma linux Qcow2 disk image
variable "alma9_volume_source" {
}
# VM name
variable "alma9_domain_name" {
}

# Vm Memory
variable "alma9_domain_memory" {
}

# VM Cpu count
variable "alma9_domain_vcpu" {
}

# VM Network name
variable "alma9_network_name" {
}

variable "selinux_content" {
  description = "Content for SELinux configuration"
  type        = string
}

variable "eth0_content" {
  description = "Content for eth0 network script"
  type        = string
}

variable "grub_content" {
  description = "Content for GRUB configuration"
  type        = string
}

variable "rc_local_content" {
  description = "Content for rc.local script"
  type        = string
}


variable "rc_local_once_content" {
  description = "Content for rc.local script"
  type        = string
}

variable "serra_passwd" {
  description = "user password"
  type        = string

}
variable "root_passwd" {
  description = "root password"
  type        = string

}

variable "serra_ssh_keys" {
  description = "SSH authorized keys for user serra"
  type        = list(string)
}

variable "root_ssh_keys" {
  description = "SSH authorized keys for user root"
  type        = list(string)
}
