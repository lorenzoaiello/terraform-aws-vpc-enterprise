variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "routable_vpc_cidr" {
  description = "The complete DX-routable CIDR block for the VPC. Recommend this to be a /24 CIDR block."
  type        = string
}

variable "routable_vpc_egress_subnets" {
  description = "The list of CIDR blocks for the VPC to use for egress (internet and corporate). Recommend this to be three /28 CIDR block."
  type        = list
}

variable "routable_vpc_ingress_subnets" {
  description = "The list of CIDR blocks for the VPC to use for ingress (load balancers). Recommend this to be three /26 CIDR block."
  type        = list
}

variable "tgw_id" {
  type        = "string"
  default     = ""
  description = "Transit gateway ID to connect the VPC to. Leave blank to not connect it."
}

variable "corporate_cidr_tgw" {
  type        = "string"
  description = "The entire corporate CIDR block that is routable over the transit gateway."
}