// Define the client specific Security Groups. Define the public access for the servers here.

locals {
  public_tcp_ports = [
    "80",
    "443"
  ]
}

// Default security group for this client
resource "aws_security_group" "client_specific" {
  name        = "${local.client}_${local.project}_${local.environment}" // TODO
  description = "Public Access for ${local.client_name} Servers" // TODO
  vpc_id      = data.terraform_remote_state.core_network.outputs.vpc

  tags = {
    Name        = "${local.client}_${local.project}" // TODO
    Client      = local.client
    Project     = local.project
    Environment = local.environment
    CreatedBy   = local.createdby
  }
}

resource "aws_security_group_rule" "default_egress_any" {
  description       = "Allow any IP outbound"
  security_group_id = aws_security_group.client_specific.id
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]

  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "all"
}

resource "aws_security_group_rule" "default_ingress_tcp" {
  for_each = toset(local.public_tcp_ports)

  description       = "Public Access (TCP)"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.client_specific.id

  type      = "ingress"
  from_port = each.key
  to_port   = each.key
  protocol  = "tcp"
}
