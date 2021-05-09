#######################################
##### Instancia privada 
#######################################
resource "oci_core_instance" "rdg-instance" {
  count               = 1
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "RDG-HOST" #"TestInstance${count.index}"
  shape               = var.instance_shape

 
  source_details {
    source_type = "image"
    source_id = var.instance_image_ocid[var.region]
    # Apply this to set the size of the boot volume that's created for this instance.
    # Otherwise, the default boot volume size of the image is used.
    # This should only be specified when source_type is set to "image".
    #boot_volume_size_in_gbs = "60"
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.private-subnet-rdg.id
    display_name     = "Primaryvnic"
    assign_public_ip = false
    #hostname_label   = "tfexampleinstance${count.index}"
  }

  # Apply the following flag only if you wish to preserve the attached boot volume upon destroying this instance
  # Setting this and destroying the instance will result in a boot volume that should be managed outside of this config.
  # When changing this value, make sure to run 'terraform apply' so that it takes effect before the resource is destroyed.
  #preserve_boot_volume = true

  metadata = {
    # "ssh_authorized_keys" - Provide one or more public SSH keys to be included in the ~/.ssh/authorized_keys
    ssh_authorized_keys = var.vm_ssh_public_key
    #user_data           = base64encode(file("./userdata/bootstrap"))
  }
  
  #defined_tags = {
  #  "${oci_identity_tag_namespace.tag-namespace1.name}.${oci_identity_tag.tag2.name}" = "awesome-app-server"
  #}

  freeform_tags = {
    "freeformkey${count.index}" = "freeformvalue${count.index}"
  }
  
  timeouts {
    create = "60m"
  }

}

#######################################
##### Instancia publica 
#######################################
resource "oci_core_instance" "bastion-instance" {
  count               = 1
  availability_domain = data.oci_identity_availability_domain.ad.name
    compartment_id = var.compartment_ocid
  display_name        = "BASTION-HOST" #"TestInstance${count.index}"
  shape               = var.instance_shape

 
  source_details {
    source_type = "image"
    source_id = var.instance_image_ocid[var.region]
    # Apply this to set the size of the boot volume that's created for this instance.
    # Otherwise, the default boot volume size of the image is used.
    # This should only be specified when source_type is set to "image".
    #boot_volume_size_in_gbs = "60"
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.public-subnet-rdg.id
    display_name     = "Primaryvnic"
    assign_public_ip = true
    #hostname_label   = "tfexampleinstance${count.index}"
  }

  # Apply the following flag only if you wish to preserve the attached boot volume upon destroying this instance
  # Setting this and destroying the instance will result in a boot volume that should be managed outside of this config.
  # When changing this value, make sure to run 'terraform apply' so that it takes effect before the resource is destroyed.
  #preserve_boot_volume = true

  metadata = {
    # "ssh_authorized_keys" - Provide one or more public SSH keys to be included in the ~/.ssh/authorized_keys
    ssh_authorized_keys = var.vm_ssh_public_key
    #user_data           = base64encode(file("./userdata/bootstrap"))
  }
  
  #defined_tags = {
  #  "${oci_identity_tag_namespace.tag-namespace1.name}.${oci_identity_tag.tag2.name}" = "awesome-app-server"
  #}

  freeform_tags = {
    "freeformkey${count.index}" = "freeformvalue${count.index}"
  }
  
  timeouts {
    create = "60m"
  }

}

###############################################
####  Variables de Compute
###############################################

variable "instance_image_ocid" {
  type = map(string)

  default = {
    # See https://docs.us-phoenix-1.oraclecloud.com/images/
    # Oracle-provided image "Oracle-Linux-7.5-2018.10.16-0"
    us-phoenix-1   = "ocid1.image.oc3.us-gov-phoenix-1.aaaaaaaablheqkh4k2mo4l5wfnpg2t5zuokmgai5cex6kell4epiio5yi6lq"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaaf2wxqc6ee5axabpbandk6ji27oyxyicatqw5iwkrk76kecqrrdyq"
    
  }
}

variable "instance_shape" {
  default = "VM.Standard2.1"
}