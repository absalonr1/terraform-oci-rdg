resource "oci_database_db_system" "test_db_system" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  database_edition    = "ENTERPRISE_EDITION"
  domain      = "mydomain"
  
  db_home {
    database {
      admin_password = "BEstrO0ng_#12"
      
      db_name        = "RNORCL"
      db_workload    = "OLTP"
      pdb_name       = "pdbName"

      db_backup_config {
        auto_backup_enabled = false
      }
    }
    # The database version must be one of 11.2.0.4 or 11.2.0.4.200114 or 11.2.0.4.200414 or 
    # 11.2.0.4.200714 or 11.2.0.4.201020 or 12.1.0.2 or 12.1.0.2.200114 or 12.1.0.2.200414 or 
    # 12.1.0.2.200714 or 12.1.0.2.201020 or 12.2.0.1 or 12.2.0.1.200114 or 12.2.0.1.200414 or 
    # 12.2.0.1.200714 or 12.2.0.1.201020 or 18.0.0.0 or 18.10.0.0 or 18.11.0.0 or 18.12.0.0 or 
    # 18.9.0.0 or 19.0.0.0 or 19.6.0.0 or 19.7.0.0 or 19.8.0.0 or 19.9.0.0 or 21.0.0.0 or 21.1.0.0
    db_version   = "12.2.0.1.200114"
    display_name = "MyTFDBHomeVm"
  }

  db_system_options {
    storage_management = "LVM"
  }

  disk_redundancy         = "NORMAL"
  shape                   = var.db_system_shape
  subnet_id               = var.subnet_id
  ssh_public_keys         = [var.ssh_public_key]
  display_name            = "MyTFDBSystemVM"
  hostname                = "myoracledb"
  data_storage_size_in_gb = "256"
  license_model           = "LICENSE_INCLUDED"
  node_count              = data.oci_database_db_system_shapes.test_db_system_shapes.db_system_shapes[0]["minimum_node_count"]
  #nsg_ids                 = [oci_core_network_security_group.test_network_security_group_backup.id, oci_core_network_security_group.test_network_security_group.id]

  #To use defined_tags, set the values below to an existing tag namespace, refer to the identity example on how to create tag namespaces
  #defined_tags  = {"${oci_identity_tag_namespace.tag-namespace1.name}.${oci_identity_tag.tag1.name}" = "value"}

   defined_tags = {
    "lad-mcr-s.pais"="Chile"
  }

}
