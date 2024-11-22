alma9_cloudinit_disk = "alma9_cloudinit_disk.iso"
alma9_cloudinit_pool = "default"
alma9_domain_memory  = "4096"
alma9_domain_name    = "Golden_Alma_9_5-TF"
alma9_domain_vcpu    = "2"
alma9_name           = "almalinux9"
alma9_network_name   = "default"
alma9_volume_format  = "qcow2"
alma9_volume_name    = "Golden_Alma_9_5-TF.qcow2"
alma9_volume_pool    = "default"
alma9_volume_size    = "32212254720"
# https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-9.5-20241120.x86_64.qcow2
alma9_volume_source = "/share/iso/AlmaLinux/9/AlmaLinux-9-GenericCloud-9.5-20241120.x86_64.qcow2"
# password can be generated with:
# echo "test" | mkpasswd -m sha-512 -s
serra_passwd        = "$6$T6g./2x.fLBA4KRO$uSQy6XVsvwccGb.JEaICrPlu7HKnjbDTyG9XtjiaETNaAZ5mnnUZb5qdoF9GGHRIoNQY0pS/OnkTinYfqeFye0"
root_passwd         = "$6$T6g./2x.fLBA4KRO$uSQy6XVsvwccGb.JEaICrPlu7HKnjbDTyG9XtjiaETNaAZ5mnnUZb5qdoF9GGHRIoNQY0pS/OnkTinYfqeFye0"
serra_ssh_keys = [
  "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAsA1JBEUJMBkDmWXlceuqV77pUoUF6O0gGJTcnwcCOQAR6fNWzZJkf8Fjp/nyjENg9sZyE9whZUqBBXO25H6apSD47Jx0ebHZbH+F5CBo8onG1UwmILWMZMDuIPdRiIS5L7eoyYJ6cGTriJu7ABaUpu9As+Wkj0C62uhb240AJPdsADKNhfvmBED+l9H2vt9EpStweMYjD+xqO9ZxW6E/0cfWrJyjE3M7t1lqtbVadV0F73clOHPC51FirEj/G0QCSvkmppBKTl73gLRe6AVmP0+eQIYU9QLIHiWATDa73veB+t1E7vib5JxCQo8//jSiFjNgs/KY0yZuOCj7PUxPow== ofsen@ocean",
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFF4U68b4mR8YBBq76u+UzNjCu+epodUgc3HbUTFMWhY2arZdzPHlsuI7bgqXD38dCyVtn2MD6pxdIm+cOv9RVQn2h9taHF7Iywxh6oxaQUlxQ19WYPEfQ7ZuWhZyIFG8TDlfBWaUlZOVbNl0e3TdRA3DQYkbx2W6hnXShB1Gf+NdV1C6y3jwyaV4UcbaMv4irKyc8BWPzpHBD67bOJ3RMzQ+1Vhny2nYboF3oAnM12ab9D8fzVYGr0Wy+Hd7JHMjMeYLgqr+BSltnSi+VhD5f1thCGZryprogQd4YcuKFCqin+yK72mn8bwfL/nTLV/XPaAAZM3ZE6eMhRghpfJ+hn3DFTkQGFwk1VJI9gHvIdZVeU8/sz7Y9ZT2pWzHLQrb7w12vFwBCnUvxQZyylLCXx9pw1CGmK3nzlJPSL79q5Yd/v1YNn/D8L2LlOzyPeHeTlCinCUwRBGj2zCKRmlNViq34NduI+4H3T5+T63J2uDXCXZ6ihyP3lI1EkPKMJQc= root@azure"
]
root_ssh_keys = [
  "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAsA1JBEUJMBkDmWXlceuqV77pUoUF6O0gGJTcnwcCOQAR6fNWzZJkf8Fjp/nyjENg9sZyE9whZUqBBXO25H6apSD47Jx0ebHZbH+F5CBo8onG1UwmILWMZMDuIPdRiIS5L7eoyYJ6cGTriJu7ABaUpu9As+Wkj0C62uhb240AJPdsADKNhfvmBED+l9H2vt9EpStweMYjD+xqO9ZxW6E/0cfWrJyjE3M7t1lqtbVadV0F73clOHPC51FirEj/G0QCSvkmppBKTl73gLRe6AVmP0+eQIYU9QLIHiWATDa73veB+t1E7vib5JxCQo8//jSiFjNgs/KY0yZuOCj7PUxPow== user1",
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFF4U68b4mR8YBBq76u+UzNjCu+epodUgc3HbUTFMWhY2arZdzPHlsuI7bgqXD38dCyVtn2MD6pxdIm+cOv9RVQn2h9taHF7Iywxh6oxaQUlxQ19WYPEfQ7ZuWhZyIFG8TDlfBWaUlZOVbNl0e3TdRA3DQYkbx2W6hnXShB1Gf+NdV1C6y3jwyaV4UcbaMv4irKyc8BWPzpHBD67bOJ3RMzQ+1Vhny2nYboF3oAnM12ab9D8fzVYGr0Wy+Hd7JHMjMeYLgqr+BSltnSi+VhD5f1thCGZryprogQd4YcuKFCqin+yK72mn8bwfL/nTLV/XPaAAZM3ZE6eMhRghpfJ+hn3DFTkQGFwk1VJI9gHvIdZVeU8/sz7Y9ZT2pWzHLQrb7w12vFwBCnUvxQZyylLCXx9pw1CGmK3nzlJPSL79q5Yd/v1YNn/D8L2LlOzyPeHeTlCinCUwRBGj2zCKRmlNViq34NduI+4H3T5+T63J2uDXCXZ6ihyP3lI1EkPKMJQc= user2@domain"
]

selinux_content = <<EOT
SELINUX=disabled
SELINUXTYPE=targeted
#
EOT

eth0_content = <<EOT
TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
BOOTPROTO="none"
DEFROUTE="yes"
IPV4_FAILURE_FATAL="no"
IPV6INIT="no"
NAME="eth0"
DEVICE="eth0"
ONBOOT="yes"
IPADDR="192.168.122.249"
PREFIX="24"
GATEWAY="192.168.122.1"
DNS1="8.8.8.8"
EOT

grub_content = <<EOT
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=false
GRUB_TERMINAL="console"
#GRUB_TERMINAL="console serial"
GRUB_SERIAL_COMMAND="serial --speed=115200"
GRUB_CMDLINE_LINUX="ipv6.disable=1 console=ttyS0 earlyprintk=ttyS0 crashkernel=auto console=ttyS0,115200"
GRUB_DISABLE_RECOVERY="false"
EOT


rc_local_once_content = <<EOT
#!/bin/bash
echo "Rebooting for Selinux only once"
rm -f  /etc/rc.local.rebootonce
grub2-mkconfig -o /boot/grub2/grub.cfg
yum -y upgrade 
rm -f /etc/ssh/ssh_host_*
# https://www.ssh-audit.com/hardening_guides.html#rhel8
ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ""
ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""
chgrp ssh_keys /etc/ssh/ssh_host_ed25519_key /etc/ssh/ssh_host_rsa_key
chmod g+r /etc/ssh/ssh_host_ed25519_key /etc/ssh/ssh_host_rsa_key
awk '$5 >= 3071' /etc/ssh/moduli > /etc/ssh/moduli.safe
mv -f /etc/ssh/moduli.safe /etc/ssh/moduli
sed -i 's/^HostKey \/etc\/ssh\/ssh_host_ecdsa_key$/\#HostKey \/etc\/ssh\/ssh_host_ecdsa_key/g' /etc/ssh/sshd_config
cp /etc/crypto-policies/back-ends/opensshserver.config /etc/crypto-policies/back-ends/opensshserver.config.orig
echo -e "Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com
GSSAPIKexAlgorithms gss-curve25519-sha256-
KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256
HostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-512
PubkeyAcceptedAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-512
CASignatureAlgorithms ecdsa-sha2-nistp256,sk-ecdsa-sha2-nistp256@openssh.com,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,ssh-ed25519,sk-ssh-ed25519@openssh.com,rsa-sha2-256,rsa-sha2-512
RequiredRSASize 2048" > /etc/crypto-policies/back-ends/opensshserver.config
reboot
EOT

rc_local_content = <<EOT
#!/bin/bash
echo "Rebooting for Selinux only once"
rm -f /etc/rc.local.rebootonce
grub2-mkconfig -o /boot/grub2/grub.cfg
yum -y upgrade
rm -f /etc/ssh/ssh_*
# https://www.ssh-audit.com/hardening_guides.html#rhel8
ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ""
ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""
chgrp ssh_keys /etc/ssh/ssh_host_ed25519_key /etc/ssh/ssh_host_rsa_key
chmod g+r /etc/ssh/ssh_host_ed25519_key /etc/ssh/ssh_host_rsa_key
EOT
