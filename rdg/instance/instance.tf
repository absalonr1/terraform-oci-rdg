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
    source_id = var.instance_image_ocid_linux_rdg_custom[var.region]
    # Apply this to set the size of the boot volume that's created for this instance.
    # Otherwise, the default boot volume size of the image is used.
    # This should only be specified when source_type is set to "image".
    #boot_volume_size_in_gbs = "60"
  }

  create_vnic_details {
    subnet_id        = var.private_subnet_id # oci_core_subnet.private-subnet-rdg.id
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
    #user_data           = base64encode(var.user_data)
  }
  
  defined_tags = {
    "lad-mcr-s.pais"="Chile"
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
    subnet_id        = var.public_subnet_id #oci_core_subnet.public-subnet-rdg.id
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
  
  defined_tags = {
    "lad-mcr-s.pais"="Chile"
  }

  provisioner "file" {
    source      = "/home/absalon/git-root/pocs/terraform/oci/rdg/vm-ssh-keys/ssh-key-2020-12-23.key"
    destination = "~/ssh-key-2020-12-23.key"
    connection {
      host     = oci_core_instance.bastion-instance[0].public_ip
      user  = "opc"
      private_key = file(var.ssh_private_key)
    }
  }

  timeouts {
    create = "60m"
  }

}

resource "null_resource" "remote-exec-bastion-instance" {
  depends_on = [oci_core_instance.bastion-instance]

  provisioner "remote-exec" {
    connection {
      host     = oci_core_instance.bastion-instance[0].public_ip
      user  = "opc"
      private_key = file(var.ssh_private_key)
    }

    inline = [
      "touch ~/IMadeAFile.Right.Here",
      "chmod 400 ssh-key-2020-12-23.key",
    ]
  }

  #triggers = {
  #  always_run = oci_core_volume.test_block_volume.size_in_gbs
  #}
}

resource "null_resource" "remote-exec-rdg-instance" {
  depends_on = [oci_core_instance.bastion-instance,oci_core_instance.rdg-instance]

  provisioner "remote-exec" {
    connection {
      type                = "ssh"
      bastion_host        = oci_core_instance.bastion-instance[0].public_ip
      bastion_host_key    = file(var.ssh_private_key)
      bastion_port        = 22
      bastion_user        = "opc"
      bastion_private_key = file(var.ssh_private_key)
      
      host     = oci_core_instance.rdg-instance[0].private_ip
      user  = "opc"
      private_key = file(var.ssh_private_key)
    }

    inline = [
      "touch ~/IMadeAFile.Right.Hereeeee",
      "sudo systemctl stop firewalld",
      "Oracle/Middleware/Oracle_Home/domain/bin/startJetty.sh",
    ]
  }

  #triggers = {
  #  always_run = oci_core_volume.test_block_volume.size_in_gbs
  #}
}