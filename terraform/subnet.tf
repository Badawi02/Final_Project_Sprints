module "subnet" {
    source = "./subnet"
    vpcId = module.vpc.vpc-id
    subnet_cidr = "10.0.0.0/24"
}