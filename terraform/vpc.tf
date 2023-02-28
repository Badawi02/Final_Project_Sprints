module "vpc" {
    source = "./vpc"
    cidr_block_vpc = "10.0.0.0/16"
    Name_vpv = "main_vpc"
}