// Core Network details, shared between all resources and clients.
// No need to change any of this.
data "terraform_remote_state" "core_network" {
  backend = "s3"
  config = {
    bucket = "terraform-state-381492063870"
    key    = "terraform-state-core-network"
    region = local.aws_region
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "ksaa"
  }
}
