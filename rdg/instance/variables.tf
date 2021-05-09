variable "tenancy_ocid"{}
variable "instance_shape"{}
variable "compartment_ocid"{}
variable "instance_image_ocid"{}
#variable "instance_image_ocid_win"{}
variable "instance_image_ocid_linux_rdg_custom"{}
variable "private_subnet_id"{}
variable "public_subnet_id"{}
variable "region"{}
variable "vm_ssh_public_key" {}
variable "ad_number" {}


variable "ssh_private_key" {
  default = "/home/absalon/git-root/pocs/terraform/oci/rdg/vm-ssh-keys/ssh-key-2020-12-23.key"
}


