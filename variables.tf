variable "region" {
  type    = string
  default = "eu-west-3"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones where resources will be created"
  default     = ["eu-west-3a", "eu-west-3b"]
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "db_username" {
  type    = string
  default = "wpuser"
}

variable "db_password" {
  type      = string
  description = "Mot de passe pour la base de données."
  sensitive = true  # on va le définir avec export TF_VAR_db_password="mon_mot_de_passe_secret" sur le server
}

variable "db_name" {
  type    = string
  default = "wordpressdb"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "volume_size" {
  type    = number
  default = 10
}
