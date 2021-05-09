# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/identity_availability_domain
data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = var.ad_number
}

# https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/identity_availability_domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}