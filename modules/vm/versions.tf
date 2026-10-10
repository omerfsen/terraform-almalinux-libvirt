# Without this, Terraform infers hashicorp/libvirt from the resource names and
# fails with "provider registry.terraform.io/hashicorp/libvirt ... does not
# have a provider named". The version stays pinned in the root module.
terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}
