resource "oci_analytics_analytics_instance" "rdg_analytics_instance" {
    #Required
     capacity {
        capacity_type  = "OLPU_COUNT"
        capacity_value = 1
    }
    compartment_id = var.compartment_ocid
    feature_set = "ENTERPRISE_ANALYTICS"
    license_type = "LICENSE_INCLUDED"
    name = "test-rdg"

    #Optional
    defined_tags = {
        "lad-mcr-s.pais"="Chile"
    }

    description = "test-rdg"
    email_notification = "absalon.opazo@oracle.com"
    #idcs_access_token = "var.idcs_access_token"
    network_endpoint_details {
        #Required
        network_endpoint_type = "PRIVATE"

        #Optional
        subnet_id = var.private_subnet_id
        vcn_id = var.vcn_id
    }
}