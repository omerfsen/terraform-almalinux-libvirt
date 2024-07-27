# Defining VM Volume
resource "libvirt_volume" "alma9_qcow2" {
  name   = var.alma9_volume_name
  pool   = var.alma9_volume_pool
  source = var.alma9_volume_source
  format = var.alma9_volume_format
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.tpl")
  vars = {
    encoded_selinux       = base64encode(var.selinux_content)
    encoded_eth0          = base64encode(var.eth0_content)
    encoded_grub          = base64encode(var.grub_content)
    encoded_rc_local      = base64encode(var.rc_local_content)
    encoded_rc_local_once = base64encode(var.rc_local_once_content)
    serra_ssh_keys        = jsonencode(var.serra_ssh_keys)
    root_ssh_keys         = jsonencode(var.root_ssh_keys)
    serra_passwd          = var.serra_passwd
    root_passwd           = var.root_passwd
  }
}

data "template_file" "meta_data" {
  template = file("${path.module}/meta-data.tpl")
  vars = {
    instance-id    = "${var.alma9_name}"
    local-hostname = "${var.alma9_name}"
  }
}

resource "libvirt_cloudinit_disk" "alma9_cloudinit_disk" {
  name      = var.alma9_cloudinit_disk
  pool      = var.alma9_cloudinit_pool
  user_data = data.template_file.user_data.rendered
  meta_data = data.template_file.meta_data.rendered
}

resource "libvirt_domain" "alma9" {
  name       = var.alma9_domain_name
  memory     = var.alma9_domain_memory
  vcpu       = var.alma9_domain_vcpu
  qemu_agent = true

  network_interface {
    network_name = var.alma9_network_name
  }

  disk {
    volume_id = libvirt_volume.alma9_qcow2.id
  }

  cloudinit = libvirt_cloudinit_disk.alma9_cloudinit_disk.id

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "0"
  }

  cpu {
    mode = "host-passthrough"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}
