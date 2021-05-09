# Configure the Oracle Cloud Infrastructure provider with an API Key

provider "oci" {
  tenancy_ocid = var.tenancy_ocid 
  user_ocid = var.user_ocid 
  fingerprint = var.fingerprint
  private_key_path = var.private_key_path
  region = var.region
}

terraform {
  backend "http"{
    update_method = "PUT"
    address ="https://objectstorage.us-ashburn-1.oraclecloud.com/p/_eniDdtsxGY_9O6AQn2P2kbaaikexGjlDZ1df_6-ot79zhBWXuNFiYiwFV_sc8dB/n/idlhjo6dp3bd/b/Terraform-Bucket/o/terraform.tfstate"
  }
  
}