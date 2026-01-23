module "vpc" {
  source = "../../modules/vpc"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}
module "iam" {
  source = "../../modules/iam"

  project_name = var.project_name
}

module "alb" {
  source = "../../modules/alb"

  project_name        = var.project_name
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
}







## asg calling

module "asg" {
  source = "../../modules/asg"

  project_name            = var.project_name
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids      = module.vpc.private_subnet_ids
  target_group_arn        = module.alb.target_group_arn
  alb_sg_id               = module.alb.alb_sg_id
  instance_profile_name   = module.iam.instance_profile_name

  ami_id        = var.ami_id
  instance_type = var.instance_type
}

module "monitoring" {
  source = "../../modules/monitoring"

  project_name = var.project_name
  asg_name     = module.asg.asg_name
}
