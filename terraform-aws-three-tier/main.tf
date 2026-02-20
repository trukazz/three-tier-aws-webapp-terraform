
module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  vpc_name = "main-vpc"

}

module "subnets" {
  source  = "./modules/subnets"
  vpc_id  = module.vpc.vpc_id
  subnets = var.subnets
}

module "networking" {
  source             = "./modules/networking"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
  vpc_name           = var.vpc_name
}

module "security_groups" {
  source   = "./modules/security_groups"
  vpc_id   = module.vpc.vpc_id
  vpc_name = var.vpc_name
}

module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  vpc_name          = var.vpc_name
  public_subnet_ids = module.subnets.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id

}


module "asg" {
  source             = "./modules/asg"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.subnets.private_subnet_ids
  ec2_sg_id          = module.security_groups.ec2_sg_id
  target_group_arn   = module.alb.target_group_arn
  vpc_name           = var.vpc_name

  db_endpoint = module.db.db_endpoint
  db_username = module.db.db_username
  db_password = module.db.db_password
}


#############################################################
#DB SECTION
#############################################################

data "aws_secretsmanager_secret" "db_creds" {
  name = "myapp/db/credentials"

}

data "aws_secretsmanager_secret_version" "db_creds" {
  secret_id = data.aws_secretsmanager_secret.db_creds.id
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.db_creds.secret_string)
}


module "db" {
  source = "./modules/db"

  db_name     = "myappdb"
  db_username = local.db_creds.username
  db_password = local.db_creds.password

  private_subnet_ids = values(module.subnets.private_subnet_ids)
  vpc_id             = module.vpc.vpc_id
  sg_ids             = [module.security_groups.db_sg_id]
}

