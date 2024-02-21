// This defines the details of the servers and associated recoures being built

locals {
  account_id   = 381492063870    // AWS Account number. Do not change.
  aws_region   = "eu-west-2"     // TODO - (London) Must match region in State.tf
  client       = "KSAA"          // TODO - Short name. No spaces or special chars. Used for Tags, etc.
  client_name  = "KSAA"          // TODO - Long name. Can include spaces, capitals, etc. Used for Descriptions.
  project      = "Wordpress"     // TODO - Project name. No spaces or special chars. Used for Tags, etc.
  environment  = "Live"          // TODO - "Live" or "Staging". 
  createdby    = "JonRussell"    // TODO - Add your name, so we know who built this.
  requestedby  = "JonRussell"    // TODO - Add the name of who requested this or owns the client relationship.
}

// Server
resource "aws_instance" "server1" {
  // Select the correct Amazon Machine Image to build the server from.
  // https://aws.amazon.com/marketplace/search/?filters=FulfillmentOptionType&FulfillmentOptionType=Ami
  // https://cloud-images.ubuntu.com/locator/ec2/
  // Only select offical images from Amazon or the vendor (Ubuntu, RHEL, etc). 
  // Be cafeul not to select an image from an unknown or untrusted source in the marketplace.
  ami = "ami-0ecf5303980918cba" // Official Canonical Ubuntu Jammy Jellyfish 22.04 LTS (X86_64) 20240220 // TODO
  //ami = "ami-070518805d83f6790" // Official Canonical Ubuntu Jammy Jellyfish 22.04 LTS (ARM) 20240220 // TODO
    
  instance_type = "t3a.micro" // (X86_64) TODO - Select correct machine type.
  //instance_type = "t4g.micro" // (ARM) TODO - Select correct machine type.
  // Name   Cores   RAM
  // nano   2       0.5
  // micro  2       1
  // small  2       2
  // medium 2       4

  key_name      = data.terraform_remote_state.core_network.outputs.default_keypair
  subnet_id     = data.terraform_remote_state.core_network.outputs.subnet_net1
    ebs_optimized          = true
  vpc_security_group_ids = [
    // Select the appropriate Security Groups.
    // Then add a client specific Securitry Group in security_group.tf.
    data.terraform_remote_state.core_network.outputs.linux_servers_sg, // TODO - add as required
    aws_security_group.client_specific.id // TODO - edit the permissions in security_group.tf
  ]

  iam_instance_profile = aws_iam_instance_profile.server_profile.name

  root_block_device {
    volume_type = "gp2"
    volume_size = 20 // TODO - Select the appropriate disk size in GB.
  }

  tags = {
    Name          = "${local.client}_${local.environment}_${local.project}" //TODO
    Client        = local.client
    Project       = local.project
    Environment   = local.environment
    CreatedBy     = local.createdby
    RequestedBy   = local.requestedby
    backup        = "true"
  }

  volume_tags = {
    Name          = "${local.client}_${local.environment}_${local.project}" //TODO
    Client        = local.client
    Project       = local.project
    Environment   = local.environment
    CreatedBy     = local.createdby
    RequestedBy   = local.requestedby
  }

  lifecycle {
    // prevent_destroy prevents unintended deletes.
    // Terraform will not destroy these resources without physically changing this line in the code to false.
    prevent_destroy = true
    ignore_changes = [
      ami,
      user_data,
    ]
  }
}

// Elastic IP
resource "aws_eip" "server1" {
  tags = {
    Name          = "${local.client}_${local.environment}_${local.project}" //TODO
    Client        = local.client
    Project       = local.project
    Environment   = local.environment
    CreatedBy     = local.createdby
    RequestedBy   = local.requestedby
  }
}

// Associate Elastic IP to server
resource "aws_eip_association" "server1" {
  allocation_id = aws_eip.server1.id
  instance_id   = aws_instance.server1.id
}

// Cloud Watch Alarm
resource "aws_cloudwatch_metric_alarm" "server1" {
  alarm_name                = "${local.client}_${local.environment}_StatusCheckFailed" //TODO
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "StatusCheckFailed"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "0.99"
  datapoints_to_alarm       = "1"
  alarm_description         = "Alarm if either StatusCheck fails"
  actions_enabled           = "true"
  alarm_actions             = ["arn:aws:sns:eu-west-2:164068852738:InstanceAlerts"]
  insufficient_data_actions = []
  ok_actions                = []
  dimensions = {
    InstanceId  = aws_instance.server1.id
  }
  tags = {
    Name          = "${local.client}_${local.environment}_StatusCheckFailed" //TODO
    Client        = local.client
    Project       = local.project
    Environment   = local.environment
    CreatedBy     = local.createdby
    RequestedBy   = local.requestedby
  }
}