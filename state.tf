// Defines the location where Terraform stores its state.
// Need to define unique key for this client, by updating the client name.

terraform {
  backend "s3" {
    key            = "terraform-state-core-network"
    region         = "eu-west-2"  //Must match region in main.tf
    bucket         = "terraform-state-381492063870"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "ksaa"
  }
}
