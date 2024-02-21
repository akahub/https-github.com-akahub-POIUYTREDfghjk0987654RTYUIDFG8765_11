// Define outputs you need displayed in the terraform console after building the servers.
// Linux servers just need the Elastic IP.

output "server1_eip" {
  value = aws_eip.server1.public_ip
}

