// Define the shared Management Security Groups. 
// This creates Four Secrity Groups
//   "Linux Servers Admin Access"
//     Access to everyone in the management group to the following Linux ports :
//       22 (ssh), 80 (HTTP), 443 (HTTPS), 3306 (mySQL)
//
// To add a user to the admin group, add their IP to the IPv4 and/or IPv6 array and apply the terraform.

locals {
  // Management details
  management_addresses = [
    "93.89.135.136/29", # Jon Russell
  ]

  management_addresses_ipv6 = [
    "2a02:390:8644:12::/64", # Jon Russell
  ]

  management_linux_tcp_ports = [
    "22",   // ssh
    "80",   // HTTP
    "443",  // HTTPS
    "3306"  // mySQL
  ]
}

// Linux Servers
resource "aws_security_group" "linux_servers" {
  name        = "Linux Servers Admin Access"
  description = "Management Access for all Linux Servers"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name        = "Linux Servers Admin Access"
    Client      = local.client
    Project     = local.project
    Environment = local.environment
    CreatedBy   = local.createdby
  }
}

resource "aws_security_group_rule" "linux_servers_egress_any" {
  description       = "Allow any IP outbound"
  security_group_id = aws_security_group.linux_servers.id
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]

  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "all"
}

resource "aws_security_group_rule" "linux_servers_ingress_tcp" {
  for_each = toset(local.management_linux_tcp_ports)

  description       = "Management Access (TCP)"
  cidr_blocks       = local.management_addresses
  ipv6_cidr_blocks  = local.management_addresses_ipv6
  security_group_id = aws_security_group.linux_servers.id

  type      = "ingress"
  from_port = each.key
  to_port   = each.key
  protocol  = "tcp"
}

