#https://www.terraform.io/docs/configuration/outputs.html
output "vcn_id" {
  value=oci_core_vcn.vcn-test-rdg.id
}

output "public_subnet_id" {
  value=oci_core_subnet.public-subnet-rdg.id
}

output "private_subnet_id" {
  value=oci_core_subnet.private-subnet-rdg.id
}


# Output the result
output "show-ads" {
  value = data.oci_identity_availability_domains.ads.availability_domains
}
