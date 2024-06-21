provider "aws" {
  region = "us-east-1"
}


module "vpc" {
  source = "./vpc"
  vpc_cidr             = "10.0.0.0/16"
  private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnet_cidrs  = ["10.0.3.0/24", "10.0.4.0/24"]
}

module "eks" {
  source = "./eks"

  cluster_name       = "mycluster"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnet_ids
  region             = "us-east-1"
  node_instance_type = "t3.medium"
  desired_capacity   = 1
  max_capacity       = 2
  min_capacity       = 1
}

