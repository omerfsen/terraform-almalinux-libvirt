#cloud-config
growpart:
  mode: auto
  devices: ["/"]
  ignore_growroot_disabled: false

resize_rootfs: noblock

chpasswd:
  expire: false
ssh_pwauth: true
disable_root: false

# password can be generated with:
# echo "test" | mkpasswd -m sha-512 -s

users:
  - default
  - name: serra
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: adm,wheel
    passwd: ${serra_passwd}
    lock_passwd: false
    ssh_authorized_keys: ${serra_ssh_keys}
  - name: root
    passwd: ${root_passwd}
    ssh_authorized_keys: ${root_ssh_keys}

timezone: Europe/London
# Disable selinux with overwriting conf file
write_files:
-   encoding: b64
    content: ${encoded_selinux}
    owner: root:root
    path: /etc/sysconfig/selinux
    permissions: '0644'

-   encoding: b64
    content: ${encoded_eth0}
    owner: root:root
    path: /etc/sysconfig/network-scripts/ifcfg-eth0
    permissions: '0644'

-   encoding: b64
    content: ${encoded_grub}
    owner: root:root
    path: /etc/default/grub
    permissions: '0644'

-   encoding: b64
    content: ${encoded_rc_local}
    owner: root:root
    path: /etc/rc.d/rc.local
    permissions: '0755'

-   encoding: b64
    content: ${encoded_rc_local_once}
    owner: root:root
    path: /etc/rc.d/rc.local.rebootonce
    permissions: '0755'

# package_update: true
# Below upgrades packages
# package_upgrade: true

runcmd:
  - [ /etc/rc.d/rc.local.rebootonce ]  # Modify this line for the correct path
