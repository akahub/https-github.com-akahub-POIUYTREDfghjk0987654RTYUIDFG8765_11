output "vpc" {
  value = aws_vpc.vpc.id
}

output "subnet_net1" {
  value = aws_subnet.net1.id
}

output "subnet_net1_cidr" {
  value = aws_subnet.net1.cidr_block
}

output "subnet_net1_ipv6_cidr" {
  value = aws_subnet.net1.ipv6_cidr_block
}

output "subnet_net2" {
  value = aws_subnet.net2.id
}

output "subnet_net2_cidr" {
  value = aws_subnet.net2.cidr_block
}

output "subnet_net2_ipv6_cidr" {
  value = aws_subnet.net2.ipv6_cidr_block
}

output "route_table" {
  value = aws_route_table.public.id
}

output "default_keypair" {
  value = aws_key_pair.keypair.key_name
}

output "linux_servers_sg" {
  value = aws_security_group.linux_servers.id
}
