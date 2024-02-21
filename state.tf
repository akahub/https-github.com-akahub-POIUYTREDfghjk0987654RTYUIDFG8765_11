// ***********************************
// IMPORTANT !!! Change the state key!
// ***********************************
// Defines the location where Terraform stores its state.
// Need to define unique key for this client, by updating the client name.

terraform {
  backend "s3" {
    key            = "terraform-state-ksaa"  // TODO - Replace CLIENTNAME with real clientname and ENVIRONMENT with enviroment e.g. staging.
    region         = "eu-west-2"  // Region where the state is stored.
    bucket         = "terraform-state-381492063870"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "ksaa"
  }
}
