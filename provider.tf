terraform {
  # A floor, not a pin. The old "= 1.9.8" refused to run under anything else,
  # including every release since. Tested on 1.16.5.
  required_version = ">= 1.16.0"

  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      # 0.9.x is a redesign of the provider: HCL now maps almost 1:1 onto
      # libvirt XML. There is no automated migration from the 0.8 schema, so
      # pin the minor and read the release notes before widening this.
      version = "~> 0.9.9"
    }
  }
}

provider "libvirt" {
  uri = var.libvirt_uri
}
