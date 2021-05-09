###########################################
###### VCN 
###########################################

resource "oci_core_vcn" "vcn-test-rdg" {
  display_name   = "vcn-test-rdg"
  cidr_block     = "10.1.0.0/16"
  dns_label = "rdgtest"
  compartment_id = var.compartment_ocid
  defined_tags = {
    "lad-mcr-s.pais"="Chile"
  }
}

###########################################
###### private sunet 
###########################################

resource "oci_core_subnet" "private-subnet-rdg" {
  # Si se omite queda como regional
  #availability_domain = data.oci_identity_availability_domain.ad.name
  cidr_block          = "10.1.0.0/24"
  display_name        = "private-subnet-rdg"
  #dns_label           = "priv-sub-rdg"
  security_list_ids   = [oci_core_security_list.test-rdg-security-list.id]
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.vcn-test-rdg.id
  route_table_id      = oci_core_route_table.priv_subnet_route_table_test_rdg.id
  dhcp_options_id     = oci_core_vcn.vcn-test-rdg.default_dhcp_options_id
  prohibit_public_ip_on_vnic = true
  defined_tags = {
    "lad-mcr-s.pais"="Chile"
  }
}

###########################################
###### public sunet 
###########################################
resource "oci_core_subnet" "public-subnet-rdg" {
  # Si se omite queda como regional
  #availability_domain = data.oci_identity_availability_domain.ad.name
  cidr_block          = "10.1.1.0/24"
  display_name        = "public-subnet-rdg"
  #dns_label           = "priv-sub-rdg"
  security_list_ids   = [oci_core_security_list.test-rdg-security-list.id] # [oci_core_vcn.vcn-test-rdg.default_security_list_id]
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.vcn-test-rdg.id
  route_table_id      = oci_core_route_table.pub_subnet_route_table_test_rdg.id #oci_core_vcn.vcn-test-rdg.default_route_table_id
  dhcp_options_id     = oci_core_vcn.vcn-test-rdg.default_dhcp_options_id
  prohibit_public_ip_on_vnic = false

  defined_tags = {
    "lad-mcr-s.pais"="Chile"
  }
}

###########################################
###### IGW
###########################################

resource "oci_core_internet_gateway" "test_rdg_internet_gateway" {
    #Required
    compartment_id = var.compartment_ocid
    vcn_id = oci_core_vcn.vcn-test-rdg.id

    #Optional
    enabled = true
    display_name = "internet-gw"
    #freeform_tags = {"Department"= "Finance"}
    defined_tags = {
    "lad-mcr-s.pais"="Chile"
  }
}


###########################################
###### ROUTE TABLE - public subnet
###########################################


resource "oci_core_route_table" "pub_subnet_route_table_test_rdg" {
    #Required
    compartment_id = var.compartment_ocid
    vcn_id = oci_core_vcn.vcn-test-rdg.id

    #Optional
    #defined_tags = {"Operations.CostCenter"= "42"}
    #display_name = var.route_table_display_name
    #freeform_tags = {"Department"= "Finance"}
    route_rules {
        #Required
        # "Target" en la consola OCI
        network_entity_id = oci_core_internet_gateway.test_rdg_internet_gateway.id

        #Optional
        description = "internet-gw"
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
    }
    defined_tags = {
      "lad-mcr-s.pais"="Chile"
    }
}

###########################################
###### ROUTE TABLE - private  subnet
###########################################


resource "oci_core_route_table" "priv_subnet_route_table_test_rdg" {
    #Required
    compartment_id = var.compartment_ocid
    vcn_id = oci_core_vcn.vcn-test-rdg.id
    defined_tags = {
      "lad-mcr-s.pais"="Chile"
    }
}

###########################################
###### Security List
###########################################


resource "oci_core_security_list" "test-rdg-security-list" {
    #Required
    compartment_id = var.compartment_ocid
    vcn_id = oci_core_vcn.vcn-test-rdg.id
    display_name="sec-list-windows-bastion"

    defined_tags = {
      "lad-mcr-s.pais"="Chile"
    }
    egress_security_rules {
        #Required
        destination = "0.0.0.0/0"
        protocol = "all"

        #Optional
        description = "Agress to All"
        destination_type = "CIDR_BLOCK"
    }
    ingress_security_rules {
        #Required
        protocol = "all" #  Options are supported only for ICMP ("1"), TCP ("6"), UDP ("17"), and ICMPv6 ("58")
        source = "0.0.0.0/0"

        #Optional
        description = "Ingress solo TCP"
    }
}