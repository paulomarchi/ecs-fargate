output "load-balancer-dns" {
    value = "${module.load-balancer.dns}"
}

output "fqdn" {
  value = "${module.dns.fqdn}"
}
