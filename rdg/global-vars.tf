variable "tenancy_ocid"{}
variable "user_ocid"{}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "vm_ssh_public_key"{}


variable "instance_image_ocid_win" {
  type = map(string)

  default = {
    # https://docs.oracle.com/en-us/iaas/images/image/88496145-3cf5-4b40-a466-70a290499a0b/
    # Windows-Server-2016-Standard-Edition-VM
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaayxmorhjrkcraeoeaid2ijneuwtupddliy3oe7yv7kbjwinnop3rq"
    sa-santiago-1  = "ocid1.image.oc1.sa-santiago-1.aaaaaaaa6ofv25fel7cmic4y6d4rjpjgo3giymxl5brlqhm2efmuw4oytxhq"
    
  }
}

variable "instance_image_ocid" {
  type = map(string)

  default = {
    # https://docs.oracle.com/en-us/iaas/images/image/c7b501b9-f2fa-40e9-b416-299cafdad0e2/
    # 	Oracle-Linux-7.9-2020.11.10-1
    us-phoenix-1   = "ocid1.image.oc3.us-gov-phoenix-1.aaaaaaaablheqkh4k2mo4l5wfnpg2t5zuokmgai5cex6kell4epiio5yi6lq"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaaf2wxqc6ee5axabpbandk6ji27oyxyicatqw5iwkrk76kecqrrdyq"
    sa-santiago-1  = "ocid1.image.oc1.sa-santiago-1.aaaaaaaavp74v67m52kohyusliy4fnov5j6yfugbxfa3dfmpicvd4ptqy6oq"
    
  }
}


variable "instance_image_ocid_linux_rdg_custom" {
  type = map(string)

  default = {
    # https://docs.oracle.com/en-us/iaas/images/image/c7b501b9-f2fa-40e9-b416-299cafdad0e2/
    # BASADA EN: 	Oracle-Linux-7.9-2020.11.10-1
    # Incluye instalacion de RDG 5.8
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaaraizp7oxtm47pk25gicdwjiwj7ar6s2eef5xcgxgkippu5rj7xsq"
    sa-santiago-1  = "ocid1.image.oc1.sa-santiago-1.aaaaaaaap2yu7ap4wcticiqdiibnc3kxkpvvszsff6yr5ofvfn4xvb3plabq"

  }
}

variable "ad_number" {
  default= 2
}
variable "instance_shape" {
  default = "VM.Standard2.1"
}

variable "db_system_shape"{
  # VM.Standard2.1
  default="VM.Standard2.4"
}