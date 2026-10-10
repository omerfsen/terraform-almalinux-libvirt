# ---------------------------------------------------------------------------
# Hypervisor and storage
# ---------------------------------------------------------------------------
libvirt_uri = "qemu:///system"
pool        = "default"

# ---------------------------------------------------------------------------
# Base image. The provider fetches this itself, so nothing has to be
# pre-downloaded onto the hypervisor. Swap the three values below to move
# between releases - the rest of the configuration is version-independent and
# has been tested on both 9.x and 10.x.
#
#   AlmaLinux 10.2 (current 10.x)
#     image_url  = "https://repo.almalinux.org/almalinux/10/cloud/x86_64/images/AlmaLinux-10-GenericCloud-10.2-20260817.0.x86_64.qcow2"
#     image_name = "AlmaLinux-10-GenericCloud-10.2.qcow2"
#
#   AlmaLinux 9.8 (current 9.x) - the default below
#
# On 10.x, cloud-init selects the network-manager renderer by itself and writes
# a keyfile, so nm_keyfiles has nothing to convert and is harmless. 10.x also
# requires an x86-64-v3 host CPU; check with:
#   /usr/lib64/ld-linux-x86-64.so.2 --help | grep x86-64-v3
image_url  = "https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-9.8-20261005.x86_64.qcow2"
image_name = "AlmaLinux-9-GenericCloud-9.8.qcow2"

# Virtual size of that image in bytes (qemu-img info | grep "virtual size").
image_capacity = 10737418240 # 10 GiB

# ---------------------------------------------------------------------------
# The VMs. Key = domain name = guest hostname. Anything omitted falls back to
# the default_* values below, so a one-line entry is a complete VM.
# ---------------------------------------------------------------------------
vms = {
  "alma9-01" = {
    ip = "192.168.122.240/24"
  }
  # "alma9-02" = {
  #   memory      = 8192
  #   vcpu        = 4
  #   disk_size   = 60
  #   extra_disks = [100, 200]   # vdb, vdc
  #   autostart   = true
  # }
  # "alma9-dhcp" = {}            # no ip = DHCP
}

default_memory    = 4096
default_vcpu      = 2
default_disk_size = 30
default_network   = "default"
default_gateway   = "192.168.122.1"

nameservers    = ["1.1.1.1", "8.8.8.8"]
search_domains = []

# ---------------------------------------------------------------------------
# Guest configuration
# ---------------------------------------------------------------------------
# password_hash comes from:  mkpasswd -m sha-512
# The hash below is the example the repo has always shipped - replace it.
users = [
  {
    name          = "serra"
    sudo          = true
    groups        = ["adm", "wheel"]
    password_hash = "$6$T6g./2x.fLBA4KRO$uSQy6XVsvwccGb.JEaICrPlu7HKnjbDTyG9XtjiaETNaAZ5mnnUZb5qdoF9GGHRIoNQY0pS/OnkTinYfqeFye0"
    ssh_authorized_keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAsA1JBEUJMBkDmWXlceuqV77pUoUF6O0gGJTcnwcCOQAR6fNWzZJkf8Fjp/nyjENg9sZyE9whZUqBBXO25H6apSD47Jx0ebHZbH+F5CBo8onG1UwmILWMZMDuIPdRiIS5L7eoyYJ6cGTriJu7ABaUpu9As+Wkj0C62uhb240AJPdsADKNhfvmBED+l9H2vt9EpStweMYjD+xqO9ZxW6E/0cfWrJyjE3M7t1lqtbVadV0F73clOHPC51FirEj/G0QCSvkmppBKTl73gLRe6AVmP0+eQIYU9QLIHiWATDa73veB+t1E7vib5JxCQo8//jSiFjNgs/KY0yZuOCj7PUxPow== ofsen@ocean",
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFF4U68b4mR8YBBq76u+UzNjCu+epodUgc3HbUTFMWhY2arZdzPHlsuI7bgqXD38dCyVtn2MD6pxdIm+cOv9RVQn2h9taHF7Iywxh6oxaQUlxQ19WYPEfQ7ZuWhZyIFG8TDlfBWaUlZOVbNl0e3TdRA3DQYkbx2W6hnXShB1Gf+NdV1C6y3jwyaV4UcbaMv4irKyc8BWPzpHBD67bOJ3RMzQ+1Vhny2nYboF3oAnM12ab9D8fzVYGr0Wy+Hd7JHMjMeYLgqr+BSltnSi+VhD5f1thCGZryprogQd4YcuKFCqin+yK72mn8bwfL/nTLV/XPaAAZM3ZE6eMhRghpfJ+hn3DFTkQGFwk1VJI9gHvIdZVeU8/sz7Y9ZT2pWzHLQrb7w12vFwBCnUvxQZyylLCXx9pw1CGmK3nzlJPSL79q5Yd/v1YNn/D8L2LlOzyPeHeTlCinCUwRBGj2zCKRmlNViq34NduI+4H3T5+T63J2uDXCXZ6ihyP3lI1EkPKMJQc= root@azure",
    ]
  },
]

# Added to every user above, on top of their own list.
ssh_authorized_keys = []

# Root stays locked and unreachable over ssh by default.
root_password_hash = null
permit_root_ssh    = false
root_ssh_authorized_keys = [
  "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAsA1JBEUJMBkDmWXlceuqV77pUoUF6O0gGJTcnwcCOQAR6fNWzZJkf8Fjp/nyjENg9sZyE9whZUqBBXO25H6apSD47Jx0ebHZbH+F5CBo8onG1UwmILWMZMDuIPdRiIS5L7eoyYJ6cGTriJu7ABaUpu9As+Wkj0C62uhb240AJPdsADKNhfvmBED+l9H2vt9EpStweMYjD+xqO9ZxW6E/0cfWrJyjE3M7t1lqtbVadV0F73clOHPC51FirEj/G0QCSvkmppBKTl73gLRe6AVmP0+eQIYU9QLIHiWATDa73veB+t1E7vib5JxCQo8//jSiFjNgs/KY0yZuOCj7PUxPow== user1",
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFF4U68b4mR8YBBq76u+UzNjCu+epodUgc3HbUTFMWhY2arZdzPHlsuI7bgqXD38dCyVtn2MD6pxdIm+cOv9RVQn2h9taHF7Iywxh6oxaQUlxQ19WYPEfQ7ZuWhZyIFG8TDlfBWaUlZOVbNl0e3TdRA3DQYkbx2W6hnXShB1Gf+NdV1C6y3jwyaV4UcbaMv4irKyc8BWPzpHBD67bOJ3RMzQ+1Vhny2nYboF3oAnM12ab9D8fzVYGr0Wy+Hd7JHMjMeYLgqr+BSltnSi+VhD5f1thCGZryprogQd4YcuKFCqin+yK72mn8bwfL/nTLV/XPaAAZM3ZE6eMhRghpfJ+hn3DFTkQGFwk1VJI9gHvIdZVeU8/sz7Y9ZT2pWzHLQrb7w12vFwBCnUvxQZyylLCXx9pw1CGmK3nzlJPSL79q5Yd/v1YNn/D8L2LlOzyPeHeTlCinCUwRBGj2zCKRmlNViq34NduI+4H3T5+T63J2uDXCXZ6ihyP3lI1EkPKMJQc= user2@domain",
]

timezone        = "Europe/London"
packages        = ["qemu-guest-agent"]
package_upgrade = false
selinux_mode    = "enforcing"

# Convert cloud-init's rendered network config into NetworkManager keyfiles.
# EL9 renders ifcfg-eth0 otherwise; EL10 has no network-scripts at all.
nm_keyfiles = true
harden_ssh  = true
runcmd      = []

# ---------------------------------------------------------------------------
# Boot / first-boot behaviour (what the old repo's rc.local run-once did)
# ---------------------------------------------------------------------------
# crashkernel=auto is deliberately absent: EL9 ignores it.
grub_serial_console     = true
ipv6_disable            = true
grub_cmdline_extra      = []
reboot_after_first_boot = true

# ---------------------------------------------------------------------------
# Hardware
# ---------------------------------------------------------------------------
cpu_mode         = "host-passthrough"
machine_type     = "q35"
firmware         = "bios"
tpm              = false
graphics         = "vnc"
qemu_agent       = true
shutdown_timeout = 60

# ---------------------------------------------------------------------------
# Parity with the original repo
# ---------------------------------------------------------------------------
# The original kept the cloud image's own user ("- default") and allowed
# password logins. ssh_password_auth is the single security default changed
# here; set it true for exact parity.
include_default_user = true
ssh_password_auth    = false

# The original's /etc/rc.d/rc.local ran on EVERY boot and regenerated the ssh
# host keys each time, so the fingerprint changed on every reboot and
# known_hosts broke. Off unless you specifically want that behaviour back.
rc_local_every_boot = false

# Show the guest's IP at the login prompt (/etc/issue, /etc/issue.net), the way
# the Rocky repo did. agetty expands \4{iface} there.
console_show_ip   = true
primary_interface = "eth0"
