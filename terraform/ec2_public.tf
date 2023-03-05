module "ec2_public" {
  source = "./ec2-public"
  instance_type = "t2.medium"
  associate_public_ip_address = "true"
  key_name = "ec2_key"
  subnetID = module.subnet.subnet_id
  secGroupId = [module.security_group_public.security_group_id]
  public_ec2 = "public_ec2"
  userData = file("userData.tpl")

}