#https://www.terraform.io/docs/configuration/outputs.html
output "bastion-public-ip" {
  value=oci_core_instance.bastion-instance[0].public_ip
}
output "bastion-private-ip" {
  value=oci_core_instance.bastion-instance[0].private_ip
}
output "rdg-private-ip" {
  value=oci_core_instance.rdg-instance[0].private_ip
}