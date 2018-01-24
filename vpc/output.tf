output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "public_subnets_ids" {
  value = ["${aws_subnet.main-public-subnet.*.id}"]
}

output "private_subnets_ids" {
  value = ["${aws_subnet.main-private-subnet.*.id}"]
}

output "internet_gateways" {
  value = ["${aws_internet_gateway.main-gw.id}"]

}

output "nat_gateway_eip" {
  value = ["${aws_nat_gateway.main.*.public_ip}"]

}

output "route_tables" {
  value = "${aws_route_table.main-public-route-table.id}"
}

output "route_table_subnet_associations" {
  value = ["${aws_route_table_association.main-public-route-association.*.id}"]
}
