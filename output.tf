# Outputs from Network module

# output "subnet_public_id" {
#   description = "ID of the public subnet"
#   value       = module.network.subnet_public_id
# }

# output "subnet_private_web_id" {
#   description = "ID of the private web subnet"
#   value       = module.network.subnet_private_web_id
# }

# output "subnet_private_db_id" {
#   description = "ID of the private db subnet"
#   value       = module.network.subnet_private_db_id
# }

# output "sg_private_web_id" {
#   description = "ID of the web security group"
#   value       = module.network.sg_private_web_id
# }

# output "sg_private_db_id" {
#   description = "ID of the db security group"
#   value       = module.network.sg_private_db_id
# }


# Outputs from Network module

output "ec2_public_dns" {
  description = "Public DNS of the EC2 Instance"
  value       = module.ec2.ec2_public_dns
}


# Outputs from DB module

# output "db_address" {
#   description = "Address of the database"
#   value = module.db.db_add
# }