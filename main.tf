locals {
  account_id = 381492063870
  aws_region = "eu-west-2" // London
  cidr       = "10.10.0.0/16"
  client      = "KSAA"
  project     = "Internal"
  environment = "Core"
  createdby   = "JonRussell"
}

resource "aws_key_pair" "keypair" {
  key_name   = "${local.client}-${local.project}-${local.environment}-keypair"
  public_key = file("~/.aws/endava-terraform.pub")
}
