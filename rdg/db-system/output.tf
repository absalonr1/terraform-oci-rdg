#https://www.terraform.io/docs/configuration/outputs.html

output "test_db_system-private_ip" {
  value=oci_database_db_system.test_db_system.private_ip
}
