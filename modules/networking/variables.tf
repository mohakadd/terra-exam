variable "vpc_cidr_block" {
  type = string
}

variable "public_subnets_cidrs" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}
