output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The VPC ID that was created"
}

output "ingress_route_table_ids" {
  value       = module.vpc.private_route_table_ids[0]
  description = "A list of the ingress route table IDs"
}

output "egress_route_table_ids" {
  value       = module.vpc.public_route_table_ids[0]
  description = "A list of the egress route table IDs"
}

output "nonroutable_cidr_blocks" {
  value       = module.vpc.intra_subnets_cidr_blocks
  description = "A list of the non-routable CIDR blocks in use for the VPC"
}

output "nonroutable_subnets" {
  value       = module.vpc.private_subnets
  description = "A list of the non-routable subnets in the VPC"
}

output "tgw_attachment" {
  value       = aws_ec2_transit_gateway_vpc_attachment.tgw-attachment.id
  description = "The transit gateway attachment ID"
}
