
module "subnet_2" {
    source = "./subnet_2"
    vpcId_2 = module.vpc.vpc-id
    subnet_cidr_2 = "10.0.1.0/24"
}