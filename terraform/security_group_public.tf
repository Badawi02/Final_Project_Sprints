module "security_group_public" {
    source = "./security-group-public"
    Name_security_group = "security_group"
    Ports_security_group = [80 , 22 , 0]
    Protocol_security_group = ["tcp" , "-1"] 
    cidr_security_group = "0.0.0.0/0"
    vpcID = module.vpc.vpc-id
}