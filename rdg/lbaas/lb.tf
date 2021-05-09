resource "oci_load_balancer" "oac_load_balancer" {
  shape          = "10Mbps"
  compartment_id = var.compartment_ocid

  subnet_ids = [
    var.subnet_id
  ]

  display_name = "oac_load_balancer"

}

resource "oci_load_balancer_listener" "listener" {
  load_balancer_id         = oci_load_balancer.oac_load_balancer.id
  name                     = "tcp-listener"
  default_backend_set_name = oci_load_balancer_backend_set.oac_backend_set.name
  #hostname_names           = [oci_load_balancer_hostname.test_hostname1.name, oci_load_balancer_hostname.test_hostname2.name]
  port                     = 443
  protocol                 = "TCP"
  #rule_set_names           = [oci_load_balancer_rule_set.test_rule_set.name]

  connection_configuration {
    idle_timeout_in_seconds = "2"
  }
}

resource "oci_load_balancer_backend_set" "oac_backend_set" {
  name             = "lb-rdg-backend-set"
  load_balancer_id = oci_load_balancer.oac_load_balancer.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = "443"
    protocol            = "TCP"
    response_body_regex = ".*"
    url_path            = "/"
  }
}

resource "oci_load_balancer_backend" "oac-backend" {
  load_balancer_id = oci_load_balancer.oac_load_balancer.id
  backendset_name  = oci_load_balancer_backend_set.oac_backend_set.name
  ip_address       = var.oac_instance_private_ip
  port             = 443
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}