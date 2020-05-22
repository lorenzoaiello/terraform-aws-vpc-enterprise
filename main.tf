data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.33.0"

  name = var.name

  cidr                = var.routable_vpc_cidr
  public_subnets      = var.routable_vpc_egress_subnets
  private_subnets     = var.routable_vpc_ingress_subnets
  database_subnets    = ["100.64.0.0/18", "100.64.64.0/18", "100.64.128.0/18"]
  elasticache_subnets = ["100.64.192.0/18", "100.65.0.0/18", "100.65.64.0/18"]
  redshift_subnets    = ["100.65.128.0/18", "100.65.192.0/18", "100.66.0.0/18"]
  azs = [
    data.aws_availability_zones.available.names[0],
    data.aws_availability_zones.available.names[1],
    data.aws_availability_zones.available.names[2]
  ]

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  secondary_cidr_blocks = [
    "100.64.0.0/16",
    "100.65.0.0/16",
    "100.66.0.0/16",
    "100.67.0.0/16",
    "100.68.0.0/16",
    "100.69.0.0/16",
    "100.70.0.0/16",
    "100.71.0.0/16",
    "100.72.0.0/16",
  ]
  intra_subnets = [
    "100.67.0.0/16",
    "100.66.64.0/18",
    "100.66.128.0/18",
    "100.66.192.0/18",
    "100.68.0.0/16",
    "100.69.0.0/16",
    "100.70.0.0/16",
    "100.71.0.0/16",
    "100.72.0.0/16",
  ]

  public_subnet_suffix = "egress"
  public_subnet_tags = {
    "SubnetType" : "public"
  }

  private_subnet_suffix = "ingress"
  private_subnet_tags = {
    "SubnetType" : "private"
  }

  intra_subnet_tags = {
    "SubnetType" : "intra"
  }

  database_subnet_tags = {
    "SubnetType" : "database"
  }

  elasticache_subnet_tags = {
    "SubnetType" : "cache"
  }

  redshift_subnet_tags = {
    "SubnetType" : "redshift"
  }

  tags = merge(var.tags, {
    "VPCType" : "primary"
  })
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-attachment" {
  count              = var.tgw_id != "" ? 1 : 0
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnets
  transit_gateway_id = var.tgw_id
  tags               = var.tags
}

resource "aws_route" "dx-ingress1" {
  count                  = var.tgw_id != "" ? 1 : 0
  route_table_id         = module.vpc.private_route_table_ids[0]
  destination_cidr_block = var.corporate_cidr_tgw
  transit_gateway_id     = var.tgw_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw-attachment]
}

resource "aws_route" "dx-ingress2" {
  count                  = var.tgw_id != "" ? 1 : 0
  route_table_id         = module.vpc.private_route_table_ids[1]
  destination_cidr_block = var.corporate_cidr_tgw
  transit_gateway_id     = var.tgw_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw-attachment]
}

resource "aws_route" "dx-ingress3" {
  count                  = var.tgw_id != "" ? 1 : 0
  route_table_id         = module.vpc.private_route_table_ids[2]
  destination_cidr_block = var.corporate_cidr_tgw
  transit_gateway_id     = var.tgw_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw-attachment]
}

resource "aws_route" "intra-nat" {
  route_table_id         = module.vpc.intra_route_table_ids[0]
  nat_gateway_id         = module.vpc.natgw_ids[0]
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "dx-egress1" {
  count                  = var.tgw_id != "" ? 1 : 0
  route_table_id         = module.vpc.public_route_table_ids[0]
  destination_cidr_block = var.corporate_cidr_tgw
  transit_gateway_id     = var.tgw_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw-attachment]
}

