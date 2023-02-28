module "route-table-public" {
  source = "./route-table-public"
  vpcID = module.vpc.vpc-id
  gwID = module.internet_getway.IGW
  Name_route_table = "route-table-public"
  subnetID = module.subnet.subnet_id
  cidr_block_route_table = "0.0.0.0/0"
}