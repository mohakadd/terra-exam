provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

module "networking" {
  source               = "./modules/networking"
  vpc_cidr_block       = var.vpc_cidr_block
  public_subnets_cidrs = var.public_subnets_cidrs
  availability_zones   = var.availability_zones
}

# Appel du module EC2
module "ec2" {
  source       = "./modules/ec2"
  instance_type = var.instance_type
  subnet_id    = module.networking.public_subnets_ids[0]  # 1ère AZ
  vpc_id       = module.networking.vpc_id
}

# Appel du module RDS
module "rds" {
  source       = "./modules/rds"
  db_username  = var.db_username
  db_password  = var.db_password
  db_name      = var.db_name
  subnet_ids   = module.networking.public_subnets_ids
}

# Appel du module EBS
module "ebs" {
  source            = "./modules/ebs"
  ec2_instance_id   = module.ec2.ec2_instance_id
  volume_size       = var.volume_size
  availability_zone = element(data.aws_availability_zones.available.names, 0)
  # Important : la zone doit correspondre à celle de l'EC2
  # Si l'EC2 est dans module.networking.public_subnets_ids[0] => c'est en AZ[0].
}

output "ec2_public_ip" {
  value = module.ec2.ec2_public_ip
}