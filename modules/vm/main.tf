locals {
  # A deterministic MAC in the QEMU 52:54:00 range. cloud-init matches the NIC
  # by address, because the name a guest gives a virtio NIC is not something
  # this module can promise.
  mac = join(":", [
    "52", "54", "00",
    substr(md5(var.name), 0, 2),
    substr(md5(var.name), 2, 2),
    substr(md5(var.name), 4, 2),
  ])

  grub_cmdline = join(" ", concat(
    var.ipv6_disable ? ["ipv6.disable=1"] : [],
    var.grub_serial_console ? ["console=tty0", "console=ttyS0,115200", "earlyprintk=ttyS0"] : [],
    var.grub_cmdline_extra,
  ))

  # Built here, not with %{ if } inside the YAML. A template directive at
  # column 0 inside a `content: |` block scalar terminates the block, so the
  # lines after it silently never reach the file - which is exactly how the
  # HostKey lines went missing.
  sshd_dropin = join("\n      ", concat(
    [
      "PermitRootLogin ${var.permit_root_ssh ? "prohibit-password" : "no"}",
      "PasswordAuthentication ${var.ssh_password_auth ? "yes" : "no"}",
    ],
    var.harden_ssh ? [
      "# Naming any HostKey suppresses OpenSSH's built-in default set, which is",
      "# what drops ECDSA. The original commented out a HostKey line in",
      "# sshd_config, but EL9's sshd_config lists none, so that matched nothing.",
      "HostKey /etc/ssh/ssh_host_ed25519_key",
      "HostKey /etc/ssh/ssh_host_rsa_key",
    ] : [],
  ))

  disk_letters = [for i in range(1, 27) : substr("bcdefghijklmnopqrstuvwxyz", i - 1, 1)]
}

# Copy-on-write overlay, not a copy: the base image is stored once however many
# VMs sit on top of it.
resource "libvirt_volume" "root" {
  name          = "${var.name}.qcow2"
  pool          = var.pool
  capacity      = var.disk_size
  capacity_unit = "GiB"

  target = {
    format = { type = "qcow2" }
  }

  backing_store = {
    path   = var.base_volume_path
    format = { type = "qcow2" }
  }
}

resource "libvirt_volume" "extra" {
  for_each = { for idx, size in var.extra_disks : tostring(idx) => size }

  name          = "${var.name}-disk${tonumber(each.key) + 1}.qcow2"
  pool          = var.pool
  capacity      = each.value
  capacity_unit = "GiB"

  target = {
    format = { type = "qcow2" }
  }
}

resource "libvirt_cloudinit_disk" "init" {
  name = "${var.name}-cloudinit.iso"

  user_data = templatefile("${path.module}/templates/user-data.yaml.tftpl", {
    hostname                = var.name
    users                   = var.users
    extra_keys              = var.ssh_authorized_keys
    root_pw                 = var.root_password_hash
    permit_root_ssh         = var.permit_root_ssh
    root_keys               = var.root_ssh_authorized_keys
    timezone                = var.timezone
    packages                = var.packages
    package_upgrade         = var.package_upgrade
    selinux_mode            = var.selinux_mode
    nm_keyfiles             = var.nm_keyfiles
    harden_ssh              = var.harden_ssh
    sshd_dropin             = local.sshd_dropin
    console_show_ip         = var.console_show_ip
    primary_interface       = var.primary_interface
    ipv6_disable            = var.ipv6_disable
    include_default_user    = var.include_default_user
    ssh_password_auth       = var.ssh_password_auth
    rc_local_every_boot     = var.rc_local_every_boot
    reboot_after_first_boot = var.reboot_after_first_boot
    grub_serial_console     = var.grub_serial_console
    ipv6_disable            = var.ipv6_disable
    grub_cmdline_extra      = var.grub_cmdline_extra
    grub_cmdline            = local.grub_cmdline
    runcmd                  = var.runcmd
  })

  meta_data = yamlencode({
    instance-id    = var.name
    local-hostname = var.name
  })

  # Network config v2: NetworkManager renders this on EL9, and EL10 has no
  # network-scripts for the old ifcfg approach to write to.
  network_config = templatefile("${path.module}/templates/network-config.yaml.tftpl", {
    mac            = local.mac
    ip             = var.ip
    gateway        = var.gateway == null ? "" : var.gateway
    nameservers    = var.nameservers
    search_domains = var.search_domains
  })
}

resource "libvirt_volume" "init" {
  name = "${var.name}-cloudinit.iso"
  pool = var.pool

  # "iso", not "raw": libvirt sniffs the uploaded image and reports iso back,
  # and a mismatch fails the apply with "produced an unexpected new value".
  target = {
    format = { type = "iso" }
  }

  create = {
    content = { url = libvirt_cloudinit_disk.init.path }
  }
}

resource "libvirt_domain" "vm" {
  name        = var.name
  type        = "kvm"
  memory      = var.memory
  memory_unit = "MiB"
  vcpu        = var.vcpu
  autostart   = var.autostart
  running     = true

  os = {
    type         = "hvm"
    type_arch    = "x86_64"
    type_machine = var.machine_type
    firmware     = var.firmware == "efi" ? "efi" : null
    boot_devices = [{ dev = "hd" }]
  }

  cpu = {
    mode = var.cpu_mode
  }

  # ACPI shutdown first, force only on timeout. The 0.8 provider always pulled
  # the plug, which is how a guest ends up fsck-ing on its next boot.
  destroy = var.shutdown_timeout > 0 ? {
    shutdown = { timeout = var.shutdown_timeout }
  } : null

  devices = {
    disks = concat(
      [{
        device = "disk"
        driver = { name = "qemu", type = "qcow2" }
        source = { file = { file = libvirt_volume.root.path } }
        target = { dev = "vda", bus = "virtio" }
      }],
      [
        for idx, size in var.extra_disks : {
          device = "disk"
          driver = { name = "qemu", type = "qcow2" }
          source = { file = { file = libvirt_volume.extra[tostring(idx)].path } }
          target = { dev = "vd${local.disk_letters[idx]}", bus = "virtio" }
        }
      ],
      [{
        device = "cdrom"
        driver = { name = "qemu", type = "raw" }
        source = { file = { file = libvirt_volume.init.path } }
        target = { dev = "sda", bus = "sata" }
      }],
    )

    interfaces = [{
      mac    = { address = local.mac }
      model  = { type = "virtio" }
      source = { network = { network = var.network } }
    }]

    # Serial console, so `virsh console` works with no display attached.
    serials  = [{ target = { port = 0 } }]
    consoles = [{ target = { type = "serial", port = 0 } }]

    # The channel target is a union, not a type string: which nested object you
    # set is what picks the kind. A `type = "virtio"` here fails domain
    # definition with "target type must be specified for channel device".
    channels = var.qemu_agent ? [{
      target = { virt_io = { name = "org.qemu.guest_agent.0" } }
      source = { mode = "bind" }
    }] : []

    graphics = var.graphics == "none" ? [] : [
      var.graphics == "spice"
      ? { spice = { auto_port = true, listen = "127.0.0.1" } }
      : { vnc = { auto_port = true, listen = "127.0.0.1" } }
    ]

    tpms = var.tpm ? [{
      model   = "tpm-crb"
      backend = { emulator = { version = "2.0" } }
    }] : []
  }
}
