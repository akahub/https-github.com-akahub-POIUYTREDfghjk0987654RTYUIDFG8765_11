This builds the core network, consisting of a VPC, two Subnets and some shared Security Groups.

## VPC

A the core VPC is called "VPC (Core)"

All client and internal resources will be contained within this shared VPC.

This has a network subnet 10.10.0.0/16

There are two subnets, one for each Availability Zone.
* "Subnet 1 (Core)" - 10.10.0.0/20
* "Subnet 2 (Core)" - 10.10.16.0/20

## Admin Access Security Groups

An Admin access group has been created for each Operating System type.
* "Linux Servers Access" - Ports 22, 80, 443, 3306
* "Windows Servers Access" - Ports 21, 80, 443, 3389

This contains ssh and RDP access for admins. This is IP restricted. Add you IP addresses to the management_addresses variable in security_groups.tf to be granted access.

All AWS virtual machines will include one of these two security groups depending on their OS.

## Client Security Groups

Each client will have one or more Security Groups for public and client access.

These Security Groups contains the public access required by the applications. These can be tuned to the specific client needs.

For most clients this will be public access to port 80 & 443 (HTTP & HTTPS).

For more complex architectures with multiple server, these will also define the server to server access required.
