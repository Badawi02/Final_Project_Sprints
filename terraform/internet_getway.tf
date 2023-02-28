module "internet_getway" {
    source = "./internet_getway"
    Name_IGW = "IGW"
    vpcID = module.vpc.vpc-id
}